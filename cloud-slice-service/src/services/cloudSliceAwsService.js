const cloudSliceAwsQueries = require('./cloudSliceQueries');

const pool= require('../db/dbconfig');

const getAllAwsServices = async(req,res)=>{
    try {
        const result = await pool.query(cloudSliceAwsQueries.GET_ALL_AWS_SERVICES);
        if(!result.rows.length){
            throw new Error('No AWS services found');
        }
        return  result.rows;
    } catch (error) {
        console.log(error);
        throw new Error('Error in getAllAwsServices function',error);
    }
}


module.exports = {
    getAllAwsServices,
}

