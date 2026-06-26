package com.mycompany.elearningsystem.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String DB_HOST = "localhost";
    private static final String DB_PORT = "3306";
    private static final String DB_NAME = "elearning";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    private static final String URL =
        "jdbc:mariadb://" + DB_HOST + ":" + DB_PORT + "/" + DB_NAME;

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("org.mariadb.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MariaDB Driver not found. Check pom.xml.", e);
        }
        return DriverManager.getConnection(URL, DB_USER, DB_PASS);
    }
}