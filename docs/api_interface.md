---
title: co-editor
language_tabs:
  - shell: Shell
  - http: HTTP
  - javascript: JavaScript
  - ruby: Ruby
  - python: Python
  - php: PHP
  - java: Java
  - go: Go
toc_footers: []
includes: []
search: true
code_clipboard: true
highlight_theme: darkula
headingLevel: 2
generator: "@tarslib/widdershins v4.0.20"

---

# co-editor

Base URLs:

# Authentication

# co-edit/登陆

## GET 用户登陆

GET /api/login

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|username|query|string| no |用户的账号|
|password|query|string| no |用户的密码|

> Response Examples

> 成功

```json
{
  "data": {
    "status": true,
    "token": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.u3pH0Kc6t3i6b6eZfTlRQwIqKxJ8WfTzAd96T8Fs4e3YVcW9p0aR3UQ6nFvHvJ2sM0eVcP4IYJKGjUjgZP7A"
  }
}
```

```json
{
  "data": {
    "status": "false",
    "error_message": "user not found"
  }
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|成功|Inline|

### Responses Data Schema

# co-edit/文档的CRUD

## POST 创建一个文档

POST /api/item

> Body Parameters

```yaml
docname: '"test_doc_1"'
docroom: '"test_room_1"'

```

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|body|body|object| no |none|
|» docname|body|string| no |none|
|» docroom|body|string| no |none|

> Response Examples

> 500 Response

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|500|[Internal Server Error](https://tools.ietf.org/html/rfc7231#section-6.6.1)|服务器错误|Inline|

### Responses Data Schema

## GET 查询文档名字操作

GET /api/item

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|username|query|string| no |none|
|token|query|string| no |none|

> Response Examples

> 成功

```json
{
  "data": [
    {
      "doc_name": "docname",
      "doc_room": "docroom",
      "id": 1
    },
    {
      "doc_name": "\"test_doc\"",
      "doc_room": "\"test_room\"",
      "id": 2
    }
  ],
  "status": true
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|成功|Inline|

### Responses Data Schema

HTTP Status Code **200**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» status|boolean|true|none||none|

## PATCH 文档重新写入

PATCH /api/item/{i}

文档重新写入

> Body Parameters

```yaml
docname: '"test_name"'
docroom: '"test_room"'
doccontent: '"test_content"'

```

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|i|path|string| yes |none|
|body|body|object| no |none|
|» docname|body|string| no |none|
|» docroom|body|string| no |none|
|» doccontent|body|string| no |none|

> Response Examples

> 200 Response

```json
{}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|成功|Inline|

### Responses Data Schema

## GET 获取文档内容

GET /api/item/1

> Body Parameters

```yaml
{}

```

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|body|body|object| no |none|

> Response Examples

> 成功

```json
{
  "doc_content": "Untitled",
  "status": "success"
}
```

```json
{
  "message": "不存在该id的文档",
  "status": "error"
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|成功|Inline|

### Responses Data Schema

# co-edit/REPL

## POST 针对某id doc的REPL

POST /api/rich_text/ai

> Body Parameters

```yaml
user_id: "1"
doc_id: "1"
doc_content: "{% mock 'csentence', 4, 8 %}"

```

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|body|body|object| no |none|
|» user_id|body|string| no |none|
|» doc_id|body|string| no |none|
|» doc_content|body|string| no |none|

> Response Examples

> 200 Response

```json
{}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|成功|Inline|

### Responses Data Schema

# Data Schema

