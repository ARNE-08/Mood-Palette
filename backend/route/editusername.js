const mysql = require("mysql");

module.exports = async (req, res) => {
    // ! how will we sent the user_id ? can we decode it from the cookie and send as body ?
    const { username, user_id } = req.body;
    var decoded = jwt.verify(user_id, "ZJGX1QL7ri6BGJWj3t");

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

        if (rows.length > 1) {
            // Username already exists
            return res.status(400).json({
                success: false,
                data: null,
                error: "Username is already exists",
            });
        }

        // Username does not exist, proceed with registration
        var updateQuery = mysql.format(
            "UPDATE user SET username = ? WHERE user_id = ?", [username, decoded.user_id]
        );

        connection.query(updateQuery, (err, rows) => {
            if (err) {
                return res.status(400).json({
                    success: false,
                    data: null,
                    error: err.message,
                });
            }

            res.status(200).json({
                success: true,
                message: "Username changed successfully",
            });
        });
    });
};