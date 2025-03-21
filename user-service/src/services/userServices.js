const pool = require('../dbconfig/db');
const {hashPassword,comparePassword,signJwt,verifyToken} = require('../helper/authHelper');
const userQueries = require('../services/userQueries');

const signupService = async (name, email, password) => {
    try {
        const hashedPassword = await hashPassword(password);
        const result = await pool.query(userQueries.insertUserQuery, [name, email, hashedPassword]);
        return result.rows[0];
    } catch (error) {
        throw error;
    }
};

const loginService = async (email, password) => {
    try {
        let userResult = await pool.query(userQueries.getUserByEmailQuery, [email]);

        if (userResult.rows.length === 0) {
            userResult = await pool.query(userQueries.getOrgUserByEmailQuery, [email]);
        }

        if (userResult.rows.length === 0) {
            return { success: false, message: "User not found" };
        }

        const user = userResult.rows[0];

        // Compare password
        const isPasswordValid = await comparePassword(password, user.password);
        if (!isPasswordValid) {
            return { success: false, message: "Invalid Password" };
        }

        // Update Last Active Date
        const currentDate = new Date();
        const day = currentDate.getDate();
        const month = currentDate.getMonth();
        const year = currentDate.getFullYear();
        const monthNames = [
            "January", "February", "March", "April", "May", "June", 
            "July", "August", "September", "October", "November", "December"
        ];
        const lastActiveDate = `${day} ${monthNames[month]} ${year}`;

        const updateQuery = user.admin_id 
            ? userQueries.updateOrgUserLastActiveQuery 
            : userQueries.updateUserLastActiveQuery;

        const updateResult = await pool.query(updateQuery, [lastActiveDate, email]);

        if (!updateResult.rows[0]) {
            return { success: false, message: "Could not update last active" };
        }

        // Generate JWT Token
        const token = signJwt(user.id);

        return { success: true, user, token };
    } catch (error) {
        throw error;
    }
};

const getAllUsers = async () => {
    const result = await pool.query(userQueries.getAllUsers);
    return result.rows;
};

const addUser = async (userData) => {
    const { name, email, role, organization } = userData.formData;
    const { id } = userData.user;
    const password = '123';
    const hashedPassword = await hashPassword(password);

    const result = await pool.query(userQueries.addUser, [
        name,
        email,
        hashedPassword,
        role,
        organization,
        id,
    ]);

    return result.rows[0];
};

const getUserData = async (userId) => {
    let user = await pool.query(userQueries.getUserById, [userId]);

    if (!user.rows[0]) {
        user = await pool.query(userQueries.getOrgUserById, [userId]);
        if (!user.rows[0]) return null;
    }

    const stats = await pool.query(userQueries.getUserStats, [userId]);
    const certifications = await pool.query(userQueries.getUserCertifications, [userId]);

    return {
        user: user.rows[0],
        stats: stats.rows[0] || {},
        certifications: certifications.rows.map(row => row.certificationname),
    };
};

const updateUserOrganization = async (userId, values) => {
    const [orgName, type] = values.split(',');

    if (!userId || !orgName || !type) {
        throw new Error('Some field is missing');
    }

    const update = await pool.query(userQueries.updateUserOrganization, [orgName, type, userId]);

    if (!update.rows[0]) {
        throw new Error('Invalid field or userId');
    }

    return update.rows[0];
};

const updateUserRole = async (userId, role) => {
    if (!userId || !role) throw new Error("User ID or role is missing");
  
    const result = await pool.query(userQueries.UPDATE_USER_ROLE, [role, userId]);
  
    if (!result.rows[0]) throw new Error("Invalid User ID or role");
  
    return result.rows[0];
  };
  
  const getTokenAndGetUserDetails = async (token) => {
    if (!token) throw new Error("No token provided");
    const decoded = verifyToken(token);
    const userId = decoded._id;
  
    let result = await pool.query(userQueries.GET_USER_BY_ID, [userId]);
    if (result.rows.length > 0) return result.rows[0];
  
    result = await pool.query(userQueries.GET_ORG_USER_BY_ID, [userId]);
    if (result.rows.length > 0) return result.rows[0];
  
    throw new Error("User not found");
  };
  
  const updateUserDetails = async (id, name, email, password) => {
    if (!id) throw new Error("User ID is required");
  
    let result = await pool.query(userQueries.GET_USER_BY_ID, [id]);
    if (result.rows.length > 0) {
      const existingUser = result.rows[0];
      if (password && (await bcrypt.compare(password, existingUser.password)))
        throw new Error("New password cannot be same as the old password");
  
      const query = password
        ? userQueries.UPDATE_USER
        : userQueries.UPDATE_USER_NO_PASSWORD;
      const values = password
        ? [name, email, await bcrypt.hash(password, 10), id]
        : [name, email, id];
  
      result = await pool.query(query, values);
      return result.rows[0];
    }
  
    result = await pool.query(userQueries.GET_ORG_USER_BY_ID, [id]);
    if (result.rows.length > 0) {
      const existingUser = result.rows[0];
      if (password && (await bcrypt.compare(password, existingUser.password)))
        throw new Error("New password cannot be same as the old password");
  
      const query = password
        ? userQueries.UPDATE_ORG_USER
        : userQueries.UPDATE_ORG_USER_NO_PASSWORD;
      const values = password
        ? [name, email, await bcrypt.hash(password, 10), id]
        : [name, email, id];
  
      result = await pool.query(query, values);
      return result.rows[0];
    }
  
    throw new Error("User not found");
  };
  
  const getUsersFromOrganization = async (orgId) => {
    const [usersResult, orgUsersResult] = await Promise.all([
      pool.query(userQueries.GET_USERS_FROM_ORG, [orgId]),
      pool.query(userQueries.GET_ORG_USERS, [orgId]),
    ]);
  
    const users = [...usersResult.rows, ...orgUsersResult.rows];
    if (users.length === 0) throw new Error("No users found for this organization");
  
    return users;
  };
  
  const deleteUsers = async (orgId, userIds) => {
    if (!Array.isArray(userIds) || userIds.length === 0)
      throw new Error("Invalid or missing userIds array");
  
    await pool.query("BEGIN");
  
    const deletedUsers = await pool.query(userQueries.DELETE_USERS, [userIds, orgId]);
    const deletedUserIds = deletedUsers.rows.map((row) => row.id);
    const remainingUserIds = userIds.filter((id) => !deletedUserIds.includes(id));
  
    let deletedOrgUsers = [];
    if (remainingUserIds.length > 0) {
      deletedOrgUsers = await pool.query(userQueries.DELETE_ORG_USERS, [remainingUserIds, orgId]);
    }
  
    await pool.query("COMMIT");
  
    return { deletedUserIds, deletedOrgUsers: deletedOrgUsers.rows.map((row) => row.id) };
  };
  

  // Add Organization User
const addOrganizationUser = async (userData) => {
    const { name, email, password, role, admin_id } = userData;
    const hashedPassword = await bcrypt.hash(password, 10);
    
    const result = await pool.query(userQueries.ADD_ORG_USER, [name, email, hashedPassword, role, admin_id]);
    return result.rows[0];
  };
  
  // Get Organization Users
  const getOrganizationUsers = async (admin_id) => {
    const result = await pool.query(userQueries.GET_ORG_USERS, [admin_id]);
    return result.rows;
  };
  
  // Update User (Checks both users and organization_users)
  const updateUser = async (id, userData) => {
    const { name, email, role, status } = userData;
  
    const userResult = await pool.query(userQueries.GET_USER_BY_ID, [id]);
    if (userResult.rows.length > 0) {
      await pool.query(userQueries.UPDATE_USER, [name, email, role, status, id]);
      return { message: "User updated successfully in users table" };
    }
  
    const orgUserResult = await pool.query(userQueries.GET_ORG_USER_BY_ID, [id]);
    if (orgUserResult.rows.length > 0) {
      await pool.query(userQueries.UPDATE_ORG_USER, [name, email, role, status, id]);
      return { message: "User updated successfully in organization_users table" };
    }
  
    throw new Error("User not found in both tables");
  };
  
  // Insert Multiple Users
  const insertUsers = async (users, organization, admin_id, organization_type) => {
    for (const user of users) {
      const hashedPassword = await bcrypt.hash(user.password, 10);
      await pool.query(userQueries.INSERT_USERS, [
        user.userId, hashedPassword, organization, admin_id, organization_type
      ]);
    }
  };

module.exports = { 
    signupService,
    loginService,
    getAllUsers,
    addUser,
    getUserData, 
    updateUserOrganization,
    updateUserRole,
  getTokenAndGetUserDetails,
  updateUserDetails,
  getUsersFromOrganization,
  deleteUsers,
  addOrganizationUser,
  getOrganizationUsers,
  updateUser,
  insertUsers,
 };