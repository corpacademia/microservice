const {Pool} = require('pg');
const { HOST , PORT, DATABASE, USER, PASSWORD } = process.env;

const pool = new Pool({
    host: HOST,
    port: PORT,
    database: DATABASE,
    user: USER,
    password: PASSWORD,
});

module.exports = pool;

