const db = require("./database");

const transactionModel = {
    insert: (userid, date, categoryid, amount, note, remaining_after, callback) =>{
        const sql = `INSERT INTO mstransaction (userid, date, categoryid, amount, note, remaining_after) VALUES (?, ?, ?, ?, ?, ?)`;
        db.query(sql, [userid, date, categoryid, amount, note, remaining_after], callback);
    },

    viewAll: (userid, callback) =>{
        const sql = `SELECT t.date, c.category, c.type, t.amount, t.note, t.remaining_after FROM mstransaction t JOIN mscategory c ON c.id = t.categoryid 
        WHERE t.userid =?`;
        db.query(sql, [userid], callback);
    },

    viewByMonth: (userid, month, callback) =>{
        const sql = `SELECT t.date, c.category, c.type, t.amount, t.note, t.remaining_after FROM mstransaction t JOIN mscategory c ON c.id = t.categoryid 
        WHERE t.userid =? AND DATE_FORMAT(t.date, '%Y-%m') = ?`;
        db.query(sql, [userid, month], callback);
    },

    chart: (userid, month, callback) => {
        const sql = `
        SELECT SUM(CASE WHEN categoryid BETWEEN 1 AND 8 THEN amount ELSE 0 END) AS total_expense,
        SUM(CASE WHEN categoryid BETWEEN 9 AND 13 THEN amount ELSE 0 END) AS total_income
        FROM mstransaction WHERE userid = ? AND DATE_FORMAT(date, '%Y-%m') = ?
        `
        db.query(sql, [userid, month], callback);

    }

}

module.exports = transactionModel;