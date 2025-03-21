module.exports = {
    insertUserQuery : `INSERT INTO users (name, email, password) VALUES ($1, $2, $3) RETURNING *`,
    getUserByEmailQuery: `SELECT * FROM users WHERE email = $1`,
    getOrgUserByEmailQuery: `SELECT * FROM organization_users WHERE email = $1`,
    updateUserLastActiveQuery: `UPDATE users SET lastactive = $1 WHERE email = $2 RETURNING *`,
    updateOrgUserLastActiveQuery: `UPDATE organization_users SET lastactive = $1 WHERE email = $2 RETURNING *`,
    getAllUsers: 'SELECT * FROM users',
    addUser: `INSERT INTO users (name, email, password, role, organization, created_by) 
              VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`,
    getUserById: 'SELECT * FROM users WHERE id = $1',
    getOrgUserById: 'SELECT * FROM organization_users WHERE id = $1',
    getUserStats: 'SELECT * FROM UserStats WHERE UserId = $1',
    getUserCertifications: 'SELECT CertificationName FROM Certifications WHERE UserId = $1',
    updateUserOrganization: 'UPDATE users SET organization = $1, organization_type = $2 WHERE id = $3 RETURNING *',
    ADD_ORG_USER: `INSERT INTO organization_users(name, email, password, role, admin_id) VALUES($1, $2, $3, $4, $5) RETURNING *`,
    GET_ORG_USERS: `SELECT * FROM organization_users WHERE admin_id=$1`,
    UPDATE_USER: `UPDATE users SET name=$1, email=$2, role=$3, status=$4 WHERE id=$5`,
    UPDATE_ORG_USER: `UPDATE organization_users SET name=$1, email=$2, role=$3, status=$4 WHERE id=$5`,
    GET_USER_BY_ID: `SELECT * FROM users WHERE id=$1`,
    GET_ORG_USER_BY_ID: `SELECT * FROM organization_users WHERE id=$1`,
    INSERT_USERS: `INSERT INTO users (email, password, organization, created_by, organization_type) VALUES($1, $2, $3, $4, $5)`,
    GET_ORG_USERS:`
            SELECT * 
            FROM users 
            WHERE org_id = $1
        `,
    GET_USERS_FROM_ORG:`
            SELECT * 
            FROM organization_users 
            WHERE org_id = $1
        `
          
}