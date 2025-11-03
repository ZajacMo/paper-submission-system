# 审稿管理模块

## 获取专家的审稿任务列表
- **URL**: `/api/reviews/assignments`
- **Method**: `GET`
- **Description**: 获取分配给当前登录专家的所有审稿任务
- **权限**: 仅限专家角色
- **Response**: 
```json
[{"assignment_id": "number", 
   "paper_id": "number", 
   "expert_id": "number", 
   "editor_id": "number", 
   "assigned_date": "datetime", 
   "assigned_due_date": "datetime", 
   "status": "string", 
   "conclusion": "string", 
   "title_zh": "string", 
   "title_en": "string"
}]
```
- **失败响应**:
  - 401: `{"message": "未授权"}`
  - 403: `{"message": "无权访问该资源"}`
  - 500: `{"message": "查询失败"}`

## 分配审稿任务
- **URL**: `/api/reviews/assignments`
- **Method**: `POST`
- **Description**: 编辑分配审稿任务给专家，并生成评审任务书
- **权限**: 仅限编辑角色
- **Request Body**: 
```json
{"paper_id": "number", 
   "expert_id": "number", 
   "assigned_due_date": "datetime"
}
```
- **Response**: 
```json
{"message": "string", 
   "assignment_id": "number", 
   "assignment_content": "string"
}
```
- **失败响应**:
  - 400: `{"message": "缺少必要的任务分配信息"}`
  - 401: `{"message": "未授权"}`
  - 403: `{"message": "无权分配审稿任务"}`
  - 404: `{"message": "论文不存在"}` 或 `{"message": "专家不存在"}` 或 `{"message": "编辑信息不存在"}`
  - 500: `{"message": "分配失败"}`

## 提交审稿意见
- **URL**: `/api/reviews/assignments/:id`
- **Method**: `PUT`
- **Description**: 专家提交审稿意见
- **权限**: 仅限专家角色
- **Request Body**: 
```json
{"conclusion": "string", 
   "positive_comments": "string", 
   "negative_comments": "string", 
   "modification_advice": "string"
}
```
- **Response**: 
```json
{"message": "string"}
```
- **失败响应**:
  - 401: `{"message": "未授权"}`
  - 403: `{"message": "无权处理该审稿任务"}`
  - 500: `{"message": "提交失败"}`

## 获取论文的所有审稿意见
- **URL**: `/api/reviews/papers/:paperId/comments`
- **Method**: `GET`
- **Description**: 获取指定论文的所有已完成的审稿意见（编辑可查看所有，作者只能查看自己论文的）
- **权限**: 已认证用户
- **Response**: 
```json
[{"assignment_id": "number",
   "paper_id": "number", 
   "expert_id": "number", 
   "editor_id": "number", 
   "assigned_date": "datetime", 
   "assigned_due_date": "datetime", 
   "status": "string", 
   "conclusion": "string", 
   "positive_comments": "string", 
   "negative_comments": "string", 
   "modification_advice": "string", 
   "submission_date": "datetime", 
   "expert_name": "string"
}]
```
- **失败响应**:
  - 401: `{"message": "未授权"}`
  - 403: `{"message": "无权查看该论文的审稿意见"}`
  - 500: `{"message": "查询失败"}`