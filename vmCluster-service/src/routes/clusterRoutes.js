const express = require('express');

const router = express.Router();
const fs = require('fs');
const path = require('path');
const multer = require('multer');

const {
    createVMClusterDatacenterLab,
    getVMClusterDatacenterlab,
    deleteDatacenterLab,
    updateSingleVMDatacenterLab
} = require('../controller/clusterController');

const uploadDir = path.join(__dirname, '../public/uploads/');
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir, { recursive: true });
}

// Set up multer storage options
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, uploadDir); // Use the correct folder path
  },
  filename: function (req, file, cb) {
    cb(null, `${file.originalname}}`); // Unique file names
  },
});

const upload = multer({storage})

//routes
router.post('/createVMClusterDatacenterLab',createVMClusterDatacenterLab);
router.post('/getClusterLabs',getVMClusterDatacenterlab);
router.delete('/deleteClusterLab/:labId',deleteDatacenterLab)
router.post('/updateClusterLab',upload.fields([
    {'name':'userGuide',maxCount:5},
    {'name':'labGuide' , maxCount:5}
]),updateSingleVMDatacenterLab)

module.exports = router;