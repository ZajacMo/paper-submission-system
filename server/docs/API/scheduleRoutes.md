# 时间安排模块 API 文档

本文档详细描述了论文提交系统中时间安排模块的API接口。

## 接口列表

### 1. 编辑执行论文排期操作

#### URL: `/api/schedules`
#### Method: `POST`
#### Description: 编辑为论文添加排期信息，包括期号、卷号和页码
#### Access: 仅编辑（editor）角色可访问

#### 请求参数

| 字段 | 类型 | 必填 | 描述 |
| --- | --- | --- | --- |
| paper_id | Integer | 是 | 论文ID |
| issue_number | String | 是 | 期号 |
| volume_number | String | 是 | 卷号 |
| page_number | String | 是 | 页码 |

#### 响应格式

成功:
```json
{
  "message": "论文排期成功",
  "schedule_id": 1
}
```

失败:
- `400 Bad Request`: 缺少必要的排期信息 或 该论文已有排期记录
- `404 Not Found`: 论文不存在
- `500 Internal Server Error`: 服务器错误

### 2. 编辑获取所有排期记录

#### URL: `/api/schedules`
#### Method: `GET`
#### Description: 获取系统中所有论文的排期记录列表
#### Access: 仅编辑（editor）角色可访问

#### 响应格式

成功:
```json
[
  {
    "schedule_id": 1,
    "paper_id": 1,
    "issue_number": "2023-01",
    "volume_number": "12",
    "page_number": "1-10",
    "title_zh": "中文标题",
    "title_en": "English Title"
  },
  ...
]
```

失败:
- `500 Internal Server Error`: 服务器错误

### 3. 编辑获取单篇论文的排期记录

#### URL: `/api/schedules/papers/:id`
#### Method: `GET`
#### Description: 获取指定论文的排期记录
#### Access: 仅编辑（editor）角色可访问

#### 路径参数

| 字段 | 类型 | 描述 |
| --- | --- | --- |
| id | Integer | 论文ID |

#### 响应格式

成功:
```json
{
  "schedule_id": 1,
  "paper_id": 1,
  "issue_number": "2023-01",
  "volume_number": "12",
  "page_number": "1-10",
  "title_zh": "中文标题",
  "title_en": "English Title"
}
```

失败:
- `404 Not Found`: 未找到该论文的排期记录
- `500 Internal Server Error`: 服务器错误

### 4. 作者获取自己论文的排期记录

#### URL: `/api/schedules/author/papers/:id`
#### Method: `GET`
#### Description: 作者获取自己提交的论文的排期记录
#### Access: 仅作者（author）角色可访问，且只能查看自己的论文

#### 路径参数

| 字段 | 类型 | 描述 |
| --- | --- | --- |
| id | Integer | 论文ID |

#### 响应格式

成功:
```json
{
  "schedule_id": 1,
  "paper_id": 1,
  "issue_number": "2023-01",
  "volume_number": "12",
  "page_number": "1-10",
  "title_zh": "中文标题",
  "title_en": "English Title"
}
```

失败:
- `403 Forbidden`: 您不是该论文的作者，无权查看排期信息
- `404 Not Found`: 未找到该论文的排期记录
- `500 Internal Server Error`: 服务器错误

### 5. 编辑更新排期记录

#### URL: `/api/schedules/:id`
#### Method: `PUT`
#### Description: 编辑更新论文的排期信息
#### Access: 仅编辑（editor）角色可访问

#### 路径参数

| 字段 | 类型 | 描述 |
| --- | --- | --- |
| id | Integer | 排期记录ID |

#### 请求参数

| 字段 | 类型 | 必填 | 描述 |
| --- | --- | --- | --- |
| issue_number | String | 否 | 期号 |
| volume_number | String | 否 | 卷号 |
| page_number | String | 否 | 页码 |

**注意**：至少需要提供一个字段进行更新

#### 响应格式

成功:
```json
{
  "message": "排期记录更新成功"
}
```

失败:
- `400 Bad Request`: 至少需要更新一个排期字段
- `404 Not Found`: 排期记录不存在
- `500 Internal Server Error`: 服务器错误

## 使用示例

### 1. 编辑为论文添加排期

```javascript
// 请求示例
fetch('/api/schedules', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer {token}'
  },
  body: JSON.stringify({
    paper_id: 1,
    issue_number: "2023-01",
    volume_number: "12",
    page_number: "1-10"
  })
})
.then(response => response.json())
.then(data => console.log(data));

// 响应示例
// {
//   "message": "论文排期成功",
//   "schedule_id": 1
// }
```

### 2. 编辑获取所有排期记录

```javascript
// 请求示例
fetch('/api/schedules', {
  method: 'GET',
  headers: {
    'Authorization': 'Bearer {token}'
  }
})
.then(response => response.json())
.then(data => console.log(data));

// 响应示例
// [
//   {
//     "schedule_id": 1,
//     "paper_id": 1,
//     "issue_number": "2023-01",
//     "volume_number": "12",
//     "page_number": "1-10",
//     "title_zh": "中文标题",
//     "title_en": "English Title"
//   },
//   ...
// ]
```

### 3. 作者获取自己论文的排期记录

```javascript
// 请求示例
fetch('/api/schedules/author/papers/1', {
  method: 'GET',
  headers: {
    'Authorization': 'Bearer {token}'
  }
})
.then(response => response.json())
.then(data => console.log(data));

// 响应示例
// {
//   "schedule_id": 1,
//   "paper_id": 1,
//   "issue_number": "2023-01",
//   "volume_number": "12",
//   "page_number": "1-10",
//   "title_zh": "中文标题",
//   "title_en": "English Title"
// }
```

### 4. 编辑更新排期记录

```javascript
// 请求示例
fetch('/api/schedules/1', {
  method: 'PUT',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer {token}'
  },
  body: JSON.stringify({
    issue_number: "2023-02",
    page_number: "11-20"
  })
})
.then(response => response.json())
.then(data => console.log(data));

// 响应示例
// {
//   "message": "排期记录更新成功"
// }
```