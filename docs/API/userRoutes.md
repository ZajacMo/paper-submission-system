# API说明 - 用户模块

本文档详细描述用户模块的所有API接口，包括请求参数、响应格式和权限要求等信息。

## 接口列表

### 1. 获取当前用户信息

**URL**: `/api/users/profile`  
**Method**: `GET`  
**Description**: 根据当前用户角色获取相应的用户信息，包括基本信息和所属机构。  
**Access**: 需要JWT认证。  

**Success Response**:  
- **Code**: 200  
- **Content**: 根据用户角色返回不同格式的信息  

  **作者(author)响应**:  
```json
{
  "author_id": 1,
  "name": "张三",
  "email": "zhangsan@example.com",
  "phone": "13800138000",
  "age": 35,
  "degree": "博士",
  "title": "副教授",
  "hometown": "北京",
  "research_areas": "计算机科学",
  "bio": "研究领域包括人工智能和机器学习",
  "institutions": [
    {
      "institution_id": 1,
      "name": "北京大学",
      "address": "北京市海淀区"
    }
  ]
}
```

  **专家(expert)响应**:  
```json
{
  "expert_id": 1,
  "name": "李四",
  "email": "lisi@example.com",
  "phone": "13900139000",
  "title": "教授",
  "research_areas": "软件工程",
  "review_fee": 500,
  "bank_account": "6222021234567890123",
  "bank_name": "工商银行",
  "account_holder": "李四",
  "institutions": [
    {
      "institution_id": 2,
      "name": "清华大学",
      "address": "北京市海淀区"
    }
  ]
}
```

  **编辑(editor)响应**:  
```json
{
  "editor_id": 1,
  "name": "王五",
  "email": "wangwu@example.com",
  "institutions": []
}
```

**Failed Response**:  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 404  
- **Content**: `{"message": "用户不存在"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 2. 更新当前用户信息

**URL**: `/api/users/profile`  
**Method**: `PUT`  
**Description**: 更新当前用户的个人信息。  
**Access**: 需要JWT认证。  

**Request Body**:

  **作者(author)请求**:  
```json
{
  "name": "张三",
  "email": "zhangsan@example.com",
  "phone": "13800138000",
  "age": 36,
  "degree": "博士",
  "title": "教授",
  "hometown": "北京",
  "research_areas": "人工智能",
  "bio": "研究领域包括人工智能和机器学习"
}
```

  **专家(expert)请求**:  
```json
{
  "name": "李四",
  "email": "lisi@example.com",
  "phone": "13900139000",
  "title": "教授",
  "research_areas": "软件工程",
  "review_fee": 600,
  "bank_account": "6222021234567890123",
  "bank_name": "工商银行",
  "account_holder": "李四"
}
```

  **编辑(editor)请求**:  
```json
{
  "name": "王五",
  "email": "wangwu@example.com"
}
```

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
{
  "message": "用户信息更新成功"
}
```

**Failed Response**:  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 404  
- **Content**: `{"message": "用户不存在"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 3. 编辑获取所有作者列表

**URL**: `/api/users/authors`  
**Method**: `GET`  
**Description**: 获取系统中的所有作者信息。  
**Access**: 需要JWT认证，需要editor角色权限。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
[
  {
    "author_id": 1,
    "name": "张三",
    "email": "zhangsan@example.com",
    "phone": "13800138000",
    "age": 35,
    "degree": "博士",
    "title": "副教授",
    "hometown": "北京",
    "research_areas": "计算机科学",
    "bio": "研究领域包括人工智能和机器学习",
    "password": "hashed_password"
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

### 4. 编辑获取所有专家列表

**URL**: `/api/users/experts`  
**Method**: `GET`  
**Description**: 获取系统中的所有专家信息。  
**Access**: 需要JWT认证，需要editor角色权限。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
[
  {
    "expert_id": 1,
    "name": "李四",
    "email": "lisi@example.com",
    "phone": "13900139000",
    "title": "教授",
    "research_areas": "软件工程",
    "review_fee": 500,
    "bank_account": "6222021234567890123",
    "bank_name": "工商银行",
    "account_holder": "李四",
    "password": "hashed_password"
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

### 5. 搜索专家API

**URL**: `/api/users/search-experts`  
**Method**: `GET`  
**Description**: 根据专家ID、姓名或研究领域搜索专家，支持分页。  
**Access**: 需要JWT认证。  

**URL Parameters**:
- `query`: 搜索关键词，必填。可以是专家ID、姓名或研究领域的部分内容。  
- `page`: 页码，默认为1。  
- `limit`: 每页记录数，默认为10。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
{
  "experts": [
    {
      "expert_id": 1,
      "name": "李四",
      "title": "教授",
      "research_areas": "软件工程"
    }
  ],
  "pagination": {
    "total": 1,
    "page": 1,
    "limit": 10,
    "totalPages": 1
  }
}
```

**Failed Response**:  
- **Code**: 400  
- **Content**: `{"message": "请输入专家ID、姓名或研究领域"}`  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 500  
- **Content**: `{"message": "搜索专家时发生错误"}`

### 6. 根据输入的作者ID或姓名查询作者

**URL**: `/api/users/search`  
**Method**: `GET`  
**Description**: 根据作者ID或姓名查询作者信息。  
**Access**: 需要JWT认证，需要author角色权限。  

**URL Parameters**:
- `query`: 搜索关键词，必填。可以是作者ID或姓名的部分内容。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
[
  {
    "author_id": 1,
    "name": "张三"
  },
  {
    "author_id": 2,
    "name": "张小明"
  }
]
```

**Failed Response**:  
- **Code**: 400  
- **Content**: `{"message": "请输入作者ID或姓名"}`  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "权限不足"}`  
- **Code**: 404  
- **Content**: `{"message": "作者不存在"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

## 使用示例

### 获取当前用户信息示例

**请求**:
```http
GET /api/users/profile
Authorization: Bearer your_jwt_token
```

**响应**:
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "author_id": 1,
  "name": "张三",
  "email": "zhangsan@example.com",
  "phone": "13800138000",
  "age": 35,
  "degree": "博士",
  "title": "副教授",
  "hometown": "北京",
  "research_areas": "计算机科学",
  "bio": "研究领域包括人工智能和机器学习",
  "institutions": [
    {
      "institution_id": 1,
      "name": "北京大学",
      "address": "北京市海淀区"
    }
  ]
}
```

### 更新用户信息示例

**请求**:
```http
PUT /api/users/profile
Authorization: Bearer your_jwt_token
Content-Type: application/json

{
  "name": "张三",
  "email": "zhangsan@example.com",
  "phone": "13800138000",
  "age": 36,
  "degree": "博士",
  "title": "教授",
  "research_areas": "人工智能和机器学习"
}
```

**响应**:
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "message": "用户信息更新成功"
}
```

### 搜索专家示例

**请求**:
```http
GET /api/users/search-experts?query=计算机&page=1&limit=10
Authorization: Bearer your_jwt_token
```

**响应**:
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "experts": [
    {
      "expert_id": 1,
      "name": "李四",
      "title": "教授",
      "research_areas": "计算机科学与技术"
    },
    {
      "expert_id": 3,
      "name": "王五",
      "title": "副教授",
      "research_areas": "计算机网络"
    }
  ],
  "pagination": {
    "total": 2,
    "page": 1,
    "limit": 10,
    "totalPages": 1
  }
}
```