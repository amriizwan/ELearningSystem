package com.mycompany.elearningsystem.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Read-only projection used for the Results view.
 * Maps the aggregated query that joins quiz_attempts + users + quiz_questions.
 */
public class QuizAttemptResult {

    private int attemptId;
    private String studentName;
    private int score;
    private int totalQuestions;
    private LocalDateTime submittedAt;
    private String quizTitle;
     
    private int percentage;
    private String percentageColor;
    private String initials;

    

    /** Percentage rounded to nearest integer. */
    public int getPercentage() {
        return totalQuestions > 0 ? (int) Math.round(score * 100.0 / totalQuestions) : 0;
    }

    /** Letter grade derived from percentage. */
    public String getGradeLetter() {
        int pct = getPercentage();
        if (pct >= 80) return "A";
        if (pct >= 60) return "B";
        if (pct >= 40) return "C";
        return "F";
    }

    /** Tailwind text-colour class for the grade. */
    public String getGradeTextClass() {
        int pct = getPercentage();
        if (pct >= 80) return "text-emerald-700";
        if (pct >= 60) return "text-blue-700";
        if (pct >= 40) return "text-amber-700";
        return "text-red-700";
    }

    /** Tailwind background class for the grade badge. */
    public String getGradeBgClass() {
        int pct = getPercentage();
        if (pct >= 80) return "bg-emerald-100";
        if (pct >= 60) return "bg-blue-100";
        if (pct >= 40) return "bg-amber-100";
        return "bg-red-100";
    }

    /** Tailwind background class for the progress bar fill. */
    public String getBarBgClass() {
        return getGradeBgClass(); // same colour family
    }

    /** Two-letter avatar from the student's name. */
    public String getAvatarText() {
        if (studentName == null || studentName.isEmpty()) return "??";
        return studentName.substring(0, Math.min(2, studentName.length())).toUpperCase();
    }

    // ── Getters & Setters ──
    public int getAttemptId()                         { return attemptId; }
    public void setAttemptId(int attemptId)           { this.attemptId = attemptId; }

    public String getStudentName()                    { return studentName; }
    public void setStudentName(String name)           { this.studentName = name; }

    public int getScore()                             { return score; }
    public void setScore(int score)                   { this.score = score; }

    public int getTotalQuestions()                    { return totalQuestions; }
    public void setTotalQuestions(int total)          { this.totalQuestions = total; }

    public LocalDateTime getSubmittedAt()             { return submittedAt; }
    
    public void setSubmittedAt(LocalDateTime dt)      { this.submittedAt = dt; }
    
    public String getSubmittedAtFormatted() {
    if (submittedAt == null) {
        return "";
    }

    return submittedAt.format(
        DateTimeFormatter.ofPattern("dd MMM yyyy, h:mm a")
    );
}
    

    public String getQuizTitle() {
        return quizTitle;
    }

    public void setQuizTitle(String quizTitle) {
        this.quizTitle = quizTitle;
    }

    public void setPercentage(int percentage) {
        this.percentage = percentage;
    }

    public String getPercentageColor() {
        return percentageColor;
    }

    public void setPercentageColor(String percentageColor) {
        this.percentageColor = percentageColor;
    }

    public String getInitials() {
        return initials;
    }

    public void setInitials(String initials) {
        this.initials = initials;
    }
    
    
}