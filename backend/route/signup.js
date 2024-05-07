const mysql = require("mysql");
const bcrypt = require("bcrypt");

module.exports = async (req, res) => {
    const { username, password } = req.body;
    const salt1 = await bcrypt.genSalt(10);
    const hash1 = await bcrypt.hash(password, salt1);

    // Check if username already exists
    var checkUsernameQuery = mysql.format("SELECT * FROM user WHERE username = ?", [username]);
    connection.query(checkUsernameQuery, (err, rows) => {
        if (err) {
            return res.json({
                success: false,
                data: null,
                error: err.message,
            });
        }

        if (rows.length > 0) {
            // Username already exists
            return res.status(400).json({
                success: false,
                data: null,
                error: "Account is already exists",
            });
        }

        // Username does not exist, proceed with registration
        var insertQuery = mysql.format(
            "INSERT INTO user (username, hashed_password) VALUES (?, ?)",
            [username, hash1]
        );

        connection.query(insertQuery, (err, rows) => {
            if (err) {
                return res.status(400).json({
                    success: false,
                    data: null,
                    error: err.message,
                });
            }

            res.status(200).json({
                success: true,
                message: "User has been created",
            });
        });
    });
};