# 通知模块

## 获取作者通知
- **URL**: `/api/notifications/author`
- **Method**: `GET`
- **Description**: 作者获取自己参与论文的通知列表
- **Response**: 
```json
[{
    "notification_id": "number", 
    "paper_id": "number", 
    "notification_type": "string", 
    "sent_at": "datetime", 
    "deadline": "datetime", 
    "is_read": "boolean", 
    "content": "string"
}]
```

## 发送通知给作者
- **URL**: `/api/notifications/author`
- **Method**: `POST`
- **Description**: 编辑发送通知给论文相关作者
- **Authorization**: 需要 JWT 令牌
- **Access Control**: 仅编辑角色可访问
- **Request Body**: 
```json
{
    "paper_id": "number", 
    "notification_type": "Acceptance Notification/Rejection Notification/Review Assignment/Payment Confirmation", 
    "deadline": "datetime" (可选，仅当notification_type为Revision Notification时必需)
}
```
- **Success Response**: 
```json
{
    "message": "通知发送成功", 
    "notification_id": "number"
}
```
- **Error Response**:
  - 400: `{"message": "无效的通知类型，有效类型为：Acceptance Notification, Rejection Notification, Review Assignment, Payment Confirmation"}`
  - 400: `{"message": "修稿通知必须提供截止时间"}`
  - 404: `{"message": "论文不存在"}`
  - 500: `{"message": "错误信息"}`

## 标记通知为已读
- **URL**: `/api/notifications/:id/read`
- **Method**: `PUT`
- **Description**: 标记通知为已读（作者只能标记自己参与论文的通知）
- **Response**: 
```json
{
    "message": "string"
}
```

## 获取未读通知数量
- **URL**: `/api/notifications/unread-count`
- **Method**: `GET`
- **Description**: 获取当前用户参与论文的未读通知数量
- **Response**: 
```json
{
    "unread_count": "number"
}
```
