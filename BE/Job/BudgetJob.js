const cron = require('node-cron');
const budgetModel = require("../Model/budgetModel");
const db = require("../Model/database");
const moment = require('moment');

cron.schedule('0 0 1 * *', async () => {
  console.log("masuk di budget job");
  const month = moment().format('YYYY-MM');

  try{
    const users = await new Promise((resolve, reject) => {
      db.query("SELECT * FROM msuser", (err, result) => {
        if(err){
            return reject(err);
        }
        resolve(result);
      });
    });

    if(users.length === 0){
      console.log("No users found");
      return;
    }

    for(const user of users){
      const userid = user.id;
      await new Promise((resolve, reject) =>{
        budgetModel.insert(userid, month, 0, (err1) => {
          if (err1) return reject(err1);
          resolve();
        });
      });
    }

    console.log("Monthly budget insert completed!");
  }
  catch (error){
    console.error("Error in monthly budget job:", error);
  }
})
