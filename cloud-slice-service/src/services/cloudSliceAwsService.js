const cloudSliceAwsQueries = require('./cloudSliceQueries');

const pool= require('../db/dbconfig');

const getAllAwsServices = async () => {
    try {
        const result = await pool.query(cloudSliceAwsQueries.GET_ALL_AWS_SERVICES);
        if (!result.rows.length) {
            throw new Error('No AWS services found');
        }
        return result.rows;
    } catch (error) {
        console.log(error);
        throw new Error('Error in getAllAwsServices function',error);
    }
};

const createCloudSliceLab = async (createdBy,labData) => {
    const { services, region, startDate, endDate, cleanupPolicy, platform, cloudProvider, title, description, labType } = labData;
   
    if (!services || !region || !startDate || !endDate || !cleanupPolicy  || !platform || !cloudProvider || !title || !description || !labType ) {
        throw new Error('Please provide all required fields');
    }
     try {
        const result = await pool.query(cloudSliceAwsQueries.INSERT_LAB_DATA,
            [createdBy,JSON.stringify(services), region, startDate, endDate, cleanupPolicy, platform, cloudProvider, title, description, labType]);
        return result.rows[0];
    } catch (error) {
        console.log(error);
        throw new Error('Error in createCloudSliceLab function', error);
    }
}




module.exports = {
    getAllAwsServices,
    createCloudSliceLab,
}

