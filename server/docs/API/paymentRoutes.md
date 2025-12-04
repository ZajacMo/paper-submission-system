# API说明 - 支付模块

本文档详细描述支付模块的所有API接口，包括请求参数、响应格式和权限要求等信息。

## 接口列表

### 1. 获取论文的支付信息

**URL**: `/api/payments/papers/:paperId`  
**Method**: `GET`  
**Description**: 获取指定论文的支付信息，作者只能查看自己参与的论文。  
**Access**: 需要JWT认证。  

**URL Parameters**:
- `paperId`: 论文ID。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
[
  {
    "payment_id": 1,
    "paper_id": 1,
    "amount": 1000,
    "status": "Pending",
    "payment_date": null
  }
]
```

**Failed Response**:  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "无权查看该论文的支付信息"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 2. 作者支付审稿费

**URL**: `/api/payments/author/pay`  
**Method**: `POST`  
**Description**: 作者为自己的论文支付审稿费。  
**Access**: 需要JWT认证，需要author角色权限。  

**Request Body**:
```json
{
  "paper_id": 1
}
```

**Success Response**:  
- **Code**: 201  
- **Content**:  
```json
{
  "message": "支付申请提交成功",
  "paper_id": 1,
  "payment_id": 1
}
```

**Failed Response**:  
- **Code**: 400  
- **Content**: `{"message": "论文ID是必需的"}` 或 `{"message": "该论文未创建支付记录"}`  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "您不是该论文的作者，无权支付"}`  
- **Code**: 404  
- **Content**: `{"message": "论文不存在"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}` 或 `{"message": "更新支付记录失败"}`

### 3. 创建支付记录（编辑）

**URL**: `/api/payments`  
**Method**: `POST`  
**Description**: 编辑为论文创建支付记录。  
**Access**: 需要JWT认证，需要editor角色权限。  

**Request Body**:
```json
{
  "paper_id": 1,
  "amount": 1000
}
```

**Success Response**:  
- **Code**: 201  
- **Content**:  
```json
{
  "message": "支付记录创建成功",
  "paper_id": 1
}
```

**Failed Response**:  
- **Code**: 400  
- **Content**: `{"message": "该论文已有支付记录"}`  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "权限不足"}`  
- **Code**: 404  
- **Content**: `{"message": "论文不存在"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 4. 更新支付状态（编辑）

**URL**: `/api/payments/:id/status`  
**Method**: `PUT`  
**Description**: 编辑更新支付记录的状态。  
**Access**: 需要JWT认证，需要editor角色权限。  

**URL Parameters**:
- `id`: 支付记录ID。  

**Request Body**:
```json
{
  "status": "Paid"
}
```

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
{
  "message": "支付状态更新成功"
}
```

**Failed Response**:  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "权限不足"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 5. 专家创建提现申请

**URL**: `/api/payments/withdrawals`  
**Method**: `POST`  
**Description**: 专家提交审稿费用的提现申请。  
**Access**: 需要JWT认证，需要expert角色权限。  

**Request Body**:
```json
{
  "assignment_id": 1
}
```

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
{
  "message": "提现申请提交成功",
  "assignment_id": 1
}
```

**Failed Response**:  
- **Code**: 400  
- **Content**: `{"message": "assignment_id是必需的"}` 或 `{"message": "该任务的提现申请已提交"}` 或 `{"message": "请先完善银行账户信息"}`  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "权限不足"}`  
- **Code**: 404  
- **Content**: `{"message": "该审稿任务不存在或未完成"}` 或 `{"message": "专家信息不存在"}` 或 `{"message": "未找到可提现的记录"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 6. 专家获取提现记录

**URL**: `/api/payments/withdrawals`  
**Method**: `GET`  
**Description**: 获取当前登录专家的所有提现记录。  
**Access**: 需要JWT认证，需要expert角色权限。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
[
  {
    "withdrawal_id": 1,
    "expert_id": 1,
    "assignment_id": 1,
    "status": 1,
    "withdrawal_date": "2023-06-10T10:00:00Z",
    "paper_id": 1,
    "paper_title_zh": "论文标题",
    "paper_title_en": "Paper Title",
    "amount": 500
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

### 7. 编辑处理提现申请

**URL**: `/api/payments/withdrawals/:assignment_id/status`  
**Method**: `PUT`  
**Description**: 编辑处理专家的提现申请，更新提现状态。  
**Access**: 需要JWT认证，需要editor角色权限。  

**URL Parameters**:
- `assignment_id`: 审稿任务ID。  

**Request Body**:
```json
{
  "status": true
}
```

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
{
  "message": "提现状态更新成功"
}
```

**Failed Response**:  
- **Code**: 400  
- **Content**: `{"message": "状态必须是布尔值"}`  
- **Code**: 401  
- **Content**: `{"message": "未授权访问"}`  
- **Code**: 403  
- **Content**: `{"message": "权限不足"}`  
- **Code**: 404  
- **Content**: `{"message": "提现记录不存在"}`  
- **Code**: 500  
- **Content**: `{"message": "服务器错误信息"}`

### 8. 编辑获取所有提现记录（分页）

**URL**: `/api/payments/admin/withdrawals`  
**Method**: `GET`  
**Description**: 编辑获取所有专家的提现记录，支持分页。  
**Access**: 需要JWT认证，需要editor角色权限。  

**URL Parameters**:
- `page` (可选): 页码，默认1。  
- `limit` (可选): 每页数量，默认10。  

**Success Response**:  
- **Code**: 200  
- **Content**:  
```json
{
  "data": [
    {
      "withdrawal_id": 1,
      "expert_id": 1,
      "assignment_id": 1,
      "status": 1,
      "withdrawal_date": "2023-06-10T10:00:00Z",
      "expert_name": "李四",
      "bank_account": "6228 **** **** 1234",
      "bank_name": "建设银行",
      "account_holder": "李四",
      "paper_id": 1,
      "paper_title_zh": "论文标题",
      "paper_title_en": "Paper Title",
      "amount": 500
    }
  ],
  "pagination": {
    "currentPage": 1,
    "pageSize": 10,
    "totalItems": 25,
    "totalPages": 3
  }
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

### 编辑创建支付记录示例

**请求**:
```http
POST /api/payments
Authorization: Bearer your_jwt_token
Content-Type: application/json

{
  "paper_id": 1,
  "amount": 1000
}
```

**响应**:
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "message": "支付记录创建成功",
  "paper_id": 1
}
```

### 作者支付审稿费示例

**请求**:
```http
POST /api/payments/author/pay
Authorization: Bearer your_jwt_token
Content-Type: application/json

{
  "paper_id": 1
}
```

**响应**:
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "message": "支付申请提交成功",
  "paper_id": 1,
  "payment_id": 1
}
```

### 专家提交提现申请示例

**请求**:
```http
POST /api/payments/withdrawals
Authorization: Bearer your_jwt_token
Content-Type: application/json

{
  "assignment_id": 1
}
```

**响应**:
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "message": "提现申请提交成功",
  "assignment_id": 1
}
```

### 编辑获取提现记录示例

**请求**:
```http
GET /api/payments/admin/withdrawals?page=1&limit=10
Authorization: Bearer your_jwt_token
```

**响应**:
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "data": [
    {
      "withdrawal_id": 1,
      "expert_id": 1,
      "assignment_id": 1,
      "status": 1,
      "withdrawal_date": "2023-06-10T10:00:00Z",
      "expert_name": "李四",
      "bank_account": "6228 **** **** 1234",
      "bank_name": "建设银行",
      "account_holder": "李四",
      "paper_id": 1,
      "paper_title_zh": "论文标题",
      "paper_title_en": "Paper Title",
      "amount": 500
    }
  ],
  "pagination": {
    "currentPage": 1,
    "pageSize": 10,
    "totalItems": 25,
    "totalPages": 3
  }
}
```