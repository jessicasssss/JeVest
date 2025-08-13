const db = require("./database");

const budgetModel = {
    
    insert: (userid, month, a_r, callback) => {
        const sql = `INSERT INTO msbudget (userid, month, amount, remaining) VALUES(?,?,?,?)`;
        db.query(sql, [userid, month, a_r, a_r], callback);
    },

    update: (userid, month, amount, remaining, callback) =>{
        const sql =  `UPDATE msbudget SET amount = ?, remaining = ? WHERE userid =? AND month=?`;
        db.query(sql, [amount, remaining,userid, month], callback);

    },

    getBudget: (userid, month, callback) =>{
        const sql = `SELECT amount, remaining FROM msbudget WHERE userid =? AND month =?`;
        db.query(sql, [userid, month], callback);
    }

}

module.exports = budgetModel;