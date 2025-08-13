const express = require("express");
const cookieParser = require('cookie-parser');
require('dotenv').config();


const authRoute = require("./Route/authRoute");
const budgetRoute = require("./Route/budgetRoute");
const transactionRoute = require("./Route/transactionRoute");

const app = express();
const port = process.env.PORT || 3000;

app.use(cookieParser());
app.use(express.json());

app.use("/", authRoute);
app.use("/", budgetRoute);
app.use("/", transactionRoute);

app.listen(port, ()=>{
    console.log(`Server running at: ${port}`);
})