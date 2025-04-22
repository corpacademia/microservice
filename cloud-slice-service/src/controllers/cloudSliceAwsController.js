const { json } = require('body-parser');
const clouSliceAwsService = require('../services/cloudSliceAwsService');

const getAllAwsServices = async(req,res)=>{
    try {
        const result = await clouSliceAwsService.getAllAwsServices();
        if(!result.length){
            return res.status(404).send({
                success:false,
                message:"No aws services found"
            })
        }
            return res.status(200).send({
                success:true,
                message:"Successfully fetched all aws services",
                data:result
            })
        
    } catch (error) {
        console.log(error);
        return res.status(500).send({
            success:true,
            message:"Internal server error",
            error :error.message
        })
    }
}

//create cloud slice lab
const createCloudSliceLab = async(req,res)=>{
    try {
        const {createdBy,labData} = req.body;
        if(!labData){
            return res.status(400).send({
                success:false,
                message:"Please provide lab data"
            })
        }
        const result = await clouSliceAwsService.createCloudSliceLab(createdBy,labData);
        if(!result){
            return res.status(400).send({
                success:false,
                message:"Failed to create cloud slice lab"
            })
        }
        return res.status(201).send({
            success:true,
            message:"Successfully created cloud slice lab",
            data:result
        })
    } catch (error) {
        console.log(error);
        return res.status(500).send({
            success:false,
            message:"Internal server error",
            error:error.message
        })
    }
    

}

const createCloudSliceLabWithModules = async(req,res)=>{
    try {
        const labData = JSON.parse(req.body.data);
    const files = req.files.map(file=>file.path);
    const filesArray = files.length > 0 ? files : null;
    const createLab = await clouSliceAwsService.createCloudSliceLabWithModules(labData,filesArray);
    
    return res.status(201).send({
        success:true,
        message:"Successfully created cloud slice lab with modules",
        data:createLab
    })
    } catch (error) {
        console.log(error);
        return res.status(500).send({
            success:false,
            message:"Internal server error",
            error:error.message
        })
        
    }
    }

    const getCloudSliceLabByCreatedUserId = async(req,res)=>{
        try {
            const userId = req.query.userId;
            if(!userId){
                return res.status(400).send({
                    success:false,
                    message:"Please provide user id"
                })
            }
            const result = await clouSliceAwsService.getCloudSliceLabsByCreatedUser(userId);
            if(!result.length){
                return res.status(404).send({
                    success:false,
                    message:"No cloud slice labs found"
                })
            }
            return res.status(200).send({
                success:true,
                message:"Successfully fetched all cloud slice labs",
                data:result
            })
        } catch (error) {
            console.log(error);
            return res.status(500).send({
                success:false,
                message:"Internal server error",
                error:error.message
            })
        }
    }

// get cloud slice lab by id
const getCloudSliceLabById = async(req,res)=>{
    try {
        const {labId} = req.params;
        console.log(labId)
        if(!labId){
            return res.status(400).send({
                success:false,
                message:"Please provide lab id"
            })
        }
        const result = await clouSliceAwsService.getCloudSliceLabById(labId);
        if(!result){
            return res.status(404).send({
                success:false,
                message:"No cloud slice lab found with this id"
            })
        }
        return res.status(200).send({
            success:true,
            message:"Successfully fetched cloud slice lab",
            data:result
        })
    } catch (error) {
        console.log(error);
        return res.status(500).send({
            success:false,
            message:"Internal server error",
            error:error.message
        })
    }
}

//update the services on lab id
const updateServicesOnLabId = async(req,res)=>{
    const {labId} = req.params;
    const {services} = req.body;
    if(!labId){
        return res.status(400).send({
            success:false,
            message:"Please provide lab id"
        })
    }
    if(!services){
        return res.status(400).send({
            success:false,
            message:"Please provide services"
        })
    }
    try {
        const result = await clouSliceAwsService.updateServicesOnLabId(labId,services);
        if(!result){
            return res.status(404).send({
                success:false,
                message:"No cloud slice lab found with this id"
            })
        }
        return res.status(200).send({
            success:true,
            message:"Successfully updated services on cloud slice lab",
            data:result
        })
    } catch (error) {
        console.log(error);
        return res.status(500).send({
            success:false,
            message:"Internal server error",
            error:error.message
        })
    }
}

//get modules on lab id
const getModulesOnLabId = async(req,res)=>{
    const {labId} = req.params;
    if(!labId){
        return res.status(400).send({
            success:false,
            message:"Please provide lab id"
        })
    }
    try {
        const result = await clouSliceAwsService.getModulesOnLabId(labId);
        if(!result){
            return res.status(404).send({
                success:false,
                message:"No modules found with this lab id"
            })
        }
        return res.status(200).send({
            success:true,
            message:"Successfully fetched modules on cloud slice lab",
            data:result
        })
    } catch (error) {
        console.log(error);
        return res.status(500).send({
            success:false,
            message:"Internal server error",
            error:error.message
        })
    }
}

//get lab exercises on module id
const getLabExercisesOnModuleId = async(req,res)=>{
    const {moduleId} = req.params;
    if(!moduleId){
        return res.status(400).send({
            success:false,
            message:"Please provide module id"
        })
    }
    try {
        const result = await clouSliceAwsService.getLabExercisesOnModuleId(moduleId);
        if(!result){
            return res.status(404).send({
                success:false,
                message:"No lab exercises found with this module id"
            })
        }
        return res.status(200).send({
            success:true,
            message:"Successfully fetched lab exercises on module",
            data:result
        })
    } catch (error) {
        console.log(error);
        return res.status(500).send({
            success:false,
            message:"Internal server error",
            error:error.message
        })
    }
}


// MODULES
const getAllModules = async (req, res) => {
    try {
        const { sliceId } = req.params;
      const modules = await clouSliceAwsService.getAllModules(sliceId);
      for (const mod of modules) {
        const exercises = await clouSliceAwsService.getExercisesByModuleId(mod.id);
        mod.exercises = exercises;
      }
      if(!modules.length) {
        return res.status(404).send({
          success: false,
          message: "No modules found"
        });
      }
      return res.status(200).send({
        success: true,
        message: "Modules fetched successfully",
        data: modules
      });
    } catch (error) {
      console.log(error);
      return res.status(500).send({
        success: false,
        message: "Internal Server Error",
        error: error.message
      });
    }
  };
  
  // LAB EXERCISES
  const getLabExercises = async (req, res) => {
    const { moduleId } = req.params;
    try {
      const result = await clouSliceAwsService.getLabExercisesByModuleId(moduleId);
      if(!result.length) {
        return res.status(404).send({
          success: false,
          message: "No lab exercises found for this module"
        });
      }
      return res.status(200).send({
        success: true,
        message: "Lab exercises fetched successfully",
        data: result
      });
    } catch (error) {
      console.log(error);
      return res.status(500).send({
        success: false,
        message: "Internal Server Error",
        error: error.message
      });
    }
  };
  
  // QUIZ EXERCISES
  const getQuizExercises = async (req, res) => {
    const { moduleId } = req.params;
    try {
      const result = await clouSliceAwsService.getQuizExercisesByModuleId(moduleId);
      if(!result.length) {
        return res.status(404).send({
          success: false,
          message: "No quiz exercises found for this module"
        });
      }
      return res.status(200).send({
        success: true,
        message: "Quiz exercises fetched successfully",
        data: result
      });
    } catch (error) {
      console.log(error);
      return res.status(500).send({
        success: false,
        message: "Internal Server Error",
        error: error.message
      });
    }
  };
  
//update module on id
const updateModuleOnId = async(req,res)=>{
    try {
        const moduleData =  req.body;
        if(!moduleData) {
            return res.status(400).send({
                success:false,
                message:"Please provide module data"
            })
        }
        const result = await clouSliceAwsService.updateModuleOnId(moduleData);
        if (!result ) {
            return res.status(404).send({
                success: false,
                message: "No module found with this id"
            });
        }
        return res.status(200).send({
            success:true,
            message:"Successfully updated module",
            data:result
        })  
    } catch (error) {
        console.log(error);
        return res.status(500).send({
            success:false,
            message:"Internal server error",
            error:error.message
        })
        
    }
}

//delete module on id
const deleteModuleOnId = async(req,res)=>{
    try {
        const {moduleId} = req.params;
        if(!moduleId){
            return res.status(400).send({
                success:false,
                message:"Please provide module id"
            })
        }
        const result = await clouSliceAwsService.deleteModuleOnId(moduleId);
        if(!result){
            return res.status(404).send({
                success:false,
                message:"No module found with this id"
            })
        }
        return res.status(200).send({
            success:true,
            message:"Successfully deleted module",
            data:result
        })

    } catch (error) {
        console.log(error);
        return res.status(500).send({
            success:false,
            message:"Internal server error",
            error:error.message
        })
        
    }
}

//update exercise main content on id
const updateExerciseMainContentOnId = async(req,res)=>{
    try {
        const  moduleData  = req.body;

        if(!moduleData) {
            return res.status(400).send({
                success:false,
                message:"Please provide module data"
            })
        }
        const result = await clouSliceAwsService.updateExerciseMainContentOnId(moduleData);
        if (!result ) {
            return res.status(404).send({
                success: false,
                message: "No module found with this id"
            });
        }
        return res.status(200).send({
            success:true,
            message:"Successfully updated module",
            data:result
        })
    } catch (error) {
        console.log(error);
        return res.status(500).send({
            success:false,
            message:"Internal server error",
            error:error.message
        })
        
    }
}

//delete exercise on id
const deleteExerciseOnId = async(req,res)=>{  
    try {
        const exerciseId = req.params.exerciseId;
        if(!exerciseId){
            return res.status(400).send({
                success:false,
                message:"Please provide exercise id"
            })
        }
        const result = await clouSliceAwsService.deleteExerciseOnId(exerciseId);
        if(!result){
            return res.status(404).send({
                success:false,
                message:"No exercise found with this id"
            })
        }
        return res.status(200).send({
            success:true,
            message:"Successfully deleted exercise",
            data:result
        })
    } catch (error) {
        console.log(error);
        return res.status(500).send({
            success:false,
            message:"Internal server error",
            error:error.message
        })
    }
  }

  //update lab_exercise on exercise id
  const updateLabExerciseOnExerciseId = async(req,res)=>{
    try {
        const exerciseData = req.body;
        if(!exerciseData){
            return res.status(400).send({
                success:false,
                message:"Please provide exercise data"
            })
        }
        const result = await clouSliceAwsService.updateLabExerciseContentOnExerciseId(exerciseData);
        if(!result){
            return res.status(404).send({
                success:false,
                message:"No exercise found with this id"
            })
        }
        return res.status(200).send({
            success:true,
            message:"Successfully updated exercise",
            data:result
        })
    } catch (error) {
        console.log(error);
        return res.status(500).send({
            success:false,
            message:"Internal server error",
            error:error.message
        })
    }
  }

//update quiz exercise on exercise id
const updateQuizExerciseOnExerciseId = async(req,res)=>{
    try {
        const exerciseData = req.body;
        if(!exerciseData){
            return res.status(400).send({
                success:false,
                message:"Please provide exercise data"
            })
        }
        const result = await clouSliceAwsService.updateQuizExerciseContentOnExerciseId(exerciseData);
        if(!result){
            return res.status(404).send({
                success:false,
                message:"No exercise found with this id"
            })
        }
        return res.status(200).send({
            success:true,
            message:"Successfully updated exercise",
            data:result
        })


    } catch (error) {
        console.log(error);     
        return res.status(500).send({
            success:false,
            message:"Internal server error",
            error:error.message
        })

    }
}

module.exports = {
    getAllAwsServices,
    createCloudSliceLab,
    createCloudSliceLabWithModules,
    getCloudSliceLabByCreatedUserId,
    getCloudSliceLabById,
    updateServicesOnLabId,
    getModulesOnLabId,
    getLabExercisesOnModuleId,
    getAllModules,
  getLabExercises,
  getQuizExercises,
  updateModuleOnId,
  deleteModuleOnId,
  updateExerciseMainContentOnId,
  deleteExerciseOnId,
  updateLabExerciseOnExerciseId,
  updateQuizExerciseOnExerciseId,
}