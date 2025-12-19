# API说明 - 认证模块

本文档详细描述认证模块的所有API接口，包括请求参数、响应格式和使用方法等信息。

## 接口列表

### 1. 用户登录

**URL**: `/api/auth/login`  
**Method**: `POST`  
**Description**: 用户登录接口，支持作者、专家和编辑角色的登录。  
**Access**: 不需要JWT认证。  

**Request Body**:
```json
{
  "email": "user@example.com",
  "password": "your_password",
  "role": "author"
}
```

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "role": "author"
  }
}
```

**Failed Response**:  
- **Code**: 400  
- **Content**: `{"message": "缺少必要的登录信息"}`  
- **Code**: 401  
- **Content**: `{"message": "邮箱或密码错误"}` 或 `{"message": "用户不存在"}` 或其他认证失败信息  

### 2. 检查令牌有效性

**URL**: `/api/auth/check-auth`  
**Method**: `GET`  
**Description**: 检查当前用户的认证令牌是否有效。  
**Access**: 可选JWT认证。  

**Headers**:
- `Authorization`: Bearer {token} (可选)  

**Success Response**:  
- **Code**: 200  
- **Content**:  
  - 如果令牌存在: `{"authenticated": true}`  
  - 如果令牌不存在: `{"authenticated": false}`  

## 使用示例

### 用户登录示例

**请求**:
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "author@example.com",
  "password": "secure_password",
  "role": "author"
}
```

**响应**:
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhdXRob3JAZXhhbXBsZS5jb20iLCJyb2xlIjoiYXV0aG9yIiwiaWF0IjoxNjIwNjQ0NDAwLCJleHAiOjE2MjA3MzA4MDB9.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c",
  "user": {
    "id": 1,
    "email": "author@example.com",
    "role": "author"
  }
}
```

### 检查令牌有效性示例

**请求** (带令牌):
```http
GET /api/auth/check-auth
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**响应**:
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "authenticated": true
}
```

**请求** (无令牌):
```http
GET /api/auth/check-auth
```

**响应**:
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "authenticated": false
}
```