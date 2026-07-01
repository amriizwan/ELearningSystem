package com.mycompany.elearningsystem.model;

import java.sql.Timestamp;

public class Assignment {
    private int id;
    private int courseId;
    private int lecturerId;
    private String title;
    private String description;
    private Timestamp dueDate;
    private int maxMarks;
    private Timestamp createdAt;

    // Extra fields filled by JOIN queries — not stored in assignments table
    private String courseName;
    private String lecturerName;
    private boolean submitted;      // UC007 post condition — is student submitted?
    private int submissionCount;    // UC016 — how many students submitted
    
    private int submissionId;
    private Timestamp submittedAt;
    private String status;
    
    private Submission submission;
    
    private int assignment_count;
    private int ungraded_count;
    private int enroll_count;

    public int getUngraded_count() {
        return ungraded_count;
    }

    public void setUngraded_count(int ungraded_count) {
        this.ungraded_count = ungraded_count;
    }

    public int getEnroll_count() {
        return enroll_count;
    }

    public void setEnroll_count(int enroll_count) {
        this.enroll_count = enroll_count;
    }

    public int getAssignment_count() {
        return assignment_count;
    }

    public void setAssignment_count(int assignment_count) {
        this.assignment_count = assignment_count;
    }


    public Assignment() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }

    public int getLecturerId() { return lecturerId; }
    public void setLecturerId(int lecturerId) { this.lecturerId = lecturerId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Timestamp getDueDate() { return dueDate; }
    public void setDueDate(Timestamp dueDate) { this.dueDate = dueDate; }

    public int getMaxMarks() { return maxMarks; }
    public void setMaxMarks(int maxMarks) { this.maxMarks = maxMarks; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }

    public String getLecturerName() { return lecturerName; }
    public void setLecturerName(String lecturerName) { this.lecturerName = lecturerName; }

    public boolean isSubmitted() { return submitted; }
    public void setSubmitted(boolean submitted) { this.submitted = submitted; }

    public int getSubmissionCount() { return submissionCount; }
    public void setSubmissionCount(int submissionCount) { this.submissionCount = submissionCount; }
    
    public int getSubmissionId() {
        return submissionId;
    }

    public Timestamp getSubmittedAt() {
        return submittedAt;
    }

    public String getStatus() {
        return status;
    }
    
    public void setSubmissionId(int submissionId) {
        this.submissionId = submissionId;
    }

    public void setSubmittedAt(Timestamp submittedAt) {
        this.submittedAt = submittedAt;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
    public Submission getSubmission() {
        return submission;
    }
    
    public void setSubmission(Submission submission) {
        this.submission = submission;
    }
    
    
    public String getStatusText() {
        switch (status) {
            case "marked": return "Marked";
            case "submitted": return "Submitted";
            case "overdue": return "Overdue";
            case "due_soon": return "Due soon";
            default: return "Upcoming";
        }
    }

    public String getStatusClass() {
        switch (status) {
            case "marked":
                return "bg-violet-100 text-violet-700";
            case "submitted":
                return "bg-emerald-100 text-emerald-700";
            case "overdue":
                return "bg-red-100 text-red-700";
            case "due_soon":
                return "bg-amber-100 text-amber-700";
            default:
                return "bg-gray-100 text-gray-600";
        }
    }
    
    public String getDueColor() {
        switch (status) {
            case "overdue": return "text-red-500";
            case "due_soon": return "text-amber-600";
            default: return "text-gray-500";
        }
    }
    
}
