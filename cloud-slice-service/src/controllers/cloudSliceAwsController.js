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
    console.log(files)
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

module.exports = {
    getAllAwsServices,
    createCloudSliceLab,
    createCloudSliceLabWithModules,
}