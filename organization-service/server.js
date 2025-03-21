const app = require('./src/app');

require('dotenv').config();
const PORT = process.env.PORT || 3004;

app.listen(PORT,(err)=>{
   if(err){
    console.log("Error running organization-service",err);
    process.exit(1);
   }
   else{
    console.log("Successfully running organization-service at port:",PORT)
   }
})
