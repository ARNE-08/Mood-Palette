const mysql = require("mysql");

module.exports = async (req, res) => {
    // ! how will we sent the user_id ? can we decode it from the cookie and send as body ?
    const { username } = req.body;
    const { user_id } = parseInt(req.body.user_id);

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
            "UPDATE user SET username = ? WHERE user_id = ?", [username, user_id]
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