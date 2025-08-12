const express = require("express");
const cookieParser = require('cookie-parser');
require('dotenv').config();


const authRoute = require("./Route/authRoute");

const app = express();
const port = process.env.PORT || 3000;

app.use(cookieParser());
app.use(express.json());

app.use("/", authRoute);

app.listen(port, ()=>{
    console.log(`Server running at: ${port}`);
})