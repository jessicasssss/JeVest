const moment = require("moment");
const transactionModel = require("../Model/transactionModel");
const budgetModel = require("../Model/budgetModel");

exports.insert = (req, res) =>{
    const userid = req.user.userid;
    const { date, categoryid: categoryIdRaw, amount: amountRaw, note } = req.body;
    const categoryid = Number(categoryIdRaw);
    const amount = Number(amountRaw);

    const month_date = moment(date).format('YYYY-MM');

    budgetModel.getBudget(userid, month_date, (err, result) =>{
        if(err){
            return res.status(400).json({message: err.message});
        }

        if(result.length === 0){
            return res.status(404).json({message:  `404 No Budget Found for ${month_date}!`});
        }

        const budget = result[0];
        const remaining = parseFloat(budget.remaining);

        let remaining_after;
        if(categoryid <= 8){
            remaining_after = remaining - amount;
        }
        else{
            remaining_after = remaining + amount;
            console.log(`masuk ${remaining_after}`);
        }

        transactionModel.insert(userid, date, categoryid, amount, note, remaining_after, (err) =>{
            if(err){
                return res.status(400).json({message: err.message});
            }

            budgetModel.updateRemaining(userid, month_date, remaining_after, (err, result)=>{
                if(err){
                    return res.status(400).json({message: err.message});
                }

                if(result.affectedRows === 0){
                    return res.status(404).json({message: `No Updated Rows for ${month_date}!` });
                }

                return res.status(201).json({message: `Transaction for ${date} Successfully Added!`});

            })
            
        })
    })
}

exports.viewAllTrans = (req, res) =>{
    const userid = req.user.userid;

    transactionModel.viewAll(userid, (err, result) => {
        if(err){
            return res.status(400).json({message: err.message});
        }


        if(result.length === 0){
            return res.status(404).json({message:  `404 No Transaction Found!`});
        }

        return res.status(200).json({result});
    })
}

exports.viewMonth = (req, res) =>{
    const userid = req.user.userid;
    const month = req.body.month;

    transactionModel.viewByMonth(userid, month, (err, result) => {
        if(err){
            return res.status(400).json({message: err.message});
        }


        if(result.length === 0){
            return res.status(404).json({message:  `404 No Transaction Found!`});
        }

        const formatted = result.map(row => ({
            ...row,
            date: moment(row.date).format('YYYY-MM-DD')
        }));

        return res.status(200).json({result: formatted});
    })
}

exports.chart = (req, res) => {
    const userid = req.user.userid;
    const month = req.body.month;

    transactionModel.chart(userid, month, (err, result) => {
        if(err){
            return res.status(400).json({message: err.message});
        }

        if(result.length === 0){
            return res.status(404).json({message: "No result!"})
        }

        return res.status(200).json({result});
    })
}