const express = require('express');
const mysql = require('mysql');
const cors = require('cors');
const bodyParser = require("body-parser");
const cookieParser = require("cookie-parser");

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());
app.use(bodyParser.json({ type: "application/json" }));
app.use(cookieParser());

app.use(
    cors({
        origin: '*',
        credentials: true,
    })
);

require('dotenv').config(); // Load environment variables from .env file

const connection = mysql.createConnection({
  host: process.env.DATABASE_URL,
  port: process.env.PORT,
  user: process.env.DATABASE_USER,
  password: process.env.PASSWORD,
  database: process.env.DATABASE_NAME
});

connection.connect();
global.connection = connection;
console.log("Database is connected");;

app.get("/", (req, res) => {
  res.send("Hello MoodPalette!");
});

app.post("/signup", require("./route/signup"));
app.post("/login", require("./route/login"));
app.post("/editusername", require("./route/editusername"));

app.listen(port, () => {
  console.log(`Server listening at http://localhost:${port}`);
});
