-- create_tables.sql
-- اسکریپت ایجاد جداول برای دیتابیس ai_123

USE ai_123;

-- جدول تاریخچه بروزرسانی
CREATE TABLE IF NOT EXISTS update_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    version VARCHAR(50) NOT NULL,
    shamsi_date VARCHAR(20) NOT NULL,
    shamsi_time VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_problem TEXT NOT NULL,
    solution_description TEXT NOT NULL,
    user_comment TEXT,
    tags TEXT,
    priority ENUM('low', 'medium', 'high', 'critical') DEFAULT 'medium',
    category ENUM('feature', 'bugfix', 'enhancement', 'security', 'testing') DEFAULT 'feature',
    status ENUM('completed', 'in_progress', 'planned') DEFAULT 'completed'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- جدول ارائه‌دهندگان پیامک
CREATE TABLE IF NOT EXISTS sms_providers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    provider_type VARCHAR(50) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    priority INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- جدول تنظیمات ارائه‌دهندگان پیامک
CREATE TABLE IF NOT EXISTS sms_configs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    provider_id INT NOT NULL,
    config_key VARCHAR(100) NOT NULL,
    config_value TEXT NOT NULL,
    is_encrypted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (provider_id) REFERENCES sms_providers(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- جدول لاگ پیامک‌ها
CREATE TABLE IF NOT EXISTS sms_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    provider_id INT NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    message TEXT NOT NULL,
    status ENUM('pending', 'sent', 'failed', 'delivered') DEFAULT 'pending',
    response_data TEXT,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (provider_id) REFERENCES sms_providers(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- داده‌های پیش‌فرض
INSERT INTO sms_providers (name, provider_type, description, is_active, priority) VALUES
('سامانه ۰۰۹۸', '0098sms', 'سامانه پیامک ۰۰۹۸', TRUE, 1);

INSERT INTO sms_configs (provider_id, config_key, config_value, is_encrypted) VALUES
(1, 'api_url', 'http://0098sms.com/sendsmslink.aspx', FALSE),
(1, 'username', 'zsms8829', FALSE),
(1, 'password', 'ZRtn63e*)Od1', TRUE),
(1, 'from', '3000164545', FALSE);

INSERT INTO update_history (title, version, shamsi_date, shamsi_time, user_problem, solution_description, tags, priority, category, status) VALUES
('راه‌اندازی اولیه سیستم', '1.0.0', '۱۴۰۴/۰۶/۰۱', '۱۰:۳۰', 'نیاز به سیستم مدیریت کسب و کار', 'پیاده‌سازی سیستم کامل با Flutter', 'شروع، پایه، سیستم', 'high', 'feature', 'completed');
