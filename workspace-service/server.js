const app = require('./src/app');
require('dotenv').config();
const PORT = process.env.PORT || 3005;

app.listen(PORT, (err)=>{
    if(err){
        console.log("Error starting workspace microservice at PORT:",PORT);
    }
    else{
        console.log("Successfully started workspace microservice");
    }
})