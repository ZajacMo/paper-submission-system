# 论文投稿系统 API 文档

本文档汇总了论文投稿系统的所有API接口，按照功能模块进行组织。每个模块都包含完整的接口说明、请求参数、响应格式和权限要求等信息。

## 目录

- [论文投稿系统 API 文档](#论文投稿系统-api-文档)
  - [目录](#目录)
  - [模块功能说明](#模块功能说明)
    - [论文模块](#论文模块)
    - [审稿模块](#审稿模块)
    - [用户模块](#用户模块)
    - [基金模块](#基金模块)
    - [关键词模块](#关键词模块)
    - [认证模块](#认证模块)
    - [机构模块](#机构模块)
    - [通知模块](#通知模块)
    - [支付模块](#支付模块)
    - [日程模块](#日程模块)
  - [通用说明](#通用说明)
    - [认证方式](#认证方式)
    - [错误响应格式](#错误响应格式)
    - [角色说明](#角色说明)

## 模块功能说明
### 论文模块

论文模块包含以下API接口：

1. **获取论文列表** - `GET /api/papers`
2. **获取指定论文详情** - `GET /api/papers/:paperId`
3. **下载论文附件** - `GET /api/papers/:paperId/attachment/:attachmentId`
4. **上传论文附件** - `POST /api/papers/:paperId/attachment`
5. **创建论文** - `POST /api/papers`
6. **更新论文** - `PUT /api/papers/:paperId`
7. **更新论文完整性** - `PUT /api/papers/:paperId/completeness`
8. **获取指定论文的审稿进度** - `GET /api/papers/:paperId/review-progress`
9. **获取指定论文的状态信息** - `GET /api/papers/:paperId/status`

详细文档请参考：[paperRoutes.md](API/paperRoutes.md)

### 审稿模块

审稿模块包含以下API接口：

1. **专家获取审稿任务** - `GET /api/reviews/assignments`
2. **专家获取未读任务数量** - `GET /api/reviews/assignments/unread-count`
3. **编辑批量分配审稿任务** - `POST /api/reviews/assignments`
4. **专家标记任务为已读** - `PUT /api/reviews/assignments/:id/read`
5. **专家提交审稿意见** - `PUT /api/reviews/assignments/:id`
6. **获取论文审稿意见** - `GET /api/reviews/papers/:paperId/comments`
7. **编辑获取论文对应的所有审稿专家** - `GET /api/reviews/papers/:paperId/expert`

详细文档请参考：[reviewRoutes.md](API/reviewRoutes.md)

### 用户模块

用户模块包含以下API接口：

1. **获取当前用户信息** - `GET /api/users/profile`
2. **更新当前用户信息** - `PUT /api/users/profile`
3. **编辑获取所有作者列表** - `GET /api/users/authors`
4. **编辑获取所有专家列表** - `GET /api/users/experts`
5. **搜索专家API** - `GET /api/users/search-experts`
6. **根据作者ID或姓名查询作者** - `GET /api/users/search`

详细文档请参考：[userRoutes.md](API/userRoutes.md)

### 基金模块

基金模块包含以下API接口：

1. **作者创建基金** - `POST /api/funds`
2. **作者查询自己的所有基金** - `GET /api/funds`
3. **作者搜索基金** - `GET /api/funds/search`
4. **作者查询特定基金详情** - `GET /api/funds/:fundId`

详细文档请参考：[fundRoutes.md](API/fundRoutes.md)

### 关键词模块

关键词模块包含以下API接口：

1. **获取所有关键词列表** - `GET /api/keywords`
2. **添加新关键词** - `POST /api/keywords`
3. **更新关键词** - `PUT /api/keywords/:id`
4. **删除关键词** - `DELETE /api/keywords/:id`
5. **搜索关键词** - `GET /api/keywords/search`
6. **搜索中文关键词** - `GET /api/keywords/search/zh`
7. **搜索英文关键词** - `GET /api/keywords/search/en`
8. **关联论文与关键词** - `POST /api/keywords/papers/:paperId/associate`

详细文档请参考：[keywordRoutes.md](API/keywordRoutes.md)

### 认证模块

认证模块包含以下API接口：

1. **用户登录** - `POST /api/auth/login`
2. **检查令牌有效性** - `GET /api/auth/check-auth`

详细文档请参考：[authRoutes.md](API/authRoutes.md)

### 机构模块

机构模块包含以下API接口：

1. **搜索机构** - `GET /api/institutions/search`
2. **新增机构信息** - `POST /api/institutions`
3. **作者关联机构** - `POST /api/institutions/author/link`
4. **作者解除机构关联** - `DELETE /api/institutions/author/unlink/:institution_id`
5. **专家关联机构** - `POST /api/institutions/expert/link`
6. **专家解除机构关联** - `DELETE /api/institutions/expert/unlink/:institution_id`
7. **获取当前用户关联的机构** - `GET /api/institutions/my`

详细文档请参考：[institutionRoutes.md](API/institutionRoutes.md)

### 通知模块

通知模块包含以下API接口：

1. **作者拉取自己的通知** - `GET /api/notifications/author`
2. **编辑发送通知给作者** - `POST /api/notifications/author`
3. **标记通知为已读** - `PUT /api/notifications/:id/read`
4. **获取未读通知数量** - `GET /api/notifications/unread-count`

详细文档请参考：[notificationRoutes.md](API/notificationRoutes.md)

### 支付模块

支付模块包含以下API接口：

1. **获取论文的支付信息** - `GET /api/payments/papers/:paperId`
2. **作者支付审稿费** - `POST /api/payments/author/pay`
3. **创建支付记录（编辑）** - `POST /api/payments`
4. **更新支付状态（编辑）** - `PUT /api/payments/:id/status`
5. **专家申请提现** - `POST /api/payments/withdrawals`
6. **专家查看提现记录** - `GET /api/payments/withdrawals`
7. **编辑更新提现状态** - `PUT /api/payments/withdrawals/:assignment_id/status`
8. **编辑查看所有提现记录** - `GET /api/payments/admin/withdrawals`

详细文档请参考：[paymentRoutes.md](API/paymentRoutes.md)

### 日程模块

日程模块包含以下API接口：

1. **编辑执行论文排期操作** - `POST /api/schedules`
2. **编辑获取所有排期记录** - `GET /api/schedules`
3. **编辑获取单篇论文的排期记录** - `GET /api/schedules/papers/:id`
4. **作者获取自己论文的排期记录** - `GET /api/schedules/author/papers/:id`
5. **编辑更新论文排期信息** - `PUT /api/schedules/:id`

详细文档请参考：[scheduleRoutes.md](API/scheduleRoutes.md)


## 通用说明

### 认证方式

所有API接口均需要JWT认证，认证信息通过HTTP请求头中的`Authorization`字段传递，格式为：

```
Authorization: Bearer your_jwt_token
```

### 错误响应格式

大多数错误响应遵循以下格式：

```json
{
  "message": "错误描述信息"
}
```

### 角色说明

系统用户分为三种角色：

- **author**: 作者，可提交论文、管理基金等
- **expert**: 专家，可进行论文审稿
- **editor**: 编辑，可管理用户、分配审稿任务等

各接口的具体权限要求请参考对应模块的详细文档。