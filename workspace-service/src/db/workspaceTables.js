const pool = require('./dbConfig');

const enableUuidExtension = require('../config/uuidExtension');

enableUuidExtension();

const createTables = async()=>{
    try {
         //workspace table
     await pool.query(`
        CREATE TABLE IF NOT EXISTS workspace (
      id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
      lab_name TEXT NOT NULL,
      description TEXT,
      lab_type TEXT NOT NULL,
      documents TEXT[] DEFAULT '{}',
      url TEXT[] DEFAULT '{}',
      date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      status TEXT DEFAULT 'active',
      created_by UUID NOT NULL,
      last_updated TIMESTAMP ,
      org_id TEXT
  );
  `);

  console.log("Workspace tables created successfully");
    } catch (error) {
        console.log("Error creating workspace tables:",error.message);
    }
    

}

createTables();

module.exports = createTables;