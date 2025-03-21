const pool= require('../db/dbConfig');

const enableUuidExtension = require('../config/uuidEnable');

enableUuidExtension();

const createTables = async()=>{
    try {
        await pool.query(`
            CREATE TABLE IF NOT EXISTS organization_users (
            id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
            name TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            role TEXT DEFAULT 'user',
            admin_id UUID,  
            organization TEXT NOT NULL,
            organization_type TEXT,
            status TEXT DEFAULT 'active',
            lastactive TIMESTAMP ,
            org_id UUID,  
            CONSTRAINT fk_admin FOREIGN KEY (admin_id) REFERENCES users(id) ON DELETE SET NULL,
            CONSTRAINT fk_org FOREIGN KEY (org_id) REFERENCES organizations(id) ON DELETE SET NULL
        );
        `);
        
        //create table for organizations
        await pool.query(`CREATE TABLE IF NOT EXISTS organizations (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    organization_name TEXT NOT NULL,
    org_email TEXT UNIQUE NOT NULL,
    org_admin UUID NOT NULL,
    org_type TEXT,
    admin_name TEXT,
    phone_number TEXT,
    address TEXT,
    website_url TEXT,
    status TEXT DEFAULT 'active',
    org_id TEXT UNIQUE NOT NULL,
    total_users INTEGER DEFAULT 0,
    total_admins INTEGER DEFAULT 0,
    active_workspace INTEGER DEFAULT 0,
    monthly_usage INTEGER DEFAULT 0
);

            )`)

        console.log("Successfully created tables")
    } 
    
    catch (error) {
        console.log("Error creating tables:",error.message);
    }
}

createTables();

module.exports = createTables;

