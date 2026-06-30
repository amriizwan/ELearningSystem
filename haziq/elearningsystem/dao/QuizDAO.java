package com.mycompany.elearningsystem.dao;

import com.mycompany.elearningsystem.model.QuizAttemptResult;
import com.mycompany.project.model.Course;
import com.mycompany.project.model.Quiz;
import com.mycompany.project.model.QuizOption;
import com.mycompany.project.model.QuizQuestion;
import com.mycompany.elearningsystem.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data-Access Object for all quiz-related database operations.
 *
 * All SQL that was scattered across quiz.php is centralised here.
 * Only PreparedStatements are used; no dynamic SQL concatenation.
 *
 * NOTE: `question_order` is backtick-quoted throughout because it is a
 * reserved word in MariaDB. Text blocks (""") have been replaced with
 * plain String literals for maximum JDBC / server compatibility.
 */
public class QuizDAO {

    // ════════════════════════════════════════════════════════════════
    //  COURSES
    // ════════════════════════════════════════════════════════════════

    /**
     * Fetch all courses assigned to a lecturer, with the count of quizzes
     * that lecturer has created per course.
     */
    public List<Course> getCoursesByLecturer(int lecturerId) throws SQLException {
        String sql =
            "SELECT c.id, c.title, COUNT(q.id) AS quiz_count " +
            "FROM course_lecturer cl " +
            "JOIN courses c ON c.id = cl.course_id " +
            "LEFT JOIN quizzes q ON q.course_id = c.id AND q.lecturer_id = ? " +
            "WHERE cl.lecturer_id = ? " +
            "GROUP BY c.id " +
            "ORDER BY c.title ASC";

        List<Course> courses = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, lecturerId);
            ps.setInt(2, lecturerId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Course c = new Course();
                    c.setId(rs.getInt("id"));
                    c.setTitle(rs.getString("title"));
                    c.setQuizCount(rs.getInt("quiz_count"));
                    courses.add(c);
                }
            }
        }
        return courses;
    }

    // ════════════════════════════════════════════════════════════════
    //  QUIZZES
    // ════════════════════════════════════════════════════════════════

    /**
     * Fetch quizzes for a course, with aggregated question/attempt stats.
     */
    public List<Quiz> getQuizzesByCourse(int courseId, int lecturerId) throws SQLException {
        String sql =
            "SELECT q.*, " +
            "       COUNT(DISTINCT qq.id) AS question_count, " +
            "       COUNT(DISTINCT qa.id) AS attempt_count, " +
            "       AVG(qa.score)         AS avg_score " +
            "FROM quizzes q " +
            "LEFT JOIN quiz_questions qq ON qq.quiz_id = q.id " +
            "LEFT JOIN quiz_attempts  qa ON qa.quiz_id = q.id AND qa.submitted_at IS NOT NULL " +
            "WHERE q.course_id = ? AND q.lecturer_id = ? " +
            "GROUP BY q.id " +
            "ORDER BY q.created_at DESC";

        List<Quiz> quizzes = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, courseId);
            ps.setInt(2, lecturerId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    quizzes.add(mapQuizRow(rs));
                }
            }
        }
        return quizzes;
    }

    /**
     * Fetch a single quiz by its id, verifying lecturer ownership.
     */
    public Quiz getQuizById(int quizId, int lecturerId) throws SQLException {
        String sql = "SELECT * FROM quizzes WHERE id = ? AND lecturer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quizId);
            ps.setInt(2, lecturerId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapQuizRow(rs);
            }
        }
        return null;
    }

    /**
     * Check whether a quiz_code is already in use (optionally excluding a quiz).
     *
     * @param quizCode  the code to check
     * @param excludeId quiz id to exclude (pass 0 when creating a new quiz)
     */
    public boolean isQuizCodeTaken(String quizCode, int excludeId) throws SQLException {
        String sql = excludeId > 0
                ? "SELECT id FROM quizzes WHERE quiz_code = ? AND id != ?"
                : "SELECT id FROM quizzes WHERE quiz_code = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, quizCode);
            if (excludeId > 0) ps.setInt(2, excludeId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Insert a new quiz. Returns the generated id.
     */
    public int createQuiz(int courseId, int lecturerId, String title, String quizCode) throws SQLException {
        String sql = "INSERT INTO quizzes (course_id, lecturer_id, title, quiz_code) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, courseId);
            ps.setInt(2, lecturerId);
            ps.setString(3, title);
            ps.setString(4, quizCode);
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        }
        return -1;
    }

    /**
     * Update title and quiz_code for a quiz owned by the lecturer.
     */
    public void updateQuiz(int quizId, int lecturerId, String title, String quizCode) throws SQLException {
        String sql = "UPDATE quizzes SET title = ?, quiz_code = ? WHERE id = ? AND lecturer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, title);
            ps.setString(2, quizCode);
            ps.setInt(3, quizId);
            ps.setInt(4, lecturerId);
            ps.executeUpdate();
        }
    }

    /**
     * Delete a quiz (cascade-deletes questions/attempts if FK ON DELETE CASCADE is set).
     */
    public void deleteQuiz(int quizId, int lecturerId) throws SQLException {
        String sql = "DELETE FROM quizzes WHERE id = ? AND lecturer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quizId);
            ps.setInt(2, lecturerId);
            ps.executeUpdate();
        }
    }

    // ════════════════════════════════════════════════════════════════
    //  QUESTIONS
    // ════════════════════════════════════════════════════════════════

    /**
     * Fetch all questions for a quiz, each with its options.
     *
     * `question_order` is backtick-quoted — reserved word in MariaDB.
     */
    public List<QuizQuestion> getQuestionsByQuiz(int quizId) throws SQLException {
        String sql = "SELECT * FROM quiz_questions WHERE quiz_id = ? ORDER BY `question_order` ASC";

        List<QuizQuestion> questions = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quizId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    QuizQuestion q = mapQuestionRow(rs);
                    q.setOptions(getOptionsByQuestion(conn, q.getId()));
                    questions.add(q);
                }
            }
        }
        return questions;
    }

    /**
     * Add a question plus its options inside a single transaction.
     *
     * @param quizId       owner quiz
     * @param questionText question body
     * @param questionType "multiple_choice" | "true_false"
     * @param marks        mark value
     * @param optionTexts  list of option strings
     * @param correctIndex index (0-based) of the correct option
     */
    public void addQuestion(int quizId, String questionText, String questionType,
                            int marks, List<String> optionTexts, int correctIndex) throws SQLException {

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int nextOrder = getNextQuestionOrder(conn, quizId);

                // Insert question
                int questionId;
                String insertQ =
                    "INSERT INTO quiz_questions (quiz_id, question_text, question_type, marks, `question_order`) " +
                    "VALUES (?, ?, ?, ?, ?)";

                try (PreparedStatement ps = conn.prepareStatement(insertQ, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, quizId);
                    ps.setString(2, questionText);
                    ps.setString(3, questionType);
                    ps.setInt(4, marks);
                    ps.setInt(5, nextOrder);
                    ps.executeUpdate();
                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        keys.next();
                        questionId = keys.getInt(1);
                    }
                }

                // Insert options as a batch
                String insertOpt = "INSERT INTO quiz_options (question_id, option_text, is_correct) VALUES (?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(insertOpt)) {
                    for (int i = 0; i < optionTexts.size(); i++) {
                        String text = optionTexts.get(i).trim();
                        if (!text.isEmpty()) {
                            ps.setInt(1, questionId);
                            ps.setString(2, text);
                            ps.setBoolean(3, i == correctIndex);
                            ps.addBatch();
                        }
                    }
                    ps.executeBatch();
                }

                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    /**
     * Delete a question, verifying lecturer ownership via a JOIN rather than
     * a subquery — MariaDB rejects modifying a table referenced in a subquery
     * in the same statement.
     *
     * PHP equivalent:
     *   DELETE FROM quiz_questions WHERE id = ?
     *   AND quiz_id IN (SELECT id FROM quizzes WHERE lecturer_id = ?)
     */
    public void deleteQuestion(int questionId, int lecturerId) throws SQLException {
        // Use a JOIN-based DELETE which MariaDB handles correctly.
        String sql =
            "DELETE qq " +
            "FROM quiz_questions qq " +
            "JOIN quizzes qz ON qz.id = qq.quiz_id " +
            "WHERE qq.id = ? AND qz.lecturer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, questionId);
            ps.setInt(2, lecturerId);
            ps.executeUpdate();
        }
    }

    // ════════════════════════════════════════════════════════════════
    //  RESULTS
    // ════════════════════════════════════════════════════════════════

    /**
     * Fetch all submitted attempts for a quiz, ordered by score descending.
     */
    public List<QuizAttemptResult> getResultsByQuiz(int quizId) throws SQLException {
        String sql =
            "SELECT qa.id, qa.score, qa.submitted_at, " +
            "       u.name AS student_name, " +
            "       COUNT(qq.id) AS total_questions " +
            "FROM quiz_attempts qa " +
            "JOIN users u ON u.id = qa.student_id " +
            "LEFT JOIN quiz_questions qq ON qq.quiz_id = qa.quiz_id " +
            "WHERE qa.quiz_id = ? AND qa.submitted_at IS NOT NULL " +
            "GROUP BY qa.id, qa.score, qa.submitted_at, u.name " +
            "ORDER BY qa.score DESC";

        List<QuizAttemptResult> results = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quizId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    QuizAttemptResult r = new QuizAttemptResult();
                    r.setAttemptId(rs.getInt("id"));
                    r.setScore(rs.getInt("score"));
                    r.setTotalQuestions(rs.getInt("total_questions"));
                    r.setStudentName(rs.getString("student_name"));
                    Timestamp ts = rs.getTimestamp("submitted_at");
                    if (ts != null) r.setSubmittedAt(ts.toLocalDateTime());
                    results.add(r);
                }
            }
        }
        return results;
    }

    // ════════════════════════════════════════════════════════════════
    //  PRIVATE HELPERS
    // ════════════════════════════════════════════════════════════════

    /** Load options for a question, reusing an existing connection. */
    private List<QuizOption> getOptionsByQuestion(Connection conn, int questionId) throws SQLException {
        String sql = "SELECT * FROM quiz_options WHERE question_id = ?";
        List<QuizOption> options = new ArrayList<>();

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    QuizOption opt = new QuizOption();
                    opt.setId(rs.getInt("id"));
                    opt.setQuestionId(rs.getInt("question_id"));
                    opt.setOptionText(rs.getString("option_text"));
                    opt.setCorrect(rs.getBoolean("is_correct"));
                    options.add(opt);
                }
            }
        }
        return options;
    }

    /**
     * Return the next question_order value for a quiz.
     * `question_order` backtick-quoted for MariaDB compatibility.
     */
    private int getNextQuestionOrder(Connection conn, int quizId) throws SQLException {
        String sql = "SELECT COALESCE(MAX(`question_order`), 0) + 1 AS next_order " +
                     "FROM quiz_questions WHERE quiz_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt("next_order") : 1;
            }
        }
    }

    /** Map a ResultSet row to a Quiz object. */
    private Quiz mapQuizRow(ResultSet rs) throws SQLException {
        Quiz q = new Quiz();
        q.setId(rs.getInt("id"));
        q.setCourseId(rs.getInt("course_id"));
        q.setLecturerId(rs.getInt("lecturer_id"));
        q.setTitle(rs.getString("title"));
        q.setQuizCode(rs.getString("quiz_code"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) q.setCreatedAt(ts.toLocalDateTime());

        // Aggregated columns present only in some queries — silently ignore if absent
        try { q.setQuestionCount(rs.getInt("question_count")); } catch (SQLException ignored) {}
        try { q.setAttemptCount(rs.getInt("attempt_count"));   } catch (SQLException ignored) {}
        try { q.setAvgScore(rs.getDouble("avg_score"));        } catch (SQLException ignored) {}

        return q;
    }

    /** Map a ResultSet row to a QuizQuestion object. */
    private QuizQuestion mapQuestionRow(ResultSet rs) throws SQLException {
        QuizQuestion q = new QuizQuestion();
        q.setId(rs.getInt("id"));
        q.setQuizId(rs.getInt("quiz_id"));
        q.setQuestionText(rs.getString("question_text"));
        q.setQuestionType(rs.getString("question_type"));
        q.setMarks(rs.getInt("marks"));
        q.setQuestionOrder(rs.getInt("question_order"));
        return q;
    }
}
