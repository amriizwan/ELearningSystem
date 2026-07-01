/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.elearningsystem.model;

/**
 *
 * @author amri1
 */
public class QuizAnswer {
    private int answerId;
    private int attemptId;
    private int questionId;
    private int selectedOptionId;
    private boolean isCorrect;
    
    private String questionText;
    private String selectedOption;
    private String correctOption;
    private boolean selectedCorrect;
    
    public QuizAnswer() {
    }

    public QuizAnswer(int answerId, int attemptId, int questionId, int selectedOptionId, boolean isCorrect, String questionText, String selectedOption, String correctOption, boolean selectedCorrect) {
        this.answerId = answerId;
        this.attemptId = attemptId;
        this.questionId = questionId;
        this.selectedOptionId = selectedOptionId;
        this.isCorrect = isCorrect;
        this.questionText = questionText;
        this.selectedOption = selectedOption;
        this.correctOption = correctOption;
        this.selectedCorrect = selectedCorrect;
    }

    public int getAnswerId() {
        return answerId;
    }

    public int getAttemptId() {
        return attemptId;
    }

    public int getQuestionId() {
        return questionId;
    }

    public int getSelectedOptionId() {
        return selectedOptionId;
    }

    public boolean getIsCorrect() {
        return isCorrect;
    }

    public String getQuestionText() {
        return questionText;
    }

    public String getSelectedOption() {
        return selectedOption;
    }
    
    public String getCorrectOption() {
        return correctOption;
    }

    public boolean getSelectedCorrect() {
        return selectedCorrect;
    }

    public void setAnswerId(int answerId) {
        this.answerId = answerId;
    }

    public void setAttemptId(int attemptId) {
        this.attemptId = attemptId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public void setSelectedOptionId(int selectedOptionId) {
        this.selectedOptionId = selectedOptionId;
    }

    public void setIsCorrect(boolean isCorrect) {
        this.isCorrect = isCorrect;
    }

    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }

    public void setSelectedOption(String selectedOption) {
        this.selectedOption = selectedOption;
    }

    public void setCorrectOption(String correctOption) {
        this.correctOption = correctOption;
    }

    public void setSelectedCorrect(boolean selectedCorrect) {
        this.selectedCorrect = selectedCorrect;
    }
}
