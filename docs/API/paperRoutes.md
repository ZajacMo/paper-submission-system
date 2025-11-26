
# API说明-论文管理模块

## 提交论文
- **URL**: `/api/papers`
- **Method**: `POST`
- **Description**: 作者提交论文
- **Request Body**: 
```json
{
  "title_zh": "string",
  "title_en": "string",
  "abstract_zh": "string",
  "abstract_en": "string",
  "keywords_zh": ["string"],
  "keywords_en": ["string"],
  "keywords_new":[{
    "name": "string",
    "type": "string" // "zh" or "en"
  }],
  "attachment_path": "string",
  "authors": ["number"],
  "institutions": ["string"],
  "is_corresponding": ["boolean"],
  "funds": ["string"],
  "funds_new":[{
    "name": "string",
    "number": "string"
  }]
}
```
- **Response**: `{"message": "string", "paper_id": "number"}`

## 获取论文列表
- **URL**: `/api/papers`
- **Method**: `GET`
- **Description**: 获取论文列表，支持分页、过滤和排序功能（根据用户角色返回不同范围的论文）
- **Authorization**: 需要 JWT 令牌
- **Query Parameters**:
  - `id` (number): 按论文ID精确搜索（优先，若有则不考虑其他）
  - `progress` (string): 按论文进度过滤
  - `search` (string): 搜索关键词，会在标题（中、英文）和摘要（中、英文）中进行模糊搜索（当指定了id参数时，此参数将被忽略）
  - `sortBy` (string): 排序字段，可选值：submission_date, title_zh, title_en, progress, status, status_read，默认值为 submission_date
  - `sortOrder` (string): 排序顺序，可选值：ASC, DESC，默认值为 DESC
  - `page` (number): 页码，默认为1
  - `pageSize` (number): 每页大小，默认为10
  - `status` (string): 论文状态过滤（仅编辑角色可用）
  - `status_read` (boolean): 论文状态已读标志过滤（仅编辑角色可用）
  - `conclusion` (string): 专家角色特有，按审稿结论过滤
  - `review_status` (string): 专家角色特有，按审稿状态过滤
  - `review_start_date` (string): 专家角色特有，按审稿提交开始日期过滤
  - `review_end_date` (string): 专家角色特有，按审稿提交结束日期过滤
- **Access Control**:
  - 作者：只能查看自己参与的论文（通过author_accessible_papers视图）
  - 编辑：可以查看所有论文
  - 专家：只能查看review_assignments表中与自己关联的论文
- **Response**: 
```json
{
  "items": [{
    "paper_id": "number", 
    "title_zh": "string", 
    "title_en": "string", 
    "abstract_zh": "string", 
    "abstract_en": "string", 
    "attachment_path": "string",
    "progress": "string",
    "integrity": "string",
    "check_time": "datetime",
    "submission_date": "datetime",
    "conclusion": "string",  // 仅专家角色返回
    "review_status": "string",  // 仅专家角色返回
    "review_submission_date": "datetime"  // 仅专家角色返回
  }],
  "total": "number",
  "page": "number",
  "pageSize": "number",
  "totalPages": "number"
}
```

## 获取论文详情
- **URL**: `/api/papers/:id`
- **Method**: `GET`
- **Description**: 获取论文详情
- **Response**: 
```json
{
  "paper_id": "number",
  "title_zh": "string",
  "title_en": "string",
  "abstract_zh": "string",
  "abstract_en": "string",
  "keywords_zh": ["string"],
  "keywords_en": ["string"],
  "submission_date": "datetime",
  "progress": "string",
  "integrity": "string",
  "check_time": "datetime",
  "authors": ["object"],
  "funds": ["object"],
  "reviewComments": ["object"],
  "totalAuthors": "number",
  "totalKeywords": "number",
  "totalFunds": "number",
  "hasReviewComments": "boolean",
  "reviewTimes": "number",
  "status": "string",
  "status_read": "boolean"
}
```

## 更新论文 
- **URL**: `/api/papers/:id`
- **Method**: `PUT`
- **Description**: 更新论文信息（作者只能更新部分字段，编辑/专家可更新更多字段）
- **Request Body**: 
```json
{
  "title_zh": "string",
  "title_en": "string",
  "abstract_zh": "string",
  "abstract_en": "string",
  "keywords_zh": ["string"],
  "keywords_en": ["string"],
  "keywords_new":[{
    "name": "string",
    "type": "string" // "zh" or "en"
  }],
  "attachment_path": "string",
  "authors": ["number"],
  "institutions": ["string"],
  "is_corresponding": ["boolean"],
  "funds": ["string"],
  "funds_new":[{
    "name": "string",
    "number": "string"
  }]
}
```
- **Response**: `{"message": "string"}`
  
## 论文完整性检查
- **URL**: `/api/papers/:id/integrity`
- **Method**: `PUT`
- **Description**: 编辑检查并更新论文的完整性状态
- **权限要求**: 仅编辑角色
- **Authorization**: 需要 JWT 令牌
- **Request Body**: 
```json
{
  "integrity": "string" // 有效值: 'True', 'False', 'Waiting'
}
```
- **Response**: 
```json
{
  "message": "论文完整性检查完成"
}
```
- **失败响应**:
  - 400: `{"message": "无效的完整性状态，有效状态为：True, False, Waiting"}`
  - 404: `{"message": "论文不存在"}`
  - 500: `{"message": "错误信息"}`

## 上传论文附件
- **URL**: `/api/papers/upload-attachment`
- **Method**: `POST`
- **Description**: 作者上传论文附件文件
- **权限要求**: 作者角色
- **请求参数**:
  - Header: `Authorization`: Bearer JWT令牌
  - Form Data: `attachment` (文件)
- **文件要求**:
  - 支持格式: 图片、文档、PDF、压缩文件
  - 最大文件大小: 50MB
- **文件命名规则**:
  系统自动生成唯一文件名，格式为：`attachment-{时间戳}-{随机数}.{原文件扩展名}`
  - 时间戳: 当前时间的毫秒数
  - 随机数: 0-10亿之间的随机整数
  - 扩展名: 保留原文件扩展名
- **成功响应**:
  ```json
  {
    "message": "文件上传成功",
    "file": {
      "filename": "文件名",
      "originalname": "原始文件名",
      "mimetype": "MIME类型",
      "size": "文件大小(字节)",
      "path": "文件相对路径"
    }
  }
  ```
- **失败响应**:
  - 400: `{"message": "文件类型不支持"}`或`{"message": "文件大小超过限制"}`
  - 401: `{"message": "未授权"}`
  - 500: `{"message": "文件上传失败"}`

## 附件路径验证
- **功能说明**: 提交或更新论文时，系统会对`attachment_path`参数进行以下验证：
  1. 路径格式检查: 确保附件路径以`uploads/`开头
  2. 文件存在性检查: 验证指定路径的文件是否实际存在
- **验证失败响应**:
  - 400: `{"message": "附件路径格式不正确，必须以uploads/开头"}`
  - 400: `{"message": "附件文件不存在，请先上传正确的附件"}`

## 旧附件自动删除
- **功能说明**: 更新论文并提供新附件时，系统会自动删除旧的附件文件，避免服务器存储空间浪费
- **触发条件**: 同时满足以下条件时执行删除操作：
  1. 论文原有附件路径（oldAttachmentPath）存在
  2. 提交了新的附件路径（attachment_path）
  3. 新旧附件路径不同（oldAttachmentPath !== attachment_path）
- **删除特性**: 即使删除旧附件失败，也不会影响论文更新的成功状态（错误会记录到日志中）

## 下载论文附件
- **URL**: `/api/papers/:id/download`
- **Method**: `GET`
- **Description**: 下载论文附件
- **权限要求**: 作者（只能下载自己参与的论文）、专家、编辑
- **请求参数**:
  - URL参数: `id` (论文ID)
  - Header: `Authorization`: Bearer JWT令牌
- **成功响应**:
  - 流式文件下载（Content-Disposition: attachment）
- **失败响应**:
  - 403: `{"message": "无权下载该论文附件"}`
  - 404: `{"message": "论文不存在"}`或`{"message": "附件不存在"}`
  - 500: `{"message": "文件下载失败"}`

## 获取论文审稿进度
- **URL**: `/api/papers/:id/progress`
- **Method**: `GET`
- **Description**: 获取指定论文的审稿进度信息，包括审稿专家信息、审稿状态等
- **权限要求**: 作者（只能查看自己参与的论文）、专家、编辑
- **请求参数**:
  - URL参数: `id` (论文ID)
  - Header: `Authorization`: Bearer JWT令牌
- **成功响应**:
  ```json
  {
    "paper_id": 1,
    "title_zh": "中文标题示例",
    "title_en": "English Title Example",
    "reviewers": [
      {
        "reviewer_id": 1,
        "fullname": "李四",
        "review_status": "completed",
        "review_date": "2023-07-10T14:20:00Z",
        "review_content": "这是一篇高质量的论文..."
      },
      {
        "reviewer_id": 2,
        "fullname": "王五",
        "review_status": "pending",
        "review_date": null,
        "review_content": null
      }
    ],
    "overall_progress": "partially_reviewed"
  }
  ```
- **失败响应**:
  - 403: `{"message": "无权访问该论文的审稿进度"}`
  - 404: `{"message": "未找到该论文的审稿进度"}`
  - 500: `{"message": "查询失败"}`

## 获取论文状态信息
- **URL**: `/api/papers/:id/status`
- **Method**: `GET`
- **Description**: 获取指定论文的状态信息，包括 status 和 status_read 字段
- **权限要求**: 作者（只能查看自己参与的论文）、专家、编辑
- **请求参数**:
  - URL参数: `id` (论文ID)
  - Header: `Authorization`: Bearer JWT令牌
- **成功响应**:
  ```json
  {
    "paper_id": 1,
    "status": "需要修改",
    "status_read": false
  }
  ```
- **失败响应**:
  - 403: `{"message": "无权查看该论文的状态"}`
  - 404: `{"message": "论文不存在"}`
  - 500: `{"message": "获取论文状态失败: 错误信息"}`

## 获取论文状态信息
- **URL**: `/api/papers/:id/status`
- **Method**: `GET`
- **Description**: 获取指定论文的状态信息，包括 status 和 status_read 字段
- **权限要求**: 作者（只能查看自己参与的论文）、专家、编辑
- **请求参数**:
  - URL参数: `id` (论文ID)
  - Header: `Authorization`: Bearer JWT令牌
- **成功响应**:
  ```json
  {
    "paper_id": "number",
    "status": "string",
    "status_read": "boolean"
  }
  ```
- **失败响应**:
  - 403: `{"message": "无权查看该论文的状态"}`
  - 404: `{"message": "论文不存在"}`
  - 500: `{"message": "查询失败"}`

## 获取作者所有论文的审稿进度
- **URL**: `/api/papers/progress`
- **Method**: `GET`
- **Description**: 获取当前作者所有论文的审稿进度列表
- **权限要求**: 仅作者角色
- **请求参数**:
  - Header: `Authorization`: Bearer JWT令牌
- **成功响应**:
  - 论文审稿进度对象数组，格式同"获取论文审稿进度"API的成功响应
  - 按提交时间（submission_time）倒序排列
- **失败响应**:
  - 401: `{"message": "未授权"}`
  - 500: `{"message": "查询失败"}`