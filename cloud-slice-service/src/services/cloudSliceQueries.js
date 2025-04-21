module.exports = {
    GET_ALL_AWS_SERVICES:`SELECT * FROM awsservices`,
    INSERT_LAB_DATA:`INSERT INTO cloudslicelab(createdby,services, region, startDate, endDate, cleanupPolicy, platform, provider, title, description, modules,credits) VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12) RETURNING *`,
    INSERT_LAB_DATA_WITH_MODULES:`INSERT INTO cloudslicelab(createdby,services, region, startDate, endDate, platform, provider, title, description, modules) VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10) RETURNING *`,
    
    INSERT_MODULES:`INSERT INTO modules(name,description,lab_id) VALUES($1,$2,$3) RETURNING *`,
    INSERT_EXERCISES:`INSERT INTO exercises(module_id,type) VALUES($1,$2) RETURNING *`,
    INSERT_LAB_EXERCISES:`INSERT INTO lab_exercises(exercise_id,estimated_duration,instructions,services,files,title,cleanuppolicy) VALUES($1,$2,$3,$4,$5,$6,$7) RETURNING *`,
    INSERT_QUIZ_QUESTIONS:`INSERT INTO questions(exercise_id,question_text,description,correct_answer,estimated_duration,title) VALUES($1,$2,$3,$4,$5,$6) RETURNING *`,
    INSERT_QUIZ_OPTIONS:`INSERT INTO options(question_id,option_text,option_id,is_correct) VALUES($1,$2,$3,$4) RETURNING *`,
    GET_ALL_LABS_ON_CREATED_USER:`SELECT * FROM cloudslicelab where createdby = $1`,
    GET_LABS_ON_ID:`SELECT * FROM cloudslicelab where labid = $1`,
    UPDATE_SERVICES_ON_LABID:`UPDATE cloudslicelab SET services = $1 WHERE labid = $2 RETURNING *`,
    GET_MODULES_ON_LABID:`SELECT * FROM modules WHERE lab_id = $1`,
    GET_LAB_EXERCISES_ON_MODULEID:`SELECT 
  e.*, 
  le.*
FROM 
  exercises e
LEFT JOIN 
  lab_exercises le 
ON 
  e.id = le.exercise_id
WHERE 
  e.module_id = $1;
`,

  // MODULES
  GET_ALL_MODULES: `
    SELECT id, name AS title, description FROM modules
  `,
  GET_MODULE_EXERCISES: `
    SELECT 
      e.id, e.type,
      COALESCE(l.title, q.title) AS title,
      COALESCE(l.estimated_duration, q.estimated_duration) AS duration,
      COALESCE(l.instructions, q.question_text) AS description
    FROM exercises e
    LEFT JOIN lab_exercises l ON l.exercise_id = e.id
    LEFT JOIN questions q ON q.exercise_id = e.id
    WHERE e.module_id = $1
    ORDER BY e.created_at;
  `,

  // LAB
  GET_LAB_EXERCISES_BY_MODULE: `
    SELECT le.*, e.id AS exercise_id
    FROM exercises e
    JOIN lab_exercises le ON le.exercise_id = e.id
    WHERE e.module_id = $1
  `,

  // QUIZ
  GET_QUIZ_EXERCISES_IDS_BY_MODULE: `
    SELECT e.id AS exercise_id
    FROM exercises e
    WHERE e.module_id = $1 AND e.type = 'questions'
  `,
  GET_QUESTIONS_BY_EXERCISE_ID: `
    SELECT id, question_text AS text FROM questions WHERE exercise_id = $1
  `,
  GET_OPTIONS_BY_QUESTION_ID: `
    SELECT option_text AS text, is_correct FROM options WHERE question_id = $1
  `
}
