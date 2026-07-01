package com.mycompany.elearningsystem.dao;

import com.mycompany.elearningsystem.model.Quiz;
import com.mycompany.elearningsystem.model.QuizAnswer;
import com.mycompany.elearningsystem.model.QuizAttempt;
import com.mycompany.elearningsystem.model.QuizOption;
import com.mycompany.elearningsystem.model.QuizQuestion;
import com.mycompany.elearningsystem.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class QuizDAO {
    public List<Quiz> getQuizList(int studentId){
        List<Quiz> quizzes = new ArrayList<>();

        String sql = 
                "SELECT q.id, q.title, q.created_at, " +
                "c.title AS course_title, " +
                "u.name  AS lecturer_name, " +
                "COUNT(DISTINCT qq.id) AS question_count, " +
                "qa.id            AS attempt_id, " +
                "qa.score         AS score, " +
                "qa.submitted_at  AS submitted_at " +
                "FROM quizzes q " +
                "JOIN enrollments e ON e.course_id = q.course_id AND e.student_id = ? " +
                "JOIN courses c     ON c.id = q.course_id " +
                "JOIN users u       ON u.id = q.lecturer_id " +
                "LEFT JOIN quiz_questions qq ON qq.quiz_id = q.id " +
                "LEFT JOIN quiz_attempts  qa ON qa.quiz_id = q.id AND qa.student_id = ? " +
                "GROUP BY q.id " +
                "ORDER BY qa.submitted_at IS NOT NULL ASC, q.created_at DESC";

        try {
            Connection conn = DBConnection.getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, studentId);
            ps.setInt(2, studentId);

            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Quiz quiz = new Quiz();

                quiz.setId(rs.getInt("id"));
                quiz.setTitle(rs.getString("title"));
                quiz.setCreatedAt(rs.getTimestamp("created_at"));
                quiz.setCourseTitle(rs.getString("course_title"));
                quiz.setLectName(rs.getString("lecturer_name"));
                quiz.setQuestionCount(rs.getInt("question_count"));
                
                QuizAttempt qat = null;
                Integer attemptId = (Integer) rs.getObject("attempt_id");
                if (attemptId != null) {
                    qat = new QuizAttempt();
                    qat.setId(attemptId);
                    qat.setScore(rs.getInt("score"));
                    qat.setSubmittedAt(rs.getTimestamp("submitted_at"));
                    quiz.setQuizAttempt(qat);
                }

                quiz.setQuizAttempt(qat);
                quizzes.add(quiz);
            }

        } catch(SQLException e) {
            e.printStackTrace();
            System.out.println("SQL ERROR: " + e.getMessage());
        }

        return quizzes;
    }
    
    public Quiz getQuizDetails(int quizId){
        Quiz quizDetails = null;

        String sql = 
                "SELECT q.*, c.title AS course_title, u.name AS lecturer_name,\n" +
                "COUNT(qq.id) AS question_count\n" +
                "FROM quizzes q\n" +
                "JOIN courses c ON c.id = q.course_id\n" +
                "JOIN users u   ON u.id = q.lecturer_id\n" +
                "LEFT JOIN quiz_questions qq ON qq.quiz_id = q.id\n" +
                "WHERE q.id = ?\n" +
                "GROUP BY q.id";

        try {
            Connection conn = DBConnection.getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, quizId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                quizDetails = new Quiz();

                quizDetails.setId(rs.getInt("id"));
                quizDetails.setTitle(rs.getString("title"));
                quizDetails.setCreatedAt(rs.getTimestamp("created_at"));
                quizDetails.setCourseId(rs.getInt("course_id"));
                quizDetails.setLecturerId(rs.getInt("lecturer_id"));
                quizDetails.setQuizCode(rs.getString("quiz_code"));

                quizDetails.setCourseTitle(rs.getString("course_title"));
                quizDetails.setLectName(rs.getString("lecturer_name"));
                quizDetails.setQuestionCount(rs.getInt("question_count"));
            }

        } catch(SQLException e) {
            e.printStackTrace();
            System.out.println("SQL ERROR: " + e.getMessage());
        }

        return quizDetails;
    }
    
    public boolean isValidAttempt(int attemptId, int studentId) {
        boolean valid = false;

        String sql = 
                "SELECT 1\n" +
                "FROM quiz_attempts\n" +
                "WHERE id = ?\n" +
                "AND student_id = ?\n" +
                "AND submitted_at IS NULL";

        try {
            Connection conn = DBConnection.getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, attemptId);
            ps.setInt(2, studentId);

            ResultSet rs = ps.executeQuery();

            valid = rs.next();

        } catch(SQLException e) {
            e.printStackTrace();
            System.out.println("SQL ERROR: " + e.getMessage());
        }

        return valid;
    }
    
    public List<QuizQuestion> getQuestions(int quizId, int attemptId){
        List<QuizQuestion> questions = new ArrayList<>();

        String questionSql =
            "SELECT * FROM quiz_questions " +
            "WHERE quiz_id = ? " +
            "ORDER BY question_order ASC, id ASC";

        String optionSql =
            "SELECT id, option_text " +
            "FROM quiz_options " +
            "WHERE question_id = ?";

        String answerSql =
            "SELECT selected_option_id " +
            "FROM quiz_answers " +
            "WHERE attempt_id = ? AND question_id = ?";

        try {
            Connection conn = DBConnection.getConnection();

            PreparedStatement questionPs = conn.prepareStatement(questionSql);
            PreparedStatement optionPs = conn.prepareStatement(optionSql);
            PreparedStatement answerPs = conn.prepareStatement(answerSql);

            questionPs.setInt(1, quizId);

            ResultSet questionRs = questionPs.executeQuery();

            while (questionRs.next()) {

                QuizQuestion question = new QuizQuestion();

                question.setId(questionRs.getInt("id"));
                question.setQuizId(questionRs.getInt("quiz_id"));
                question.setQuestionText(questionRs.getString("question_text"));
                question.setQuestionType(questionRs.getString("question_type"));
                question.setMarks(questionRs.getInt("marks"));
                question.setQuestionOrder(questionRs.getInt("question_order"));

                // ---------- Options ----------
                List<QuizOption> options = new ArrayList<>();

                optionPs.setInt(1, question.getId());

                ResultSet optionRs = optionPs.executeQuery();

                while (optionRs.next()) {

                    QuizOption option = new QuizOption();

                    option.setId(optionRs.getInt("id"));
                    option.setOptionText(optionRs.getString("option_text"));

                    options.add(option);
                }

                question.setOptions(options);

                // ---------- Saved Answer ----------
                answerPs.setInt(1, attemptId);
                answerPs.setInt(2, question.getId());

                ResultSet answerRs = answerPs.executeQuery();

                if (answerRs.next()) {
                    question.setSavedAnswer(answerRs.getInt("selected_option_id"));
                }

                questions.add(question);
            }

        } catch(SQLException e) {
            e.printStackTrace();
            System.out.println("SQL ERROR: " + e.getMessage());
        }

        return questions;
    }
    
    public Quiz getQuizByCode(String quizCode){
        
        Quiz quiz = null;

        String sql = 
                "SELECT id, course_id\n" +
                "FROM quizzes\n" +
                "WHERE quiz_code = ?";

        try {
            Connection conn = DBConnection.getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, quizCode);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                quiz = new Quiz();

                quiz.setId(rs.getInt("id"));
                quiz.setCourseId(rs.getInt("course_id"));
            }

        } catch(SQLException e) {
            e.printStackTrace();
            System.out.println("SQL ERROR: " + e.getMessage());
        }

        return quiz;
    }
    
    public boolean isStudentEnrolled(int studentId, int courseId) {
        
        boolean valid = false;

        String sql = 
                "SELECT 1\n" +
                "FROM enrollments\n" +
                "WHERE student_id = ?\n" +
                "AND course_id = ?";

        try {
            Connection conn = DBConnection.getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, studentId);
            ps.setInt(2, courseId);

            ResultSet rs = ps.executeQuery();

            valid = rs.next();

        } catch(SQLException e) {
            e.printStackTrace();
            System.out.println("SQL ERROR: " + e.getMessage());
        }

        return valid;
    }
    
    public QuizAttempt getStudentAttempt(int quizId, int studentId) {
        
        QuizAttempt attempt = null;

        String sql = 
                "SELECT *\n" +
                "FROM quiz_attempts\n" +
                "WHERE quiz_id = ?\n" +
                "AND student_id = ?";

        try {
            Connection conn = DBConnection.getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, quizId);
            ps.setInt(2, studentId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                attempt = new QuizAttempt();

                attempt.setId(rs.getInt("id"));
                attempt.setQuizId(rs.getInt("quiz_id"));
                attempt.setStudentId(rs.getInt("student_id"));
                attempt.setScore(rs.getInt("score"));
                attempt.setStartedAt(rs.getTimestamp("started_at"));
                attempt.setSubmittedAt(rs.getTimestamp("submitted_at"));
            }

        } catch(SQLException e) {
            e.printStackTrace();
            System.out.println("SQL ERROR: " + e.getMessage());
        }
        
        return attempt;
    }
    
    public int createAttempt(int quizId, int studentId){
        
        String sql = "INSERT INTO quiz_attempts (quiz_id, student_id) VALUES (?, ?)";

        try {
            Connection conn = DBConnection.getConnection();

            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            ps.setInt(1, quizId);
            ps.setInt(2, studentId);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();

                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;  
    }
    
    public QuizAttempt getQuizResult(int attemptId, int studentId) {
        
        QuizAttempt result = null;

        String sql = 
                "SELECT qa.score, qa.submitted_at,\n" +
                "q.title, c.title AS course_title, u.name AS lecturer_name,\n" +
                "COUNT(qq.id) AS total_questions\n" +
                "FROM quiz_attempts qa\n" +
                "JOIN quizzes q       ON q.id = qa.quiz_id\n" +
                "JOIN courses c       ON c.id = q.course_id\n" +
                "JOIN users u         ON u.id = q.lecturer_id\n" +
                "LEFT JOIN quiz_questions qq ON qq.quiz_id = q.id\n" +
                "WHERE qa.id = ? AND qa.student_id = ?\n" +
                "GROUP BY qa.id";

        try {
            Connection conn = DBConnection.getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, attemptId);
            ps.setInt(2, studentId);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                result = new QuizAttempt();

                result.setScore(rs.getInt("score"));
                result.setSubmittedAt(rs.getTimestamp("submittedAt"));
                result.setQuizTitle(rs.getString("title"));
                result.setCourseTitle(rs.getString("course_title"));
                result.setLectName(rs.getString("lecturer_name"));
                result.setTotalQuestions(rs.getInt("total_questions"));
            }

        } catch(SQLException e) {
            e.printStackTrace();
            System.out.println("SQL ERROR: " + e.getMessage());
        }
        
        return result;
    }
    
    public List<QuizAnswer> getAnswerBreakdown(int attemptId) {
        List<QuizAnswer> answers = new ArrayList<>();

        String sql = 
                "SELECT qq.question_text,\n" +
                "qo.option_text  AS selected_option,\n" +
                "qo.is_correct   AS selected_correct,\n" +
                "correct_opt.option_text AS correct_option\n" +
                "FROM quiz_answers ans\n" +
                "JOIN quiz_questions qq ON qq.id = ans.question_id\n" +
                "JOIN quiz_options   qo ON qo.id = ans.selected_option_id\n" +
                "JOIN quiz_options correct_opt ON correct_opt.question_id = qq.id AND correct_opt.is_correct = 1\n" +
                "WHERE ans.attempt_id = ?\n" +
                "ORDER BY qq.question_order ASC";

        try {
            Connection conn = DBConnection.getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, attemptId);

            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                QuizAnswer answer = new QuizAnswer();

                answer.setQuestionText(rs.getString("queston_text"));
                answer.setSelectedOption(rs.getString("selected_option"));
                answer.setSelectedCorrect(rs.getBoolean("selected_correct"));
                answer.setCorrectOption(rs.getString("correct_option"));

                answers.add(answer);
            }

        } catch(SQLException e) {
            e.printStackTrace();
            System.out.println("SQL ERROR: " + e.getMessage());
        }

        return answers;
    }
    
    public boolean isCorrectOption(int questionId, int optionId) {
        boolean valid = false;
        
        try {
            Connection conn = DBConnection.getConnection();

            String sql =
                "SELECT is_correct " +
                "FROM quiz_options " +
                "WHERE id = ? " +
                "AND question_id = ?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, optionId);
            ps.setInt(2, questionId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getBoolean("is_correct");
            }

            return false;

        } catch(SQLException e) {
            e.printStackTrace();
            System.out.println("SQL ERROR: " + e.getMessage());
        }

        return valid;
    }
    
    public void saveAnswer(int attemptId, int questionId, int optionId, boolean correct) {
        
        try {
            Connection conn = DBConnection.getConnection();
            
            String sql =
                "INSERT IGNORE INTO quiz_answers " +
                "(attempt_id, question_id, selected_option_id, is_correct) " +
                "VALUES (?, ?, ?, ?)";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, attemptId);
            ps.setInt(2, questionId);
            ps.setInt(3, optionId);
            ps.setBoolean(4, correct);

            ps.executeUpdate();

        } catch(SQLException ex) {
            ex.printStackTrace();
        }
    }
    
    public void submitQuiz(int attemptId, int score) {
        try {
            Connection conn = DBConnection.getConnection();
            
            String sql =
                "UPDATE quiz_attempts " +
                "SET score = ?, submitted_at = NOW() " +
                "WHERE id = ?";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, score);
            ps.setInt(2, attemptId);

            ps.executeUpdate();

        } catch(SQLException ex) {
            ex.printStackTrace();
        }
    }
    
    
}
