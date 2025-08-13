const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const path = require('path');
require("dotenv").config({path: path.join(__dirname, "../../.env")});

const userModel = require("../Model/userModel");

exports.register = (req, res) => {
    const { usn, email, password } = req.body;

    if(!usn ||!email || !password){
        return res.status(400).json({message: "Username, Email, and Password is missing!"});
    }

    bcrypt.hash(password, 10, function (err, hash) {
        if(err){
            console.log(err);
            return res.status(500).json({message:"Error hashing password"});
        }

        userModel.register(usn, email, hash, (err)=> {
        if(err){
            return res.status(500).json({message: err.message});
        }
        res.status(201).json({message: "Registration Successfull!"})
     });
    });
};

exports.login = (req, res) => {
    const { email, password } = req.body;

    if(!email || !password){
        return res.status(400).json({message : "Email and Password must be filled!"});
    }

    userModel.login(email, (err, result) => {
        if(err){
            return res.status(500).json({message: err.message});
        }

        if(result.length === 0){
            return res.status(404).json({message: "Email not found!"});
        }

        const user = result[0];
        bcrypt.compare(password, user.userpassword, function (err, result) {
            if(err){
                return res.status(500).json({message: err.message});        
            }

            if(result){

                userModel.loginStatus(user.id, (err) => {
                    if(err){
                        return res.status(400).json({message: err.message})
                    }

                    const secret = process.env.JWT_SECRET;
                    const token = jwt.sign(
                    {userid: user.id, email: user.useremail }, secret)

                    res.cookie("token", token, {
                    httpOnly: true,
                    secure: process.env.NODE_ENV === "production",
                    //sameSite: "strict"
                    });

                    res.status(200).json({message: "Succesfully Login!", token: token});

                })
               
            }
            else{
                return res.status(404).json({message: "Password does not match!"});
            }
        })

       
    })
}

exports.logout = (req, res) =>{
    const userid = req.user.userid;

    userModel.logoutStatus(userid, (err) =>{
        if(err){
            return res.status(400).json({message: err.message});
        }

        res.clearCookie("token", {
        httpOnly: true,
        secure: process.env.NODE_ENV === "production",
        //sameSite: "strict"
      });
        return res.status(200).json({message: "Logged Out Succesfully!"});
    })

  
}

exports.profile = (req, res) =>{
    const userid = req.user.userid;

    userModel.profile(userid, (err, result) =>{
        if(err){
            return res.status(400).json({message: err.message});
        }

        if(result.length === 0){
            return res.status(404).json({message: "Unauthorized!"});
        }

        return res.status(200).json({result})
    })
}