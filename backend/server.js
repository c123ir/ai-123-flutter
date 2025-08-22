# نمونه Backend API برای MySQL
# فایل: backend/server.js (Node.js + Express + MySQL)

const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
const port = 3000;

// تنظیمات
app.use(cors());
app.use(express.json());

// اتصال به MySQL
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'password',
  database: 'ai_123_flutter'
});

// تست اتصال
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', message: 'MySQL Backend Ready' });
});

// SMS History API
app.get('/api/sms_history', (req, res) => {
  const query = 'SELECT * FROM sms_history ORDER BY created_at DESC';
  
  db.query(query, (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(results);
  });
});

app.post('/api/sms_history', (req, res) => {
  const { phone, message, status, provider } = req.body;
  
  const query = 'INSERT INTO sms_history (phone, message, status, provider, created_at) VALUES (?, ?, ?, ?, NOW())';
  
  db.query(query, [phone, message, status, provider], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.status(201).json({ id: result.insertId });
  });
});

// Update History API
app.get('/api/update_history', (req, res) => {
  const query = 'SELECT * FROM update_history ORDER BY created_at DESC';
  
  db.query(query, (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(results);
  });
});

app.post('/api/update_history', (req, res) => {
  const { title, description, category, priority, version, changes, affected_files } = req.body;
  
  const query = `INSERT INTO update_history 
    (title, description, category, priority, version, changes, affected_files, created_at) 
    VALUES (?, ?, ?, ?, ?, ?, ?, NOW())`;
  
  db.query(query, [
    title, 
    description, 
    category, 
    priority, 
    version, 
    JSON.stringify(changes),
    JSON.stringify(affected_files)
  ], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.status(201).json({ id: result.insertId });
  });
});

app.listen(port, () => {
  console.log(`🚀 Backend API running on http://localhost:${port}`);
});
