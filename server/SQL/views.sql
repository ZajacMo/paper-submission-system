-- 论文投稿系统 - 视图定义文件
-- 用途：定义系统中用于数据查询和展示的所有视图
-- 视图列表：
-- 1. author_accessible_papers - 作者可访问的论文列表
-- 2. author_papers_full - 作者论文详细信息（含通讯作者标识）
-- 3. expert_review_assignments - 专家审稿任务详情
-- 4. expert_with_institutions - 专家及所属机构信息
-- 5. paper_full_details - 论文完整详细信息
-- 6. paper_progress - 论文当前进度状态
-- 7. paper_review_comments - 论文审稿意见信息
-- 8. paper_review_details - 论文审稿详细信息
-- 9. paper_review_progress - 论文审稿流程各阶段进度
-- 10. review_assignments_details - 审稿任务详细信息（含编辑）

-- 视图：author_accessible_papers
-- 用途：提供作者可访问的论文列表，包含论文基本信息和进度状态
-- 主要功能：关联论文、作者机构关联和论文进度表，用于作者查看自己参与的论文
-- 字段说明：包含paper_id、title_zh、title_en等基本信息，以及作者ID和论文进度状态
create definer = root@localhost view paper_submission_system.author_accessible_papers as
select distinct `p`.`paper_id`                          AS `paper_id`,
                `p`.`title_zh`                          AS `title_zh`,
                `p`.`title_en`                          AS `title_en`,
                `p`.`abstract_zh`                       AS `abstract_zh`,
                `p`.`abstract_en`                       AS `abstract_en`,
                `p`.`attachment_path`                   AS `attachment_path`,
                `p`.`submission_date`                   AS `submission_date`,
                `p`.`integrity`                         AS `integrity`,
                `p`.`check_time`                        AS `check_time`,
                `p`.`update_date`                       AS `update_date`,
                `p`.`status`                            AS `status`,
                `pai`.`author_id`                       AS `author_id`,
                `paper_submission_system`.`pp`.`status` AS `progress`
from ((`paper_submission_system`.`papers` `p` join `paper_submission_system`.`paper_authors_institutions` `pai`
       on ((`p`.`paper_id` = `pai`.`paper_id`))) left join `paper_submission_system`.`paper_progress` `pp`
      on ((`p`.`paper_id` = `paper_submission_system`.`pp`.`paper_id`)));

-- 视图：author_papers_full
-- 用途：提供作者论文的详细信息，包含通讯作者标识
-- 主要功能：在author_accessible_papers基础上增加通讯作者标志，便于区分不同作者角色
-- 字段说明：增加is_corresponding字段标识是否为通讯作者
create definer = root@localhost view paper_submission_system.author_papers_full as
select `p`.`paper_id`                          AS `paper_id`,
       `p`.`title_zh`                          AS `title_zh`,
       `p`.`title_en`                          AS `title_en`,
       `p`.`abstract_zh`                       AS `abstract_zh`,
       `p`.`abstract_en`                       AS `abstract_en`,
       `p`.`attachment_path`                   AS `attachment_path`,
       `p`.`submission_date`                   AS `submission_date`,
       `p`.`integrity`                         AS `integrity`,
       `p`.`check_time`                        AS `check_time`,
       `p`.`update_date`                       AS `update_date`,
       `p`.`status`                            AS `status`,
       `pai`.`is_corresponding`                AS `is_corresponding`,
       `paper_submission_system`.`pp`.`status` AS `progress`
from ((`paper_submission_system`.`papers` `p` join `paper_submission_system`.`paper_authors_institutions` `pai`
       on ((`p`.`paper_id` = `pai`.`paper_id`))) left join `paper_submission_system`.`paper_progress` `pp`
      on ((`p`.`paper_id` = `paper_submission_system`.`pp`.`paper_id`)));

-- 视图：expert_review_assignments
-- 用途：提供专家审稿任务详情，包含论文信息和审稿状态
-- 主要功能：关联审稿任务和论文表，便于专家查看分配给自己的审稿任务
-- 字段说明：包含assignment_id、paper_id、expert_id等任务信息，以及title_zh、title_en等论文标题
create definer = root@localhost view paper_submission_system.expert_review_assignments as
select `ra`.`assignment_id`       AS `assignment_id`,
       `ra`.`paper_id`            AS `paper_id`,
       `ra`.`expert_id`           AS `expert_id`,
       `ra`.`editor_id`           AS `editor_id`,
       `ra`.`conclusion`          AS `conclusion`,
       `ra`.`positive_comments`   AS `positive_comments`,
       `ra`.`negative_comments`   AS `negative_comments`,
       `ra`.`modification_advice` AS `modification_advice`,
       `ra`.`submission_date`     AS `submission_date`,
       `ra`.`status`              AS `status`,
       `ra`.`assigned_due_date`   AS `assigned_due_date`,
       `ra`.`assigned_date`       AS `assigned_date`,
       `p`.`title_zh`             AS `title_zh`,
       `p`.`title_en`             AS `title_en`
from (`paper_submission_system`.`review_assignments` `ra` join `paper_submission_system`.`papers` `p`
      on ((`ra`.`paper_id` = `p`.`paper_id`)));

-- 视图：expert_with_institutions
-- 用途：提供专家信息及其所属机构信息的关联视图
-- 主要功能：关联专家表、专家机构关联表和机构表，聚合显示专家的所属机构
-- 字段说明：expert_id、name等专家基本信息，以及用逗号分隔的机构名称列表
create definer = root@localhost view paper_submission_system.expert_with_institutions as
select `e`.`expert_id`                                  AS `expert_id`,
       `e`.`name`                                       AS `name`,
       `e`.`title`                                      AS `title`,
       `e`.`email`                                      AS `email`,
       `e`.`phone`                                      AS `phone`,
       `e`.`research_areas`                             AS `research_areas`,
       `e`.`review_fee`                                 AS `review_fee`,
       group_concat(distinct `i`.`name` separator ', ') AS `institution_names`
from ((`paper_submission_system`.`experts` `e` left join `paper_submission_system`.`expert_institutions` `ei`
       on ((`e`.`expert_id` = `ei`.`expert_id`))) left join `paper_submission_system`.`institutions` `i`
      on ((`ei`.`institution_id` = `i`.`institution_id`)))
group by `e`.`expert_id`;

-- 视图：paper_full_details
-- 用途：提供论文的完整详细信息，包含作者、关键词、基金等关联信息
-- 主要功能：多表关联聚合论文所有相关信息，是系统中最完整的论文信息视图
-- 字段说明：包含论文基本信息、进度、作者信息（含通讯作者标识）、中英文关键词、基金信息等
create definer = root@localhost view paper_submission_system.paper_full_details as
select `p`.`paper_id`                                                                                                 AS `paper_id`,
       `p`.`title_zh`                                                                                                 AS `title_zh`,
       `p`.`title_en`                                                                                                 AS `title_en`,
       `p`.`abstract_zh`                                                                                              AS `abstract_zh`,
       `p`.`abstract_en`                                                                                              AS `abstract_en`,
       `p`.`attachment_path`                                                                                          AS `attachment_path`,
       `p`.`submission_date`                                                                                          AS `submission_date`,
       `p`.`update_date`                                                                                              AS `update_date`,
       `paper_submission_system`.`pp`.`status`                                                                        AS `progress`,
       `p`.`integrity`                                                                                                AS `integrity`,
       `p`.`check_time`                                                                                               AS `check_time`,
       `p`.`status`                                                                                                   AS `status`,
       `p`.`status_read`                                                                                              AS `status_read`,
       count(distinct `ra`.`assignment_id`)                                                                           AS `review_times`,
       group_concat(distinct concat(`a`.`author_id`, ':', `a`.`name`, ':', `i`.`name`, ':',
                                    if(`pai`.`is_corresponding`, '1', '0')) order by `a`.`author_id` ASC separator
                    '|')                                                                                              AS `authors_info`,
       group_concat(distinct
                    (case when (`k`.`keyword_type` = 'zh') then concat(`k`.`keyword_id`, ':', `k`.`keyword_name`) end)
                    order by `k`.`keyword_id` ASC separator
                    '|')                                                                                              AS `keywords_zh`,
       group_concat(distinct
                    (case when (`k`.`keyword_type` = 'en') then concat(`k`.`keyword_id`, ':', `k`.`keyword_name`) end)
                    order by `k`.`keyword_id` ASC separator
                    '|')                                                                                              AS `keywords_en`,
       group_concat(distinct concat(`f`.`fund_id`, ':', `f`.`project_name`, ':', `f`.`project_number`) separator
                    '|')                                                                                              AS `funds_info`
from (((((((((`paper_submission_system`.`papers` `p` left join `paper_submission_system`.`paper_progress` `pp`
              on ((`p`.`paper_id` = `paper_submission_system`.`pp`.`paper_id`))) left join `paper_submission_system`.`review_assignments` `ra`
             on (((`p`.`paper_id` = `ra`.`paper_id`) and
                  (`ra`.`submission_date` is not null)))) left join `paper_submission_system`.`paper_authors_institutions` `pai`
            on ((`p`.`paper_id` = `pai`.`paper_id`))) left join `paper_submission_system`.`authors` `a`
           on ((`pai`.`author_id` = `a`.`author_id`))) left join `paper_submission_system`.`institutions` `i`
          on ((`pai`.`institution_id` = `i`.`institution_id`))) left join `paper_submission_system`.`paper_keywords` `pk`
         on ((`p`.`paper_id` = `pk`.`paper_id`))) left join `paper_submission_system`.`keywords` `k`
        on ((`pk`.`keyword_id` = `k`.`keyword_id`))) left join `paper_submission_system`.`paper_funds` `pf`
       on ((`p`.`paper_id` = `pf`.`paper_id`))) left join `paper_submission_system`.`funds` `f`
      on ((`pf`.`fund_id` = `f`.`fund_id`)))
group by `p`.`paper_id`, `p`.`title_zh`, `p`.`title_en`, `p`.`abstract_zh`, `p`.`abstract_en`, `p`.`attachment_path`,
         `p`.`submission_date`, `p`.`update_date`, `paper_submission_system`.`pp`.`status`, `p`.`integrity`,
         `p`.`check_time`;

-- 视图：paper_progress
-- 用途：提供论文当前的进度状态
-- 主要功能：根据论文状态和各个阶段的完成情况，计算并返回论文的整体进度状态
-- 字段说明：paper_id和status（如Draft、Reviewing、Revisioning、Published等）
create definer = Zajac@`%` view paper_submission_system.paper_progress as
select `p`.`paper_id`                        AS `paper_id`,
       (case
            when (`p`.`status` = 'Reject') then `p`.`status`
            else (case
                      when ((`paper_submission_system`.`prp`.`payment_stage` = 'finished') and
                            (`paper_submission_system`.`prp`.`schedule_stage` = 'finished')) then 'Published'
                      when (`paper_submission_system`.`prp`.`payment_stage` = 'finished') then 'Scheduling'
                      when (`paper_submission_system`.`prp`.`acceptance_stage` = 'finished') then 'Paying'
                      when (`paper_submission_system`.`prp`.`re_review_stage2` = 'finished')
                          then 'Final Review Completed'
                      when ((`paper_submission_system`.`prp`.`re_review_stage1` = 'finished') and
                            (`paper_submission_system`.`prp`.`revision_stage` = 'finished')) then 'Final Reviewing'
                      when (`paper_submission_system`.`prp`.`re_review_stage1` = 'finished') then 'Revisioning'
                      when ((`paper_submission_system`.`prp`.`review_stage` = 'finished') and
                            (`paper_submission_system`.`prp`.`revision_stage` = 'finished')) then 'Second Reviewing'
                      when (`paper_submission_system`.`prp`.`review_stage` = 'finished') then 'Revisioning'
                      when ((`paper_submission_system`.`prp`.`initial_review_stage` = 'finished') and
                            (`p`.`integrity` = true)) then 'Reviewing'
                      when (`paper_submission_system`.`prp`.`initial_review_stage` = 'finished') then 'Revisioning'
                      when (`paper_submission_system`.`prp`.`submission_stage` = 'finished') then 'Initial Reviewing'
                      else 'Draft' end) end) AS `status`
from (`paper_submission_system`.`papers` `p` left join `paper_submission_system`.`paper_review_progress` `prp`
      on ((`p`.`paper_id` = `paper_submission_system`.`prp`.`paper_id`)));

-- 视图：paper_review_comments
-- 用途：提供论文的审稿意见信息
-- 主要功能：关联审稿任务和专家表，展示审稿意见及审稿专家
-- 字段说明：conclusion、positive_comments、negative_comments等审稿意见，以及专家姓名
create definer = root@localhost view paper_submission_system.paper_review_comments as
select `ra`.`conclusion`          AS `conclusion`,
       `ra`.`positive_comments`   AS `positive_comments`,
       `ra`.`negative_comments`   AS `negative_comments`,
       `ra`.`modification_advice` AS `modification_advice`,
       `e`.`name`                 AS `expert_name`,
       `ra`.`submission_date`     AS `submission_date`,
       `ra`.`paper_id`            AS `paper_id`
from (`paper_submission_system`.`review_assignments` `ra` join `paper_submission_system`.`experts` `e`
      on ((`ra`.`expert_id` = `e`.`expert_id`)));

-- 视图：paper_review_details
-- 用途：提供论文审稿的详细信息，包含审稿状态
-- 主要功能：在paper_review_comments基础上增加审稿状态和提交日期字段
-- 字段说明：增加review_status和review_submission_date字段
create definer = root@localhost view paper_submission_system.paper_review_details as
select `ra`.`paper_id`            AS `paper_id`,
       `ra`.`conclusion`          AS `conclusion`,
       `ra`.`positive_comments`   AS `positive_comments`,
       `ra`.`negative_comments`   AS `negative_comments`,
       `ra`.`modification_advice` AS `modification_advice`,
       `e`.`name`                 AS `expert_name`,
       `ra`.`submission_date`     AS `review_submission_date`,
       `ra`.`status`              AS `review_status`
from (`paper_submission_system`.`review_assignments` `ra` join `paper_submission_system`.`experts` `e`
      on ((`ra`.`expert_id` = `e`.`expert_id`)));

-- 视图：paper_review_progress
-- 用途：提供论文审稿流程各阶段的详细进度信息
-- 主要功能：跟踪论文在各个阶段（提交、初审、审稿、修改、复审等）的完成状态和时间
-- 字段说明：各阶段的状态（finished/processing）和对应的完成时间
create definer = root@localhost view paper_submission_system.paper_review_progress as
select `p`.`paper_id`                                                                           AS `paper_id`,
       `p`.`title_zh`                                                                           AS `title_zh`,
       `p`.`title_en`                                                                           AS `title_en`,
       (case when (`p`.`attachment_path` is not null) then 'finished' else 'processing' end)    AS `submission_stage`,
       (case when (`p`.`attachment_path` is not null) then `p`.`submission_date` else NULL end) AS `submission_time`,
       (case
            when (`p`.`check_time` is not null) then 'finished'
            else 'processing' end)                                                              AS `initial_review_stage`,
       `p`.`check_time`                                                                         AS `initial_review_time`,
       (case
            when ((select count(0)
                   from `paper_submission_system`.`review_assignments` `ra`
                   where ((`ra`.`paper_id` = `p`.`paper_id`) and (`ra`.`submission_date` is not null))) >= 3)
                then 'finished'
            else 'processing' end)                                                              AS `review_stage`,
       (case
            when ((select count(0)
                   from `paper_submission_system`.`review_assignments` `ra`
                   where ((`ra`.`paper_id` = `p`.`paper_id`) and (`ra`.`submission_date` is not null))) >= 3)
                then (select min(`top3_dates`.`submission_date`)
                      from (select `ra`.`submission_date` AS `submission_date`
                            from `paper_submission_system`.`review_assignments` `ra`
                            where ((`ra`.`paper_id` = `p`.`paper_id`) and (`ra`.`submission_date` is not null))
                            order by `ra`.`submission_date`
                            limit 3) `top3_dates`
                      order by `top3_dates`.`submission_date` desc
                      limit 1)
            else NULL end)                                                                      AS `review_time`,
       (case
            when (`p`.`update_date` > (select min(`n`.`sent_at`)
                                       from `paper_submission_system`.`notifications` `n`
                                       where ((`n`.`paper_id` = `p`.`paper_id`) and
                                              (`n`.`notification_type` = 'Review Assignment')))) then 'finished'
            else 'processing' end)                                                              AS `revision_stage`,
       (case
            when (`p`.`update_date` > (select min(`n`.`sent_at`)
                                       from `paper_submission_system`.`notifications` `n`
                                       where ((`n`.`paper_id` = `p`.`paper_id`) and
                                              (`n`.`notification_type` = 'Review Assignment')))) then `p`.`update_date`
            else NULL end)                                                                      AS `revision_time`,
       (case
            when ((select count(0)
                   from `paper_submission_system`.`review_assignments` `ra`
                   where ((`ra`.`paper_id` = `p`.`paper_id`) and (`ra`.`submission_date` is not null))) >= 6)
                then 'finished'
            else 'processing' end)                                                              AS `re_review_stage1`,
       (case
            when ((select count(0)
                   from `paper_submission_system`.`review_assignments` `ra`
                   where ((`ra`.`paper_id` = `p`.`paper_id`) and (`ra`.`submission_date` is not null))) >= 6)
                then (select `ra`.`submission_date`
                      from `paper_submission_system`.`review_assignments` `ra`
                      where (`ra`.`paper_id` = `p`.`paper_id`)
                      order by `ra`.`submission_date` desc
                      limit 5,1)
            else NULL end)                                                                      AS `re_review_time1`,
       (case
            when ((select count(0)
                   from `paper_submission_system`.`review_assignments` `ra`
                   where ((`ra`.`paper_id` = `p`.`paper_id`) and (`ra`.`submission_date` is not null))) = 9)
                then 'finished'
            else 'processing' end)                                                              AS `re_review_stage2`,
       (case
            when ((select count(0)
                   from `paper_submission_system`.`review_assignments` `ra`
                   where ((`ra`.`paper_id` = `p`.`paper_id`) and (`ra`.`submission_date` is not null))) = 9)
                then (select max(`ra`.`submission_date`)
                      from `paper_submission_system`.`review_assignments` `ra`
                      where (`ra`.`paper_id` = `p`.`paper_id`))
            else NULL end)                                                                      AS `re_review_time2`,
       (case
            when exists(select 1
                        from `paper_submission_system`.`notifications` `n`
                        where ((`n`.`paper_id` = `p`.`paper_id`) and
                               (`n`.`notification_type` = 'Acceptance Notification'))) then 'finished'
            else 'processing' end)                                                              AS `acceptance_stage`,
       (select `n`.`sent_at`
        from `paper_submission_system`.`notifications` `n`
        where ((`n`.`paper_id` = `p`.`paper_id`) and (`n`.`notification_type` = 'Acceptance Notification'))
        limit 1)                                                                                AS `acceptance_time`,
       (case
            when ((select `pa`.`payment_date`
                   from `paper_submission_system`.`payments` `pa`
                   where (`pa`.`paper_id` = `p`.`paper_id`)) is not null) then 'finished'
            else 'processing' end)                                                              AS `payment_stage`,
       (select `pa`.`payment_date`
        from `paper_submission_system`.`payments` `pa`
        where (`pa`.`paper_id` = `p`.`paper_id`))                                               AS `payment_time`,
       (case
            when exists(select 1 from `paper_submission_system`.`schedules` `s` where (`s`.`paper_id` = `p`.`paper_id`))
                then 'finished'
            else 'processing' end)                                                              AS `schedule_stage`
from `paper_submission_system`.`papers` `p`;

-- 视图：review_assignments_details
-- 用途：提供审稿任务的详细信息，包含编辑信息
-- 主要功能：关联审稿任务、论文、专家和编辑表，提供完整的审稿任务信息
-- 字段说明：包含assignment_id、论文标题、专家姓名、编辑姓名、审稿结论等
create definer = root@localhost view paper_submission_system.review_assignments_details as
select `ra`.`assignment_id`   AS `assignment_id`,
       `p`.`title_zh`         AS `title_zh`,
       `p`.`title_en`         AS `title_en`,
       `e`.`name`             AS `expert_name`,
       `ed`.`name`            AS `editor_name`,
       `ra`.`conclusion`      AS `conclusion`,
       `ra`.`submission_date` AS `submission_date`
from (((`paper_submission_system`.`review_assignments` `ra` left join `paper_submission_system`.`papers` `p`
        on ((`ra`.`paper_id` = `p`.`paper_id`))) left join `paper_submission_system`.`experts` `e`
       on ((`ra`.`expert_id` = `e`.`expert_id`))) left join `paper_submission_system`.`editors` `ed`
      on ((`ra`.`editor_id` = `ed`.`editor_id`)));

