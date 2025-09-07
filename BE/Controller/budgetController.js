const moment = require("moment");
const budgetModel = require("../Model/budgetModel");

exports.initialBudget = (req, res) => {
    const userid = req.user.userid;
    const month = moment().format('YYYY-MM');

    budgetModel.insert(userid, month, 0, (err) => {
        if(err){
            return res.status(400).json({message: err.message})
        }

        return res.status(201).json({message: `Budget for ${month} successfully created!`})
    })
}

exports.insert = (req,res) =>{
    const userid = req.user.userid;
    const month = moment().format('YYYY-MM');
    const a_r = req.body.a_r;

    budgetModel.insert(userid, month, a_r, (err)=>{
        if(err){
            return res.status(400).json({message: err.message});
        }

        return res.status(201).json({message:  `Budget for ${month} successfully inputed!`});
    })
}

exports.update = (req, res) =>{
    const userid = req.user.userid;
    const month = moment().format('YYYY-MM');
    const amount = req.body.amount;

    budgetModel.getBudget(userid, month, (err, result) =>{
        if(err){
            return res.status(400).json({message: err.message});
        }

        if(result.length === 0){
            return res.status(404).json({message:  `No budget for ${month}!`});
        }

        const budget_before = result[0];
        const remaining = amount - (budget_before.amount - budget_before.remaining);

        budgetModel.update(userid, month, amount, remaining, (err, result) =>{
            if(err){
                return res.status(400).json({message: err.message});
            }

            if(result.affectedRows === 0){
                return res.status(404).json({message: "Not Found!"});
            }

            return res.status(200).json({message: "Update Successful!"});
        })
    });
}

exports.getBudget = (req,res) =>{
    const userid = req.user.userid;
    const month = moment().format('YYYY-MM');

    budgetModel.getBudget(userid, month, (err, result) =>{
        if(err){
            return res.status(400).json({message: err.message});
        }

        if(result.length === 0){
            return res.status(404).json({message: "404 Not Found!"});
        }

        return res.status(200).json({result});
    })
}