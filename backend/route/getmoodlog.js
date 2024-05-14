const mysql = require("mysql");

module.exports = async (req, res) => {
    try {
        // Log the request body for debugging
        console.log('Request Body:', req.body);

        // Parse user_id from request body
        const user_id = parseInt(req.body.user_id);
        if (isNaN(user_id)) {
            return res.status(400).json({
                success: false,
                data: null,
                error: 'Invalid user_id',
            });
        }

        // Log the parsed user_id
        console.log('Parsed user_id:', user_id);

        // Prepare and execute the query
        const getMood = mysql.format("SELECT * FROM mood WHERE user_id = ?", [user_id]);
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