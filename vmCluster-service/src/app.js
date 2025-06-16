const express = require('express');
const cors = require('cors');
const cookieParser = require('cookie-parser')
const bodyParser = require('body-parser')
const clusterRouter = require('./routes/clusterRoutes.js')

const app = express();

//tables
const tables = require('./dbconfig/clusterTables');
tables;

app.use(bodyParser.json({ limit: '100mb' }));
app.use(bodyParser.urlencoded({ extended: true, limit: '100mb' }));

app.use(cookieParser());

app.use(cors({
    origin: process.env.FRONTEND_URL || "http://localhost:5173",
    credentials: true,
}));

//routes
app.use('/',clusterRouter);

module.exports = app;