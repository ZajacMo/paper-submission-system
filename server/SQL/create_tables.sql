-- 创建作者表 (authors)
create table paper_submission_system.authors
(
    author_id      int auto_increment primary key,
    name           varchar(100)     not null,
    age            tinyint unsigned null,
    email          varchar(100)     not null,
    password       varchar(255)     not null,
    degree         varchar(50)      null,
    title          varchar(50)      null,
    hometown       varchar(100)     null,
    research_areas text             null,
    bio            text             null,
    phone          varchar(20)      null,
    constraint email_UNIQUE
        unique (email)
);


-- 创建单位表 (institutions)
create table paper_submission_system.institutions
(
    institution_id int auto_increment primary key,
    name           varchar(200) not null,
    city           varchar(100) not null,
    zip_code       varchar(20)  null
);



-- 创建作者-单位关联表 (author_institutions)
create table paper_submission_system.author_institutions
(
    author_id      int not null,
    institution_id int not null,
    primary key (author_id, institution_id),
    constraint fk_author_institutions_authors
        foreign key (author_id) references paper_submission_system.authors (author_id)
            on update cascade on delete cascade,
    constraint fk_author_institutions_institutions
        foreign key (institution_id) references paper_submission_system.institutions (institution_id)
            on update cascade on delete cascade
);



-- 创建专家表 (experts)
create table paper_submission_system.experts
(
    expert_id      int auto_increment
        primary key,
    name           varchar(100)   not null,
    title          varchar(50)    null,
    email          varchar(100)   not null,
    phone          varchar(20)    null,
    research_areas text           null,
    bank_account   varchar(50)    null,
    bank_name      varchar(100)   null,
    account_holder varchar(100)   null,
    review_fee     decimal(10, 2) not null,
    password       varchar(255)   not null,
    constraint email_UNIQUE
        unique (email)
);

-- 创建专家就职表 (expert_institutions)
create table paper_submission_system.expert_institutions
(
    expert_id      int not null,
    institution_id int not null,
    primary key (expert_id, institution_id),
    constraint fk_expert_institutions_experts
        foreign key (expert_id) references paper_submission_system.experts (expert_id)
            on update cascade on delete cascade,
    constraint fk_expert_institutions_institutions
        foreign key (institution_id) references paper_submission_system.institutions (institution_id)
            on update cascade on delete cascade
);


-- 创建编辑表 (editors)
create table paper_submission_system.editors
(
    editor_id int auto_increment
        primary key,
    name      varchar(100) not null,
    email     varchar(100) not null,
    password  varchar(255) not null,
    constraint email_UNIQUE
        unique (email)
);

-- 创建论文表 (papers)
create table paper_submission_system.papers
(
    paper_id        int auto_increment
        primary key,
    title_zh        varchar(500)                                                  not null,
    title_en        varchar(500)                                                  not null,
    abstract_zh     text                                                          not null,
    abstract_en     text                                                          not null,
    attachment_path varchar(500)                                                  not null,
    submission_date datetime                          default CURRENT_TIMESTAMP   not null,
    integrity       enum ('True', 'False', 'Waiting') default 'Waiting'           not null,
    check_time      datetime                                                      null,
    update_date     datetime                          default CURRENT_TIMESTAMP   not null on update CURRENT_TIMESTAMP,
    status          enum ('Accept', 'Reject', 'Minor Revision', 'Major Revision') null,
    status_read     tinyint(1)                        default 0                   not null
);


-- 创建关键词表 (keywords)
create table paper_submission_system.keywords
(
    keyword_id   int auto_increment primary key,
    keyword_name varchar(20)       not null,
    keyword_type enum ('zh', 'en') not null
);



-- 创建论文-关键词关联表 (paper_keywords)=======
create table paper_submission_system.paper_keywords
(
    paper_id   int not null,
    keyword_id int not null,
    primary key (paper_id, keyword_id),
    constraint fk_paper_keywords_keywords
        foreign key (keyword_id) references paper_submission_system.keywords (keyword_id)
            on update cascade on delete cascade,
    constraint fk_paper_keywords_papers
        foreign key (paper_id) references paper_submission_system.papers (paper_id)
            on update cascade on delete cascade
);


-- 创建论文-作者-单位关联表 (paper_authors_institutions)========
create table paper_submission_system.paper_authors_institutions
(
    paper_id         int                  not null,
    author_id        int                  not null,
    institution_id   int                  not null,
    is_corresponding tinyint(1) default 0 not null,
    primary key (paper_id, author_id, institution_id),
    constraint fk_paper_authors_institutions_authors
        foreign key (author_id) references paper_submission_system.authors (author_id)
            on update cascade on delete cascade,
    constraint fk_paper_authors_institutions_institutions
        foreign key (institution_id) references paper_submission_system.institutions (institution_id)
            on update cascade on delete cascade,
    constraint fk_paper_authors_institutions_papers
        foreign key (paper_id) references paper_submission_system.papers (paper_id)
            on update cascade on delete cascade
);


-- 创建基金表 (funds)
create table paper_submission_system.funds
(
    fund_id        int auto_increment
        primary key,
    project_name   varchar(200) not null,
    project_number varchar(100) not null
);


-- 创建论文-基金关联表 (paper_funds)
create table paper_submission_system.paper_funds
(
    paper_id int not null,
    fund_id  int not null,
    primary key (paper_id, fund_id),
    constraint fk_paper_funds_funds
        foreign key (fund_id) references paper_submission_system.funds (fund_id)
            on update cascade on delete cascade,
    constraint fk_paper_funds_papers
        foreign key (paper_id) references paper_submission_system.papers (paper_id)
            on update cascade on delete cascade
);



-- 创建审稿分配表 (review_assignments)
create table paper_submission_system.review_assignments
(
    assignment_id       int auto_increment
        primary key,
    paper_id            int                                                                           not null,
    expert_id           int                                                                           not null,
    editor_id           int                                                                           not null,
    conclusion          enum ('Accept', 'Minor Revision', 'Major Revision', 'Not Reviewed', 'Reject') not null,
    positive_comments   text                                                                          null,
    negative_comments   text                                                                          null,
    modification_advice text                                                                          null,
    submission_date     datetime                                                                      null on update CURRENT_TIMESTAMP,
    status              enum ('Assigned', 'Completed', 'Overdue')                                     not null,
    assigned_due_date   datetime                                                                      not null,
    assigned_date       datetime   default (now())                                                    not null,
    is_read             tinyint(1) default 0                                                          null,
    constraint fk_review_assignments_editors
        foreign key (editor_id) references paper_submission_system.editors (editor_id)
            on update cascade on delete cascade,
    constraint fk_review_assignments_experts
        foreign key (expert_id) references paper_submission_system.experts (expert_id)
            on update cascade on delete cascade,
    constraint fk_review_assignments_papers
        foreign key (paper_id) references paper_submission_system.papers (paper_id)
            on update cascade on delete cascade
);


-- 创建支付表 (payments)
create table paper_submission_system.payments
(
    paper_id     int                                        not null,
    amount       decimal(10, 2)                             not null,
    status       enum ('Pending', 'Paid') default 'Pending' not null,
    payment_date datetime                                   null on update CURRENT_TIMESTAMP,
    constraint paper_id_UNIQUE
        unique (paper_id),
    constraint fk_payments_papers
        foreign key (paper_id) references paper_submission_system.papers (paper_id)
            on update cascade on delete cascade
);


-- 创建专家提现表 (withdrawals)
create table paper_submission_system.withdrawals
(
    assignment_id   int                                  not null,
    status          tinyint(1) default 0                 not null,
    expert_id       int                                  not null,
    withdrawal_date datetime   default CURRENT_TIMESTAMP null,
    constraint fk_withdrawals_assignments
        foreign key (assignment_id) references paper_submission_system.review_assignments (assignment_id)
            on update cascade on delete cascade,
    constraint fk_withdrawals_experts
        foreign key (expert_id) references paper_submission_system.experts (expert_id)
            on update cascade on delete cascade
);



-- 创建排期表 (schedules)
create table paper_submission_system.schedules
(
    schedule_id   int auto_increment
        primary key,
    paper_id      int         not null,
    issue_number  varchar(20) not null,
    volume_number varchar(20) not null,
    page_number   varchar(50) not null,
    constraint paper_id_UNIQUE
        unique (paper_id),
    constraint fk_schedules_papers
        foreign key (paper_id) references paper_submission_system.papers (paper_id)
            on update cascade on delete cascade
);



-- 创建通知表 (notifications)
create table paper_submission_system.notifications
(
    notification_id   int auto_increment
        primary key,
    paper_id          int                                                                                                     not null,
    notification_type enum ('Review Assignment', 'Payment Confirmation', 'Acceptance Notification', 'Rejection Notification') not null,
    sent_at           datetime   default CURRENT_TIMESTAMP                                                                    not null,
    deadline          datetime                                                                                                null,
    is_read           tinyint(1) default 0                                                                                    not null,
    constraint fk_notifications_papers
        foreign key (paper_id) references paper_submission_system.papers (paper_id)
            on update cascade on delete cascade
);



