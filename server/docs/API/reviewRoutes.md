# API说明 - 审稿模块

本文档详细描述审稿模块的所有API接口，包括请求参数、响应格式和权限要求等信息。

## 接口列表

### 1. 获取分配给专家的审稿任务

**URL**: `/api/reviews/assignments`  
**Method**: `GET`  
**Description**: 获取分配给当前登录专家的所有审稿任务。  
**Access**: 需要JWT认证，需要expert角色权限。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
[
  {
    "assignment_id": 1,
    "paper_id": 1,
    "expert_id": 1,
    "editor_id": 1,
    "assigned_date": "2023-05-10T09:00:00Z",
    "assigned_due_date": "2023-05-24T23:59:59Z",
    "conclusion": "Not Reviewed",
    "status": "Assigned",
    "is_read": 0,
    "submission_date": null,
    "positive_comments": null,
    "negative_comments": null,
    "modification_advice": null,
    "title_zh": "中文标题",
    "title_en": "English Title"
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

### 2. 获取专家的未读任务数量

**URL**: `/api/reviews/assignments/unread-count`  
**Method**: `GET`  
**Description**: 获取当前登录专家的未读审稿任务数量。  
**Access**: 需要JWT认证，需要expert角色权限。  

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

### 3. 编辑批量分配审稿任务并发送评审任务书

**URL**: `/api/reviews/assignments`  
**Method**: `POST`  
**Description**: 编辑为论文批量分配审稿任务，支持1-3个专家。  
**Access**: 需要JWT认证，需要editor角色权限。  

**Request Body**:
```json
[
  {
    "paper_id": 1,
    "expert_id": 1,
    "assigned_due_date": "2023-05-24T23:59:59Z"
  },
  {
    "paper_id": 1,
    "expert_id": 2,
    "assigned_due_date": "2023-05-24T23:59:59Z"
  }
]
```

**Success Response**:  
- **Code**: 201  
- **Content**:  
```json
{
  "message": "审稿任务批量分配成功",
  "created_assignments": [
    {
      "paper_id": 1,
      "expert_id": 1,
      "assignment_id": 1
    },
    {
      "paper_id": 1,
      "expert_id": 2,
      "assignment_id": 2
    }
  ]
}
```

**Failed Response**:  
- **Code**: 400  
- **Content**: `{"message": "请求体必须是任务分配数组"}` 或 `{"message": "任务分配数组必须包含1-3条记录"}` 或 `{"message": "数组中存在缺少必要信息的任务"}` 或 `{"message": "专家ID 1 已经被分配到论文ID 1"}`  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "权限不足"}`  
- **Code**: 404  
- **Content**: `{"message": "编辑信息不存在"}` 或 `{"message": "论文ID 1 不存在"}` 或 `{"message": "专家ID 1 不存在"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 4. 专家标记审稿任务为已读

**URL**: `/api/reviews/assignments/:id/read`  
**Method**: `PUT`  
**Description**: 将指定审稿任务标记为已读。  
**Access**: 需要JWT认证，需要expert角色权限。  

**URL Parameters**:
- `id`: 任务分配ID。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
{
  "message": "任务已标记为已读"
}
```

**Failed Response**:  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "无权处理该审稿任务"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 5. 专家提交审稿意见

**URL**: `/api/reviews/assignments/:id`  
**Method**: `PUT`  
**Description**: 提交审稿意见，包括结论和详细评论。  
**Access**: 需要JWT认证，需要expert角色权限。  

**URL Parameters**:
- `id`: 任务分配ID。  

**Request Body**:
```json
{
  "conclusion": "Accept",
  "positive_comments": "论文研究方法科学，论证充分。",
  "negative_comments": "实验数据可以更加丰富。",
  "modification_advice": "建议补充更多实验案例。"
}
```

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
{
  "message": "审稿意见提交成功"
}
```

**Failed Response**:  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "无权处理该审稿任务"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 6. 获取论文的所有审稿意见

**URL**: `/api/reviews/papers/:paperId/comments`  
**Method**: `GET`  
**Description**: 获取指定论文的所有已完成的审稿意见，作者只能查看自己参与的论文。  
**Access**: 需要JWT认证。  

**URL Parameters**:
- `paperId`: 论文ID。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
[
  {
    "assignment_id": 1,
    "paper_id": 1,
    "expert_id": 1,
    "editor_id": 1,
    "assigned_date": "2023-05-10T09:00:00Z",
    "assigned_due_date": "2023-05-24T23:59:59Z",
    "conclusion": "Accept",
    "status": "Completed",
    "is_read": 1,
    "submission_date": "2023-05-20T14:30:00Z",
    "positive_comments": "论文研究方法科学，论证充分。",
    "negative_comments": "实验数据可以更加丰富。",
    "modification_advice": "建议补充更多实验案例。",
    "expert_name": "王五"
  }
]
```

**Failed Response**:  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "无权查看该论文的审稿意见"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 7. 编辑获取论文对应的所有审稿专家

**URL**: `/api/reviews/papers/:paperId/expert`  
**Method**: `GET`  
**Description**: 获取指定论文的所有审稿专家信息，并返回是否可编辑状态。  
**Access**: 需要JWT认证，需要editor角色权限。  

**URL Parameters**:
- `paperId`: 论文ID。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
{
  "experts": [
    {
      "assignment_id": 1,
      "paper_id": 1,
      "expert_id": 1,
      "editor_id": 1,
      "assigned_date": "2023-05-10T09:00:00Z",
      "assigned_due_date": "2023-05-24T23:59:59Z",
      "conclusion": "Accept",
      "status": "Completed",
      "is_read": 1,
      "submission_date": "2023-05-20T14:30:00Z",
      "expert_name": "王五",
      "institution_names": "中国科学院",
      "research_areas": "计算机科学"
    }
  ],
  "editable": false
}
```

**Failed Response**:  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "权限不足"}`  
- **Code**: 404  
- **Content**: `{"message": "论文不存在"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

## 使用示例

### 专家获取审稿任务示例

**请求**:
```http
GET /api/reviews/assignments
Authorization: Bearer your_jwt_token
```

**响应**:
```http
HTTP/1.1 200 OK
Content-Type: application/json

[
  {
    "assignment_id": 1,
    "paper_id": 1,
    "expert_id": 1,
    "editor_id": 1,
    "assigned_date": "2023-05-10T09:00:00Z",
    "assigned_due_date": "2023-05-24T23:59:59Z",
    "conclusion": "Not Reviewed",
    "status": "Assigned",
    "is_read": 0,
    "submission_date": null,
    "positive_comments": null,
    "negative_comments": null,
    "modification_advice": null,
    "title_zh": "中文标题",
    "title_en": "English Title"
  }
]
```

### 专家提交审稿意见示例

**请求**:
```http
PUT /api/reviews/assignments/1
Authorization: Bearer your_jwt_token
Content-Type: application/json

{
  "conclusion": "Accept",
  "positive_comments": "论文研究方法科学，论证充分。",
  "negative_comments": "实验数据可以更加丰富。",
  "modification_advice": "建议补充更多实验案例。"
}
```

**响应**:
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "message": "审稿意见提交成功"
}
```

### 编辑分配审稿任务示例

**请求**:
```http
POST /api/reviews/assignments
Authorization: Bearer your_jwt_token
Content-Type: application/json

[
  {
    "paper_id": 1,
    "expert_id": 1,
    "assigned_due_date": "2023-05-24T23:59:59Z"
  },
  {
    "paper_id": 1,
    "expert_id": 2,
    "assigned_due_date": "2023-05-24T23:59:59Z"
  }
]
```

**响应**:
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "message": "审稿任务批量分配成功",
  "created_assignments": [
    {
      "paper_id": 1,
      "expert_id": 1,
      "assignment_id": 1
    },
    {
      "paper_id": 1,
      "expert_id": 2,
      "assignment_id": 2
    }
  ]
}
```