const express = require('express');
const router = express.Router();
const multer = require('multer');
const fs = require('fs');
const path = require('path');

const uploadDir = path.join(__dirname, '../public/uploads/');
if(!fs.existsSync(uploadDir)){
    fs.mkdirSync(uploadDir,{recursive:true})
}

const storage = multer.diskStorage({
    destination:function(req,file,cb){
        cb(null,uploadDir)
    },
    filename:function(req,file,cb){
        cb(null,`${Date.now()}-${file.originalname}`)
    }
})

const upload = multer({storage});

const {
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
  getQuizExercises
} = require('../controllers/cloudSliceAwsController')

router.get('/getAwsServices',getAllAwsServices);
router.post('/createCloudSliceLab',createCloudSliceLab);
router.post('/createLabModules',upload.array('files'),createCloudSliceLabWithModules);
router.get('/getCloudSlices',getCloudSliceLabByCreatedUserId);
router.post('/getCloudSliceDetails/:labId',getCloudSliceLabById);
router.post('/updateCloudSliceServices/:labId',updateServicesOnLabId);

router.get('/getModules/:sliceId', getAllModules);
router.get('/lab-exercises/:moduleId', getLabExercises);
router.get('/quiz-exercises/:moduleId', getQuizExercises);


module.exports = router;