const {Pool} = require('pg');

require('dotenv').config();

const pool = new Pool({
  user: process.env.USER,
  host: process.env.HOST,
  database:process.env.DATABASE,
  password:process.env.PASSWORD,
  port: process.env.DATABASE_PORT,
});

module.exports = pool;