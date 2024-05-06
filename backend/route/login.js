const mysql = require("mysql");
const bcrypt = require("bcrypt");
var jwt = require("jsonwebtoken");

module.exports = (req, res) => {
    const { username, password } = req.body;

    var sql = mysql.format("SELECT * FROM user WHERE username = ?", [username]);
    // console.log("DEBUG: /basic/login => " + sql);
    connection.query(sql, (err, rows) => {
        if (err) {
            return res.json({
                success: false,
                data: null,
                error: err.message,
            });
        }

        numRows = rows.length;
        if (numRows == 0) {
            res.json({
                success: false,
                message: "user not found in the system",
            });
        } else {
            bcrypt.compare(password, rows[0].hashed_password, (err, valid) => {
                if (err) {
                    return res.json({
                        success: false,
                        message: "Error comparing passwords",
                    });
                }

                if (valid) {
                    const token = jwt.sign(
                        {
                            userId: rows[0].user_id,
                        },
                        "ZJGX1QL7ri6BGJWj3t",
                        { expiresIn: "1h" }
                    );
                    res.cookie("userToken", token);

                    res.json({
                        success: true,
                        message: "Login credential is correct",
                        data: rows[0] && rows[0].username,
                    });
                } else {
                    res.json({
                        success: true,
                        message: "Login credential is incorrect",
                    });
                }
            });
        }
    });
};