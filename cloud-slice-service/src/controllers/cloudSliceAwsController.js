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

module.exports = {
    getAllAwsServices,
}