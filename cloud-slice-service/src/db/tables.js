const enableUuidExtension = require('../config/uuidenable');
const pool = require('../db/dbconfig')

enableUuidExtension();

const createTables = async () => {
    try {
        await pool.query(
            `
            CREATE TABLE IF NOT EXISTS cloudSliceLab (
             labId UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
             createdAt TIMESTAMP DEFAULT NOW(),
             createdBy UUID NOT NULL,
             services JSONB NOT NULL,
             region VARCHAR(255) NOT NULL,
             duration INT NOT NULL,
             cleanupPolicy INT NOT NULL,
             type VARCHAR(255) NOT NULL,
             platform VARCHAR(255) NOT NULL,
             provider VARCHAR(255) NOT NULL,
             title VARCHAR(255) NOT NULL,
             description TEXT NOT NULL,
             difficultyLevel INT NOT NULL,
             status VARCHAR(255) NOT NULL,
             rating INT NOT NULL,
             foreign key (createdBy) references users(id) on delete cascade
            )
            `
        )
        console.log('cloudSlice tables created successfully!');


    } catch (error) {
        console.error('Error creating tables:', error);
        
    }
}

createTables();

module.exports = createTables