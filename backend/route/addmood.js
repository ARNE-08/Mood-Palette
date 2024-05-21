const mysql = require("mysql");
const jwt = require("jsonwebtoken");

module.exports = async (req, res) => {
    try {
        const { mood, log_date } = req.body;
        const token = req.body.user_id;
        var decoded = jwt.verify(token, "ZJGX1QL7ri6BGJWj3t");
        const user_id = decoded.userId;

        const addMood = mysql.format("INSERT INTO mood (user_id, date, mood) VALUES (?, ? ?)", [user_id, log_date, mood]);
        connection.query(addMood, (err, rows) => {
            if (err) {
                return res.status(400).json({
                    success: false,
                    data: null,
                    error: err.message,
                });
            }

            return res.status(200).json({
                success: true,
                data: rows,
            });
        });
    } catch (error) {
        return res.status(500).json({
            success: false,
            data: null,
            error: 'Internal server error',
        });
    }
};
