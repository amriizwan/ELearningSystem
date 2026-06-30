package com.mycompany.project.model;

/**
 * Model class representing a row in the `quiz_options` table.
 */
public class QuizOption {

    private int id;
    private int questionId;
    private String optionText;
    private boolean isCorrect;

    // ── Constructors ──
    public QuizOption() {}

    // ── Getters & Setters ──
    public int getId()                        { return id; }
    public void setId(int id)                 { this.id = id; }

    public int getQuestionId()                { return questionId; }
    public void setQuestionId(int qid)        { this.questionId = qid; }

    public String getOptionText()             { return optionText; }
    public void setOptionText(String text)    { this.optionText = text; }

    public boolean isCorrect()                { return isCorrect; }
    public void setCorrect(boolean correct)   { this.isCorrect = correct; }
}
