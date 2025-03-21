const express = require('express')
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');
const cors = require('cors');
const app =express();


const workspaceRouter = require('./routes/workspaceRoutes');

//middlewares
app.use(express.json());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended:true}));
app.use(cookieParser());

//router
app.use('/',workspaceRouter);


module.exports  = app;