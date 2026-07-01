package com.mycompany.elearningsystem.controller;

import com.mycompany.elearningsystem.model.Quiz;
import com.mycompany.elearningsystem.model.QuizAnswer;
import com.mycompany.elearningsystem.model.QuizAttempt;
import com.mycompany.elearningsystem.dao.QuizDAO;
import com.mycompany.elearningsystem.model.QuizQuestion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/quiz")
public class QuizServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userId");
        String screen = request.getParameter("screen");
        QuizDAO quizDAO = new QuizDAO();
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

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userId");

        QuizDAO quizDAO = new QuizDAO();

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
        
    }

}
