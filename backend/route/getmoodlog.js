const mysql = require("mysql");

module.exports = async (req, res) => {
    try {
        // Log the request body for debugging

        // Parse user_id from request body
        const user_id = req.body;
        var decoded = jwt.verify(user_id, "ZJGX1QL7ri6BGJWj3t");
        if (isNaN(decoded.user_id.isNaN)) {
            return res.status(400).json({
                success: false,
                data: null,
                error: 'Invalid user_id',
            });
        }

        // Log the parsed user_id

        // Prepare and execute the query
        const getMood = mysql.format("SELECT * FROM mood WHERE user_id = ?", [decoded.user_id]);
        console.log('Executing query:', getMood); // Log the query for debugging

        connection.query(getMood, (err, rows) => {
            if (err) {
                console.error('Query error:', err); // Log the error for debugging
                return res.status(400).json({
                    success: false,
                    data: null,
                    error: err.message,
                });
            }

            console.log('Query result:', rows); // Log the result for debugging
            return res.status(200).json({
                success: true,
                data: rows,
            });
        });
    } catch (error) {
        console.error('Server error:', error); // Log any server error
        return res.status(500).json({
            success: false,
            data: null,
            error: 'Internal server error',
        });
    }
};