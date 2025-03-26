const { get } = require("../app");

module.exports = {
    createWorkspace: `
        INSERT INTO workspace (lab_name, description, lab_type, date, documents, url, created_by, org_id) 
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8) 
        RETURNING *`,
        getWorkspaceByUserId: `SELECT * FROM workspace WHERE created_by = $1`,
        getWorkspaceById: `SELECT * FROM workspace WHERE id = $1`,
        updateWorkspace: `
        UPDATE workspace 
        SET lab_name = $1, description = $2, lab_type = $3, documents = $4, url = $5, last_updated = $6 
        WHERE id = $7 
        RETURNING *`,
        deleteWorkspaces: `DELETE FROM workspace WHERE id = ANY($1::uuid[]) RETURNING *`,
         getWorkspaceCount: `SELECT COUNT(*) FROM workspace WHERE org_id = $1`,

         getWorkspaceByOrgId: `SELECT * FROM workspace WHERE org_id = $1`,
         
};