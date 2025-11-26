# 支付管理模块

## 创建支付记录
- **URL**: `/api/payments`
- **Method**: `POST`
- **Description**: 创建支付记录（用于作者支付审稿费）
- **Request Body**: 
```json
{
    "paper_id": "number", 
    "amount": "number"
}
```
- **Response**: 
```json
{
    "message": "string"
}
```

## 获取论文支付信息
- **URL**: `/api/payments/papers/:paperId`
- **Method**: `GET`
- **Description**: 作者获取自己论文的支付状态信息
- **权限**: 所有已登录用户，但作者只能查看自己论文的支付信息
- **成功响应** (200): 
```json
[
  {
    "payment_id": "number",
    "paper_id": "number",
    "amount": "number",
    "status": "string",
    "payment_date": "datetime"
  }
]
```
- **错误响应**:
  - 401: `{"message": "未授权"}`
  - 403: `{"message": "无权查看该论文的支付信息"}`
  - 500: `{"message": "错误信息"}`

## 作者支付审稿费
- **URL**: `/api/payments/author/pay`
- **Method**: `POST`
- **Description**: 作者为自己的论文更新支付状态为Pending（仅更新已存在且状态为Paid的支付记录）
- **权限**: 仅作者角色
- **Request Body**: 
```json
{
  "paper_id": "number"
}
```
- **成功响应** (201): 
```json
{
  "message": "支付申请提交成功",
  "paper_id": "number",
  "payment_id": "number"
}
```
- **错误响应**:
  - 400: `{"message": "论文ID是必需的"}` 或 `{"message": "该论文未创建支付记录"}`
  - 403: `{"message": "您不是该论文的作者，无权支付"}`
  - 404: `{"message": "论文不存在"}`
  - 500: `{"message": "错误信息"}` 或 `{"message": "更新支付记录失败"}`

## 更新支付状态
- **URL**: `/api/payments/:id/status`
- **Method**: `PUT`
- **Description**: 更新支付状态（编辑使用）
- **Request Body**: 
```json
{
    "status": "Paid/Pending"
}
```
- **Response**: 
```json
{
    "message": "string"
}
```

## 提现申请
- **URL**: `/api/payments/withdrawals`
- **Method**: `POST`
- **Description**: 专家提交审稿任务的提现申请
- **Request Body**: 
```json
{
    "assignment_id": "number"
}
```
- **成功响应** (200): 
```json
{
    "message": "string", 
    "assignment_id": "number"
}
```
- **错误响应**:
  - 400: `{"message": "assignment_id是必需的"}` 或 `{"message": "该任务的提现申请已提交"}` 或 `{"message": "请先完善银行账户信息"}`
  - 404: `{"message": "该审稿任务不存在或未完成"}` 或 `{"message": "专家信息不存在"}` 或 `{"message": "未找到可提现的记录"}`
  - 500: `{"message": "错误信息"}`

## 获取专家提现记录
- **URL**: `/api/payments/withdrawals`
- **Method**: `GET`
- **Description**: 专家获取自己的提现记录
- **成功响应** (200): 
```json
[{
  "assignment_id": "number", 
  "expert_id": "number", 
  "status": "boolean", 
  "withdrawal_date": "datetime", 
  "paper_id": "number", 
  "paper_title_zh": "string", 
  "paper_title_en": "string", 
  "amount": "number"
}]
```
- **错误响应**:
  - 401: `{"message": "未授权"}`
  - 500: `{"message": "查询失败"}`

## 处理提现申请
- **URL**: `/api/payments/withdrawals/:assignment_id/status`
- **Method**: `PUT`
- **Description**: 编辑处理专家的提现申请
- **Request Body**: `{"status": "boolean"}`
- **Response**: `{"message": "string"}`

## 获取所有提现记录（分页）
- **URL**: `/api/payments/admin/withdrawals`
- **Method**: `GET`
- **Description**: 编辑获取所有提现记录，支持分页
- **URL参数**: 
  - `page` (可选): 页码，默认为1
  - `limit` (可选): 每页记录数，默认为10
- **成功响应** (200): 
  ```json
  {
    "data": [
      {
        "assignment_id": "number", 
        "expert_name": "string", 
        "paper_id": "number", 
        "paper_title_zh": "string", 
        "paper_title_en": "string", 
        "amount": "number", 
        "status": "boolean", 
        "withdrawal_date": "datetime", 
        "bank_account": "string", 
        "bank_name": "string", 
        "account_holder": "string"
      }
    ],
    "pagination": {
      "currentPage": "number",
      "pageSize": "number",
      "totalItems": "number",
      "totalPages": "number"
    }
  }
  ```
- **错误响应**:
  - 401: `{"message": "未授权"}`
  - 500: `{"message": "查询失败"}`