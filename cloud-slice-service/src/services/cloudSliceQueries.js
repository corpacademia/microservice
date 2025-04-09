module.exports = {
    GET_ALL_AWS_SERVICES:`SELECT * FROM awsservices`,
    INSERT_LAB_DATA:`INSERT INTO cloudslicelab(createdby,services, region, startDate, endDate, cleanupPolicy, platform, provider, title, description, modules) VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11) RETURNING *`,
    INSERT_MODULES:`INSERT INTO modules(name,description,lab_id) VALUES($1,$2,$3) RETURNING *`,
    INSERT_EXERCISES:`INSERT INTO exercises(module_id,type) VALUES($1,$2) RETURNING *`,
    INSERT_LAB_EXERCISES:`INSERT INTO lab_exercises(exercise_id,estimated_duration,instructions,services,files,title) VALUES($1,$2,$3,$4,$5,$6) RETURNING *`,
    INSERT_QUIZ_QUESTIONS:`INSERT INTO questions(exercise_id,question_text,description,correct_answer) VALUES($1,$2,$3,$4) RETURNING *`,
    INSERT_QUIZ_OPTIONS:`INSERT INTO options(question_id,option_text,option_id) VALUES($1,$2,$3) RETURNING *`,
}