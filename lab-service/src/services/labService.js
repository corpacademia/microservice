const pool = require('../db/dbConfig');
const labQueries = require('./labQueries');
const queries = require('./labQueries');



//lab tables that contains the details of the lab
const createLab=async(data,user)=>{
    try{
       const {type,details,platform,provider,config,instance} = data;
       const output = await pool.query(queries.CREATE_LAB,[user.id,type,platform,provider,config.os,config.os_version,config.cpu,config.ram,config.storage,instance,details.title,details.description,details.duration,config.snapshotType])
       
       return output.rows[0];
    }
    catch(error){
        console.log('Error in createlab service:',error.message);
        throw error
     }
}

//get the labs created
const getAllLab = async()=>{
    try{
        const labs = await pool.query(labQueries.GET_ALL_LAB);
       
        return labs
        
    }
    catch(error){
        console.log("Error in getAllLab service:",error.message);
        throw error
    }
}

//GET LAB ON ID
const getLabOnId = async(labId)=>{
    try{
        const result = await pool.query(labQueries.GET_LAB_ON_ID,[labId]);

        return result.rows[0];
    }
    catch(error){
       console.log("Error in getlabonid service:",error)
    }
}

//ASSIGN LAB TO USERS
const assignLab = async (lab, userIds, assign_admin_id) => {
    try {
        // Normalize `userIds` to an array
        userIds = Array.isArray(userIds) ? userIds : [userIds];
        // Get configuration details
        const getDays = await pool.query(labQueries.GET_CONFIG_DETAILS, [lab, assign_admin_id]);
        if (!getDays.rows.length) {
            throw new Error("Invalid lab ID");
        }

        let date = new Date();
        date.setDate(date.getDate() + getDays.rows[0].config_details.numberOfDays);
        let completion_date = date.toISOString().split('T')[0]; // Format as YYYY-MM-DD

        // Arrays to track successful assignments and errors
        const successfulAssignments = [];
        const errors = [];

        for (const user of userIds) {
            const checkAlreadyAssigned = await pool.query(labQueries.CHECK_ALREADY_ASSIGNED, [user, lab]);

            if (checkAlreadyAssigned.rows.length > 0) {
                errors.push({
                    user_id: user,
                    lab_id: lab,
                    message: "Lab already assigned to the user",
                });
                continue;
            }

            // Insert lab assignment into the database
            const result = await pool.query(labQueries.ASSIGN_LAB, [
                lab,
                user,
                completion_date,
                "pending",
                assign_admin_id,
            ]);

            if (result.rows.length > 0) {
                successfulAssignments.push(result.rows[0]);
            } else {
                errors.push({
                    user_id: user,
                    lab_id: lab,
                    message: "Failed to assign the lab",
                });
            }
        }

        return { successfulAssignments, errors };
    } catch (error) {
        console.error(error);
        throw new Error(error.message);
    }
};

//get user assigned lab on id
const getAssignLabOnId = async (userId) => {
    try {
        const result = await pool.query(queries.GET_ASSIGNED_LABS, [userId]);
      
        if (!result.rows) {
            throw new Error("Error in retrieving the labs");
        }

        return result.rows;
    } catch (error) {
        console.error(error);
        throw new Error(error.message);
    }
};

//get user labs on labid and userid
const getAssignLabOnLabId = async(labId,userId) =>{
    try {
        const result = await pool.query(queries.GET_ASSIGNED_LABS_ON_LABID,[labId,userId]);

        if(!result.rows[0]){
            throw new Error("Error in retrieving the lab");
        }
        return result.rows[0];

    } catch (error) {
        console.error(error);
        throw new Error(error.message);
    }
}

const getInstanceOnParameters = async (cloud, cpu, ram) => {
    try {
        let table;
        switch (cloud.toLowerCase()) {
            case 'aws':
                table = 'ec2_instance';
                break;
            case 'azure':
                table = 'azure_vm';
                break;
            default:
                throw new Error("Unsupported cloud platform");
        }

        const core = cpu.toString();
        const memory = ram.toString();
        const query = labQueries.GET_INSTANCES_DETAILS(table);
        const result = await pool.query(query, [core, memory]);

        if (!result.rows.length) {
            throw new Error("No data found for the given parameters");
        }

        return result.rows;
    } catch (error) {
        console.error(error);
        throw new Error(error.message);
    }
};

const getInstanceDetailsForPricing = async (provider, instance, cpu, ram) => {
    try {
        let table, instancename;
        switch (provider.toLowerCase()) {
            case 'aws':
                table = 'ec2_instance';
                instancename = 'instanceName';
                break;
            case 'azure':
                table = 'azure_vm';
                instancename = 'instance';
                break;
            default:
                throw new Error("Unsupported provider");
        }

        const query = queries.GET_INSTANCE_DETAILS_FOR_PRICING(table, instancename);
        const result = await pool.query(query, [instance, cpu, ram]);

        if (!result.rows.length) {
            throw new Error("No data found with the provided details");
        }

        return result.rows[0];
    } catch (error) {
        console.error(error);
        throw new Error(error.message);
    }
};

const updateLabConfig = async (lab_id, admin_id, config_details) => {
    const result = await pool.query(queries.UPDATE_LAB_CONFIG, [lab_id, admin_id, config_details]);
    return result.rows[0]; // Return the result to the controller
};

//check whether the ami is created
const getAmiInformation = async (lab_id) => {
    const result = await pool.query(queries.GET_AMI_INFO, [lab_id]);
    return result.rows[0]; // Return the result to the controller
};

const getAwsInstanceDetails = async (lab_id) => {
    const result = await pool.query(queries.GET_INSTANCE_DETAILS, [lab_id]);
    return result.rows[0]; // Return the instance details to the controller
};

const getAwsInstanceDetailsOfUsers = async (lab_id, user_id) => {
    const result = await pool.query(queries.GET_USER_INSTANCE_DETAILS, [lab_id, user_id]);
    return result.rows[0]; // Return instance details
};

const updateAwsInstanceDetailsOfUsers = async (lab_id, user_id, state, isStarted) => {
    if(!isStarted){
        const result = await pool.query(queries.UPDATE_USER_INSTANCE_STATES, [true,state, lab_id, user_id]);
        return result.rows[0];
    }
    else{
        const result = await pool.query(queries.UPDATE_USER_INSTANCE_STATE, [state, lab_id, user_id]);
        return result.rows[0]; // Return updated instance details
    }
   
};

const updateAwsLabInstanceDetails = async (lab_id, state, isStarted) => {

    if(!isStarted){
        const result = await pool.query(queries.UPDATE_LAB_INSTANCE_STATES, [true,state, lab_id]);
        return result.rows[0];
    }
    else{
    const result = await pool.query(queries.UPDATE_LAB_INSTANCE_STATE, [state, lab_id]);
    return result.rows[0]; // Return updated lab instance details
    }
};

const assignLabBatch = async (lab_id, admin_id, org_id, config_details, configured_by, software) => {
    const existingRecord = await pool.query(queries.CHECK_LAB_ASSIGNMENT, [lab_id, admin_id, org_id]);

    if (existingRecord.rows.length > 0) {
        return { assigned: true, data: existingRecord.rows[0] };
    }

    const batch = await pool.query(queries.INSERT_LAB_BATCH, [lab_id, admin_id, org_id, config_details, configured_by, software]);

    return { assigned: false, data: batch.rows[0] };
};

const getLabBatchAssessment = async (admin_id) => {
    const data = await pool.query(queries.GET_LAB_BATCH_BY_ADMIN, [admin_id]);
    return data.rows;
};

const getSoftwareDetails = async () => {
    const data = await pool.query(queries.GET_ALL_SOFTWARE_DETAILS);
    return data.rows;
};

const checkLabBatchAssessment = async (admin_id, org_id) => {
    const data = await pool.query(queries.CHECK_LAB_BATCH_ASSESSMENT, [admin_id, org_id]);
    return data.rows;
};

const getLabsConfigured = async () => {
    const labs = await pool.query(labQueries.GET_CONFIGURED_LABS);
    return labs.rows;
  };

// Get Lab Catalogues
const getLabCatalogues = async () => {
    const result = await pool.query(labQueries.GET_LAB_CATALOGUES);
    return result.rows;
  };

  const updateAwsInstanceDetailsOfUsersService = async (state, labId, userId) => {
    try {
      const response = await pool.query(queries.UPDATE_AWS_INSTANCE_DETAILS, [state, labId, userId]);
      return response.rows[0] || null;
    } catch (error) {
      throw error;
    }
  };
  
  const updateAwsLabInstanceDetailsService = async (state, labId) => {
    try {
      const response = await pool.query(queries.UPDATE_AWS_LAB_INSTANCE_DETAILS, [state, labId]);
      return response.rows[0] || null;
    } catch (error) {
      throw error;
    }
  };

  const checkIsStartedService = async (type, id) => {
    if (!type || !id) {
      throw new Error("Type and ID are required.");
    }
  
    let query;
    if (type === "lab") {
      query = queries.CHECK_LAB_INSTANCE_STARTED;
    } else if (type === "user") {
      query = queries.CHECK_USER_INSTANCE_STARTED;
    } else {
      throw new Error("Invalid type. Use 'lab' or 'user'.");
    }
  
    const result = await pool.query(query, [id]);
  
    if (!result.rows[0]) {
      throw new Error("No record found.");
    }
  
    return { success: true, message: "Successful", isStarted: result.rows[0].isstarted };
  };
  
  const createNewCatalogue = async (catalogueData) => {
    try {
      const {
        name,
        cpu,
        ram,
        storage,
        instance,
        snapshotType,
        os,
        os_version,
        platform,
        provider,
        description,
        duration,
        user,
      } = catalogueData;
  
      const values = [
        user,
        instance,
        platform,
        provider,
        os,
        os_version,
        cpu,
        ram,
        storage,
        instance,
        name,
        description,
        duration,
        snapshotType,
      ];
  
      const result = await pool.query(queries.CREATE_CATALOGUE, values);
  
      if (!result.rows[0]) {
        throw new Error("Could not store the lab catalogue");
      }
  
      return result.rows[0];
    } catch (error) {
      console.error("Error in createNewCatalogue service:", error.message);
      throw error;
    }
  };

  const getOperatingSystems = async () => {
    try {
        const result = await pool.query(labQueries.GET_OPERATING_SYSTEMS);

        if (result.rowCount === 0) {  // ✅ Safer check
            return { success: false, message: "Could not get the operating systems", data: null };
        }

        return { success: true, message: "Successfully accessed the operating systems list", data: result.rows };
    } catch (error) {
        console.error("Database Query Error:", error); // ✅ Logs full error stack
        throw new Error("Database error: " + error.message);
    }
};

 const updateSigleVmLabStatus = async(labId,status)=>{
     try {
        const result = await pool.query(queries.UPDATE_LAB_STATUS,[status,labId]);
        return result.rows[0]; // Return the updated lab status
     } catch (error) {
        throw new Error("Error in updating the lab status:",error.message);
     }
 }



module.exports = {
    createLab,
    getAllLab,
    getLabOnId,
    assignLab,
    getAssignLabOnId,
    getInstanceOnParameters,
    getInstanceDetailsForPricing,
    updateLabConfig,
    getAmiInformation,
    getAwsInstanceDetails,
    getAwsInstanceDetailsOfUsers,
    updateAwsInstanceDetailsOfUsers,
    updateAwsLabInstanceDetails,
    assignLabBatch,
    getLabBatchAssessment,
    getSoftwareDetails,
    checkLabBatchAssessment,
    getLabsConfigured,
    getLabCatalogues,
    updateAwsInstanceDetailsOfUsersService,
    updateAwsLabInstanceDetailsService,
    getAmiInformation,
    checkIsStartedService,
    createNewCatalogue,
    getOperatingSystems,
    getAssignLabOnLabId,
    updateSigleVmLabStatus,
}