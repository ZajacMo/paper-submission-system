# API说明 - 基金模块

本文档详细描述基金模块的所有API接口，包括请求参数、响应格式和权限要求等信息。

## 接口列表

### 1. 新建基金

**URL**: `/api/funds`  
**Method**: `POST`  
**Description**: 作者用户创建新的基金项目。  
**Access**: 需要JWT认证，需要author角色权限。  

**Request Body**:
```json
{
  "project_name": "国家自然科学基金项目",
  "project_number": "61232010"
}
```

**Success Response**:  
- **Code**: 201  
- **Content**:  
```json
{
  "message": "基金创建成功",
  "fund_id": 1,
  "project_name": "国家自然科学基金项目",
  "project_number": "61232010"
}
```

**Failed Response**:  
- **Code**: 400  
- **Content**: `{"message": "项目名称和项目编号不能为空"}`  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "权限不足"}`  
- **Code**: 409  
- **Content**: `{"message": "该基金项目编号已存在"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误，创建基金失败"}`

### 2. 查询作者的所有基金

**URL**: `/api/funds`  
**Method**: `GET`  
**Description**: 查询作者用户自己创建或关联的所有基金。  
**Access**: 需要JWT认证，需要author角色权限。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
[
  {
    "fund_id": 1,
    "project_name": "国家自然科学基金项目",
    "project_number": "61232010"
  },
  {
    "fund_id": 2,
    "project_name": "教育部博士点基金",
    "project_number": "20130001110045"
  }
]
```

**Failed Response**:  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "权限不足"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误，查询基金失败"}`

### 3. 搜索基金

**URL**: `/api/funds/search`  
**Method**: `GET`  
**Description**: 根据项目名称或编号搜索基金。  
**Access**: 需要JWT认证，需要author角色权限。  

**URL Parameters**:
- `query`: 搜索关键词，必填。可以是项目名称或项目编号的部分内容。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
[
  {
    "fund_id": 1,
    "project_name": "国家自然科学基金项目",
    "project_number": "61232010"
  },
  {
    "fund_id": 3,
    "project_name": "国家重点研发计划",
    "project_number": "2017YFB1002900"
  }
]
```

**Failed Response**:  
- **Code**: 400  
- **Content**: `{"message": "搜索关键词不能为空"}`  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "权限不足"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误，搜索基金失败"}`

### 4. 根据ID查询基金详情

**URL**: `/api/funds/:fundId`  
**Method**: `GET`  
**Description**: 查询特定基金的详细信息，并验证用户是否有权限访问。  
**Access**: 需要JWT认证，需要author角色权限。  

**URL Parameters**:
- `fundId`: 基金ID，必填。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
{
  "fund_id": 1,
  "project_name": "国家自然科学基金项目",
  "project_number": "61232010"
}
```

**Failed Response**:  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "权限不足"}`  
- **Code**: 404  
- **Content**: `{"message": "基金不存在或您无权访问"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误，查询基金详情失败"}`

## 使用示例

### 创建新基金示例

**请求**:
```http
POST /api/funds
Authorization: Bearer your_jwt_token
Content-Type: application/json

{
  "project_name": "国家自然科学基金项目",
  "project_number": "61232010"
}
```

**响应**:
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "message": "基金创建成功",
  "fund_id": 1,
  "project_name": "国家自然科学基金项目",
  "project_number": "61232010"
}
```

### 查询所有基金示例

**请求**:
```http
GET /api/funds
Authorization: Bearer your_jwt_token
```

**响应**:
```http
HTTP/1.1 200 OK
Content-Type: application/json

[
  {
    "fund_id": 1,
    "project_name": "国家自然科学基金项目",
    "project_number": "61232010"
  },
  {
    "fund_id": 2,
    "project_name": "教育部博士点基金",
    "project_number": "20130001110045"
  }
]
```

### 搜索基金示例

**请求**:
```http
GET /api/funds/search?query=国家自然科学
Authorization: Bearer your_jwt_token
```

**响应**:
```http
HTTP/1.1 200 OK
Content-Type: application/json

[
  {
    "fund_id": 1,
    "project_name": "国家自然科学基金项目",
    "project_number": "61232010"
  }
]
```

### 查询基金详情示例

**请求**:
```http
GET /api/funds/1
Authorization: Bearer your_jwt_token
```

**响应**:
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "fund_id": 1,
  "project_name": "国家自然科学基金项目",
  "project_number": "61232010"
}
```