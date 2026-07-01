package com.mycompany.elearningsystem.controller;

import com.mycompany.elearningsystem.model.Quiz;
import com.mycompany.elearningsystem.model.QuizAnswer;
import com.mycompany.elearningsystem.model.QuizAttempt;
import com.mycompany.elearningsystem.dao.QuizDAO;
import com.mycompany.elearningsystem.model.Course;
import com.mycompany.elearningsystem.model.QuizAttemptResult;
import com.mycompany.elearningsystem.model.QuizQuestion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/quiz")
public class QuizServlet extends HttpServlet {

    private final QuizDAO quizDAO = new QuizDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        
        
        if ("student".equals(role)) {
            String screen = request.getParameter("screen");
            int quizId = 0;
            int attemptId = 0;       
            if(screen == null){
                screen = "list";
            }

            switch(screen){
                case "entry":       
                    quizId = Integer.parseInt(request.getParameter("quiz_id"));

                    Quiz quizDetails = quizDAO.getQuizDetails(quizId);
                    request.setAttribute("quizDetails", quizDetails);
                    request.setAttribute("quizId", quizId);
                    break;

                case "quiz":
                    quizId = Integer.parseInt(request.getParameter("quiz_id"));

                    attemptId = Integer.parseInt(request.getParameter("attempt_id"));

                    Quiz quizInfo = quizDAO.getQuizDetails(quizId);
                    List<QuizQuestion> questions = quizDAO.getQuestions(quizId, attemptId);

                    request.setAttribute("quizInfo", quizInfo);
                    request.setAttribute("questions", questions);
                    request.setAttribute("quizId", quizId);
                    request.setAttribute("attemptId", attemptId);
                    break;

                case "result":
                    attemptId = Integer.parseInt(request.getParameter("attempt_id"));

                    QuizAttempt resultData = quizDAO.getQuizResult(attemptId, userId);

                    List<QuizAnswer> answersbd = quizDAO.getAnswerBreakdown(attemptId);

                    request.setAttribute("resultData", resultData);
                    request.setAttribute("answersbd", answersbd);
                    break;

                default:
                    List<Quiz> quizzes = quizDAO.getQuizList(userId);
                    request.setAttribute("quizzes", quizzes);
            }

            request.setAttribute("screen", screen);
            request.getRequestDispatcher("WEB-INF/views/student/quiz.jsp").forward(request,response);
        }else if("lecturer".equals(role)){
            
            int lecturerId = (int) session.getAttribute("userId");

            // ── Parse URL parameters ──
            int    courseId = parseIntParam(request, "course_id", 0);
            int    quizId   = parseIntParam(request, "quiz_id",   0);
            String view     = getStringParam(request, "view",      "list");
            String urlMsg   = getStringParam(request, "msg",       "");

            
            // ── Fetch lecturer's courses ──
            List<Course> courses = null;
            try {
                courses = quizDAO.getCoursesByLecturer(lecturerId);
            } catch (SQLException ex) {
                Logger.getLogger(QuizServlet.class.getName()).log(Level.SEVERE, null, ex);
            }

            // Default to first course if none selected
            if (courseId == 0 && !courses.isEmpty()) {
                courseId = courses.get(0).getId();
            }

            // ── Fetch quizzes for the selected course ──
            List<Quiz> quizzes = null;
            try {
                quizzes = courseId > 0
                        ? quizDAO.getQuizzesByCourse(courseId, lecturerId)
                        : List.of();
            } catch (SQLException ex) {
                Logger.getLogger(QuizServlet.class.getName()).log(Level.SEVERE, null, ex);
            }

            // ── Fetch selected quiz ──
            Quiz selectedQuiz = null;
            try {
                selectedQuiz = quizId > 0
                        ? quizDAO.getQuizById(quizId, lecturerId)
                        : null;
            } catch (SQLException ex) {
                Logger.getLogger(QuizServlet.class.getName()).log(Level.SEVERE, null, ex);
            }

            // ── Fetch questions (for questions view) ──
            List<QuizQuestion> questions = List.of();
            if (quizId > 0 && "questions".equals(view)) {
                try {
                    questions = quizDAO.getQuestionsByQuiz(quizId);
                } catch (SQLException ex) {
                    Logger.getLogger(QuizServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            // ── Fetch results (for results view) ──
            List<QuizAttemptResult> results = List.of();
            ResultStats stats = null;
            if (quizId > 0 && "results".equals(view)) {
                try {
                    results = quizDAO.getResultsByQuiz(quizId);
                } catch (SQLException ex) {
                    Logger.getLogger(QuizServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
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

            request.getRequestDispatcher("/WEB-INF/views/lecturer/quiz.jsp").forward(request, response);
            
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
        
        
        

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        
        
        if ("student".equals(role)) {
            //--------------------------------------------------
        // Enter Quiz Code
        //--------------------------------------------------
        if (request.getParameter("enter_code") != null) {

            int quizId = Integer.parseInt(request.getParameter("quiz_id"));

            String code = request.getParameter("quiz_code");

            if (code == null || code.isBlank()) {
                session.setAttribute("error", "Please enter the quiz code.");

                Quiz quizDetails = quizDAO.getQuizDetails(quizId);

                request.setAttribute("quizDetails", quizDetails);
                request.setAttribute("quizId", quizId);
                request.setAttribute("screen", "entry");

                request.getRequestDispatcher("/WEB-INF/views/student/quiz.jsp")
                        .forward(request, response);
                return;
            }

            code = code.toUpperCase();

            Quiz quiz = quizDAO.getQuizByCode(code);

            if (quiz == null) {

                session.setAttribute("error", "Invalid quiz code.");

                Quiz quizDetails = quizDAO.getQuizDetails(quizId);

                request.setAttribute("quizDetails", quizDetails);
                request.setAttribute("quizId", quizId);
                request.setAttribute("screen", "entry");

                request.getRequestDispatcher("/WEB-INF/views/student/quiz.jsp")
                        .forward(request, response);
                return;
            }

            if (!quizDAO.isStudentEnrolled(userId, quiz.getCourseId())) {

                session.setAttribute("error", "You are not enrolled in this course.");

                Quiz quizDetails = quizDAO.getQuizDetails(quizId);

                request.setAttribute("quizDetails", quizDetails);
                request.setAttribute("quizId", quizId);
                request.setAttribute("screen", "entry");

                request.getRequestDispatcher("/WEB-INF/views/student/quiz.jsp")
                        .forward(request, response);
                return;
            }

            QuizAttempt attempt = quizDAO.getStudentAttempt(quiz.getId(), userId);

            //--------------------------------------------------
            // Completed
            //--------------------------------------------------
            if (attempt != null && attempt.getSubmittedAt() != null) {

                response.sendRedirect(
                        "quiz?screen=result"
                        + "&quiz_id=" + quiz.getId()
                        + "&attempt_id=" + attempt.getId());

                return;
            }

            //--------------------------------------------------
            // Resume
            //--------------------------------------------------
            if (attempt != null) {

                response.sendRedirect(
                        "quiz?screen=quiz"
                        + "&quiz_id=" + quiz.getId()
                        + "&attempt_id=" + attempt.getId());

                return;
            }

            //--------------------------------------------------
            // First Attempt
            //--------------------------------------------------
            int attemptId = quizDAO.createAttempt(quiz.getId(), userId);

            response.sendRedirect(
                    "quiz?screen=quiz"
                    + "&quiz_id=" + quiz.getId()
                    + "&attempt_id=" + attemptId);

            return;
        }

        //--------------------------------------------------
        // Submit Quiz
        //--------------------------------------------------
        if (request.getParameter("submit_quiz") != null) {

            int quizId = Integer.parseInt(request.getParameter("quiz_id"));
            int attemptId = Integer.parseInt(request.getParameter("attempt_id"));

            if (!quizDAO.isValidAttempt(attemptId, userId)) {
                response.sendRedirect("quiz");
                return;
            }

            int score = 0;

            Map<String, String[]> answers = request.getParameterMap();

            for (String key : answers.keySet()) {

                if (key.startsWith("answers[")) {

                    int questionId = Integer.parseInt(
                            key.substring(8, key.length() - 1));

                    int optionId = Integer.parseInt(
                            request.getParameter(key));

                    boolean correct =
                            quizDAO.isCorrectOption(questionId, optionId);

                    quizDAO.saveAnswer(
                            attemptId,
                            questionId,
                            optionId,
                            correct);

                    if (correct) {
                        score++;
                    }
                }
            }

            quizDAO.submitQuiz(attemptId, score);

            response.sendRedirect(
                    "quiz?screen=result"
                    + "&quiz_id=" + quizId
                    + "&attempt_id=" + attemptId);

        }
        }else if("lecturer".equals(role)){
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
