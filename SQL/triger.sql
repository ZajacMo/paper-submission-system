-- 论文投稿系统 - 触发器定义文件
-- 用途：定义系统中用于自动处理业务逻辑的数据库触发器
-- 触发器总数：2个

-- 触发器1: trg_update_paper_status_after_review
-- 用途：根据评审意见自动更新论文状态
-- 触发时机：在review_assignments表更新后
-- 触发条件：当conclusion字段发生变化时
-- 功能描述：
--   1. 当论文评审结论(conclusion)更新时触发
--   2. 统计该论文已完成评审(非'Not Reviewed')的记录数
--   3. 当评审记录数为3的倍数时，计算中间值(中位数)
--   4. 使用中间值更新论文表的状态(status)字段
--   5. 重置状态已读标记(status_read)为未读
create definer = Zajac@`%` trigger trg_update_paper_status_after_review
    after update
    on review_assignments
    for each row
begin
    BEGIN
  DECLARE v_paper_id INT; -- 论文ID变量
  DECLARE v_review_count INT; -- 评审记录数变量
  DECLARE v_middle_conclusion VARCHAR(50); -- 中间评审结论变量

  -- 只有当conclusion字段发生变化时才执行后续操作
  IF NEW.`conclusion` != OLD.`conclusion` THEN
    SET v_paper_id = NEW.`paper_id`;

    -- 统计该论文的conclusion不为'Not Reviewed'的记录数
    SELECT COUNT(*) INTO v_review_count
    FROM `review_assignments`
    WHERE `paper_id` = v_paper_id AND `conclusion` != 'Not Reviewed';

    -- 当记录数为3的倍数时，计算中间值并更新论文状态
    IF v_review_count > 0 AND v_review_count % 3 = 0 THEN
      -- 直接使用子查询获取排序后的中间值，避免使用临时表
      -- 步骤1: 获取最后3条记录
      -- 步骤2: 对这3条记录按conclusion优先级排序
      -- 步骤3: 取中间值（第2条记录）
      SELECT conclusion INTO v_middle_conclusion
      FROM (
        SELECT
          conclusion,
          ROW_NUMBER() OVER (ORDER BY
            CASE
              WHEN conclusion = 'Accept' THEN 1
              WHEN conclusion = 'Minor Revision' THEN 2
              WHEN conclusion = 'Major Revision' THEN 3
              WHEN conclusion = 'Reject' THEN 4
            END ASC
          ) AS row_num
        FROM (
          SELECT conclusion
          FROM `review_assignments`
          WHERE `paper_id` = v_paper_id AND `conclusion` != 'Not Reviewed'
          ORDER BY submission_date DESC
          LIMIT 3
        ) AS last_three_reviews
      ) AS ranked_reviews
      WHERE row_num = 2;

      -- 使用中间值更新papers表的status字段
      UPDATE `papers`
      SET `status` = v_middle_conclusion, `status_read`=FALSE
      WHERE `paper_id` = v_paper_id;
    END IF;
  END IF;
END;
end;


-- 触发器2: trg_withdrawal_before_insert
-- 用途：自动设置论文撤稿时间戳
-- 触发时机：在withdrawals表插入记录前
-- 功能描述：
--   1. 当用户提交论文撤稿请求时触发
--   2. 自动将当前系统时间设置为撤稿日期(withdrawal_date)
--   3. 确保撤稿时间的准确性和一致性，避免手动设置错误
create definer = root@localhost trigger trg_withdrawal_before_insert
    before insert
    on withdrawals
    for each row
BEGIN
  SET NEW.`withdrawal_date` = CURRENT_TIMESTAMP; -- 设置当前时间戳为撤稿日期
END;
