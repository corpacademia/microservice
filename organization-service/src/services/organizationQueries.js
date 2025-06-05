module.exports = {
    GET_ALL_ORGANIZATIONS: `SELECT * FROM organizations`,
    GET_ORGANIZATION_BY_ID: `SELECT * FROM organizations WHERE id = $1`,
    DELETE_LAB_ASSIGNMENTS: `DELETE FROM labassignments WHERE assigned_admin_id = $1`,
    DELETE_LAB_BATCH: `DELETE FROM lab_batch WHERE lab_id = $1`,
    CREATE_ORGANIZATION: `
        INSERT INTO organizations
        (organization_name, org_email, org_type, admin_name, phone_number, address, website_url, org_id, logo) 
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) 
        RETURNING *`,
        GET_USERS_COUNT: `
        SELECT COUNT(*) AS user_count 
        FROM organization_users 
        WHERE org_id = $1
    `,

    GET_ADMINS_COUNT: `
        SELECT COUNT(*) AS admin_count 
        FROM users 
        WHERE org_id = $1 AND role = 'orgadmin'
    `,
    UPDATE_ORGANIZATION: `
        UPDATE organizations 
        SET organization_name=$1, org_email=$2, phone_number=$3, address=$4, website_url=$5, org_type=$6, status=$7, org_id=$8 
        WHERE id=$9 
        RETURNING *;
    `,

    UPDATE_ORGANIZATION_WITH_LOGO: `
        UPDATE organizations 
        SET organization_name=$1, org_email=$2, phone_number=$3, address=$4, website_url=$5, org_type=$6, status=$7, org_id=$8, logo=$9 
        WHERE id=$10 
        RETURNING *;
    `,
    DELETE_ORGANIZATION: `
        DELETE FROM organizations WHERE id = ANY($1) RETURNING *;
    `,
    UPDATE_ORGANIZATION_ADMIN:`UPDATE organizations set org_admin=$1 where id=$2 RETURNING *`
};