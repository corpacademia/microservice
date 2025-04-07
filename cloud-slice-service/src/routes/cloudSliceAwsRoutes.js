const express = require('express');
const router = express.Router();

const {
    getAllAwsServices,
    createCloudSliceLab,
} = require('../controllers/cloudSliceAwsController')

router.get('/getAwsServices',getAllAwsServices);
router.post('/createCloudSliceLab',createCloudSliceLab);

module.exports = router;