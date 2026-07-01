/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.elearningsystem.util;

import java.sql.Timestamp;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

/**
 *
 * @author amri1
 */
public class DateUtil {
    public static String timeAgo(Timestamp timestamp) {
        if (timestamp == null) {
            return "";
        }

        LocalDateTime dateTime = timestamp.toLocalDateTime();

        Duration duration = Duration.between(dateTime, LocalDateTime.now());

        long minutes = duration.toMinutes();
        long hours = duration.toHours();
        long days = duration.toDays();

        if (minutes < 1) return "Just now";
        if (minutes < 60) return minutes + " min ago";
        if (hours < 24) return hours + " hr ago";
        return days + " day ago";
    }

    /**
     * Returns today's date formatted as "Monday, 10 June 2024".
     * Equivalent to PHP: date('l, d F Y')
     */
    public static String getTodayFormatted() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE, dd MMMM yyyy");
        return LocalDate.now().format(formatter);
    }

    /**
     * Returns a greeting based on the current hour.
     * Equivalent to PHP $greeting logic in dashboard.php.
     */
    public static String getGreeting() {
        int hour = LocalDateTime.now().getHour();
        if (hour < 12) {
            return "Good morning";
        } else if (hour < 17) {
            return "Good afternoon";
        } else {
            return "Good evening";
        }
    }

    /**
     * Returns the first word of a full name.
     * Equivalent to PHP: explode(' ', $lecturer_name)[0]
     */
    public static String getFirstName(String fullName) {
        if (fullName == null || fullName.isEmpty()) {
            return "";
        }
        return fullName.split(" ")[0];
    }

    /**
     * Returns the first 2 characters of a name, uppercased.
     * Used for avatar initials in the JSP.
     * Equivalent to PHP: strtoupper(substr($name, 0, 2))
     */
    public static String getInitials(String name) {
        if (name == null || name.isEmpty()) {
            return "??";
        }
        int len = Math.min(2, name.length());
        return name.substring(0, len).toUpperCase();
    }

    /**
     * Calculates percentage score for a quiz attempt.
     * Equivalent to PHP: round($attempt['score'] / $attempt['total_questions'] * 100)
     */
    public static int calcPercent(int score, int totalQuestions) {
        if (totalQuestions <= 0) {
            return 0;
        }
        return (int) Math.round((double) score / totalQuestions * 100);
    }

    /**
     * Returns the Tailwind CSS color class for a quiz percentage score.
     * Equivalent to PHP ternary: $pct >= 80 ? 'text-emerald-600' : ...
     */
    public static String getPctColorClass(int pct) {
        if (pct >= 80) {
            return "text-emerald-600";
        } else if (pct >= 60) {
            return "text-blue-600";
        } else if (pct >= 40) {
            return "text-amber-600";
        } else {
            return "text-red-500";
        }
    }
}
