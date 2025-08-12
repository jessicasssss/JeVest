const mysql = require("mysql2");
const path = require("path");

require("dotenv").config({path: path.join(__dirname, "../../.env")});


const db = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port:  process.env.DB_PORT
});

db.connect((err) =>{
    if(err){
        return console.log(err);
    }
    
    console.log("Connected to MySQL!");
})

module.exports = db;