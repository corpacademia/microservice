const clusterService = require('../services/clusterService');

const path = require('path');
const fs = require('fs');

const uploadDir = path.join(__dirname, '../public/uploads');

const createVMClusterDatacenterLab = async(req,res)=>{
    try {
        const {userId,data} = req.body;
         const { userGuides = [], labGuides = [] } = data;
                const savedUserGuidePaths = [];
                const savedLabGuidePaths = [];
                // Save user guide files and collect full paths
                userGuides.forEach(file => {
              const base64Data = file.content.split(';base64,').pop();
              const filePath = path.join(uploadDir, file.name);
              fs.writeFileSync(filePath, Buffer.from(base64Data, 'base64'));
              savedUserGuidePaths.push(filePath); 
            });
        
            // Save lab guide files and collect full paths
            labGuides.forEach(file => {
              const base64Data = file.content.split(';base64,').pop();
              const filePath = path.join(uploadDir, file.name);
              fs.writeFileSync(filePath, Buffer.from(base64Data, 'base64'));
              savedLabGuidePaths.push(filePath); 
            });
            // Add full paths to the data object
            const updatedData = {
              ...data,
              userGuides: savedUserGuidePaths,
              labGuides: savedLabGuidePaths,
            };
        const result = await clusterService.createVMClusterDatacenterLab(updatedData,userId);
        if(!result){
            return res.status(404).send({
                success:false,
                message:"Could not create the vmcluster datacenter lab"
            })
        }
        return res.status(200).send({
            success:true,
            message:"Successfully created the vm cluster lab",
            data:result
        })
    } catch (error) {
        console.log(error);
        return res.status(500).send({
            success:false,
            message:"Error in creating vmcluster datacenter lab",
            error:error.message
        })
    }
}

//get all labs of user
const getVMClusterDatacenterlab = async(req,res)=>{
    try {
        const {userId} = req.body;
        const result = await clusterService.getVMClusterDatacenterlab(userId);
        if(!result){
            return res.status(400).send({
                success:false,
                message:"No labs found for the user"
            })
        }
        return res.status(200).send({
            success:true,
            message:"Successfully accessed the labs",
            data:result
        })
    } catch (error) {
        console.log(error);
        return res.status(500).send({
            success:false,
            message:"Error in getting the labs",
            error:error.message
        })
    }
}

//delete the datacenter lab
const deleteDatacenterLab = async(req,res)=>{
    try {
        const labId = req.params.labId;
        await clusterService.deleteDatacenterLab(labId);

        return res.status(200).send({
            success:true,
            messsage:"Successfully deleted the  lab"
        })
    } catch (error) {
        console.log(error);
        return res.status(500).send({
            success:false,
            message:"Error in deleting the datacenter lab",
            error:error.message
        })
    }
}

//update the vm cluster datacenter lab
const updateSingleVMDatacenterLab = async(req,res)=>{
    try {
       const labGuideFile = req.files?.labGuide?.[0] // new file if any
       const userGuideFile = req.files?.userGuide?.[0];
       let {labId , title ,description ,startDate,endDate,software,existingLabGuide,existingUserGuide,credentials,vmConfigs} = req.body;
       const finalLabGuide = [existingLabGuide, labGuideFile?.path].filter(Boolean);
       const finalUserGuide = [existingUserGuide, userGuideFile?.path].filter(Boolean);
       software = software.length > 0 ? JSON.parse(software) : null;
       const result  = await clusterService.updateVMClusterDatacenterLab(labId , title ,description ,startDate,endDate,software,finalLabGuide,finalUserGuide,JSON.parse(credentials),JSON.parse(vmConfigs));
       if(!result){
        return res.status(400).send({
            success:false,
            message:"Could not update the lab"
        })
       }
       return res.status(200).send({
        success:true,
        message:"Successfully updated the lab",
        data:result
       })
    } catch (error) {
        console.log(error);
        return res.status(500).send({
            success:false,
            message:'Error in updating vm cluster datacenter lab',
            error:error.message
        })
    }
}

//update the uservm enable/disable
const updateUserVM = async(req,res)=>{
    try {
         const data = req.body;
        const result = await clusterService.updateUserVM(data);
        if(!result){
             return res.status(400).send({
             success:false,
             message:"Could not update the vmcluster datacenter lab"
             })
            }
   return res.status(200).send({
    success:true,
    message:"Successfully updated the vmcluster datacenter lab",
    data:result
   })
    } catch (error) {
        console.log("Error in updating the vmcluster datacenter lab:",error.message);
        return res.status(500).send({
            success:false,
            message:"Error in updating the vmcluster datacenter lab",
            error:error.message
        })
    }
  

}

//update the uservm details
const updateUserVMWithProtocol = async(req,res)=>{
    try {
        const data = req.body;
        const result =  await clusterService.updateUserVMWithProtocol(data);
        if(!result){
            return res.status(400).send({
                success:false,
                message:"No user vm found with this id"
            })
        }
        return res.status(200).send({
            success:true,
            message:'Successfully updated the user vm',
            data:result
        })
    } catch (error) {
        console.log("Error in updating the user vm details",error);
        return res.status(500).send({
            success:false,
            message:'Error in updating the user vm details',
            error:error.message
        })
    }
}

module.exports = {
    createVMClusterDatacenterLab,
    getVMClusterDatacenterlab,
    deleteDatacenterLab,
    updateSingleVMDatacenterLab,
    updateUserVM,
    updateUserVMWithProtocol
}