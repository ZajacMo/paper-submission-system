-- 论文投稿系统 - 索引定义文件
-- 用途：定义系统中用于性能优化的所有数据库索引
-- 索引类型概述：
-- 1. 外键索引（fk_前缀）：优化关联查询性能
-- 2. 查询索引（idx_前缀）：优化特定字段的查询和排序性能
-- 总索引数：12个

-- 索引：fk_author_institutions_institutions_idx
-- 用途：优化作者-机构关联表中按机构ID查询的性能
-- 作用表：author_institutions
-- 作用列：institution_id
-- 优化目的：加速通过机构ID查找关联作者的查询操作
create index fk_author_institutions_institutions_idx
    on paper_submission_system.author_institutions (institution_id);

-- 索引：fk_expert_institutions_institutions_idx
-- 用途：优化专家-机构关联表中按机构ID查询的性能
-- 作用表：expert_institutions
-- 作用列：institution_id
-- 优化目的：加速通过机构ID查找关联专家的查询操作
create index fk_expert_institutions_institutions_idx
    on paper_submission_system.expert_institutions (institution_id);

-- 索引：idx_papers_submission_date
-- 用途：优化论文表中按提交日期查询和排序的性能
-- 作用表：papers
-- 作用列：submission_date
-- 优化目的：加速按提交日期范围查询、排序和分页操作
create index idx_papers_submission_date
    on paper_submission_system.papers (submission_date);

-- 索引：idx_keywords_keyword_name
-- 用途：优化关键词表中按关键词名称查询的性能
-- 作用表：keywords
-- 作用列：keyword_name
-- 优化目的：加速关键词搜索、匹配和查重操作
create index idx_keywords_keyword_name
    on paper_submission_system.keywords (keyword_name);

-- 索引：fk_paper_keywords_keywords_idx
-- 用途：优化论文-关键词关联表中按关键词ID查询的性能
-- 作用表：paper_keywords
-- 作用列：keyword_id
-- 优化目的：加速通过关键词查找相关论文的查询操作
create index fk_paper_keywords_keywords_idx
    on paper_submission_system.paper_keywords (keyword_id);

-- 索引：fk_paper_authors_institutions_authors_idx
-- 用途：优化论文-作者-机构关联表中按作者ID查询的性能
-- 作用表：paper_authors_institutions
-- 作用列：author_id
-- 优化目的：加速通过作者ID查找其所有论文的查询操作
create index fk_paper_authors_institutions_authors_idx
    on paper_submission_system.paper_authors_institutions (author_id);

-- 索引：fk_paper_authors_institutions_institutions_idx
-- 用途：优化论文-作者-机构关联表中按机构ID查询的性能
-- 作用表：paper_authors_institutions
-- 作用列：institution_id
-- 优化目的：加速通过机构ID查找相关论文的查询操作
create index fk_paper_authors_institutions_institutions_idx
    on paper_submission_system.paper_authors_institutions (institution_id);

-- 索引：idx_paper_authors_institutions_is_corresponding
-- 用途：优化论文-作者-机构关联表中按通讯作者标识查询的性能
-- 作用表：paper_authors_institutions
-- 作用列：is_corresponding
-- 优化目的：加速查找通讯作者及其相关论文的查询操作
create index idx_paper_authors_institutions_is_corresponding
    on paper_submission_system.paper_authors_institutions (is_corresponding);

-- 索引：fk_paper_funds_funds_idx
-- 用途：优化论文-基金关联表中按基金ID查询的性能
-- 作用表：paper_funds
-- 作用列：fund_id
-- 优化目的：加速通过基金ID查找相关论文的查询操作
create index fk_paper_funds_funds_idx
    on paper_submission_system.paper_funds (fund_id);

-- 索引：fk_review_assignments_editors_idx
-- 用途：优化审稿任务表中按编辑ID查询的性能
-- 作用表：review_assignments
-- 作用列：editor_id
-- 优化目的：加速查找特定编辑分配的审稿任务的查询操作
create index fk_review_assignments_editors_idx
    on paper_submission_system.review_assignments (editor_id);

-- 索引：fk_review_assignments_experts_idx
-- 用途：优化审稿任务表中按专家ID查询的性能
-- 作用表：review_assignments
-- 作用列：expert_id
-- 优化目的：加速查找分配给特定专家的审稿任务的查询操作
create index fk_review_assignments_experts_idx
    on paper_submission_system.review_assignments (expert_id);

-- 索引：idx_payments_status
-- 用途：优化支付表中按支付状态查询的性能
-- 作用表：payments
-- 作用列：status
-- 优化目的：加速按支付状态（如待支付、已支付、支付失败等）筛选记录的查询操作
create index idx_payments_status
    on paper_submission_system.payments (status);


