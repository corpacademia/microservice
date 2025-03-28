const app = require('./src/app');

//config env variables
require('dotenv').config();
const { PORT } = process.env;

//start server
app.listen(PORT, (err) => {
  if (err) {
    console.error('Error starting cloudSlice server:', err);
  } else {
    console.log(`Cloudslice Service is running on port ${PORT}`);
  }
});

module.exports = app; // Export the app for testing purposes

