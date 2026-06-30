package com.mycompany.elearningsystem.controller;

import com.mycompany.elearningsystem.dao.QuizDAO;
import com.mycompany.elearningsystem.model.QuizAttemptResult;
import com.mycompany.project.model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

/**
 * Servlet controller for the Lecturer Quiz management page.
 *
 * URL mapping: /quiz
 *
 * Replaces the entire quiz.php PHP file's server-side logic.
 * All views are dispatched to quiz.jsp; the active "view" is
 * determined by the "view" query parameter (list | new | edit | questions | results).
 */
@WebServlet("/quiz")
public class QuizServlet extends HttpServlet {

    private final QuizDAO quizDAO = new QuizDAO();

    // ════════════════════════════════════════════════════════════════
    //  GET — load data and forward to JSP
    // ════════════════════════════════════════════════════════════════

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // ── Auth guard (replaces auth_guard.php) ──
        if (!isLecturer(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int lecturerId = (int) session.getAttribute("userId");

        // ── Parse URL parameters ──
        int    courseId = parseIntParam(request, "course_id", 0);
        int    quizId   = parseIntParam(request, "quiz_id",   0);
        String view     = getStringParam(request, "view",      "list");
        String urlMsg   = getStringParam(request, "msg",       "");

        try {
            // ── Fetch lecturer's courses ──
            List<Course> courses = quizDAO.getCoursesByLecturer(lecturerId);

            // Default to first course if none selected
            if (courseId == 0 && !courses.isEmpty()) {
                courseId = courses.get(0).getId();
            }

            // ── Fetch quizzes for the selected course ──
            List<Quiz> quizzes = courseId > 0
                    ? quizDAO.getQuizzesByCourse(courseId, lecturerId)
                    : List.of();

            // ── Fetch selected quiz ──
            Quiz selectedQuiz = quizId > 0
                    ? quizDAO.getQuizById(quizId, lecturerId)
                    : null;

            // ── Fetch questions (for questions view) ──
            List<QuizQuestion> questions = List.of();
            if (quizId > 0 && "questions".equals(view)) {
                questions = quizDAO.getQuestionsByQuiz(quizId);
            }

            // ── Fetch results (for results view) ──
            List<QuizAttemptResult> results = List.of();
            ResultStats stats = null;
            if (quizId > 0 && "results".equals(view)) {
                results = quizDAO.getResultsByQuiz(quizId);
                if (!results.isEmpty()) {
                    stats = computeStats(results);
                }
            }

            // ── Find selected course object ──
           Course selectedCourse = null;

            for (Course c : courses) {
                if (c.getId() == courseId) {
                    selectedCourse = c;
                    break;
                }
            }

            // ── Set request attributes for the JSP ──
            request.setAttribute("courses",        courses);
            request.setAttribute("quizzes",        quizzes);
            request.setAttribute("selectedCourse", selectedCourse);
            request.setAttribute("selectedQuiz",   selectedQuiz);
            request.setAttribute("questions",      questions);
            request.setAttribute("results",        results);
            request.setAttribute("stats",          stats);
            request.setAttribute("view",           view);
            request.setAttribute("courseId",       courseId);
            request.setAttribute("quizId",         quizId);
            request.setAttribute("urlMsg",         urlMsg);
            // Supply a pre-generated code for the "new quiz" form
            request.setAttribute("generatedCode",  generateCode());

            request.getRequestDispatcher("/WEB-INF/view/lecture/quiz.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Database error loading quiz page", e);
        }
    }

    // ════════════════════════════════════════════════════════════════
    //  POST — handle form submissions
    // ════════════════════════════════════════════════════════════════

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
//        if (!isLecturer(session)) {
//            response.sendRedirect(request.getContextPath() + "/login");
//            return;
//        }

        int    lecturerId = (int) session.getAttribute("userId");
        String action     = getStringParam(request, "action", "");

        try {
            switch (action) {
            case "create_quiz":
                handleCreateQuiz(request, response, lecturerId);
                break;

            case "edit_quiz":
                handleEditQuiz(request, response, lecturerId);
                break;

            case "delete_quiz":
                handleDeleteQuiz(request, response, lecturerId);
                break;

            case "add_question":
                handleAddQuestion(request, response, lecturerId);
                break;

            case "delete_question":
                handleDeleteQuestion(request, response, lecturerId);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/quiz");
                break;
        }
        } catch (SQLException e) {
            throw new ServletException("Database error during POST action: " + action, e);
        }
    }

    // ════════════════════════════════════════════════════════════════
    //  ACTION HANDLERS
    // ════════════════════════════════════════════════════════════════

    /**
     * Handle CREATE QUIZ form submission.
     * PHP: action === 'create_quiz'
     */
    private void handleCreateQuiz(HttpServletRequest req, HttpServletResponse resp,
                                  int lecturerId) throws SQLException, IOException, ServletException {

        int    courseId = parseIntParam(req, "course_id", 0);
        String title    = getStringParam(req, "title",     "").trim();
        String code     = getStringParam(req, "quiz_code", "").trim().toUpperCase();

        // ── Validate ──
        if (courseId == 0 || title.isEmpty() || code.isEmpty()) {
            forwardWithError(req, resp, "Please fill in all fields.",
                    "/quiz?course_id=" + courseId + "&view=new");
            return;
        }
        if (code.length() != 6 || !code.matches("[A-Z0-9]{6}")) {
            forwardWithError(req, resp, "Quiz code must be exactly 6 alphanumeric characters.",
                    "/quiz?course_id=" + courseId + "&view=new");
            return;
        }
        if (quizDAO.isQuizCodeTaken(code, 0)) {
            forwardWithError(req, resp, "That quiz code is already taken. Choose another.",
                    "/quiz?course_id=" + courseId + "&view=new");
            return;
        }

        int newId = quizDAO.createQuiz(courseId, lecturerId, title, code);
        resp.sendRedirect(req.getContextPath()
                + "/quiz?course_id=" + courseId + "&quiz_id=" + newId + "&view=questions&msg=created");
    }

    /**
     * Handle EDIT QUIZ form submission.
     * PHP: action === 'edit_quiz'
     */
    private void handleEditQuiz(HttpServletRequest req, HttpServletResponse resp,
                                int lecturerId) throws SQLException, IOException, ServletException {

        int    quizId   = parseIntParam(req, "quiz_id",   0);
        int    courseId = parseIntParam(req, "course_id", 0);
        String title    = getStringParam(req, "title",     "").trim();
        String code     = getStringParam(req, "quiz_code", "").trim().toUpperCase();

        if (quizId == 0 || title.isEmpty() || code.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/quiz?course_id=" + courseId);
            return;
        }

        if (quizDAO.isQuizCodeTaken(code, quizId)) {
            forwardWithError(req, resp, "That quiz code is already taken.",
                    "/quiz?course_id=" + courseId + "&quiz_id=" + quizId + "&view=edit");
            return;
        }

        quizDAO.updateQuiz(quizId, lecturerId, title, code);
        resp.sendRedirect(req.getContextPath() + "/quiz?course_id=" + courseId + "&msg=edited");
    }

    /**
     * Handle DELETE QUIZ form submission.
     * PHP: action === 'delete_quiz'
     */
    private void handleDeleteQuiz(HttpServletRequest req, HttpServletResponse resp,
                                  int lecturerId) throws SQLException, IOException {

        int quizId   = parseIntParam(req, "quiz_id",   0);
        int courseId = parseIntParam(req, "course_id", 0);

        if (quizId > 0) {
            quizDAO.deleteQuiz(quizId, lecturerId);
        }
        resp.sendRedirect(req.getContextPath() + "/quiz?course_id=" + courseId + "&msg=deleted");
    }

    /**
     * Handle ADD QUESTION form submission.
     * PHP: action === 'add_question'
     */
    private void handleAddQuestion(HttpServletRequest req, HttpServletResponse resp,
                                   int lecturerId) throws SQLException, IOException, ServletException {

        int    quizId       = parseIntParam(req, "quiz_id",       0);
        int    courseId     = parseIntParam(req, "course_id",     0);
        String questionText = getStringParam(req, "question_text", "").trim();
        String questionType = getStringParam(req, "question_type", "multiple_choice");
        int    marks        = parseIntParam(req, "marks",          1);
        int    correctIndex = parseIntParam(req, "correct",        0);
        String[] rawOptions = req.getParameterValues("options[]");

        List<String> options = rawOptions != null ? Arrays.asList(rawOptions) : List.of();

        if (quizId == 0 || questionText.isEmpty() || options.isEmpty()) {
            forwardWithError(req, resp, "Please fill in the question and all options.",
                    "/quiz?course_id=" + courseId + "&quiz_id=" + quizId + "&view=questions");
            return;
        }

        quizDAO.addQuestion(quizId, questionText, questionType, marks, options, correctIndex);
        resp.sendRedirect(req.getContextPath()
                + "/quiz?course_id=" + courseId + "&quiz_id=" + quizId + "&view=questions&msg=question_added");
    }

    /**
     * Handle DELETE QUESTION form submission.
     * PHP: action === 'delete_question'
     */
    private void handleDeleteQuestion(HttpServletRequest req, HttpServletResponse resp,
                                      int lecturerId) throws SQLException, IOException {

        int questionId = parseIntParam(req, "question_id", 0);
        int quizId     = parseIntParam(req, "quiz_id",     0);
        int courseId   = parseIntParam(req, "course_id",   0);

        if (questionId > 0) {
            quizDAO.deleteQuestion(questionId, lecturerId);
        }
        resp.sendRedirect(req.getContextPath()
                + "/quiz?course_id=" + courseId + "&quiz_id=" + quizId + "&view=questions");
    }

    // ════════════════════════════════════════════════════════════════
    //  HELPERS
    // ════════════════════════════════════════════════════════════════

    /** Re-run the GET handler after setting an error message attribute. */
    private void forwardWithError(HttpServletRequest req, HttpServletResponse resp,
                                  String message, String getUrl) throws ServletException, IOException {
        req.setAttribute("errorMessage", message);
        // Redirect to GET so the user sees the form with the error message.
        // We store the error in the session so it survives the redirect.
        req.getSession().setAttribute("flashError", message);
        resp.sendRedirect(req.getContextPath() + getUrl);
    }

    /** Check that the session exists and the user has the "lecturer" role. */
    private boolean isLecturer(HttpSession session) {
        if (session == null) return false;
        return "lecturer".equals(session.getAttribute("role"));
    }

    /** Parse an int parameter, returning defaultVal on failure. */
    private int parseIntParam(HttpServletRequest req, String name, int defaultVal) {
        try {
            String val = req.getParameter(name);
            return (val != null && !val.isBlank()) ? Integer.parseInt(val.trim()) : defaultVal;
        } catch (NumberFormatException e) {
            return defaultVal;
        }
    }

    /** Return a string parameter, falling back to defaultVal if absent. */
    private String getStringParam(HttpServletRequest req, String name, String defaultVal) {
        String val = req.getParameter(name);
        return (val != null) ? val : defaultVal;
    }

    /**
     * Generate a random 6-character alphanumeric code (server-side fallback).
     * PHP: generate_code()
     */
    private String generateCode() {
        String chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
        StringBuilder sb = new StringBuilder(6);
        for (int i = 0; i < 6; i++) {
            sb.append(chars.charAt((int) (Math.random() * chars.length())));
        }
        return sb.toString();
    }

    /**
     * Compute average / high / low percentages from a result list.
     * PHP: $scores, $pcts, $avg_pct, $high, $low computed inline.
     */
    private ResultStats computeStats(List<QuizAttemptResult> results) {
        int sum = 0, high = 0, low = 100;
        for (QuizAttemptResult r : results) {
            int pct = r.getPercentage();
            sum += pct;
            if (pct > high) high = pct;
            if (pct < low)  low  = pct;
        }
        return new ResultStats(
                (int) Math.round((double) sum / results.size()),
                high,
                low
        );
    }

    /**
     * Simple value holder for aggregated result stats.
     * Exposed to JSP as ${stats.avgPct} etc.
     */
    public static class ResultStats {
        private final int avgPct;
        private final int highPct;
        private final int lowPct;

        public ResultStats(int avgPct, int highPct, int lowPct) {
            this.avgPct  = avgPct;
            this.highPct = highPct;
            this.lowPct  = lowPct;
        }

        public int getAvgPct()  { return avgPct; }
        public int getHighPct() { return highPct; }
        public int getLowPct()  { return lowPct; }
    }
}
