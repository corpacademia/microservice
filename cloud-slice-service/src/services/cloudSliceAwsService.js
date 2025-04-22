const cloudSliceAwsQueries = require('./cloudSliceQueries');

const pool= require('../db/dbconfig');

//function to get the files path with matching name
function getMatchingFilePaths(filePaths, files) {
    const fileNames = files.map(f => f.name);
  
    return filePaths.filter(path => {
      const fullFileName = path.split('\\').pop(); // get the filename from path
      const dashIndex = fullFileName.indexOf('-');
      const nameAfterDash = fullFileName.substring(dashIndex + 1); // extract part after first dash
  
      return fileNames.includes(nameAfterDash);
    });
  }



const getAllAwsServices = async () => {
    try {
        const result = await pool.query(cloudSliceAwsQueries.GET_ALL_AWS_SERVICES);
        if (!result.rows.length) {
            throw new Error('No AWS services found');
        }
        return result.rows;
    } catch (error) {
        console.log(error);
        throw new Error('Error in getAllAwsServices function',error);
    }
};

const createCloudSliceLab = async (createdBy,labData) => {
    const { services, region, startDate, endDate, cleanupPolicy, platform, cloudProvider, title, description, labType, credits } = labData;
   
    if (!services || !region || !startDate || !endDate || !cleanupPolicy  || !platform || !cloudProvider || !title || !description || !labType ) {
        throw new Error('Please provide all required fields');
    }
     try {
        const result = await pool.query(cloudSliceAwsQueries.INSERT_LAB_DATA,
            [createdBy,JSON.stringify(services), region, startDate, endDate, cleanupPolicy, platform, cloudProvider, title, description, labType, credits]);
        return result.rows[0];
    } catch (error) {
        console.log(error);
        throw new Error('Error in createCloudSliceLab function', error);
    }
}

//create a function to create cloudslice lab with modules
const createCloudSliceLabWithModules = async (labData,filesArray) => {
    try {
        const {createdBy,labConfig,modules} = labData;
        console.log('modules',modules);
        if (!createdBy || !labConfig || !modules) {
            throw new Error('Please provide all required fields');
        }
        const {cloudProvider,description,endDate,labType,platform,region,services,startDate,title} = labConfig;

        if ( !cloudProvider || !description || !endDate || !labType || !platform || !region  || !startDate || !title) {
            throw new Error('Please provide all required fields in labConfig');
        }
        const lab = await pool.query(cloudSliceAwsQueries.INSERT_LAB_DATA_WITH_MODULES,[createdBy,JSON.stringify(services),region,startDate,endDate,platform,cloudProvider,title,description,labType]);
     
        const labId = lab.rows[0].labid;
        if (!labId) {
            throw new Error('Lab creation failed');
        }

        for (const module of modules) {
            const { name, description } = module;
            if (!name || !description) {
                throw new Error('Please provide all required fields in modules');
            }
        
            let totalDuration = 0; // 👈 Initialize total duration
        
            // Pre-calculate exercise durations
            for (const exercise of module.exercises) {
                if (exercise.type === 'lab') {
                    totalDuration += Number(exercise.labExercise?.duration || 0);
                } else if (exercise.type === 'questions') {
                    totalDuration += Number(exercise.duration || 0); // assuming quiz exercise has a `duration`
                }
            }
        
            // Now insert the module with the calculated totalDuration
            const moduleResult = await pool.query(cloudSliceAwsQueries.INSERT_MODULES, [name, description, labId, totalDuration]);
            const moduleId = moduleResult.rows[0].id;
        
            for (const exercise of module.exercises) {
                const type = exercise.type;
                const exercise_result = await pool.query(cloudSliceAwsQueries.INSERT_EXERCISES, [moduleId, type]);
                const exerciseId = exercise_result.rows[0].id;
        
                if (!exerciseId) {
                    throw new Error('Exercise creation failed');
                }
        
                if (type === 'lab') {
                    const { title, duration, instructions, services, files, cleanupPolicy } = exercise.labExercise;
                    if (!duration || !instructions || !services || !files) {
                        throw new Error('Please provide all required fields in lab exercises');
                    }
        
                    await pool.query(cloudSliceAwsQueries.INSERT_LAB_EXERCISES, [
                        exerciseId,
                        duration,
                        instructions,
                        services,
                        getMatchingFilePaths(filesArray, files),
                        title,
                        cleanupPolicy
                    ]);
                }
        
                if (type === 'questions') {
                    for (const question of exercise.questions) {
                        const { title, description, correctAnswer } = question;
                        if (!title || !description || !correctAnswer) {
                            throw new Error('Please provide all required fields in questions');
                        }
        
                        const question_result = await pool.query(cloudSliceAwsQueries.INSERT_QUIZ_QUESTIONS, [
                            exerciseId,
                            title,
                            description,
                            correctAnswer,
                            exercise.duration,
                            exercise.title
                        ]);
        
                        const questionId = question_result.rows[0].id;
                        if (!questionId) {
                            throw new Error('Question creation failed');
                        }
        
                        for (const option of question.options) {
                            const { id, text } = option;
                            let is_correct = question.correctAnswer === id;
        
                            if (!id || !text) {
                                throw new Error('Please provide all required fields in options');
                            }
        
                            const option_result = await pool.query(cloudSliceAwsQueries.INSERT_QUIZ_OPTIONS, [
                                questionId,
                                text,
                                id,
                                is_correct
                            ]);
        
                            if (!option_result) {
                                throw new Error('Option creation failed');
                            }
                        }
                    }
                }
            }
        }
        

    } catch (error) {
        console.log(error);
        throw new Error('Error in createCloudSliceLabWithModules function', error);
        
    }
}

const getCloudSliceLabsByCreatedUser = async(userId)=>{
    try {
        const result = await pool.query(cloudSliceAwsQueries.GET_ALL_LABS_ON_CREATED_USER,[userId]);
      
        return result.rows;
    } catch (error) {
        console.log(error);
        throw new Error('Error in getCloudSliceLabs function', error);
    }
}

//fetch cloudslice lab by id
const getCloudSliceLabById = async(labId)=>{
    try {
        const result = await pool.query(cloudSliceAwsQueries.GET_LABS_ON_ID,[labId]);
        if (!result.rows.length) {
            throw new Error('No lab found with this id');
        }
        return result.rows[0];
    } catch (error) {
        console.log(error);
        throw new Error('Error in getCloudSliceLabById function', error);
    }
}

//update the services on lab id
const updateServicesOnLabId = async(labId,services)=>{
    try {
        const result = await pool.query(cloudSliceAwsQueries.UPDATE_SERVICES_ON_LABID,[JSON.stringify(services),labId]);
        if (!result.rows.length) {
            throw new Error('No lab found with this id');
        }
        return result.rows[0];
    } catch (error) {
        console.log(error);
        throw new Error('Error in updateServicesOnLabId function', error);
    }
}

//GET MODULES ON LABID
const getModulesOnLabId = async(labId)=>{
    try {
        const result = await pool.query(cloudSliceAwsQueries.GET_MODULES_ON_LABID,[labId]);
        if (!result.rows.length) {
            throw new Error('No lab found with this id');
        }
        return result.rows[0];
    } catch (error) {
        console.log(error);
        throw new Error('Error in getModulesOnLabId function', error);
    }
}

const getLabExercisesOnModuleId = async(moduleId)=>{
    try {
        const result = await pool.query(cloudSliceAwsQueries.GET_LAB_EXERCISES_ON_MODULEID,[moduleId]);
        if (!result.rows.length) {
            throw new Error('No lab found with this id');
        }
        return result.rows;
    } catch (error) {
        console.log(error);
        throw new Error('Error in getLabExercisesOnModuleId function', error);
    }
}

// MODULES
const getAllModules = async (labId) => {
    const result = await pool.query(cloudSliceAwsQueries.GET_ALL_MODULES,[labId]);
    return result.rows;
  };
  
  const getExercisesByModuleId = async (moduleId) => {
    const result = await pool.query(cloudSliceAwsQueries.GET_MODULE_EXERCISES, [moduleId]);
    return result.rows;
  };
  
  // LABS
  const getLabExercisesByModuleId = async (moduleId) => {
    const result = await pool.query(cloudSliceAwsQueries.GET_LAB_EXERCISES_BY_MODULE, [moduleId]);
    return result.rows;
  };
  
  // QUIZZES
  const getQuizExercisesByModuleId = async (moduleId) => {
    const { rows: exercises } = await pool.query(cloudSliceAwsQueries.GET_QUIZ_EXERCISES_IDS_BY_MODULE, [moduleId]);
    const quizData = [];
  
    for (const ex of exercises) {
      const { rows: questions } = await pool.query(cloudSliceAwsQueries.GET_QUESTIONS_BY_EXERCISE_ID, [ex.exercise_id]);
  
      for (const q of questions) {
        const { rows: options } = await pool.query(cloudSliceAwsQueries.GET_OPTIONS_BY_QUESTION_ID, [q.id]);
        q.options = options;
      }
      quizData.push({
        exerciseId: ex.exercise_id,
        questions
      });
    }
    return quizData;
  };

  //update module on id
  const updateModuleOnId = async(moduleData)=>{
     try{
        const {id,title,description,totalduration} = moduleData;
        if (!id || !title || !description || !totalduration) {
            throw new Error('Please provide all required fields in modules');
        }
        const result = await pool.query(cloudSliceAwsQueries.UPDATE_MODULE_ON_ID,[title,description,totalduration,id]);
        return result.rows[0];
     }
     catch(error){
        throw new Error("Error in updateModuleOnId function",error);
     }
  }

  //DELETE MODULE ON ID
  const deleteModuleOnId = async (moduleId) => {
    try {
        const exerciseResult = await pool.query(cloudSliceAwsQueries.GET_ALL_EXERCISES_ON_MODULEID, [moduleId]);

        if (!exerciseResult.rows.length) {
            throw new Error('No exercises found for this module');
        }

        const exercises = exerciseResult.rows;

        for (const exercise of exercises) {
            const exerciseId = exercise.id;

            const questionResult = await pool.query(cloudSliceAwsQueries.GET_QUESTIONS_BY_EXERCISE_ID, [exerciseId]);

            for (const question of questionResult.rows) {
                const questionId = question.id;

                // Delete options for each question
                await pool.query(cloudSliceAwsQueries.DELETE_OPTIONS_ON_QUESTION_ID, [questionId]);

                // Delete the question itself
                await pool.query(cloudSliceAwsQueries.DELETE_QUESTION_ON_ID, [questionId]);
            }

            // Delete lab and quiz exercises
            await pool.query(cloudSliceAwsQueries.DELETE_LAB_EXERCISE_ON_EXERCISE_ID, [exerciseId]);
            await pool.query(cloudSliceAwsQueries.DELETE_QUIZ_EXERCISE_ON_EXERCISE_ID, [exerciseId]);

            // Delete the main exercise
            await pool.query(cloudSliceAwsQueries.DELETE_EXERCISE_ON_ID, [exerciseId]);
        }

        // Finally, delete the module
        const deleteModule = await pool.query(cloudSliceAwsQueries.DELETE_MODULE_ON_ID, [moduleId]);

        if (!deleteModule.rows.length) {
            throw new Error('No module found with this id');
        }

        return deleteModule.rows[0];

    } catch (error) {
        console.error("Detailed error during deleteModuleOnId:", error);
        throw new Error(`Error in deleteModuleOnId function: ${error.message}`);
    }
};

//delete exercise and its content
const deleteExerciseOnId = async(exerciseId)=>{
    try {
        const exerciseResult = await pool.query(cloudSliceAwsQueries.GET_EXERCISE_ON_ID, [exerciseId]);
        if (!exerciseResult.rows.length) {
            throw new Error('No exercise found with this id');
        }
        const exercise = exerciseResult.rows[0];
        if(exercise.type === 'lab'){
            await pool.query(cloudSliceAwsQueries.DELETE_LAB_EXERCISE_ON_EXERCISE_ID,[exerciseId]);
        }
        else if(exercise.type === 'questions'){
            const questionResult = await pool.query(cloudSliceAwsQueries.GET_QUESTIONS_BY_EXERCISE_ID, [exerciseId]);
            if (!questionResult.rows.length) {
                throw new Error('No questions found for this exercise');
            }
            const questions = questionResult.rows;
            for (const question of questions) {
                const questionId = question.id;
                await pool.query(cloudSliceAwsQueries.DELETE_OPTIONS_ON_QUESTION_ID, [questionId]);
                await pool.query(cloudSliceAwsQueries.DELETE_QUIZ_EXERCISE_ON_EXERCISE_ID, [questionId]);
            }
           
    }
    const exerciseDelete = await pool.query(cloudSliceAwsQueries.DELETE_EXERCISE_ON_ID,[exerciseId]);
    if (!exerciseDelete.rows.length) {
        throw new Error('No exercise found with this id');
    }
    return exerciseDelete.rows[0];
} catch (error) {
        console.log(error);
        throw new Error('Error in deleteExerciseOnId function', error);
        
    }
}

  //update headings of exercises on exercise id
  const updateExerciseMainContentOnId = async(exerciseData)=>{
    try {
        let quiz_exercise = null;
        const {description,type,duration,title,id} = exerciseData;
        const exercise =  await pool.query(cloudSliceAwsQueries.UPDATE_EXERCISE_ON_ID,[type,id]);
        if (!exercise.rows.length) {
            throw new Error('No exercise found with this id');
        }
        const lab_exercise = await pool.query(cloudSliceAwsQueries.UPDATE_LAB_EXERCISE_ON_EXERCISE_ID,[title,duration,id]);
        if (!lab_exercise.rows.length) {
             quiz_exercise = await pool.query(cloudSliceAwsQueries.UPDATE_QUIZ_EXERCISE_ON_EXERCISE_ID,[title,description,duration,id]);
            if (!quiz_exercise.rows.length) {
                throw new Error('No exercise found with this id');
            }
        }
        return {
            exercise: exercise.rows[0],
            lab_exercise: lab_exercise.rows[0] ? lab_exercise.rows[0] : null,
            quiz_exercise: quiz_exercise ? quiz_exercise.rows[0] : null
        }
    } catch (error) {
        throw new Error("Error in updateExerciseMainContentOnId function",error);
        
    }
  }

  //UPDATE LAB_EXERCISE CONTENT ON EXERCISE ID
  const updateLabExerciseContentOnExerciseId = async(exerciseData)=>{
    try {
        const {id,instructions,services,files,cleanupPolicy} = exerciseData;
        if (!id || !instructions || !services || !files || !cleanupPolicy) {
            throw new Error('Please provide all required fields in lab exercises');
        }
        const lab_exercise = await pool.query(cloudSliceAwsQueries.UPDATE_LAB_EXERCISE_CONTENT_ON_EXERCISE_ID,[instructions,services,files,cleanupPolicy,id]);
        if (!lab_exercise.rows.length) {
            throw new Error('No lab exercise found with this id');
        }
        return lab_exercise.rows[0];

    } catch (error) {
        console.log(error);
        throw new Error("Error in updateLabExerciseContentOnExerciseId function",error);
    }
  }

  //update the quiz exercise content on exercise id
  const updateQuizExerciseContentOnExerciseId = async(exerciseData)=>{
    try {
        const {exerciseId,questions,duration} = exerciseData;
        if (!exerciseId || !questions) {
            throw new Error('Please provide all required fields in quiz exercises');
        }
        for(question of questions){
            const questionResult = await pool.query(cloudSliceAwsQueries.GET_QUESTIONS_BY_EXERCISE_ID, [question.id]);
            if(questionResult.rows.length){
                const {description,duration,id,options,text} = question;
                const quiz_exercise = await pool.query(cloudSliceAwsQueries.UPDATE_QUIZ_EXERCISE_ON_EXERCISE_ID,[text,description,duration,id]);

                for(option of options){
                    const optionResult = await pool.query(cloudSliceAwsQueries.GET_OPTIONS_BY_QUESTION_ID, [id]);
                    if(optionResult.rows.length){
                        const {is_correct,text} = option;
                        const quiz_option = await pool.query(cloudSliceAwsQueries.UPDATE_QUIZ_OPTION_ON_ID,[text,is_correct,option.id]);
                        if (!quiz_option.rows.length) {
                            throw new Error('No quiz option found with this id');
                        }
                    }
                    else{
                        const quiz_option = await pool.query(cloudSliceAwsQueries.INSERT_QUIZ_OPTIONS,[question.id,option.text,option.id,option.is_correct]);
                        if (!quiz_option.rows.length) {
                            throw new Error('No quiz option found with this id');
                        }
                    }
                }
            }
            else{
                const quiz_exercise = await pool.query(cloudSliceAwsQueries.INSERT_QUIZ_QUESTIONS,[exerciseId,question.text,"","",duration,""]);
                if (!quiz_exercise.rows.length) {
                    throw new Error('No quiz exercise found with this id');
                }
                const questionId = quiz_exercise.rows[0].id;
                for(option of question.options){
                    const quiz_option = await pool.query(cloudSliceAwsQueries.INSERT_QUIZ_OPTIONS,[questionId,option.text,option.id,option.is_correct]);
                    if (!quiz_option.rows.length) {
                        throw new Error('No quiz option found with this id');
                    }
                }
            }
        }   

    } catch (error) {
        console.log(error);
        throw new Error("Error in updateQuizExerciseContentOnExerciseId function",error);
    }
  }

module.exports = {
    getAllAwsServices,
    createCloudSliceLab,
    createCloudSliceLabWithModules,
    getCloudSliceLabsByCreatedUser,
    getCloudSliceLabById,
    updateServicesOnLabId,
    getModulesOnLabId,
    getLabExercisesOnModuleId,
    getAllModules,
  getExercisesByModuleId,
  getLabExercisesByModuleId,
  getQuizExercisesByModuleId,
  updateModuleOnId,
  deleteModuleOnId,
  updateExerciseMainContentOnId,
  deleteExerciseOnId,
  updateLabExerciseContentOnExerciseId,
  updateQuizExerciseContentOnExerciseId
}

