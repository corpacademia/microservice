const terraformService = require("../services/awsServices");

//to track the progress of the lab creation process
let progress = {
  step1: false,
  step2: false,
  step3: false, 
}

// Controller: EC2 Terraform Execution
const ec2Terraform = async (req, res) => {
  try {
    const { cloudPlatform } = req.body;
    const result = await terraformService.ec2Terraform(cloudPlatform);
    progress.step1 = true; // Mark step 1 as completed
    return res.status(200).send({
      success: true,
      message: "Python script executed successfully",
      result,
    });
  } catch (error) {
    console.log(error)
    return res.status(500).send({
      success: false,
      message: "Python script execution failed",
      error,
    });
  }
};

// Controller: Run Terraform Script
const runTf = async (req, res) => {
  try {
    console.log(req.body)
    const { lab_id } = req.body;
    const result = await terraformService.runTf(lab_id);
    progress.step2 = true; // Mark step 2 as completed
    return res.status(200).send({
      success: true,
      message: "Python script executed successfully",
      result,
    });
  } catch (error) {
    return res.status(500).send({
      success: false,
      message: "Python script execution failed",
      error,
    });
  }
};

// Controller: Instance to Data Processing
const instanceToData = async (req, res) => {
  try {
    const { lab_id } = req.body;
    const result = await terraformService.instanceToData(lab_id);

    return res.status(200).send({
      success: true,
      message: "Python script executed successfully",
      result,
    });
  } catch (error) {
    return res.status(500).send({
      success: false,
      message: "Python script execution failed",
      error,
    });
  }
};

const getInstanceOnParameters = async (req, res) => {
    try {
      const { cloud, cpu, ram } = req.body;
      const instances = await terraformService.fetchInstances(cloud, cpu, ram);
  
      if (instances.length === 0) {
        return res.status(404).send({
          success: false,
          message: "No matching instances found",
        });
      }
  
      return res.status(200).send({
        success: true,
        message: "Successfully accessed the data",
        result: instances,
      });
    } catch (error) {
      console.error("Error fetching instances:", error);
      return res.status(500).send({
        success: false,
        message: error.message || "Error retrieving instances",
      });
    }
  };

  const getInstanceDetailsForPricing = async (req, res) => {
    try {
        const { provider, instance, cpu, ram } = req.body;

        if (!provider || !instance || !cpu || !ram) {
            return res.status(400).send({
                success: false,
                message: "Missing required parameters: provider, instance, cpu, ram."
            });
        }

        const instanceDetails = await terraformService.fetchInstanceDetails(provider, instance, cpu, ram);

        if (!instanceDetails) {
            return res.status(404).send({
                success: false,
                message: "No data found with the given details."
            });
        }

        return res.status(200).send({
            success: true,
            message: "Successfully retrieved instance details.",
            data: instanceDetails
        });

    } catch (error) {
        return res.status(500).send({
            success: false,
            message: "Error accessing data",
            error: error.message
        });
    }
};

const vmToGoldenImage = async (req, res) => {
  try {
      const { instance_id, lab_id } = req.body;

      if (!instance_id || !lab_id) {
          return res.status(400).send({
              success: false,
              message: "Missing required parameters: instance_id, lab_id.",
          });
      }

      const result = await terraformService.executeVmToGoldenImage(instance_id, lab_id);

      return res.status(200).send({
          success: true,
          message: "VmToGoldenImage script executed successfully",
          data: result.data,
      });
  } catch (error) {
    console.log(error)
      return res.status(500).send({
          success: false,
          message: error.message || "Error executing script",
          error: error.error || "Unknown error",
      });
  }
};

const goldenToInstance = async (req, res) => {
  const { instance_type, ami_id, no_instance, termination_period } = req.body;

  const response = await terraformService.goldenToInstanceLogic(instance_type, ami_id, no_instance, termination_period);
  
  if (response.success) {
    return res.status(200).send(response);
  } else {
    return res.status(500).send(response);
  }
};

const goldenToInstanceForNewCatalogue = async (req, res) => {
  const { instance_type, ami_id, storage_size, lab_id, prev_labId } = req.body;
  const response = await terraformService.goldenToInstanceForNewCatalogueLogic(instance_type, ami_id, storage_size, lab_id, prev_labId);
  
  if (response.success) {
    return res.status(200).send(response);
  } else {
    return res.status(500).send(response);
  }
};

const deleteVm = async (req, res) => {
  try {
    const { id, instance_id, ami_id, user_id } = req.body;

    const response = await terraformService.deleteLabService(id, instance_id, ami_id, user_id);

    return res.status(200).send(response);
  } catch (error) {
    return res.status(500).send({
      success: false,
      message: "Error deleting lab from the database",
      error: error.message,
    });
  }
};

const deleteSuperVm = async (req, res) => {
  try {
    const { id, instance_id, ami_id } = req.body;

    const response = await terraformService.deleteSuperLabService(id, instance_id, ami_id);

    return res.status(200).send(response);
  } catch (error) {
    return res.status(500).send({
      success: false,
      message: "Error deleting lab from the database",
      error: error.message,
    });
  }
};

const handleLaunchSoftwareOrStop = async (req, res) => {
  try {
      const { os_name, instance_id, hostname, password } = req.body;
      console.log(req.body);

      const response = await terraformService.handleLaunchSoftwareOrStopService(os_name, instance_id, hostname, password);
      console.log(response)
      return res.status(200).send({
        success:true,
        message:"successfully executed..",
        response
      });
  } catch (error) {
      return res.status(500).send({
          success: false,
          message: "Could not Launch or Stop software",
          error: error.message,
      });
  }
};

const getDecryptPasswordFromCloud = async (req, res) => {
  try {
    console.log("Decrypt password request received");

    const { lab_id, public_ip, instance_id } = req.body;

    // Wait for script execution to complete before updating progress
    const response = await terraformService.getDecryptPasswordFromCloudService(lab_id, public_ip, instance_id);

    if (response.success) {
      progress.step3 = true; // Mark step 3 as completed **only when execution is successful**
      console.log("Decryption successful, progress updated:", progress);
    } else {
      console.error("Decryption failed, progress not updated.");
    }

    return res.status(200).send(response);
  } catch (error) {
    console.error("Error:", error);

    return res.status(500).send({
      success: false,
      message: "Error decrypting password",
      error: error.message,
    });
  }
};


const getNewIpFromCloud = async (req, res) => {
  try {
      console.log("Get public IP request received");
      const { instance_id } = req.body;

      const response = await terraformService.getNewIpFromCloudService(instance_id);

      return res.status(200).json(response);
  } catch (error) {
      console.error("Error:", error);
      return res.status(500).json({
          success: false,
          message: "Error getting new public IP",
          error: error.message,
      });
  }
};

const getUserDecryptPasswordFromCloud = async (req, res) => {
  try {
      console.log("Decrypt Password request received:", req.body);
      const { user_id, public_ip, instance_id } = req.body;

      const response = await terraformService.getUserDecryptPasswordFromCloudService(user_id, public_ip, instance_id);

      return res.status(200).json(response);
  } catch (error) {
      console.error("Error:", error);
      return res.status(500).json({
          success: false,
          message: "Error decrypting user password",
          error: error.message,
      });
  }
};

const updateAssessmentStorage = async (req, res) => {
  try {
      console.log("Edit Instance request received:", req.body);
      const { new_volume_size, instance_id, lab_id } = req.body;

      const response = await terraformService.updateAssessmentStorageService(instance_id, new_volume_size, lab_id);

      return res.status(200).json(response);
  } catch (error) {
      console.error("Error:", error);
      return res.status(500).json({
          success: false,
          message: "Error editing instance storage",
          error: error.message,
      });
  }
};

const createCloudAssignedInstance = async (req, res) => {
  try {
      console.log("Launching instance")

      const { name, ami_id, user_id, lab_id, instance_type, start_date, end_date } = req.body;
      const result = await terraformService.createCloudAssignedInstance(name, ami_id, user_id, lab_id, instance_type, start_date, end_date);

      return res.status(200).json({
          success: true,
          message: "Launch instance script executed successfully",
          result,
      });

  } catch (error) {
      console.error("Error launching instance:", error);
      return res.status(500).json({
          success: false,
          message: "Error executing Python script",
          error: error.message,
      });
  }
};

const startLab = async (req, res) => {
  try {
      console.log("Start Lab Request:");

      const { aws_access_key, aws_secret_key } = req.body;
      const result = await terraformService.startLabService(aws_access_key, aws_secret_key);

      return res.status(200).json({
          success: true,
          message: "Start Lab script executed successfully",
          result,
      });

  } catch (error) {
      console.error("Error starting lab:", error);
      return res.status(500).json({
          success: false,
          message: "Error executing Python script",
          error: error.message,
      });
  }
};

const stopLab = async (req, res) => {
  try {
      console.log("Stop Lab Request:", req.body);

      const { aws_access_key, aws_secret_key } = req.body;
      const result = await terraformService.stopLabService(aws_access_key, aws_secret_key);

      return res.status(200).json({
          success: true,
          message: "Stop Lab script executed successfully",
          result,
      });

  } catch (error) {
      console.error("Error stopping lab:", error);
      return res.status(500).json({
          success: false,
          message: "Error executing Python script",
          error: error.message,
      });
  }
};

const getCloudAssignedInstance = async (req, res) => {
  try {
    const { user_id, lab_id } = req.body;

    // Call the service function
    const instance = await terraformService.getCloudAssignedInstanceService(user_id, lab_id);

    if (!instance) {
      return res.status(404).json({
        success: false,
        message: "Invalid credentials or no instance found",
      });
    }

    return res.status(200).json({
      success: true,
      message: "Successfully accessed",
      data: instance,
    });

  } catch (error) {
    console.error("Database Error:", error);
    return res.status(500).json({
      success: false,
      message: "Error in database",
      error: error.message,
    });
  }
};

const checkCloudAssignedInstanceLaunched = async (req, res) => {
  try {
    const { lab_id, user_id } = req.body;
    // Call the service function
    const instance = await terraformService.checkCloudAssignedInstanceLaunchedService(lab_id, user_id);

    if (!instance) {
      return res.status(404).json({
        success: false,
        message: "Invalid credentials or no instance found",
      });
    }

    return res.status(200).json({
      success: true,
      message: "Successfully accessed",
      data: instance,
    });

  } catch (error) {
    console.error("Database Error:", error);
    return res.status(500).json({
      success: false,
      message: "Error in database",
      error: error.message,
    });
  }
};

const checkLabCloudInstanceLaunched = async (req, res) => {
  try {
    const { lab_id } = req.body;

    // Call the service function
    const instance = await terraformService.checkLabCloudInstanceLaunchedService(lab_id);

    if (!instance) {
      return res.status(404).json({
        success: false,
        message: "No instance found for the given lab ID",
      });
    }

    return res.status(200).json({
      success: true,
      message: "Successfully accessed",
      data: instance,
    });

  } catch (error) {
    console.error("Database Error:", error);
    return res.status(500).json({
      success: false,
      message: "Error in database",
      error: error.message,
    });
  }
};

const stopInstance = async (req, res) => {
  try {
    const { instance_id } = req.body;

    if (!instance_id) {
      return res.status(400).json({
        success: false,
        message: "Instance ID is required",
      });
    }

    // Call the service function
    const response = await terraformService.stopInstanceService(instance_id);

    return res.status(200).send({
      success:true,
      message:'successfully executed..',
      response
    });
  } catch (error) {
    console.error("Error stopping instance:", error.message);
    return res.status(500).json({
      success: false,
      message: "Error stopping instance",
      error: error.message,
    });
  }
};

const restartInstance = async (req, res) => {
  try {
    const { instance_id, user_type } = req.body;

    if (!instance_id || !user_type) {
      return res.status(400).json({
        success: false,
        message: "Instance ID and User Type are required",
      });
    }

    // Call the service function
    const response = await terraformService.restartInstanceService(instance_id, user_type);

    return res.status(200).send({
      success:true,
      message:"Successfully executed..",
      response});
  } catch (error) {
    console.error("Error restarting instance:", error.message);
    return res.status(500).send({
      success: false,
      message: "Error restarting instance",
      error: error.message,
    });
  }
};

//labprgress update
const labProgress = async(req,res)=>{
  try {
    return res.send({
      success: true,
      message: "Lab progress updated successfully",
      data: progress,
    });
  } catch (error) {
    console.error("Error in lab progress:", error.message);
    return res.status(500).send({
      success: false,
      message: "Error in lab progress",
      error: error.message,
    });
  }
}

module.exports = {
  ec2Terraform,
  runTf,
  instanceToData,
  getInstanceOnParameters,
  getInstanceDetailsForPricing,
  vmToGoldenImage,
  goldenToInstance,
  goldenToInstanceForNewCatalogue,
  deleteVm,
  deleteSuperVm,
  handleLaunchSoftwareOrStop,
  getDecryptPasswordFromCloud,
  getNewIpFromCloud,
  getUserDecryptPasswordFromCloud,
  updateAssessmentStorage,
  createCloudAssignedInstance,
  startLab,
  stopLab,
  getCloudAssignedInstance,
  checkCloudAssignedInstanceLaunched,
  checkLabCloudInstanceLaunched,
  stopInstance,
  restartInstance,
  labProgress,
};
