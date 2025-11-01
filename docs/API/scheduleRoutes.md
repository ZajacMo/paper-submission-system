# 排期管理模块

## 创建论文排期
- **URL**: `/api/schedules`
- **Method**: `POST`
- **Description**: 编辑为论文创建排期
- **Request Body**: `{"paper_id": "number", "issue_number": "string", "volume_number": "string", "page_number": "string"}`
- **Response**: `{"message": "string", "schedule_id": "number"}`

## 获取排期列表
- **URL**: `/api/schedules`
- **Method**: `GET`
- **Description**: 编辑获取所有论文排期列表
- **Response**: `[{"schedule_id": "number", "paper_id": "number", "issue_number": "string", "volume_number": "string", "page_number": "string", "title_zh": "string", "title_en": "string"}]`

## 编辑获取单篇论文排期
- **URL**: `/api/schedules/papers/:id`
- **Method**: `GET`
- **Description**: 编辑获取指定论文的排期详情
- **Response**: `{"schedule_id": "number", "paper_id": "number", "issue_number": "string", "volume_number": "string", "page_number": "string", "title_zh": "string", "title_en": "string"}`

## 作者获取自己论文排期
- **URL**: `/api/schedules/author/papers/:id`
- **Method**: `GET`
- **Description**: 作者获取自己论文的排期详情
- **权限**: 仅作者角色，且只能查看自己论文的排期
- **成功响应** (200): 
```json
{
  "schedule_id": "number",
  "paper_id": "number",
  "issue_number": "string",
  "volume_number": "string",
  "page_number": "string",
  "title_zh": "string",
  "title_en": "string"
}
```
- **错误响应**:
  - 403: `{"message": "您不是该论文的作者，无权查看排期信息"}`
  - 404: `{"message": "未找到该论文的排期记录"}`
  - 500: `{"message": "错误信息"}`

## 更新论文排期
- **URL**: `/api/schedules/:id`
- **Method**: `PUT`
- **Description**: 编辑更新论文排期
- **Request Body**: `{"issue_number": "string", "volume_number": "string", "page_number": "string"}`
- **Response**: `{"message": "string"}`

## 删除论文排期
- **URL**: `/api/schedules/:id`
- **Method**: `DELETE`
- **Description**: 编辑删除论文排期
- **Response**: `{"message": "string"}`