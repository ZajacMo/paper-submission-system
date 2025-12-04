# API说明 - 论文管理模块

本文档详细描述论文管理模块的所有API接口，包括请求参数、响应格式和权限要求等信息。

## 接口列表

### 1. 获取当前用户所有论文的审稿进度

**URL**: `/api/papers/progress`  
**Method**: `GET`  
**Description**: 获取当前登录作者的所有论文的审稿进度信息。  
**Access**: 需要JWT认证，需要author角色权限。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
[
  {
    "paper_id": 1,
    "progress": "under_review",
    "reviewer_id": 2,
    "review_time": "2023-05-15T10:30:00Z",
    "comment": "论文内容充实，分析深入。"
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

### 2. 获取论文列表

**URL**: `/api/papers`  
**Method**: `GET`  
**Description**: 获取论文列表，支持分页和筛选，根据用户角色返回不同权限的数据。  
**Access**: 需要JWT认证。  

**URL Parameters**:
- `page` (可选): 页码，默认1。  
- `limit` (可选): 每页数量，默认10。  
- `search` (可选): 搜索关键词。  
- `status` (可选): 状态筛选。  
- `author_id` (可选): 作者ID筛选。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
{
  "papers": [
    {
      "paper_id": 1,
      "title_zh": "中文标题",
      "title_en": "English Title",
      "abstract_zh": "中文摘要...",
      "abstract_en": "English abstract...",
      "status": "submitted",
      "submit_time": "2023-05-10T08:00:00Z",
      "integrity": "Waiting"
    }
  ],
  "total": 100,
  "page": 1,
  "limit": 10
}
```

**Failed Response**:  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 3. 获取论文详情

**URL**: `/api/papers/:id`  
**Method**: `GET`  
**Description**: 获取指定论文的详细信息，包括作者、机构、关键词和基金等关联数据。  
**Access**: 需要JWT认证。  

**URL Parameters**:
- `id`: 论文ID。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
{
  "paper_id": 1,
  "title_zh": "中文标题",
  "title_en": "English Title",
  "abstract_zh": "中文摘要...",
  "abstract_en": "English abstract...",
  "status": "submitted",
  "submit_time": "2023-05-10T08:00:00Z",
  "integrity": "Waiting",
  "check_time": null,
  "attachment_path": "uploads/paper1.pdf",
  "authors": [
    {
      "author_id": 1,
      "name": "张三",
      "institution_id": 1,
      "is_corresponding": true
    }
  ],
  "keywords_zh": ["关键词1", "关键词2"],
  "keywords_en": ["Keyword1", "Keyword2"],
  "funds": ["国家自然科学基金"]
}
```

**Failed Response**:  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "无权访问该论文"}`  
- **Code**: 404  
- **Content**: `{"message": "论文不存在"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 4. 下载论文附件

**URL**: `/api/papers/:id/download`  
**Method**: `GET`  
**Description**: 下载指定论文的附件文件。  
**Access**: 需要JWT认证。  

**URL Parameters**:
- `id`: 论文ID。  

**Success Response**:  
- **Code**: 200  
- **Content**: 文件流。  

**Failed Response**:  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "无权下载该论文附件"}`  
- **Code**: 404  
- **Content**: `{"message": "论文不存在"}` 或 `{"message": "附件不存在"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 5. 上传论文附件

**URL**: `/api/papers/upload-attachment`  
**Method**: `POST`  
**Description**: 上传论文附件文件，支持PDF格式，最大50MB。  
**Access**: 需要JWT认证，需要author角色权限。  

**Form Data**:
- `attachment`: 文件对象。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
{
  "message": "附件上传成功",
  "path": "uploads/paper_1620644400000.pdf"
}
```

**Failed Response**:  
- **Code**: 400  
- **Content**: `{"message": "请选择要上传的文件"}` 或 `{"message": "只支持PDF文件"}` 或 `{"message": "文件大小超过限制"}`  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "权限不足"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 6. 创建论文

**URL**: `/api/papers`  
**Method**: `POST`  
**Description**: 创建新论文，包括论文基本信息、作者、机构、关键词和基金等关联数据。  
**Access**: 需要JWT认证，需要author角色权限。  

**Request Body**:
```json
{
  "title_zh": "中文标题",
  "title_en": "English Title",
  "abstract_zh": "中文摘要...",
  "abstract_en": "English abstract...",
  "attachment_path": "uploads/paper1.pdf",
  "authors": [1, 2],
  "institutions": [1, 2],
  "is_corresponding": [true, false],
  "keywords_zh": ["关键词1", "关键词2"],
  "keywords_en": ["Keyword1", "Keyword2"],
  "keywords_new": [
    {"name": "新关键词", "type": "zh"}
  ],
  "funds": ["国家自然科学基金"],
  "funds_new": [
    {"name": "新基金", "number": "123456"}
  ]
}
```

**Success Response**:  
- **Code**: 201  
- **Content**:  
```json
{
  "message": "论文创建成功",
  "paper_id": 1
}
```

**Failed Response**:  
- **Code**: 400  
- **Content**: `{"message": "标题、摘要和附件路径不能为空"}` 或 `{"message": "附件路径格式不正确}` 或 `{"message": "附件文件不存在"}`  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "权限不足"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 7. 更新论文

**URL**: `/api/papers/:id`  
**Method**: `PUT`  
**Description**: 更新论文信息，作者只能更新自己参与的论文。  
**Access**: 需要JWT认证。  

**URL Parameters**:
- `id`: 论文ID。  

**Request Body**:
```json
{
  "title_zh": "更新后的中文标题",
  "title_en": "Updated English Title",
  "abstract_zh": "更新后的中文摘要...",
  "abstract_en": "Updated English abstract...",
  "attachment_path": "uploads/paper_updated.pdf",
  "authors": [1, 3],
  "institutions": [1, 3],
  "is_corresponding": [true, false],
  "keywords_zh": ["更新关键词1"],
  "keywords_en": ["Updated Keyword1"],
  "keywords_new": [],
  "funds": ["国家自然科学基金"],
  "funds_new": []
}
```

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
{
  "message": "论文更新成功"
}
```

**Failed Response**:  
- **Code**: 400  
- **Content**: `{"message": "附件路径格式不正确}` 或 `{"message": "附件文件不存在"}`  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "无权更新该论文"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 8. 更新论文完整性

**URL**: `/api/papers/:id/integrity`  
**Method**: `PUT`  
**Description**: 编辑进行论文完整性检查，设置论文的完整性状态。  
**Access**: 需要JWT认证，需要editor角色权限。  

**URL Parameters**:
- `id`: 论文ID。  

**Request Body**:
```json
{
  "integrity": "True"
}
```

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
{
  "message": "论文完整性检查完成"
}
```

**Failed Response**:  
- **Code**: 400  
- **Content**: `{"message": "无效的完整性状态，有效状态为：True, False, Waiting"}`  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "权限不足"}`  
- **Code**: 404  
- **Content**: `{"message": "论文不存在"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 9. 获取指定论文的审稿进度

**URL**: `/api/papers/:id/progress`  
**Method**: `GET`  
**Description**: 获取指定论文的审稿进度详情。  
**Access**: 需要JWT认证，需要author、expert或editor角色权限。  

**URL Parameters**:
- `id`: 论文ID。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
{
  "paper_id": 1,
  "progress": "under_review",
  "reviewer_id": 2,
  "review_time": "2023-05-15T10:30:00Z",
  "comment": "论文内容充实，分析深入。"
}
```

**Failed Response**:  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "无权访问该论文的审稿进度"}`  
- **Code**: 404  
- **Content**: `{"message": "未找到该论文的审稿进度"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 10. 获取指定论文的状态信息

**URL**: `/api/papers/:id/status`  
**Method**: `GET`  
**Description**: 获取指定论文的状态信息。  
**Access**: 需要JWT认证。  

**URL Parameters**:
- `id`: 论文ID。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
{
  "paper_id": 1,
  "status": "submitted",
  "status_read": 0
}
```

**Failed Response**:  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "无权查看该论文的状态"}`  
- **Code**: 404  
- **Content**: `{"message": "论文不存在"}`  
- **Code**: 500  
- **Content**: `{"message": "获取论文状态失败: 错误信息"}`

## 使用示例

### 创建论文示例

**请求**:
```http
POST /api/papers
Authorization: Bearer your_jwt_token
Content-Type: application/json

{
  "title_zh": "人工智能在医疗领域的应用",
  "title_en": "Application of Artificial Intelligence in Medical Field",
  "abstract_zh": "本研究探讨了人工智能技术在医疗诊断、治疗方案制定和健康管理等方面的应用。",
  "abstract_en": "This study explores the application of artificial intelligence technology in medical diagnosis, treatment planning, and health management.",
  "attachment_path": "uploads/ai_medical_paper.pdf",
  "authors": [1, 2],
  "institutions": [1, 2],
  "is_corresponding": [true, false],
  "keywords_zh": ["人工智能", "医疗诊断"],
  "keywords_en": ["Artificial Intelligence", "Medical Diagnosis"],
  "keywords_new": [],
  "funds": ["国家自然科学基金"],
  "funds_new": []
}
```

**响应**:
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "message": "论文创建成功",
  "paper_id": 1
}
```

### 上传论文附件示例

**请求**:
```http
POST /api/papers/upload-attachment
Authorization: Bearer your_jwt_token
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW

------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="attachment"; filename="paper.pdf"
Content-Type: application/pdf

(file content)
------WebKitFormBoundary7MA4YWxkTrZu0gW--
```

**响应**:
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "message": "附件上传成功",
  "path": "uploads/paper_1620644400000.pdf"
}
```

### 搜索论文示例

**请求**:
```http
GET /api/papers?search=人工智能&page=1&limit=10
Authorization: Bearer your_jwt_token
```

**响应**:
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "papers": [
    {
      "paper_id": 1,
      "title_zh": "人工智能在医疗领域的应用",
      "title_en": "Application of Artificial Intelligence in Medical Field",
      "abstract_zh": "本研究探讨了人工智能技术在医疗诊断、治疗方案制定和健康管理等方面的应用。",
      "abstract_en": "This study explores the application of artificial intelligence technology in medical diagnosis, treatment planning, and health management.",
      "status": "submitted",
      "submit_time": "2023-05-10T08:00:00Z",
      "integrity": "Waiting"
    }
  ],
  "total": 5,
  "page": 1,
  "limit": 10
}
```