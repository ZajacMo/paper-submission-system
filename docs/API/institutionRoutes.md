# API说明 - 机构模块

本文档详细描述机构模块的所有API接口，包括请求参数、响应格式和权限要求等信息。

## 接口列表

### 1. 搜索机构

**URL**: `/api/institutions/search`  
**Method**: `GET`  
**Description**: 根据机构名称模糊搜索机构信息。  
**Access**: 需要JWT认证。  

**URL Parameters**:
- `name`: 机构名称查询参数，必填。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
[
  {
    "institution_id": 1,
    "name": "北京大学",
    "city": "北京",
    "zip_code": "100871"
  },
  {
    "institution_id": 2,
    "name": "北京师范大学",
    "city": "北京",
    "zip_code": "100875"
  }
]
```

**Failed Response**:  
- **Code**: 400  
- **Content**: `{"message": "请提供机构名称查询参数"}`  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 2. 新增机构信息

**URL**: `/api/institutions`  
**Method**: `POST`  
**Description**: 创建新的机构信息。  
**Access**: 需要JWT认证。  

**Request Body**:
```json
{
  "name": "浙江大学",
  "city": "杭州",
  "zip_code": "310027"
}
```

**Success Response**:  
- **Code**: 201  
- **Content**:  
```json
{
  "institution_id": 3,
  "name": "浙江大学",
  "city": "杭州",
  "zip_code": "310027"
}
```

**Failed Response**:  
- **Code**: 400  
- **Content**: `{"message": "机构名称和城市为必填字段"}` 或 `{"message": "该城市中已存在同名机构"}`  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 3. 作者关联机构

**URL**: `/api/institutions/author/link`  
**Method**: `POST`  
**Description**: 作者用户关联机构信息。  
**Access**: 需要JWT认证，需要author角色权限。  

**Request Body**:
```json
{
  "institution_id": 1
}
```

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
{
  "message": "机构关联成功"
}
```

**Failed Response**:  
- **Code**: 400  
- **Content**: `{"message": "请提供机构ID"}` 或 `{"message": "您已关联该机构"}`  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "权限不足"}`  
- **Code**: 404  
- **Content**: `{"message": "机构不存在"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 4. 作者解除机构关联

**URL**: `/api/institutions/author/unlink/:institution_id`  
**Method**: `DELETE`  
**Description**: 作者用户解除与机构的关联。  
**Access**: 需要JWT认证，需要author角色权限。  

**URL Parameters**:
- `institution_id`: 机构ID，必填。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
{
  "message": "机构关联已解除"
}
```

**Failed Response**:  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "权限不足"}`  
- **Code**: 404  
- **Content**: `{"message": "您未关联该机构"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 5. 专家关联机构

**URL**: `/api/institutions/expert/link`  
**Method**: `POST`  
**Description**: 专家用户关联机构信息。  
**Access**: 需要JWT认证，需要expert角色权限。  

**Request Body**:
```json
{
  "institution_id": 2
}
```

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
{
  "message": "机构关联成功"
}
```

**Failed Response**:  
- **Code**: 400  
- **Content**: `{"message": "请提供机构ID"}` 或 `{"message": "您已关联该机构"}`  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "权限不足"}`  
- **Code**: 404  
- **Content**: `{"message": "机构不存在"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 6. 专家解除机构关联

**URL**: `/api/institutions/expert/unlink/:institution_id`  
**Method**: `DELETE`  
**Description**: 专家用户解除与机构的关联。  
**Access**: 需要JWT认证，需要expert角色权限。  

**URL Parameters**:
- `institution_id`: 机构ID，必填。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
{
  "message": "机构关联已解除"
}
```

**Failed Response**:  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "权限不足"}`  
- **Code**: 404  
- **Content**: `{"message": "您未关联该机构"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 7. 获取用户关联的机构列表

**URL**: `/api/institutions/my`  
**Method**: `GET`  
**Description**: 获取当前登录用户关联的机构信息，或查询指定作者的机构信息。  
**Access**: 需要JWT认证。  

**URL Parameters**:
- `author_id`: (可选) 要查询的作者ID。如果提供，则查询指定作者的机构信息。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
[
  {
    "institution_id": 1,
    "name": "北京大学",
    "city": "北京",
    "zip_code": "100871"
  },
  {
    "institution_id": 3,
    "name": "浙江大学",
    "city": "杭州",
    "zip_code": "310027"
  }
]
```

**Failed Response**:  
- **Code**: 400  
- **Content**: `{"message": "无效的用户角色"}`  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

## 使用示例

### 搜索机构示例

**请求**:
```http
GET /api/institutions/search?name=北京
Authorization: Bearer your_jwt_token
```

**响应**:
```http
HTTP/1.1 200 OK
Content-Type: application/json

[
  {
    "institution_id": 1,
    "name": "北京大学",
    "city": "北京",
    "zip_code": "100871"
  },
  {
    "institution_id": 2,
    "name": "北京师范大学",
    "city": "北京",
    "zip_code": "100875"
  }
]
```

### 新增机构示例

**请求**:
```http
POST /api/institutions
Authorization: Bearer your_jwt_token
Content-Type: application/json

{
  "name": "浙江大学",
  "city": "杭州",
  "zip_code": "310027"
}
```

**响应**:
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "institution_id": 3,
  "name": "浙江大学",
  "city": "杭州",
  "zip_code": "310027"
}
```

### 作者关联机构示例

**请求**:
```http
POST /api/institutions/author/link
Authorization: Bearer your_jwt_token
Content-Type: application/json

{
  "institution_id": 1
}
```

**响应**:
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "message": "机构关联成功"
}
```

### 获取我的机构列表示例

**请求**:
```http
GET /api/institutions/my
Authorization: Bearer your_jwt_token
```

**响应**:
```http
HTTP/1.1 200 OK
Content-Type: application/json

[
  {
    "institution_id": 1,
    "name": "北京大学",
    "city": "北京",
    "zip_code": "100871"
  }
]
```