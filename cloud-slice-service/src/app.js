const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');
const cloudSliceAwsRoute = require('./routes/cloudSliceAwsRoutes');

const app = express();
//config env variables
require('dotenv').config();

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

module.exports = app;
