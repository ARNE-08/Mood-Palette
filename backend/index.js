const express = require('express');
const mysql = require('mysql');
const cors = require('cors');

const app = express();
const port = 3000;

require('dotenv').config(); // Load environment variables from .env file

const db = mysql.createConnection({
  host: process.env.DATABASE_URL,
  port: process.env.PORT,
  user: process.env.DATABASE_USER,
  password: process.env.PASSWORD,
  database: process.env.DATABASE_NAME
});

db.connect((err) => {
  if (err) {
    throw err;
  }
  console.log('Connected to database');
});

app.use(
  cors({
      origin: [process.env.CORS_ORIGIN],
      credentials: true,
  })
);

app.use(express.json());

app.listen(port, () => {
  console.log(`Server listening at http://localhost:${port}`);
});
