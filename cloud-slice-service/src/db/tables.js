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
             startDate TIMESTAMP NOT NULL,
             endDate TIMESTAMP NOT NULL,
             cleanupPolicy INT ,
             platform VARCHAR(255) NOT NULL,
             provider VARCHAR(255) NOT NULL,
             title VARCHAR(255) NOT NULL,
             description TEXT NOT NULL,
             difficultyLevel INT NOT NULL,
             status VARCHAR(255) NOT NULL,
             rating INT NOT NULL,
             modules TEXT Not NULL,
             credits INT,
             accounttype TEXT NOT NULL,
             foreign key (createdBy) references users(id) on delete cascade
            )
            `
        )

        //create a table for cloudslicelab with modules
        // await pool.query(`
        //     CREATE TABLE IF NOT EXISTS cloudSliceLabWithModules (
        //      labId UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        //      createdAt TIMESTAMP DEFAULT NOW(),
        //      createdBy UUID NOT NULL,
        //      region VARCHAR(255) NOT NULL,
        //      startDate TIMESTAMP NOT NULL,
        //      endDate TIMESTAMP NOT NULL,
        //      cleanupPolicy INT NOT NULL,
        //      platform VARCHAR(255) NOT NULL,
        //      provider VARCHAR(255) NOT NULL,
        //      title VARCHAR(255) NOT NULL,
        //      description TEXT NOT NULL,
        //      difficultyLevel INT,
        //      status VARCHAR(255) NOT NULL,
        //      rating INT ,
        //      modules TEXT Not NULL,
        //      foreign key (createdBy) references users(id) on delete cascade)
        //     `)

            // -- MODULES TABLE
        await pool.query(`CREATE TABLE IF NOT EXISTS modules (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    lab_id UUID REFERENCES cloudSliceLab(labId) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);`)

// -- EXERCISES TABLE
    await pool.query(`CREATE TABLE IF NOT EXISTS exercises (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    module_id UUID REFERENCES modules(id) ON DELETE CASCADE,
    type VARCHAR(50) CHECK (type IN ('lab', 'quiz')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)`)

// -- LAB EXERCISE TABLE
    await pool.query(`CREATE TABLE IF NOT EXISTS lab_exercises (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    exercise_id UUID UNIQUE REFERENCES exercises(id) ON DELETE CASCADE,
    estimated_duration INT, -- in minutes
    title VARCHAR(255) NOT NULL,
    instructions TEXT,
	services TEXT[],
	files TEXT[] ,
    cleanuppolicy JSONB
);`)

// -- QUIZ QUESTIONS TABLE
    await pool.query(`CREATE TABLE IF NOT EXISTS questions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    exercise_id UUID REFERENCES exercises(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    question_text TEXT NOT NULL,
	description TEXT,
	correct_answet TEXT,
    title TEXT,
    estimated_duration INT
);
`)

// -- OPTIONS TABLE
    await pool.query(`CREATE TABLE IF NOT EXISTS options (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    question_id UUID REFERENCES questions(id) ON DELETE CASCADE,
    option_text TEXT NOT NULL,
    is_correct BOOLEAN DEFAULT FALSE
);`)


        console.log('cloudSlice tables created successfully!');


    } catch (error) {
        console.error('Error creating tables:', error);
        
    }
}

createTables();

module.exports = createTables