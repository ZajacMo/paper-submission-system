const express = require('express');
const router = express.Router();
const { pool } = require('../db');
const { authenticateToken, authorizeRole } = require('../auth');

// 获取分配给专家的审稿任务
router.get('/assignments', authenticateToken, authorizeRole(['expert']), async (req, res) => {
  try {
    const [assignments] = await pool.execute(
      `SELECT ra.*, p.title_zh, p.title_en 
       FROM review_assignments ra 
       JOIN papers p ON ra.paper_id = p.paper_id 
       WHERE ra.expert_id = ?
       ORDER BY ra.assigned_date DESC`,
      [req.user.id]
    );
    
    res.json(assignments);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// 获取专家的未读任务数量
router.get('/assignments/unread-count', authenticateToken, authorizeRole(['expert']), async (req, res) => {
  try {
    const [countResult] = await pool.execute(
      `SELECT COUNT(*) AS unread_count 
       FROM review_assignments 
       WHERE expert_id = ? AND is_read = 0`,
      [req.user.id]
    );
    
    res.json({ unread_count: countResult[0].unread_count });
  } catch (error) {
    res.status(500).json({ message: error.message });
    console.error('获取专家未读任务数量失败:', error);
  }
});

// 编辑批量分配审稿任务并发送评审任务书
router.post('/assignments', authenticateToken, authorizeRole(['editor']), async (req, res) => {
  try {
    // 期望接收一个assignments数组
    const assignments = req.body;
    
    // 验证输入格式
    if (!Array.isArray(assignments)) {
      return res.status(400).json({ message: '请求体必须是任务分配数组' });
    }
    
    // 验证数组长度
    if (assignments.length === 0 || assignments.length > 3) {
      return res.status(400).json({ message: '任务分配数组必须包含1-3条记录' });
    }
    
    // 检查编辑信息
    const [editors] = await pool.execute('SELECT * FROM editors WHERE editor_id = ?', [req.user.id]);
    if (editors.length === 0) {
      return res.status(404).json({ message: '编辑信息不存在' });
    }
    
    const createdAssignments = [];
    
    // 遍历处理每个分配任务
    for (const assignment of assignments) {
      const { paper_id, expert_id, assigned_due_date } = assignment;
      
      // 验证必填字段
      if (!paper_id || !expert_id || !assigned_due_date) {
        return res.status(400).json({ message: '数组中存在缺少必要信息的任务' });
      }
      
      // 检查论文是否存在
      const [papers] = await pool.execute('SELECT * FROM papers WHERE paper_id = ?', [paper_id]);
      if (papers.length === 0) {
        return res.status(404).json({ message: `论文ID ${paper_id} 不存在` });
      }
      
      // 检查专家是否存在
      const [experts] = await pool.execute('SELECT * FROM experts WHERE expert_id = ?', [expert_id]);
      if (experts.length === 0) {
        return res.status(404).json({ message: `专家ID ${expert_id} 不存在` });
      }
      
      // 检查是否已经分配过该专家
      const [existingAssignments] = await pool.execute(
        'SELECT * FROM review_assignments WHERE paper_id = ? AND expert_id = ?',
        [paper_id, expert_id]
      );
      if (existingAssignments.length > 0) {
        return res.status(400).json({ message: `专家ID ${expert_id} 已经被分配到论文ID ${paper_id}` });
      }
      
      // 创建审稿分配记录
      const [result] = await pool.execute(
        `INSERT INTO review_assignments (paper_id, expert_id, editor_id, assigned_due_date, conclusion, status)
         VALUES (?, ?, ?, ?, 'Not Reviewed', 'Assigned')`,
        [paper_id, expert_id, req.user.id, assigned_due_date]
      );
      
      createdAssignments.push({
        paper_id,
        expert_id,
        assignment_id: result.insertId
      });
    }
    
    res.status(201).json({
      message: '审稿任务批量分配成功', 
      created_assignments: createdAssignments
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
    console.error('审稿任务批量分配失败:', error);
  }
});

// 专家标记审稿任务为已读
router.put('/assignments/:id/read', authenticateToken, authorizeRole(['expert']), async (req, res) => {
  try {
    const assignmentId = req.params.id;
    
    // 检查该任务是否分配给当前专家
    const [check] = await pool.execute(
      `SELECT COUNT(*) AS count FROM review_assignments WHERE assignment_id = ? AND expert_id = ?`,
      [assignmentId, req.user.id]
    );
    
    if (check[0].count === 0) {
      return res.status(403).json({ message: '无权处理该审稿任务' });
    }
    
    // 更新is_read状态为1
    await pool.execute(
      `UPDATE review_assignments SET is_read = 1 WHERE assignment_id = ?`,
      [assignmentId]
    );
    
    res.json({ message: '任务已标记为已读' });
  } catch (error) {
    res.status(500).json({ message: error.message });
    console.error('标记任务为已读失败:', error);
  }
});

// 专家提交审稿意见
router.put('/assignments/:id', authenticateToken, authorizeRole(['expert']), async (req, res) => {
  try {
    const assignmentId = req.params.id;
    const { conclusion, positive_comments, negative_comments, modification_advice } = req.body;
    
    // 检查该任务是否分配给当前专家
    const [check] = await pool.execute(
      `SELECT COUNT(*) AS count FROM review_assignments WHERE assignment_id = ? AND expert_id = ?`,
      [assignmentId, req.user.id]
    );
    
    if (check[0].count === 0) {
      return res.status(403).json({ message: '无权处理该审稿任务' });
    }
    
    const [result] = await pool.execute(
      `UPDATE review_assignments 
       SET status = 'Completed', conclusion = ?, positive_comments = ?, negative_comments = ?, modification_advice = ?, submission_date = CURRENT_TIMESTAMP
       WHERE assignment_id = ?`,
      [conclusion, positive_comments, negative_comments, modification_advice, assignmentId]
    );
    
    res.json({ message: '审稿意见提交成功' });
  } catch (error) {
    res.status(500).json({ message: error.message });
    console.error('审稿意见提交失败:', error);
  }
});

// 获取论文的所有审稿意见（编辑和作者）
router.get('/papers/:paperId/comments', authenticateToken, async (req, res) => {
  try {
    const paperId = req.params.paperId;
    
    // 检查用户是否有权限查看
    if (req.user.role === 'author') {
      const [authorCheck] = await pool.execute(
        `SELECT COUNT(*) AS count 
         FROM paper_authors_institutions 
         WHERE paper_id = ? AND author_id = ?`,
        [paperId, req.user.id]
      );
      
      if (authorCheck[0].count === 0) {
        return res.status(403).json({ message: '无权查看该论文的审稿意见' });
      }
    }
    
    const [comments] = await pool.execute(
      `SELECT ra.*, e.name AS expert_name 
       FROM review_assignments ra 
       JOIN experts e ON ra.expert_id = e.expert_id 
       WHERE ra.paper_id = ? AND ra.status = 'Completed'`,
      [paperId]
    );
    
    res.json(comments);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// 编辑获取论文对应的所有审稿专家
router.get('/papers/:paperId/expert', authenticateToken, authorizeRole(['editor']), async (req, res) => {
  try {
    const paperId = req.params.paperId;
    
    // 检查论文是否存在
    const [papers] = await pool.execute('SELECT * FROM papers WHERE paper_id = ?', [paperId]);
    if (papers.length === 0) {
      return res.status(404).json({ message: '论文不存在' });
    }
    
    // 查询论文的当前状态
    const [progress] = await pool.execute(
      'SELECT status FROM paper_progress WHERE paper_id = ?', 
      [paperId]
    );
    
    let editable = false;
    
    if (progress.length > 0) {
      const paperStatus = progress[0].status;
      
      if (paperStatus === 'Reviewing') {
        // 查询review_assignments表中是否存在该论文的对应记录
        const [assignments] = await pool.execute(
          'SELECT COUNT(*) as count FROM review_assignments WHERE paper_id = ?', 
          [paperId]
        );
        if (assignments[0].count === 0) {
          editable = true;
        }
      } else if (paperStatus === 'Second Reviewing') {
        // 查询review_assignments表中该论文的记录数量
        const [assignments] = await pool.execute(
          'SELECT COUNT(*) as count FROM review_assignments WHERE paper_id = ?', 
          [paperId]
        );
        if (assignments[0].count === 3) {
          editable = true;
        }
      } else if (paperStatus === 'Final Reviewing') {
        // 查询review_assignments表中该论文的记录数量
        const [assignments] = await pool.execute(
          'SELECT COUNT(*) as count FROM review_assignments WHERE paper_id = ?', 
          [paperId]
        );
        if (assignments[0].count === 6) {
          editable = true;
        }
      }
    }
    
    // 查询该论文的所有审稿专家分配记录，只获取最近的三条
    const [experts] = await pool.execute(
      `SELECT ra.*, e.name AS expert_name, e.institution_names, e.research_areas 
       FROM review_assignments ra 
       JOIN expert_with_institutions e ON ra.expert_id = e.expert_id 
       WHERE ra.paper_id = ?
       ORDER BY ra.assigned_date DESC`,
      [paperId]
    );
    
    res.json({ experts, editable });
  } catch (error) {
    res.status(500).json({ message: error.message });
    console.error('获取论文审稿专家失败:', error);
  }
});

module.exports = router;