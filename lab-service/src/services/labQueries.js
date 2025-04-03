module.exports = {
    CREATE_LAB :`
    INSERT INTO createlab 
    (user_id,type,platform,provider,os,os_version,cpu,ram,storage,instance,title,description,duration,snapshot_type) 
    VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14) 
    RETURNING *
    `,
    GET_ALL_LAB:`
     SELECT * FROM createlab
    `,
    GET_LAB_ON_ID:`
    SELECT * from createlab where lab_id=$1
    `,
    GET_CONFIG_DETAILS: `SELECT config_details FROM lab_batch WHERE lab_id=$1 AND admin_id=$2`,
    CHECK_ALREADY_ASSIGNED: `SELECT * FROM labassignments WHERE user_id=$1 AND lab_id=$2`,
    ASSIGN_LAB: `
        INSERT INTO labassignments (lab_id, user_id, completion_date, status, assigned_admin_id) 
        VALUES ($1, $2, $3, $4, $5) 
        RETURNING *`,
        GET_ASSIGNED_LABS: `SELECT * FROM labassignments WHERE user_id=$1`,
    
    GET_INSTANCES_DETAILS: (table) => `SELECT * FROM ${table} WHERE vcpu=$1 AND memory=$2`,
    GET_INSTANCE_DETAILS_FOR_PRICING: (table, instancename) => `
        SELECT * 
        FROM ${table} 
        WHERE REPLACE(${instancename}, E'\n', '') = $1 
        AND vcpu = $2 
        AND memory = $3
    `,
    UPDATE_LAB_CONFIG: `
    INSERT INTO lab_configurations (lab_id, admin_id, config_details) 
    VALUES ($1, $2, $3) 
    RETURNING *`,
    GET_AMI_INFO: `SELECT * FROM amiinformation WHERE lab_id=$1`,
    GET_INSTANCE_DETAILS: `SELECT * FROM instances WHERE lab_id=$1`,
    GET_USER_INSTANCE_DETAILS: `SELECT * FROM cloudassignedinstance WHERE lab_id=$1 AND user_id=$2`,
    UPDATE_USER_INSTANCE_STATE: `UPDATE cloudassignedinstance SET isRunning=$1 WHERE lab_id=$2 AND user_id=$3 RETURNING *`,
    UPDATE_USER_INSTANCE_STATES: `UPDATE cloudassignedinstance SET isstarted=$1 , isRunning=$2 WHERE lab_id=$3 AND user_id=$4 RETURNING *`,
    UPDATE_LAB_INSTANCE_STATE: `UPDATE instances SET isRunning=$1 WHERE lab_id=$2 RETURNING *`,
    UPDATE_LAB_INSTANCE_STATES: `UPDATE instances SET isstarted=$1, isRunning=$2 WHERE lab_id=$3 RETURNING *`,
   
    CHECK_LAB_ASSIGNMENT: `SELECT * FROM lab_batch WHERE lab_id = $1 AND admin_id = $2 AND org_id = $3`,
    INSERT_LAB_BATCH: `INSERT INTO lab_batch(lab_id, admin_id, org_id, config_details, configured_by, software) 
                       VALUES($1, $2, $3, $4, $5, $6) RETURNING *`,
    GET_LAB_BATCH_BY_ADMIN: `SELECT * FROM lab_batch WHERE admin_id=$1`,
    GET_ALL_SOFTWARE_DETAILS: `SELECT * FROM lab_batch`,
    CHECK_LAB_BATCH_ASSESSMENT: `SELECT * FROM lab_batch WHERE admin_id=$1 AND org_id=$2`,
    GET_CONFIGURED_LABS: `
    SELECT cl.* 
    FROM createlab cl
    INNER JOIN instances ic 
    ON cl.lab_id = ic.lab_id
  `,
  GET_LAB_CATALOGUES: `
  SELECT * 
  FROM createlab l 
  INNER JOIN lab_configurations lc 
  ON l.lab_id = lc.lab_id 
  WHERE lc.config_details->>'catalogueType' = 'public'
`,

CHECK_LAB_INSTANCE_STARTED: "SELECT isstarted FROM instances WHERE instance_id = $1",
CHECK_USER_INSTANCE_STARTED: "SELECT isstarted FROM cloudassignedinstance WHERE instance_id = $1",

CREATE_CATALOGUE: `
    INSERT INTO createlab 
    (user_id, type, platform, provider, os, os_version, cpu, ram, storage, instance, title, description, duration, snapshot_type) 
    VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14) 
    RETURNING *`,
    GET_OPERATING_SYSTEMS: 'SELECT * FROM operating_systems',
    GET_ASSIGNED_LABS_ON_LABID:"SELECT * from labassignments where lab_id=$1 and user_id=$2",
UPDATE_LAB_STATUS: `UPDATE createlab SET status=$1 WHERE lab_id=$2 RETURNING *`,
}