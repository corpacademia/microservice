const labService = require('../services/labService');

const createLab=async(req,res)=>{
    try{
       const {data,user} = req.body; 
       const output = await labService.createLab(data,user);
       if(!output){
        return res.status(405).send({
            success:false,
            message:"Could not store the lab catalogue",
        })
       }
       res.status(200).send({
        success:true,
        message:"Successfully stored the catalogue",
        output:output,
       })
    }
    catch(error){
        console.log(error)
        return res.status(500).send({
            success:false,
            message:"Could not create the lab",
            error
        })
    }
}

const getAllLab = async(req,res)=>{
    try{
        const labs = await labService.getAllLab();
        if(!labs.rows){
            return res.status(405).send({
                success:false,
                message:"Could not get the labs"
            })
        }
        return res.status(200).send({
            success:true,
            message:'Successfully retrieved the labs',
            data:labs.rows
        })
    }
    catch(error){
        return res.status(500).send({
            success:false,
            message:"Error in gettings the labs",
            error,
        })
    }
}

const getLabOnId = async(req,res)=>{
    try{
        const {labId} = req.body;
        const result = await labService.getLabOnId(labId);

        if (!result ) {
          return res.status(404).send({
            success: false,
            message: "No lab found for the provided labId",
          });
        }
        return res.status(200).send({
            success:true,
            message:"Successfully accessed lab catalogue",
            data:result,
        })
    }
    catch(error){
        return res.status(500).send({
            success:false,
            message:"Error in getting the lab",
            error,
        })
    }
}

const assignLab = async (req, res) => {
    try {
        const { lab, userId, assign_admin_id } = req.body;
        const response = await labService.assignLab(lab, userId, assign_admin_id);

        return res.status(200).send({
            success: true,
            message: "Lab assignments processed",
            ...response, // Successful assignments and errors
        });
    } catch (error) {
        return res.status(500).send({
            success: false,
            message: "Error in assigning the labs",
            error: error.message,
        });
    }
};

const getAssignLabOnId = async (req, res) => {
    try {
        const { userId } = req.body;
        const data = await labService.getAssignLabOnId(userId);
        return res.status(200).send({
            success: true,
            message: "Successfully accessed the labs",
            data,
        });
    } catch (error) {
        return res.status(500).send({
            success: false,
            message: "Server error",
            error: error.message,
        });
    }
};
const getAssignLabOnLabId = async(req,res)=>{
    try {
        const {labId,userId} = req.body;
        const data = await labService.getAssignLabOnLabId(labId,userId);
        return res.status(200).send({
            success:true,
            message:"Successfully accessed the lab",
            data
        })

    } catch (error) {
        return res.status(500).send({
            success: false,
            message: "Server error",
            error: error.message,
        });
    }
}

const getInstanceOnParameters = async (req, res) => {
    try {
        const { cloud, cpu, ram } = req.body;
        const data = await labService.getInstanceOnParameters(cloud, cpu, ram);
      
        return res.status(200).send({
            success: true,
            message: "Successfully accessed the data",
            result:data,
        });
    } catch (error) {
        return res.status(400).send({
            success: false,
            message: error.message,
        });
    }
};
const getInstanceDetailsForPricing = async (req, res) => {
    try {
        const { provider, instance, cpu, ram } = req.body;
        const data = await labService.getInstanceDetailsForPricing(provider, instance, cpu, ram);

        return res.status(200).send({
            success: true,
            message: "Successfully accessed the details",
            data,
        });
    } catch (error) {
        return res.status(400).send({
            success: false,
            message: error.message,
        });
    }
};

const updateLabsOnConfig = async (req, res) => {
    try {
        const { lab_id, admin_id, config_details } = req.body;

        const updatedLab = await labService.updateLabConfig(lab_id, admin_id, config_details);

        if (!updatedLab) {
            return res.status(404).send({
                success: false,
                message: "Invalid Details for updating lab"
            });
        }

        return res.status(201).send({
            success: true,
            message: "Successfully updated the lab configuration",
            data: updatedLab
        });

    } catch (error) {
        console.error(error);
        return res.status(500).send({
            success: false,
            message: "Could not update the lab config",
            error,
        });
    }
};

const awsConfigure = async (req, res) => {
    try {
        const { lab_id } = req.body;

        const amiInfo = await labService.getAmiInformation(lab_id);

        if (!amiInfo) {
            return res.status(404).send({
                success: false,
                message: "Invalid lab ID",
            });
        }

        return res.status(200).send({
            success: true,
            message: "Successfully accessed AMI information",
            result: amiInfo,
        });

    } catch (error) {
        return res.status(500).send({
            success: false,
            message: "Error accessing AMI information",
            error,
        });
    }
};

const getAwsInstanceDetails = async (req, res) => {
    try {
        const { lab_id } = req.body;

        const instanceDetails = await labService.getAwsInstanceDetails(lab_id);

        if (!instanceDetails) {
            return res.status(404).send({
                success: false,
                message: "Invalid lab ID",
            });
        }

        return res.status(200).send({
            success: true,
            message: "Successfully accessed instance details",
            result: instanceDetails,
        });

    } catch (error) {
        console.error(error);
        return res.status(500).send({
            success: false,
            message: "Could not access the AWS instance details",
            error,
        });
    }
};

const getAwsInstanceDetailsOfUsers = async (req, res) => {
    try {
        const { lab_id, user_id } = req.body;
        const instanceDetails = await labService.getAwsInstanceDetailsOfUsers(lab_id, user_id);
        console.log(instanceDetails)
        if (!instanceDetails) {
            return res.status(404).send({
                success: false,
                message: "Invalid lab ID",
            });
        }

        return res.status(200).send({
            success: true,
            message: "Successfully accessed instance details",
            result: instanceDetails,
        });

    } catch (error) {
        console.error(error);
        return res.status(500).send({
            success: false,
            message: "Could not access the AWS instance details",
            error,
        });
    }
};

const updateAwsInstanceDetailsOfUsers = async (req, res) => {
    try {
        const { lab_id, user_id, state ,isStarted } = req.body;

        const updatedInstance = await labService.updateAwsInstanceDetailsOfUsers(lab_id, user_id, state,isStarted);

        if (!updatedInstance) {
            return res.status(404).send({
                success: false,
                message: "Invalid lab ID",
            });
        }

        return res.status(200).send({
            success: true,
            message: "Successfully updated instance details",
            result: updatedInstance,
        });

    } catch (error) {
        console.error(error);
        return res.status(500).send({
            success: false,
            message: "Could not update the AWS instance details",
            error,
        });
    }
};

const updateAwsLabInstanceDetails = async (req, res) => {
    try {
        const { lab_id, state ,isStarted } = req.body;

        const updatedLabInstance = await labService.updateAwsLabInstanceDetails(lab_id, state, isStarted);

        if (!updatedLabInstance) {
            return res.status(404).send({
                success: false,
                message: "Invalid lab ID",
            });
        }

        return res.status(200).send({
            success: true,
            message: "Successfully updated lab instance details",
            result: updatedLabInstance,
        });

    } catch (error) {
        console.error(error);
        return res.status(500).send({
            success: false,
            message: "Could not update the AWS lab instance details",
            error,
        });
    }
};

const labBatch = async (req, res) => {
    try {
        const { lab_id, admin_id, org_id, config_details, configured_by, software } = req.body;

        const { assigned, data } = await labService.assignLabBatch(lab_id, admin_id, org_id, config_details, configured_by, software);

        if (assigned) {
            return res.status(200).send({
                success: false,
                message: "Already assigned to the organization",
                data,
            });
        }

        return res.status(201).send({
            success: true,
            message: "Successfully stored the data",
            data,
        });

    } catch (error) {
        console.error("Error in labBatch:", error);
        return res.status(500).send({
            success: false,
            message: "Server error",
            error: error.message,
        });
    }
};

const getLabBatchAssessment = async (req, res) => {
    try {
        const { admin_id } = req.body;

        const data = await labService.getLabBatchAssessment(admin_id);

        if (!data.length) {
            return res.status(404).send({
                success: false,
                message: "Invalid details",
            });
        }

        return res.status(200).send({
            success: true,
            message: "Successfully accessed",
            data,
        });

    } catch (error) {
        console.error("Error in getLabBatchAssessment:", error);
        return res.status(500).send({
            success: false,
            message: "Server error",
            error,
        });
    }
};

const getSoftwareDetails = async (req, res) => {
    try {
        const data = await labService.getSoftwareDetails();

        if (!data.length) {
            return res.status(404).send({
                success: false,
                message: "Invalid details",
            });
        }

        return res.status(200).send({
            success: true,
            message: "Successfully accessed",
            data,
        });

    } catch (error) {
        console.error("Error in getSoftwareDetails:", error);
        return res.status(500).send({
            success: false,
            message: "Server error",
            error,
        });
    }
};

const checkLabBatchAssessment = async (req, res) => {
    try {
        const { admin_id, org_id } = req.body;

        const data = await labService.checkLabBatchAssessment(admin_id, org_id);

        if (!data.length) {
            return res.status(404).send({
                success: false,
                message: "Invalid details",
            });
        }

        return res.status(200).send({
            success: true,
            message: "Successfully accessed",
            data,
        });

    } catch (error) {
        console.error("Error in checkLabBatchAssessment:", error);
        return res.status(500).send({
            success: false,
            message: "Server error",
            error,
        });
    }
};

const getLabsConfigured = async (req, res) => {
    try {
      const labs = await labService.getLabsConfigured();
      if (!labs.length) {
        return res.status(404).send({
          success: false,
          message: "No configured labs found",
        });
      }
      return res.status(200).send({
        success: true,
        message: "Successfully retrieved the labs",
        data: labs,
      });
    } catch (error) {
      console.error("Error getting configured labs:", error);
      return res.status(500).send({
        success: false,
        message: "Error retrieving the labs",
        error: error.message,
      });
    }
  };

  // Controller: Get Lab Catalogues
const getLabCatalogues = async (req, res) => {
    try {
      const labCatalogues = await labService.getLabCatalogues();
  
      if (labCatalogues.length === 0) {
        return res.status(404).json({
          success: false,
          message: "No lab catalogues available",
        });
      }
  
      return res.status(200).json({
        success: true,
        message: "Successfully accessed the lab catalogues",
        data: labCatalogues,
      });
    } catch (error) {
      console.error("Error fetching lab catalogues:", error);
      return res.status(500).json({
        success: false,
        message: "Could not access the catalogues",
        error: error.message,
      });
    }
  };

  const checkIsStarted = async (req, res) => {
    try {
      const { type, id } = req.body;
  
      if (!type || !id) {
        return res.status(400).json({ success: false, message: "Type and ID are required." });
      }
  
      const response = await labService.checkIsStartedService(type, id);
      
      return res.status(200).json(response);
    } catch (error) {
      console.error("Error checking status:", error.message);
      return res.status(500).json({
        success: false,
        message: "Could not check the status",
        error: error.message,
      });
    }
  };
 
  const createNewCatalogue = async (req, res) => {
    try {
      const catalogueData = req.body;
      const newCatalogue = await labService.createNewCatalogue(catalogueData);
  
      return res.status(200).send({
        success: true,
        message: "Successfully stored the catalogue",
        output: newCatalogue,
      });
    } catch (error) {
      console.error("Error creating catalogue:", error.message);
  
      return res.status(500).send({
        success: false,
        message: "Could not create the lab",
        error: error.message,
      });
    }
  };


  const getOperatingSystemsFromDatabase = async (req, res) => {
    try {
        const result = await labService.getOperatingSystems();
       
        if (!result.success) {
            return res.status(404).send({
                success: false,
                message: result.message,
            });
        }

        return res.status(200).send({
            success: true,
            message: result.message,
            data: result.data,
        });
    } catch (error) {
        return res.status(500).send({
            success: false,
            message: "Error in database for getting operating system list",
            error: error.message,
        });
    }
};

module.exports = {
    createLab,
    getAllLab,
    getLabOnId,
    assignLab,
    getAssignLabOnId,
    getInstanceOnParameters,
    getInstanceDetailsForPricing,
    updateLabsOnConfig,
    awsConfigure,
    getAwsInstanceDetails,
    getAwsInstanceDetailsOfUsers,
    updateAwsInstanceDetailsOfUsers,
    updateAwsLabInstanceDetails,
    labBatch,
    getLabBatchAssessment,
    getSoftwareDetails,
    checkLabBatchAssessment,
    getLabsConfigured,
    getLabCatalogues,
    checkIsStarted,
    createNewCatalogue,
    getOperatingSystemsFromDatabase,
    getAssignLabOnLabId,
}