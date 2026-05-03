const express = require("express");
const { Pool } = require("pg");

const app = express();

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(express.static("public"));

// PostgreSQL connection (Docker service name = db)
const pool = new Pool({
  user: "postgres",
  host: "db",
  database: "appdb",
  password: "postgres",
  port: 5432,
});

// Create table if not exists
pool.query(`
  CREATE TABLE IF NOT EXISTS messages (
    id SERIAL PRIMARY KEY,
    text VARCHAR(255)
  )
`);

// Save data
app.get("/submit", async (req, res) => {
  const text = req.query.text;

  await pool.query("INSERT INTO messages (text) VALUES ($1)", [text]);

  res.send(`Saved to DB: ${text}`);
});

// Get all data
app.get("/messages", async (req, res) => {
  const result = await pool.query("SELECT * FROM messages ORDER BY id DESC");
  res.json(result.rows);
});

// Health check
app.get("/health", (req, res) => {
  res.send("OK");
});

app.listen(3000, () => {
  console.log("Server running on port 3000");
});