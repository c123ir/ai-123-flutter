# راهنمای جامع API
## دستیار هوشمند یک دو سه

---

## 📋 فهرست مطالب

1. [مقدمه](#مقدمه)
2. [Authentication](#authentication)
3. [Structure](#structure)
4. [Endpoints](#endpoints)
5. [Error Handling](#error-handling)
6. [Examples](#examples)
7. [Rate Limiting](#rate-limiting)
8. [Versioning](#versioning)

---

## 🎯 مقدمه

API دستیار هوشمند یک دو سه بر اساس معماری RESTful طراحی شده و از فرمت JSON برای تبادل داده استفاده می‌کند.

### **Base URL**
```
Production:  https://api.smartassistant123.com/v1
Development: https://dev-api.smartassistant123.com/v1
Local:       http://localhost:8000/api/v1
```

### **Content Type**
تمامی درخواست‌ها باید با `Content-Type: application/json` ارسال شوند.

---

## 🔐 Authentication

### **JWT Token Authentication**

#### **دریافت Token**
```http
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

#### **Response**
```json
{
  "success": true,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expires_in": 3600,
    "user": {
      "id": 1,
      "name": "نام کاربر",
      "email": "user@example.com",
      "role": "customer"
    }
  },
  "message": "ورود با موفقیت انجام شد"
}
```

#### **استفاده از Token**
```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

#### **تمدید Token**
```http
POST /auth/refresh
Authorization: Bearer {refresh_token}
```

### **نقش‌های کاربری**
- `admin`: دسترسی کامل
- `manager`: مدیریت محصولات و گزارشات
- `staff`: دسترسی محدود
- `customer`: کاربر عادی

---

## 🏗️ Structure

### **Request Structure**
```json
{
  "field1": "value1",
  "field2": "value2",
  "nested": {
    "field3": "value3"
  }
}
```

### **Response Structure**
```json
{
  "success": boolean,
  "data": object|array|null,
  "message": string,
  "errors": array|null,
  "meta": {
    "current_page": 1,
    "total_pages": 10,
    "total_items": 100,
    "per_page": 10
  }
}
```

### **Pagination**
```http
GET /products?page=1&per_page=20&sort=created_at&order=desc
```

### **Filtering**
```http
GET /products?category=electronics&price_min=100000&price_max=500000
```

### **Search**
```http
GET /products/search?q=گوشی&category=electronics
```

---

## 🔗 Endpoints

### 👥 **Users Management**

#### **لیست کاربران**
```http
GET /users
Authorization: Bearer {token}
Permissions: admin, manager
```

**Parameters:**
- `page` (int): شماره صفحه
- `per_page` (int): تعداد در هر صفحه
- `role` (string): فیلتر بر اساس نقش
- `search` (string): جستجو در نام و ایمیل

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "احمد احمدی",
      "email": "ahmad@example.com",
      "phone": "09123456789",
      "role": "customer",
      "is_active": true,
      "created_at": "2024-01-15T10:30:00Z",
      "updated_at": "2024-01-15T10:30:00Z"
    }
  ],
  "meta": {
    "current_page": 1,
    "total_pages": 5,
    "total_items": 50,
    "per_page": 10
  }
}
```

#### **ایجاد کاربر جدید**
```http
POST /users
Authorization: Bearer {token}
Permissions: admin
```

**Request:**
```json
{
  "name": "کاربر جدید",
  "email": "newuser@example.com",
  "phone": "09123456789",
  "password": "securepassword123",
  "role": "customer"
}
```

#### **جزئیات کاربر**
```http
GET /users/{id}
Authorization: Bearer {token}
Permissions: admin, manager, own_profile
```

#### **به‌روزرسانی کاربر**
```http
PUT /users/{id}
Authorization: Bearer {token}
Permissions: admin, own_profile
```

#### **حذف کاربر**
```http
DELETE /users/{id}
Authorization: Bearer {token}
Permissions: admin
```

---

### 🛍️ **Products Management**

#### **لیست محصولات**
```http
GET /products
```

**Parameters:**
- `category` (string): دسته‌بندی
- `price_min` (int): حداقل قیمت
- `price_max` (int): حداکثر قیمت
- `is_active` (boolean): وضعیت فعال بودن
- `sort` (string): مرتب‌سازی (name, price, created_at)
- `order` (string): ترتیب (asc, desc)

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "گوشی هوشمند سامسونگ",
      "description": "گوشی پیشرفته با امکانات متنوع",
      "price": 15000000,
      "category": "الکترونیک",
      "image_url": "https://example.com/images/phone.jpg",
      "is_active": true,
      "stock_quantity": 50,
      "created_at": "2024-01-15T10:30:00Z",
      "updated_at": "2024-01-15T10:30:00Z"
    }
  ]
}
```

#### **افزودن محصول**
```http
POST /products
Authorization: Bearer {token}
Permissions: admin, manager
```

**Request:**
```json
{
  "name": "محصول جدید",
  "description": "توضیحات محصول",
  "price": 250000,
  "category": "پوشاک",
  "image_url": "https://example.com/image.jpg",
  "stock_quantity": 100
}
```

#### **جزئیات محصول**
```http
GET /products/{id}
```

#### **ویرایش محصول**
```http
PUT /products/{id}
Authorization: Bearer {token}
Permissions: admin, manager
```

#### **حذف محصول**
```http
DELETE /products/{id}
Authorization: Bearer {token}
Permissions: admin
```

#### **جستجوی محصولات**
```http
GET /products/search?q={query}
```

**Parameters:**
- `q` (string): کلمه کلیدی جستجو
- `category` (string): محدود کردن به دسته‌بندی خاص

---

### 🤖 **AI Services**

#### **چت با هوش مصنوعی**
```http
POST /ai/chat
Authorization: Bearer {token}
```

**Request:**
```json
{
  "message": "سلام، چطور می‌تونم یک گوشی خوب پیدا کنم؟",
  "context": {
    "previous_messages": 5,
    "user_preferences": {
      "budget": 15000000,
      "category": "الکترونیک"
    }
  }
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "response": "سلام! برای انتخاب گوشی مناسب، لطفاً بودجه و نیازهایتان را بگویید...",
    "suggestions": [
      {
        "type": "product",
        "id": 1,
        "name": "گوشی سامسونگ A54"
      }
    ],
    "confidence": 0.95
  }
}
```

#### **دریافت توصیه محصول**
```http
POST /ai/recommend
Authorization: Bearer {token}
```

**Request:**
```json
{
  "user_query": "گوشی برای عکاسی",
  "budget": 20000000,
  "preferences": {
    "brand": ["سامسونگ", "اپل"],
    "features": ["دوربین خوب", "باتری قوی"]
  }
}
```

#### **تاریخچه چت کاربر**
```http
GET /ai/chats/{user_id}
Authorization: Bearer {token}
Permissions: admin, manager, own_chats
```

---

### 💬 **Consultations**

#### **درخواست مشاوره**
```http
POST /consultations
Authorization: Bearer {token}
```

**Request:**
```json
{
  "product_id": 1,
  "message": "آیا این گوشی برای بازی مناسب است؟",
  "contact_method": "phone",
  "preferred_time": "2024-02-15T14:00:00Z"
}
```

#### **لیست مشاوره‌ها**
```http
GET /consultations
Authorization: Bearer {token}
Permissions: admin, manager, staff
```

**Parameters:**
- `status` (string): وضعیت (pending, in_progress, completed, cancelled)
- `assigned_to` (int): شناسه کارشناس
- `date_from` (date): از تاریخ
- `date_to` (date): تا تاریخ

#### **پاسخ به مشاوره**
```http
PUT /consultations/{id}
Authorization: Bearer {token}
Permissions: admin, manager, staff, assigned_consultant
```

**Request:**
```json
{
  "response": "بله، این گوشی برای بازی مناسب است چون...",
  "status": "completed",
  "follow_up_required": false
}
```

---

### 📋 **Forms & CRM**

#### **ایجاد فرم جدید**
```http
POST /forms
Authorization: Bearer {token}
Permissions: admin, manager
```

**Request:**
```json
{
  "title": "فرم نظرسنجی محصول",
  "description": "نظرات شما در مورد محصولات ما",
  "fields": [
    {
      "name": "satisfaction",
      "type": "radio",
      "label": "میزان رضایت",
      "options": ["عالی", "خوب", "متوسط", "ضعیف"],
      "required": true
    },
    {
      "name": "comment",
      "type": "textarea",
      "label": "نظرات",
      "required": false
    }
  ],
  "is_active": true
}
```

#### **ارسال پاسخ فرم**
```http
POST /forms/{id}/submit
Authorization: Bearer {token}
```

**Request:**
```json
{
  "responses": {
    "satisfaction": "عالی",
    "comment": "محصولات بسیار باکیفیت هستند"
  }
}
```

#### **مدیریت مخاطبین CRM**
```http
GET /crm/contacts
POST /crm/contacts
PUT /crm/contacts/{id}
DELETE /crm/contacts/{id}
Authorization: Bearer {token}
Permissions: admin, manager, staff
```

---

### 📊 **Analytics & Reports**

#### **آمار کلی داشبورد**
```http
GET /analytics/dashboard
Authorization: Bearer {token}
Permissions: admin, manager
```

**Response:**
```json
{
  "success": true,
  "data": {
    "total_sales": 58900000,
    "active_users": 124,
    "total_products": 1250,
    "consultations_today": 47,
    "sales_growth": 12.5,
    "user_satisfaction": 4.8
  }
}
```

#### **گزارش فروش**
```http
GET /analytics/sales
Authorization: Bearer {token}
Permissions: admin, manager
```

**Parameters:**
- `period` (string): دوره زمانی (daily, weekly, monthly, yearly)
- `date_from` (date): از تاریخ
- `date_to` (date): تا تاریخ
- `category` (string): دسته‌بندی محصول

#### **گزارش کاربران**
```http
GET /analytics/users
Authorization: Bearer {token}
Permissions: admin, manager
```

---

## ⚠️ Error Handling

### **HTTP Status Codes**
- `200` - OK
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `422` - Validation Error
- `429` - Too Many Requests
- `500` - Internal Server Error

### **Error Response Format**
```json
{
  "success": false,
  "data": null,
  "message": "خطا در اعتبارسنجی ورودی‌ها",
  "errors": [
    {
      "field": "email",
      "code": "invalid_format",
      "message": "فرمت ایمیل صحیح نیست"
    },
    {
      "field": "password",
      "code": "too_short",
      "message": "رمز عبور باید حداقل ۸ کاراکتر باشد"
    }
  ]
}
```

### **Common Error Codes**
- `AUTH_001`: Token نامعتبر
- `AUTH_002`: Token منقضی شده
- `AUTH_003`: دسترسی مجاز نیست
- `VAL_001`: داده‌های ورودی نامعتبر
- `VAL_002`: فیلد اجباری خالی است
- `DB_001`: خطا در بانک اطلاعاتی
- `AI_001`: سرویس هوش مصنوعی در دسترس نیست

---

## 📈 Rate Limiting

### **محدودیت‌های درخواست**
- **کاربران عادی:** 100 درخواست در دقیقه
- **کاربران احراز هویت شده:** 1000 درخواست در دقیقه
- **مدیران:** 5000 درخواست در دقیقه

### **Headers**
```http
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1640995200
```

### **خطای محدودیت**
```json
{
  "success": false,
  "message": "تعداد درخواست‌ها از حد مجاز بیشتر است",
  "errors": [{
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "لطفاً ۶۰ ثانیه صبر کنید"
  }]
}
```

---

## 🔄 Versioning

### **Current Version:** v1

### **Version Headers**
```http
API-Version: v1
Accept-Version: v1
```

### **Deprecation Notice**
API های منسوخ شده با هدر زیر مشخص می‌شوند:
```http
Deprecation: true
Sunset: Thu, 31 Dec 2024 23:59:59 GMT
```

---

## 💡 Examples

### **Example 1: ورود کاربر و دریافت محصولات**

```javascript
// ورود کاربر
const loginResponse = await fetch('/api/v1/auth/login', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    email: 'user@example.com',
    password: 'password123'
  })
});

const loginData = await loginResponse.json();
const token = loginData.data.token;

// دریافت محصولات
const productsResponse = await fetch('/api/v1/products', {
  headers: {
    'Authorization': `Bearer ${token}`
  }
});

const products = await productsResponse.json();
```

### **Example 2: چت با AI**

```javascript
const chatResponse = await fetch('/api/v1/ai/chat', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${token}`
  },
  body: JSON.stringify({
    message: 'گوشی خوب برای عکاسی پیشنهاد بده',
    context: {
      budget: 15000000
    }
  })
});

const chatData = await chatResponse.json();
console.log(chatData.data.response);
```

### **Example 3: ایجاد محصول جدید**

```javascript
const newProduct = await fetch('/api/v1/products', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${token}`
  },
  body: JSON.stringify({
    name: 'گوشی جدید',
    description: 'توضیحات محصول',
    price: 12000000,
    category: 'الکترونیک',
    stock_quantity: 50
  })
});
```

---

## 🔧 Development Tools

### **Postman Collection**
فایل Postman Collection در مسیر `docs/postman/` موجود است.

### **OpenAPI Specification**
فایل Swagger/OpenAPI در مسیر `docs/openapi.yaml` قرار دارد.

### **SDK های رسمی**
- **Flutter/Dart:** در همین پروژه موجود است
- **JavaScript:** `npm install smartassistant123-js-sdk`
- **PHP:** `composer require smartassistant123/php-sdk`

---

**نسخه API:** v1.0.0  
**آخرین به‌روزرسانی:** ۳۰ مرداد ۱۴۰۴  
**مشکلات:** [GitHub Issues](https://github.com/yourusername/ai-123-flutter/issues)
