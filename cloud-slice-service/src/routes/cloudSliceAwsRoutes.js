const express = require('express');
const router = express.Router();

const {
    getAllAwsServices
} = require('../controllers/cloudSliceAwsController')

router.get('/getAwsServices',getAllAwsServices)

module.exports = router;