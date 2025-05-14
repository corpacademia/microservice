const express = require('express');
const { createLab,
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
    getLabsConfigured,
    getLabCatalogues,
    checkIsStarted,
    createNewCatalogue,
    getOperatingSystemsFromDatabase,
    getAssignLabOnLabId,
    UpdateSingleVmLabStatus,
    getCount,
    getCloudSliceOrgLabs
} = require('../controllers/labController');

const router = express.Router();

router.post('/labconfig',createLab);
router.get('/getCatalogues',getAllLab);
router.post('/getLabOnId',getLabOnId); 
router.post('/assignlab',assignLab);
router.post('/getAssignedLabs',getAssignLabOnId);
router.post('/getInstances',getInstanceOnParameters);
router.post('/getInstanceDetails',getInstanceDetailsForPricing);
router.post('/getLabsConfigured',getLabsConfigured);
router.post('/amiInformation',awsConfigure);
router.post('/awsCreateInstanceDetails',getAwsInstanceDetails);
router.post('/awsInstanceOfUsers',getAwsInstanceDetailsOfUsers);
router.post('/updateawsInstanceOfUsers',updateAwsInstanceDetailsOfUsers);
router.post('/updateawsInstance',updateAwsLabInstanceDetails);
router.post('/batchAssignment',labBatch);
router.post('/getAssessments',getLabBatchAssessment);
router.get('/getSoftwareDetails',getSoftwareDetails);
router.post('/getLabsConfigured',getLabsConfigured);
router.get('/getPublicCatalogues',getLabCatalogues);
router.post('/updateConfigOfLabs',updateLabsOnConfig);
router.post('/checkisstarted',checkIsStarted);
router.post('/createCatalogue',createNewCatalogue);
router.post('/checkvmcreated',awsConfigure);
router.get('/getOs',getOperatingSystemsFromDatabase);
router.post('/getAssignLabOnId',getAssignLabOnLabId);
router.post('/updateSingleVmStatus',UpdateSingleVmLabStatus);
router.get('/getCountoflabs/:userId',getCount);
router.get('/getCloudSliceLabsOfOrg/:orgId',getCloudSliceOrgLabs)

module.exports = router;