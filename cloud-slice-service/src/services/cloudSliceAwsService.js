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

        for(module of modules){
            const {name,description} = module;
            if (!name || !description) {
                throw new Error('Please provide all required fields in modules');
            }
            const moduleResult = await pool.query(cloudSliceAwsQueries.INSERT_MODULES,[name,description,labId]);
            const moduleId = moduleResult.rows[0].id;

            for (exercise of module.exercises){
                const type = exercise.type;
                const exercise_result = await pool.query(cloudSliceAwsQueries.INSERT_EXERCISES,[moduleId,type]);

                const exerciseId = exercise_result.rows[0].id;
                if (!exerciseId) {
                    throw new Error('Exercise creation failed');
                }
                if(exercise.type === 'lab'){
                    const {title,duration,instructions,services,files,cleanupPolicy} = exercise.labExercise;
                    if (!duration || !instructions || !services || !files) {
                        throw new Error('Please provide all required fields in lab exercises');
                    }
                    const labExercise = await pool.query(cloudSliceAwsQueries.INSERT_LAB_EXERCISES,[exerciseId,duration,instructions,services,getMatchingFilePaths(filesArray,files),title,cleanupPolicy]);
                
            }
            if(exercise.type === 'questions'){
                for(question of exercise.questions){
                    const {title,description,correctAnswer} = question;
                    if (!title || !description || !correctAnswer) {
                        throw new Error('Please provide all required fields in questions');
                    }
                    const question_result = await pool.query(cloudSliceAwsQueries.INSERT_QUIZ_QUESTIONS,[exerciseId,title,description,correctAnswer,exercise.duration,exercise.title]);
                    const questionId = question_result.rows[0].id;
                    if (!questionId) {
                        throw new Error('Question creation failed');
                    }
                    for(option of question.options){
                        const {id , text} = option;
                        let is_correct=false;
                        if(question.correctAnswer === id){
                            is_correct = true;
                        }
                        if (!id || !text) {
                            throw new Error('Please provide all required fields in options');
                        }
                        const option_result = await pool.query(cloudSliceAwsQueries.INSERT_QUIZ_OPTIONS,[questionId,text,id,is_correct]);
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
const getAllModules = async () => {
    const result = await pool.query(cloudSliceAwsQueries.GET_ALL_MODULES);
    if (!result.rows.length) throw new Error('No modules found');
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
  getQuizExercisesByModuleId
}

