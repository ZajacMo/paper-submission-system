# 审稿管理模块

## 获取专家的审稿任务
- **URL**: `/api/reviews/assignments`
- **Method**: `GET`
- **Description**: 获取分配给当前登录专家的所有审稿任务
- **权限**: 仅专家角色可访问
- **Response**: 
  ```json
  [
    {
      "assignment_id": "number",
      "paper_id": "number",
      "expert_id": "number",
      "editor_id": "number",
      "assigned_date": "datetime",
      "assigned_due_date": "date",
      "submission_date": "datetime",
      "conclusion": "string",
      "status": "string",
      "title_zh": "string",
      "title_en": "string",
      "is_read": "boolean"
    }
  ]
  ```
- **失败响应**:
  - 401: `{"message": "未授权"}`
  - 403: `{"message": "权限不足"}`
  - 500: `{"message": "查询失败"}`

## 获取专家的未读任务数量
- **URL**: `/api/reviews/assignments/unread-count`
- **Method**: `GET`
- **Description**: 获取当前登录专家的未读审稿任务数量（状态为Assigned的任务）
- **权限**: 仅专家角色可访问
- **Response**: 
  ```json
  {
    "unread_count": "number"
  }
  ```
- **失败响应**:
  - 401: `{"message": "未授权"}`
  - 403: `{"message": "权限不足"}`
  - 500: `{"message": "查询失败"}`

## 专家标记审稿任务为已读
- **URL**: `/api/reviews/assignments/:id/read`
- **Method**: `PUT`
- **Description**: 将指定的审稿任务标记为已读
- **权限**: 仅专家角色可访问，且只能标记分配给自己的任务
- **Response**: `{"message": "任务已标记为已读"}`
- **失败响应**:
  - 401: `{"message": "未授权"}`
  - 403: `{"message": "无权处理该审稿任务"}`
  - 500: `{"message": "标记失败"}`

## 编辑批量分配审稿任务
- **URL**: `/api/reviews/assignments`
- **Method**: `POST`
- **Description**: 编辑批量分配审稿任务给专家，一次最多分配3条
- **权限**: 仅编辑角色可访问
- **Request Body**:
```json
[
  {
    "paper_id": "number",
    "expert_id": "number",
    "assigned_due_date": "date"
  }
]
```
- **Response**:
```json
{
  "message": "string",
  "created_assignments": [
    {
      "paper_id": "number",
      "expert_id": "number",
      "assignment_id": "number"
    }
  ]
}
```
- **失败响应**:
  - 400: `{"message": "请求体必须是任务分配数组"} 或 {"message": "任务分配数组必须包含1-3条记录"} 或 {"message": "数组中存在缺少必要信息的任务"} 或 {"message": "专家ID X 已经被分配到论文ID Y"}`
  - 400: `{"message": "缺少必要的任务分配信息"}`
  - 401: `{"message": "未授权"}`
  - 403: `{"message": "权限不足"}`
  - 404: `{"message": "论文ID X 不存在"} 或 {"message": "专家ID X 不存在"} 或 {"message": "编辑信息不存在"}`
  - 500: `{"message": "分配失败"}`

## 专家提交审稿意见
- **URL**: `/api/reviews/assignments/:id`
- **Method**: `PUT`
- **Description**: 专家提交审稿意见
- **权限**: 仅专家角色可访问，且只能提交分配给自己的任务
- **Request Body**: `{"conclusion": "string", "positive_comments": "string", "negative_comments": "string", "modification_advice": "string"}`
- **Response**: `{"message": "string"}`
- **失败响应**:
  - 401: `{"message": "未授权"}`
  - 403: `{"message": "无权处理该审稿任务"}`
  - 500: `{"message": "提交失败"}`

## 获取论文的审稿意见
- **URL**: `/api/reviews/papers/:paperId/comments`
- **Method**: `GET`
- **Description**: 获取论文的所有已完成审稿意见
- **权限**: 编辑可查看所有论文，作者只能查看自己的论文
- **Response**: 
  ```json
  [
    {
      "assignment_id": "number",
      "paper_id": "number",
      "expert_id": "number",
      "editor_id": "number",
      "assigned_date": "datetime",
      "assigned_due_date": "date",
      "submission_date": "datetime",
      "conclusion": "string",
      "positive_comments": "string",
      "negative_comments": "string",
      "modification_advice": "string",
      "status": "string",
      "expert_name": "string"
    }
  ]
  ```
- **失败响应**:
  - 401: `{"message": "未授权"}`
  - 403: `{"message": "无权查看该论文的审稿意见"}`
  - 500: `{"message": "查询失败"}`

## 编辑获取论文对应的所有审稿专家
- **URL**: `/api/reviews/papers/:paperId/expert`
- **Method**: `GET`
- **Description**: 获取指定论文的所有审稿专家分配记录，并根据论文状态返回是否可编辑
- **权限**: 仅编辑角色可访问
- **Response**: 
  ```json
  {
    "experts": [
      {
        "assignment_id": "number",
        "paper_id": "number",
        "expert_id": "number",
        "editor_id": "number",
        "assigned_date": "datetime",
        "assigned_due_date": "date",
        "submission_date": "datetime",
        "conclusion": "string",
        "positive_comments": "string",
        "negative_comments": "string",
        "modification_advice": "string",
        "status": "string",
        "expert_name": "string",
        "institution": "string",
        "research_areas": "string"
      }
    ],
    "editable": "boolean"
  }
  ```
- **失败响应**:
  - 401: `{"message": "未授权"}`
  - 403: `{"message": "权限不足"}`
  - 404: `{"message": "论文不存在"}`
  - 500: `{"message": "查询失败"}`
