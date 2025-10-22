# 用户管理模块

## 根据输入的作者ID或姓名查询作者
- **URL**: `/api/users/search`
- **Method**: `GET`
- **Description**: 根据输入的作者ID或姓名模糊查询作者信息，支持部分匹配
- **Authorization**: 需要 JWT 令牌
- **Access Control**: 需要 author 角色权限
- **Query Parameters**: `query` (作者ID或姓名)
- **Success Response**: `[{"author_id": "number", "name": "string"}, ...]` (作者列表)
- **Error Response**: `{"message": "请输入作者ID或姓名"}` (400), `{"message": "作者不存在"}` (404), `{"message": "错误信息"}` (500)

## 获取个人信息
- **URL**: `/api/users/profile`
- **Method**: `GET`
- **Description**: 获取当前登录用户的个人信息
- **Authorization**: 需要 JWT 令牌
- **Success Response**:
  - 作者角色: 
    ```json
    {
      "author_id": "number",
      "name": "string",
      "email": "string",
      "phone": "string",
      "age": "number",
      "degree": "string",
      "title": "string",
      "hometown": "string",
      "research_areas": "string",
      "bio": "string",
      "institutions": [{"institution_id": "number", "name": "string", ...}]
    }
    ```
  - 专家角色: 
    ```json
    {
      "expert_id": "number",
      "name": "string",
      "email": "string",
      "phone": "string",
      "title": "string",
      "research_areas": "string",
      "review_fee": "number",
      "bank_account": "string",
      "bank_name": "string",
      "account_holder": "string",
      "institutions": [{"institution_id": "number", "name": "string", ...}]
    }
    ```
  - 编辑角色: 
    ```json
    {
      "editor_id": "number",
      "name": "string",
      "email": "string",
      "institutions": []
    }
    ```
- **Error Response**: `{"message": "用户不存在"}` (404), `{"message": "无效的用户角色"}` (400), `{"message": "错误信息"}` (500)

## 更新个人信息
- **URL**: `/api/users/profile`
- **Method**: `PUT`
- **Description**: 更新当前登录用户的个人信息
- **Authorization**: 需要 JWT 令牌
- **Request Body**:
  - 作者角色: 
    ```json
    {
      "name": "string",
      "email": "string",
      "phone": "string",
      "age": "number",
      "degree": "string",
      "title": "string",
      "hometown": "string",
      "research_areas": "string",
      "bio": "string"
    }
    ```
  - 专家角色: 
    ```json
    {
      "name": "string",
      "email": "string",
      "phone": "string",
      "title": "string",
      "research_areas": "string",
      "review_fee": "number",
      "bank_account": "string",
      "bank_name": "string",
      "account_holder": "string"
    }
    ```
  - 编辑角色: 
    ```json
    {
      "name": "string",
      "email": "string"
    }
    ```
- **Success Response**: `{"message": "用户信息更新成功"}`
- **Error Response**: `{"message": "用户不存在"}` (404), `{"message": "无效的用户角色"}` (400), `{"message": "错误信息"}` (500)

## 编辑获取所有作者列表
- **URL**: `/api/users/authors`
- **Method**: `GET`
- **Description**: 编辑角色获取系统中所有作者的列表
- **Authorization**: 需要 JWT 令牌
- **Access Control**: 需要 editor 角色权限
- **Success Response**: `[{"author_id": "number", "name": "string", "email": "string", ...}, ...]` (作者列表)
- **Error Response**: `{"message": "错误信息"}` (500)

## 编辑获取所有专家列表
- **URL**: `/api/users/experts`
- **Method**: `GET`
- **Description**: 编辑角色获取系统中所有专家的列表
- **Authorization**: 需要 JWT 令牌
- **Access Control**: 需要 editor 角色权限
- **Success Response**: `[{"expert_id": "number", "name": "string", "email": "string", ...}, ...]` (专家列表)
- **Error Response**: `{"message": "错误信息"}` (500)