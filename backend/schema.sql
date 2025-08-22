-- MySQL Schema برای پروژه AI-123 Flutter
-- فایل: backend/schema.sql

-- ایجاد دیتابیس
CREATE DATABASE IF NOT EXISTS ai_123_flutter;
USE ai_123_flutter;

-- جدول تاریخچه SMS
CREATE TABLE IF NOT EXISTS sms_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    phone VARCHAR(20) NOT NULL,
    message TEXT NOT NULL,
    status VARCHAR(50) NOT NULL,
    provider VARCHAR(100) NOT NULL,
    response_data TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- جدول تاریخچه بروزرسانی
CREATE TABLE IF NOT EXISTS update_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(100) NOT NULL,
    priority VARCHAR(50) NOT NULL,
    version VARCHAR(20) NOT NULL,
    changes JSON,
    affected_files JSON,
    user_feedback TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- جدول تنظیمات SMS
CREATE TABLE IF NOT EXISTS sms_settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    provider_name VARCHAR(100) NOT NULL UNIQUE,
    api_url VARCHAR(255) NOT NULL,
    username VARCHAR(100),
    password VARCHAR(100),
    api_key VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- درج تنظیمات پیش‌فرض
INSERT INTO sms_settings (provider_name, api_url, username, password, is_active) VALUES
('SMS.ir', 'https://ws.sms.ir/', '', '', TRUE),
('Kavenegar', 'https://api.kavenegar.com/', '', '', FALSE),
('Farapayamak', 'https://rest.payamak-panel.com/api/', '', '', FALSE)
ON DUPLICATE KEY UPDATE api_url = VALUES(api_url);

-- ایجاد Index برای بهبود عملکرد
CREATE INDEX idx_sms_history_phone ON sms_history(phone);
CREATE INDEX idx_sms_history_created_at ON sms_history(created_at);
CREATE INDEX idx_update_history_category ON update_history(category);
CREATE INDEX idx_update_history_created_at ON update_history(created_at);

-- نمایش ساختار جداول
SHOW TABLES;
DESCRIBE sms_history;
DESCRIBE update_history;
DESCRIBE sms_settings;
