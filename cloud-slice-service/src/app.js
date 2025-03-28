const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');
const cloudSliceAwsRoute = require('./routes/cloudSliceAwsRoutes');

const app = express();
//config env variables
require('dotenv').config();

//middlewares
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(express.json());

//routes
app.use('/',cloudSliceAwsRoute);

module.exports = app;
