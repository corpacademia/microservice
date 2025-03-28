const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const dotenv = require("dotenv");
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');
const fs = require('fs');
const path = require('path');


dotenv.config();

const app = express();

// Middleware
app.use(morgan("dev"));  // Log requests
app.use(express.json()); // Parse JSON requests
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended:true}));
app.use(cookieParser());
const corsOptions = {
  origin: "http://localhost:5173", // React frontend URL
  credentials: true,
  methods: "GET, POST, PUT, DELETE, OPTIONS",
  allowedHeaders: "Content-Type, Authorization"
};

app.use(cors(corsOptions));

const uploadsDir = path.join(__dirname, './uploads');
if (!fs.existsSync(uploadsDir)) {
  fs.mkdirSync(uploadsDir, { recursive: true });
}


//Routes to microservices
app.use('/uploads', express.static(path.join(__dirname, 'src/public/uploads')));

app.use('/api/v1/user_ms',require('./routes/user'));  //user microservice route
app.use('/api/v1/lab_ms',require('./routes/lab'));   //lab microservice route
app.use('/api/v1/aws_ms',require('./routes/aws_service')); //aws microservice route
app.use('/api/v1/organization_ms',require('./routes/organizations')); //organizations microservice route
app.use('/api/v1/workspace_ms',require('./routes/workspaces')); //workspaces microservice route
app.use('/api/v1/cloud_slice_ms',require('./routes/cloudSliceService')); //cloud slice microservice route

module.exports = app;
