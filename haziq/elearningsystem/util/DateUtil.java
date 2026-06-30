// FILE 3: src/java/com/mycompany/elearningsystem/util/DateUtil.java

package com.mycompany.elearningsystem.util;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

public class DateUtil {

    /**
     * Returns a human-readable "time ago" string from a datetime string.
     * Equivalent to the PHP time_ago() function in dashboard.php.
     *
     * @param datetimeStr  e.g. "2024-05-10 14:30:00" (from MariaDB DATETIME column)
     * @return             e.g. "just now", "5m ago", "3h ago", "2d ago", "May 10, 2024"
     */
    public static String timeAgo(String datetimeStr) {
        if (datetimeStr == null || datetimeStr.isEmpty()) {
            return "";
        }
        try {
            // Parse the datetime string from MariaDB
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            LocalDateTime past = LocalDateTime.parse(datetimeStr, formatter);
            LocalDateTime now  = LocalDateTime.now();

            long seconds = ChronoUnit.SECONDS.between(past, now);

            if (seconds < 60) {
                return "just now";
            } else if (seconds < 3600) {
                return (seconds / 60) + "m ago";
            } else if (seconds < 86400) {
                return (seconds / 3600) + "h ago";
            } else if (seconds < 604800) {
                return (seconds / 86400) + "d ago";
            } else {
                // Format as "May 10, 2024"
                DateTimeFormatter displayFormat = DateTimeFormatter.ofPattern("MMM dd, yyyy");
                return past.format(displayFormat);
            }
        } catch (Exception e) {
            return datetimeStr; // fallback: return raw string
        }
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
