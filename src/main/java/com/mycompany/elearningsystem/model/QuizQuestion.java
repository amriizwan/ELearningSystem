/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.elearningsystem.model;

import java.util.List;

/**
 *
 * @author amri1
 */
public class QuizQuestion {
    private int id;
    private int quizId;
    private String questionText;
    private String questionType;  // "multiple_choice" or "true_false"
    private int marks;
    private int questionOrder;

    // Loaded alongside the question for display during quiz attempt
    private List<QuizOption> options;
    
    private Integer savedAnswer;

    public void setSavedAnswer(Integer savedAnswer) {
        this.savedAnswer = savedAnswer;
    }

    public Integer getSavedAnswer() {
        return savedAnswer;
    }


    public QuizQuestion() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getQuizId() { return quizId; }
    public void setQuizId(int quizId) { this.quizId = quizId; }

    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }

    public String getQuestionType() { return questionType; }
    public void setQuestionType(String questionType) { this.questionType = questionType; }

    public int getMarks() { return marks; }
    public void setMarks(int marks) { this.marks = marks; }

    public int getQuestionOrder() { return questionOrder; }
    public void setQuestionOrder(int questionOrder) { this.questionOrder = questionOrder; }

    public List<QuizOption> getOptions() { return options; }
    public void setOptions(List<QuizOption> options) { this.options = options; }
    
    public String getDisplayType() {
        return questionType == null ? "" : questionType.replace('_', ' ');
    }
}
