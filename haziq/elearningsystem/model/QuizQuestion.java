package com.mycompany.project.model;

import java.util.List;
import java.util.ArrayList;

/**
 * Model class representing a row in the `quiz_questions` table.
 */
public class QuizQuestion {

    private int id;
    private int quizId;
    private String questionText;
    private String questionType;   // "multiple_choice" | "true_false"
    private int marks;
    private int questionOrder;

    // Populated by DAO when loading questions with their options
    private List<QuizOption> options = new ArrayList<>();

    // ── Constructors ──
    public QuizQuestion() {}

    // ── Getters & Setters ──
    public int getId()                          { return id; }
    public void setId(int id)                   { this.id = id; }

    public int getQuizId()                      { return quizId; }
    public void setQuizId(int quizId)           { this.quizId = quizId; }

    public String getQuestionText()             { return questionText; }
    public void setQuestionText(String t)       { this.questionText = t; }

    public String getQuestionType()             { return questionType; }
    public void setQuestionType(String type)    { this.questionType = type; }

    public int getMarks()                       { return marks; }
    public void setMarks(int marks)             { this.marks = marks; }

    public int getQuestionOrder()               { return questionOrder; }
    public void setQuestionOrder(int order)     { this.questionOrder = order; }

    public List<QuizOption> getOptions()        { return options; }
    public void setOptions(List<QuizOption> o)  { this.options = o; }

    /** Convenience: display type with underscores replaced by spaces */
    public String getDisplayType() {
        return questionType == null ? "" : questionType.replace('_', ' ');
    }
}
