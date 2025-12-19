# API说明 - 通知模块

本文档详细描述通知模块的所有API接口，包括请求参数、响应格式和权限要求等信息。

## 接口列表

### 1. 作者拉取自己的通知

**URL**: `/api/notifications/author`  
**Method**: `GET`  
**Description**: 获取当前登录作者参与的所有论文的通知。  
**Access**: 需要JWT认证，需要author角色权限。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
[
  {
    "notification_id": 1,
    "paper_id": 1,
    "notification_type": "Acceptance Notification",
    "sent_at": "2023-05-20T14:30:00Z",
    "deadline": null,
    "is_read": false
  },
  {
    "notification_id": 2,
    "paper_id": 1,
    "notification_type": "Review Assignment",
    "sent_at": "2023-05-15T10:00:00Z",
    "deadline": null,
    "is_read": true
  }
]
```

**Failed Response**:  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "权限不足"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 2. 编辑发送通知给作者

**URL**: `/api/notifications/author`  
**Method**: `POST`  
**Description**: 编辑向作者发送通知，包括接受通知、拒绝通知、审稿分配和付款确认。  
**Access**: 需要JWT认证，需要editor角色权限。  

**Request Body**:
```json
{
  "paper_id": 1,
  "notification_type": "Acceptance Notification",
  "deadline": null
}
```

**Success Response**:  
- **Code**: 201  
- **Content**:  
```json
{
  "message": "通知发送成功",
  "notification_id": 3
}
```

**Failed Response**:  
- **Code**: 400  
- **Content**: `{"message": "无效的通知类型，有效类型为：Acceptance Notification, Rejection Notification, Review Assignment, Payment Confirmation"}` 或 `{"message": "修稿通知必须提供截止时间"}`  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "权限不足"}`  
- **Code**: 404  
- **Content**: `{"message": "论文不存在"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 3. 标记通知为已读

**URL**: `/api/notifications/:id/read`  
**Method**: `PUT`  
**Description**: 将指定通知标记为已读，并更新对应论文的状态为已读。  
**Access**: 需要JWT认证。  

**URL Parameters**:
- `id`: 通知ID。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
{
  "message": "通知已标记为已读，论文状态已更新为已读"
}
```

**Failed Response**:  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "您无权操作此通知"}`  
- **Code**: 404  
- **Content**: `{"message": "通知不存在"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 4. 获取未读通知数量

**URL**: `/api/notifications/unread-count`  
**Method**: `GET`  
**Description**: 获取当前登录作者参与的所有论文的未读通知数量。  
**Access**: 需要JWT认证，需要author角色权限。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
{
  "unread_count": 2
}
```

**Failed Response**:  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "权限不足"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

## 使用示例

### 作者获取通知示例

**请求**:
```http
GET /api/notifications/author
Authorization: Bearer your_jwt_token
```

**响应**:
```http
HTTP/1.1 200 OK
Content-Type: application/json

[
  {
    "notification_id": 1,
    "paper_id": 1,
    "notification_type": "Acceptance Notification",
    "sent_at": "2023-05-20T14:30:00Z",
    "deadline": null,
    "is_read": false
  },
  {
    "notification_id": 2,
    "paper_id": 1,
    "notification_type": "Review Assignment",
    "sent_at": "2023-05-15T10:00:00Z",
    "deadline": null,
    "is_read": true
  }
]
```

### 编辑发送通知示例

**请求**:
```http
POST /api/notifications/author
Authorization: Bearer your_jwt_token
Content-Type: application/json

{
  "paper_id": 1,
  "notification_type": "Acceptance Notification",
  "deadline": null
}
```

**响应**:
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "message": "通知发送成功",
  "notification_id": 3
}
```

### 标记通知为已读示例

**请求**:
```http
PUT /api/notifications/1/read
Authorization: Bearer your_jwt_token
```

**响应**:
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "message": "通知已标记为已读，论文状态已更新为已读"
}
```

### 获取未读通知数量示例

**请求**:
```http
GET /api/notifications/unread-count
Authorization: Bearer your_jwt_token
```

**响应**:
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "unread_count": 2
}
```