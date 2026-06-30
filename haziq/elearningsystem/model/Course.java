package com.mycompany.project.model;

/**
 * Lightweight Course model used by the quiz page sidebar.
 * Full course management belongs in its own module.
 */
public class Course {

    private int id;
    private String title;
    private int quizCount;
    private int studentCount;
    private int noteCount;
    private int asgnCount;

    public Course() {}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getQuizCount() {
        return quizCount;
    }

    public void setQuizCount(int quizCount) {
        this.quizCount = quizCount;
    }

    public int getStudentCount() {
        return studentCount;
    }

    public void setStudentCount(int studentCount) {
        this.studentCount = studentCount;
    }

    public int getNoteCount() {
        return noteCount;
    }

    public void setNoteCount(int noteCount) {
        this.noteCount = noteCount;
    }

    public int getAsgnCount() {
        return asgnCount;
    }

    public void setAsgnCount(int asgnCount) {
        this.asgnCount = asgnCount;
    }

   
    
    
}
