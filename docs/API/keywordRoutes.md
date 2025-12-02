# API说明 - 关键词模块

本文档详细描述关键词模块的所有API接口，包括请求参数、响应格式和权限要求等信息。

## 接口列表

### 1. 获取所有关键词列表

**URL**: `/api/keywords`  
**Method**: `GET`  
**Description**: 获取系统中所有关键词，按中文和英文分类返回。  
**Access**: 需要JWT认证。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
{
  "zh": [
    {
      "keyword_id": 1,
      "keyword_name": "人工智能",
      "keyword_type": "zh"
    },
    {
      "keyword_id": 2,
      "keyword_name": "机器学习",
      "keyword_type": "zh"
    }
  ],
  "en": [
    {
      "keyword_id": 3,
      "keyword_name": "Artificial Intelligence",
      "keyword_type": "en"
    },
    {
      "keyword_id": 4,
      "keyword_name": "Machine Learning",
      "keyword_type": "en"
    }
  ]
}
```

**Failed Response**:  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 2. 添加新关键词

**URL**: `/api/keywords`  
**Method**: `POST`  
**Description**: 添加新的关键词（根据代码显示只有author角色可以添加）。  
**Access**: 需要JWT认证，需要author角色权限。  

**Request Body**:
```json
{
  "keyword_name": "深度学习",
  "keyword_type": "zh"
}
```

**Success Response**:  
- **Code**: 201  
- **Content**:  
```json
{
  "message": "关键词添加成功",
  "keyword_id": 5
}
```

**Failed Response**:  
- **Code**: 400  
- **Content**: `{"message": "关键词名称和类型不能为空"}` 或 `{"message": "关键词类型必须是 zh 或 en"}` 或 `{"message": "关键词名称不能超过20个字符"}` 或 `{"message": "该关键词已存在"}`  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "权限不足"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 3. 更新关键词

**URL**: `/api/keywords/:id`  
**Method**: `PUT`  
**Description**: 更新指定ID的关键词信息（只有editor角色可以更新）。  
**Access**: 需要JWT认证，需要editor角色权限。  

**URL Parameters**:
- `id`: 关键词ID，必填。  

**Request Body**:
```json
{
  "keyword_name": "深度神经网络",
  "keyword_type": "zh"
}
```

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
{
  "message": "关键词更新成功"
}
```

**Failed Response**:  
- **Code**: 400  
- **Content**: `{"message": "关键词名称和类型不能为空"}` 或 `{"message": "关键词类型必须是 zh 或 en"}` 或 `{"message": "关键词名称不能超过20个字符"}` 或 `{"message": "该关键词已存在"}`  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "权限不足"}`  
- **Code**: 404  
- **Content**: `{"message": "关键词不存在"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 4. 删除关键词

**URL**: `/api/keywords/:id`  
**Method**: `DELETE`  
**Description**: 删除指定ID的关键词，并解除与论文的关联（只有editor角色可以删除）。  
**Access**: 需要JWT认证，需要editor角色权限。  

**URL Parameters**:
- `id`: 关键词ID，必填。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
{
  "message": "关键词删除成功"
}
```

**Failed Response**:  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "权限不足"}`  
- **Code**: 404  
- **Content**: `{"message": "关键词不存在"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 5. 搜索关键词

**URL**: `/api/keywords/search`  
**Method**: `GET`  
**Description**: 根据关键词名称搜索关键词，可选指定类型。  
**Access**: 需要JWT认证。  

**URL Parameters**:
- `query`: 搜索关键词，必填。  
- `type`: (可选) 关键词类型，zh或en。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
[
  {
    "keyword_id": 1,
    "keyword_name": "人工智能",
    "keyword_type": "zh"
  },
  {
    "keyword_id": 3,
    "keyword_name": "Artificial Intelligence",
    "keyword_type": "en"
  }
]
```

**Failed Response**:  
- **Code**: 400  
- **Content**: `{"message": "请输入搜索关键词"}`  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 6. 搜索中文关键词

**URL**: `/api/keywords/search/zh`  
**Method**: `GET`  
**Description**: 专门搜索中文关键词。  
**Access**: 需要JWT认证。  

**URL Parameters**:
- `query`: 搜索关键词，必填。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
[
  {
    "keyword_id": 1,
    "keyword_name": "人工智能",
    "keyword_type": "zh"
  },
  {
    "keyword_id": 2,
    "keyword_name": "机器学习",
    "keyword_type": "zh"
  }
]
```

**Failed Response**:  
- **Code**: 400  
- **Content**: `{"message": "请输入搜索关键词"}`  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 7. 搜索英文关键词

**URL**: `/api/keywords/search/en`  
**Method**: `GET`  
**Description**: 专门搜索英文关键词。  
**Access**: 需要JWT认证。  

**URL Parameters**:
- `query`: 搜索关键词，必填。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
[
  {
    "keyword_id": 3,
    "keyword_name": "Artificial Intelligence",
    "keyword_type": "en"
  },
  {
    "keyword_id": 4,
    "keyword_name": "Machine Learning",
    "keyword_type": "en"
  }
]
```

**Failed Response**:  
- **Code**: 400  
- **Content**: `{"message": "请输入搜索关键词"}`  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 8. 关联论文与关键词

**URL**: `/api/keywords/papers/:paperId/associate`  
**Method**: `POST`  
**Description**: 为指定论文关联关键词，先删除原有关联，再添加新关联。  
**Access**: 需要JWT认证，需要author角色权限，且必须是论文作者。  

**URL Parameters**:
- `paperId`: 论文ID，必填。  

**Request Body**:
```json
{
  "keywords_zh": [1, 2],
  "keywords_en": [3, 4]
}
```

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
{
  "message": "论文关键词关联成功",
  "paper_id": "1",
  "keywords_zh_count": 2,
  "keywords_en_count": 2
}
```

**Failed Response**:  
- **Code**: 400  
- **Content**: `{"message": "关键词ID 5 不是中文关键词"}` 或 `{"message": "关键词ID 3 不是英文关键词"}`  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "无权操作该论文"}`  
- **Code**: 404  
- **Content**: `{"message": "论文不存在"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

## 使用示例

### 获取所有关键词示例

**请求**:
```http
GET /api/keywords
Authorization: Bearer your_jwt_token
```

**响应**:
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "zh": [
    {
      "keyword_id": 1,
      "keyword_name": "人工智能",
      "keyword_type": "zh"
    },
    {
      "keyword_id": 2,
      "keyword_name": "机器学习",
      "keyword_type": "zh"
    }
  ],
  "en": [
    {
      "keyword_id": 3,
      "keyword_name": "Artificial Intelligence",
      "keyword_type": "en"
    },
    {
      "keyword_id": 4,
      "keyword_name": "Machine Learning",
      "keyword_type": "en"
    }
  ]
}
```

### 添加新关键词示例

**请求**:
```http
POST /api/keywords
Authorization: Bearer your_jwt_token
Content-Type: application/json

{
  "keyword_name": "深度学习",
  "keyword_type": "zh"
}
```

**响应**:
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "message": "关键词添加成功",
  "keyword_id": 5
}
```

### 搜索关键词示例

**请求**:
```http
GET /api/keywords/search?query=智能&type=zh
Authorization: Bearer your_jwt_token
```

**响应**:
```http
HTTP/1.1 200 OK
Content-Type: application/json

[
  {
    "keyword_id": 1,
    "keyword_name": "人工智能",
    "keyword_type": "zh"
  }
]
```

### 关联论文与关键词示例

**请求**:
```http
POST /api/keywords/papers/1/associate
Authorization: Bearer your_jwt_token
Content-Type: application/json

{
  "keywords_zh": [1, 2],
  "keywords_en": [3, 4]
}
```

**响应**:
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "message": "论文关键词关联成功",
  "paper_id": "1",
  "keywords_zh_count": 2,
  "keywords_en_count": 2
}
```