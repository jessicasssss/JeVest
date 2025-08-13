const db = require("./database");

const userModel = {
    register: (username, useremail, userpassword, callback) =>{
        const sql = `INSERT INTO msuser (username, useremail, userpassword) VALUES(?, ?, ?)`;
    db.query(sql, [username, useremail, userpassword], callback);
    },

    login: (useremail, callback) =>{
        const sql =  `SELECT * FROM msuser WHERE useremail =?`;
        db.query(sql, [useremail], callback);
    },

    loginStatus: (userid, callback) =>{
        const sql = `UPDATE msuser SET isloggedin = true WHERE id =? `;
        db.query(sql, [userid], callback);
    },

    logoutStatus: (userid, callback) =>{
        const sql = `UPDATE msuser SET isloggedin = false WHERE id =?`;
        db.query(sql, [userid], callback)
    },

    profile: (userid, callback) =>{
        const sql = `SELECT * FROM msuser WHERE id=?`;
        db.query(sql, [userid], callback);
    }
}

module.exports = userModel;