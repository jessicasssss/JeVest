const jwt = require("jsonwebtoken");
const path = require("path");

require("dotenv").config({path: path.join(__dirname, "../../.env")});


function TokenAuth(req, res, next) {
    const token = req.cookies.token;

    if(!token){
        return res.status(401).json({message: "Please Login or register!"});
    }

    jwt.verify(token, process.env.JWT_SECRET, (err, user) =>{
        if(err){
            return res.status(403).json({message: "Invalid Token!"});
        }
        req.user = user;
        next();
    })
}

module.exports = TokenAuth;