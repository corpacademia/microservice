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
    const { services, region, startDate, endDate, cleanupPolicy, platform, cloudProvider, title, description, labType } = labData;
   
    if (!services || !region || !startDate || !endDate || !cleanupPolicy  || !platform || !cloudProvider || !title || !description || !labType ) {
        throw new Error('Please provide all required fields');
    }
     try {
        const result = await pool.query(cloudSliceAwsQueries.INSERT_LAB_DATA,
            [createdBy,JSON.stringify(services), region, startDate, endDate, cleanupPolicy, platform, cloudProvider, title, description, labType]);
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
        if (!createdBy || !labConfig || !modules) {
            throw new Error('Please provide all required fields');
        }
        const {cleanupPolicy,cloudProvider,description,endDate,labType,platform,region,services,startDate,title} = labConfig;

        if (!cleanupPolicy || !cloudProvider || !description || !endDate || !labType || !platform || !region  || !startDate || !title) {
            throw new Error('Please provide all required fields in labConfig');
        }
        const lab = await pool.query(cloudSliceAwsQueries.INSERT_LAB_DATA,[createdBy,JSON.stringify(services),region,startDate,endDate,cleanupPolicy,platform,cloudProvider,title,description,labType]);
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
                    const {title,duration,instructions,services,files} = exercise.labExercise;
                    console.log('labExercise', exercise.labExercise)
                    if (!duration || !instructions || !services || !files) {
                        throw new Error('Please provide all required fields in lab exercises');
                    }
                    const labExercise = await pool.query(cloudSliceAwsQueries.INSERT_LAB_EXERCISES,[exerciseId,duration,instructions,services,getMatchingFilePaths(filesArray,files),title]);
                
            }
            if(exercise.type === 'questions'){
                for(question of exercise.questions){
                    const {title,description,correctAnswer} = question;
                    if (!title || !description || !correctAnswer) {
                        throw new Error('Please provide all required fields in questions');
                    }
                    const question_result = await pool.query(cloudSliceAwsQueries.INSERT_QUIZ_QUESTIONS,[exerciseId,title,description,correctAnswer]);
                    const questionId = question_result.rows[0].id;
                    if (!questionId) {
                        throw new Error('Question creation failed');
                    }
                    for(option of question.options){
                        const {id , text} = option;
                        if (!id || !text) {
                            throw new Error('Please provide all required fields in options');
                        }
                        const option_result = await pool.query(cloudSliceAwsQueries.INSERT_QUIZ_OPTIONS,[questionId,text,id]);
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


module.exports = {
    getAllAwsServices,
    createCloudSliceLab,
    createCloudSliceLabWithModules,
    getCloudSliceLabsByCreatedUser,
    getCloudSliceLabById,
    updateServicesOnLabId,
    getModulesOnLabId,
}

