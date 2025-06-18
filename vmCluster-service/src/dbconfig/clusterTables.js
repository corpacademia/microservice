const pool = require("./db");
const enableUuidExtension = require("../config/uuidEnable");//uuid enable function

enableUuidExtension();

const createTables = async()=>{

        //create vmcluster datacenter lab table
        await pool.query(
            `
            CREATE TABLE IF NOT EXISTS vmclusterdatacenter_lab (
            labid UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            user_id UUID NOT NULL,
            title TEXT NOT NULL,
            description TEXT,
            type TEXT,
            platform TEXT,
            status TEXT DEFAULT 'available',
            created_at TIMESTAMP DEFAULT NOW(),
            labguide TEXT[],
            userguide TEXT[],
            startdate TIMESTAMP,
            enddate TIMESTAMP,
            cataloguetype TEXT DEFAULT 'private'
            );

            `
        );

        //create vm details table

        await pool.query(`
            CREATE TABLE IF NOT EXISTS vmclusterdatacenter_vms (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            lab_id UUID,
            vmid UUID,
            vmname TEXT,
            protocol TEXT,
            created_at TIMESTAMP DEFAULT NOW()
            );

            `)

         //create user vms details table
         
        await pool.query(`
          CREATE TABLE IF NOT EXISTS vmclusterdatacenter_uservms (
          id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
          labid UUID,
          vmid UUID,
          username TEXT,
          password TEXT,
          ip TEXT,
          port INTEGER,
          orgassigned UUID,
          assigned_to UUID,
          assigned_at TIMESTAMP DEFAULT NOW(),
          assigned_by UUID,
          disabled BOOLEAN DEFAULT FALSE
            );
  
            `)

        //create table for orgassignment
       await pool.query(`
        CREATE TABLE IF NOT EXISTS vmclusterdatacenterorgassignment (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        labid UUID NOT NULL,
        orgid UUID NOT NULL,
        assigned_at TIMESTAMP DEFAULT NOW(),
        status TEXT DEFAULT 'available',
        cataloguename TEXT
        );

        `)

}

createTables();

module.exports = createTables;