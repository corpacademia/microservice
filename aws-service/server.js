const app = require('./src/app');

require('dotenv').config();

const PORT = process.env.PORT || 3003;

app.listen(PORT,(err)=>{
    if (err) {
        console.error("Error starting Aws Service:", err);
        process.exit(1); // Exit on failure
    }
    console.log("Aws service running on port:",PORT);
});

module.exports = app;