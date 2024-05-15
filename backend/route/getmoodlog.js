const mysql = require("mysql");
const jwt = require("jsonwebtoken");

module.exports = async (req, res) => {
    try {
        const token = req.body.user_id;
        var decoded = jwt.verify(token, "ZJGX1QL7ri6BGJWj3t");
        const user_id = decoded.userId;

        const getMood = mysql.format("SELECT * FROM mood WHERE user_id = ?", [user_id]);
        connection.query(getMood, (err, rows) => {
            if (err) {
                return res.status(400).json({
                    success: false,
                    data: null,
                    error: err.message,
                });
            }

            // Add one day to each date
            rows = rows.map(row => {
                const date = new Date(row.date);
                date.setDate(date.getDate() + 1); // Add one day
                return {
                    ...row,
                    date: date.toISOString().split('T')[0] // Format date to string
                };
            });

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
