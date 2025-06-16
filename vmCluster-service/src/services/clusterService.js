const clusterQueries = require('./clusterQueries');
const pool = require('../dbconfig/db');


const createVMClusterDatacenterLab = async (data, userId) => {
  try {
    const { details, type, platform, labGuides, userGuides, clusterConfig } = data;
    const { startDate, startTime, endDate, endTime, vms, users } = clusterConfig;
    const { title, description } = details;
    // Validation
    if (!title || !description || !type || !platform || !labGuides || !userGuides || !startDate || !endDate) {
      throw new Error("Please provide all the required fields");
    }
    // Insert lab
    const result = await pool.query(clusterQueries.INSERT_LAB_DETAILS, [
      userId,
      title,
      description,
      type,
      platform,
      labGuides,
      userGuides,
      `${startDate} ${startTime}`,
      `${endDate} ${endTime}`
    ]);

    if (!result.rows.length) {
      throw new Error("Could not create the VM cluster lab");
    }

    const labId = result.rows[0].labid;
    // Insert VMs and user VMs
    for (const vm of vms) {
      console.log(vm)
  await pool.query(clusterQueries.INSERT_VM_DETAILS, [
    labId,
    vm.id,
    vm.name,
    vm.protocol
  ]);

  for (const userVms of users) {
    for (const userVm of userVms.userVMs) {
      // Only insert if the userVm is for this vm.id
      if (userVm.vmId === vm.id) {
        await pool.query(clusterQueries.INSERT_USERVM_DETAILS, [
          labId,
          vm.id,
          userVm.username,
          userVm.password,
          userVm.ip,
          userVm.port,
          userVms.groupName
        ]);
      }
    }
  }
}


    return result.rows[0];
  } catch (error) {
    console.error(error);
    throw new Error("Error in creating VM cluster datacenter lab: " + error.message);
  }
};

//get the labs of user
const getVMClusterDatacenterlab = async (userId) => {
  try {
    if(!userId){
        throw new Error("Please provide the user id");
    }
    const labs = [];

    const labDetails = await pool.query(clusterQueries.GET_ALL_LABS_ON_USERID, [userId]);

    if (!labDetails.rows.length) {
      throw new Error("No labs found for this user");
    }

    for (const lab of labDetails.rows) {
      const vmDetails = await pool.query(clusterQueries.GET_VM_DETAILS_ON_LABID, [lab.labid]);

      const userVMDetails = await pool.query(
        clusterQueries.GET_USER_VM_CREDS,
        [lab.labid]
      );

      labs.push({
        lab,
        vms: vmDetails.rows,      
        users: userVMDetails.rows  
      });
    }

    return labs;
  } catch (error) {
    throw new Error(`Error in getting the labs: ${error.message}`);
  }
};

//delete datacenter lab 
const deleteDatacenterLab = async(labId)=>{
  try {
    if(!labId){
      throw new Error("Please Provide the Lab Id");
    }
    await pool.query(clusterQueries.DELETE_USERVMS_ON_LABID,[labId]);
    await pool.query(clusterQueries.DELETE_VMS_ON_LABID,[labId]);
    await pool.query(clusterQueries.DELETE_LAB_FROM_ADMIN,[labId]);
  } catch (error) {
    console.log(error);
    throw new Error('Error in deleting the datacenter lab'+error.message);
  }
}

//update the vmcluster datacenter lab
const updateVMClusterDatacenterLab = async(labId , title ,description ,startDate,endDate,software,LabGuide,UserGuide,credentials,vmConfigs)=>{
    if( !labId || !title || !description || !startDate || !endDate || !credentials || !vmConfigs){
      throw new Error('Please Provide all the required fields');
    }
    const updateLab = await pool.query(clusterQueries.UPDATE_VMCLUSTER_DATACENTER_LAB,[title,description,startDate,endDate,software,UserGuide,LabGuide ,labId]);
    if(!updateLab.rows){
      throw new Error('Could not update the vm cluster datacenter lab');
    }
    const vmCredentialsId = new Set();
    for(const vmConfig of vmConfigs){
      const vm = await pool.query(clusterQueries.GET_VM_DETAILS_ON_VMID,[vmConfig.id])
      if(vm.rows.length){
        const updateVM = await pool.query(clusterQueries.UPDATE_VMCLUSTER_DATACENTER_VMS,[vmConfig.name,vmConfig.protocol, labId,vmConfig.id])
        vmCredentialsId.add(updateVM.rows[0].id)
      }
      else{
        const insertVM = await pool.query(clusterQueries.INSERT_VM_DETAILS,[labId,vmConfig.id,vmConfig.name,vmConfig.protocol]);
        vmCredentialsId.add(insertVM.rows[0].id)
      }
      
    }
    const userVMCredentialsId = new Set();
    for(const credential of credentials){
      const existingCred = await pool.query(clusterQueries.GET_USER_VM_CRED_ON_ID,[credential.id]);
      if(existingCred.rows.length){
        const getVm = await pool.query(clusterQueries.GET_VM_DETAILS_ON_VMNAME,[labId,credential.vmName]);
        const vmId = getVm.rows[0].vmid
        const updateCred = await pool.query(clusterQueries.UPDATE_VMCLUSTER_DATACENTER_USERVMS,[credential.username,credential.password,credential.ip,credential.port,credential.groupName,labId,vmId,credential.id]);
        userVMCredentialsId.add(credential.id)
      }
      else{
        const getVm = await pool.query(clusterQueries.GET_VM_DETAILS_ON_VMNAME,[labId,credential.vmName]);
        const vmId = getVm.rows[0].vmid
        const insertUserVm  = await pool.query(clusterQueries.INSERT_USERVM_DETAILS,[labId,vmId,credential.username,credential.password,credential.ip,credential.port,credential.groupName]);
        userVMCredentialsId.add(insertUserVm.rows[0].id)

      }
         }

    //delete vms
    const existingVMS = await pool.query(clusterQueries. GET_VM_DETAILS_ON_LABID,[labId]);
    for(const vm of existingVMS.rows){
      if(!vmCredentialsId.has(vm.id)){
        const deleteVM = await pool.query(clusterQueries.DELETE_VMS_ON_LABID_ID,[labId,vm.id])
      }
    }

    //delete user vms
    const existingUserVms = await pool.query(clusterQueries.GET_USER_VM_CREDS,[labId]);
    for (const user of existingUserVms.rows){
      if(!userVMCredentialsId.has(user.id)){
        const deleteUserVm = await pool.query(clusterQueries.DELETE_USERVMS_ON_LABID_ID,[user.id,labId])
      }
    }
    return updateLab.rows[0]

}

module.exports = {
    createVMClusterDatacenterLab,
    getVMClusterDatacenterlab,
    deleteDatacenterLab,
    updateVMClusterDatacenterLab
};