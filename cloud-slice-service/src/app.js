const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');
const cloudSliceAwsRoute = require('./routes/cloudSliceAwsRoutes');
const path = require('path');

const app = express();
//config env variables
require('dotenv').config();

//create tables
const tables = require('./db/tables');
tables;

//middlewares
//middlewares
app.use(cors({
    origin:'http://localhost:5173',
    credentials:true,
}));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(express.json());

//routes
app.use('/',cloudSliceAwsRoute);
app.use('/uploads',express.static(path.join(__dirname,'public/uploads')));

module.exports = app;
