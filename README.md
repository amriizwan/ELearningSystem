# ELearning System — CS2304C1
A web-based E-Learning System developed as a group project at Universiti Teknologi MARA (UiTM), 
Faculty of Computer and Mathematical Sciences.

---

## Group Members
| Student ID   | Name                              |
|--------------|-----------------------------------|
| 2025245722   | Muhammad Amri Izwan bin Jamaludin |
| 2025229406   | Yushairul Haziq Ikhwan bin Yussaini | 
| 2025417472   | Muhammad Haziq Haikal bin Ridzuan | 
| 2025482256   | Aqeel Azhar Benmahfouz bin Azhar  | 


---

## System Overview

MyStudyZone is a web-based e-learning platform that allows:
- **Students** to enrol in courses, view notes, submit assignments, take quizzes, and participate in discussion forums
- **Lecturers** to manage course materials, assignments, quizzes, and student submissions
- **Admins** to manage users, courses, and moderate discussion posts

---

## Technology Stack

| Component    | Technology                        |
|--------------|-----------------------------------|
| Language     | Java                              |
| Framework    | Java EE (Jakarta EE 9+)           |
| Architecture | MVC (Model-View-Controller)       |
| Frontend     | JSP, Tailwind CSS, JavaScript     |
| Database     | MariaDB                           |
| Server       | GlassFish 7                       |
| Build Tool   | Maven                             |
| IDE          | Apache NetBeans                   |

---
## Database Setup

1. Install MariaDB or MySQL
2. Create a database named `elearning`
3. Import the SQL file:

```sql
-- In HeidiSQL or MySQL Workbench, run:
SOURCE CS2304C1_E-Learning_System_SQL.sql;
```

Or via command line:
```bash
mysql -u root -p elearning < CS2304C1_E-Learning_System_SQL.sql
```

Default admin account:
Email:    admin@gmail.com
Password: admin
Role:     admin

---

## How to Run

1. Clone this repository:
```bash
git clone https://github.com/amriizwan/ELearningSystem.git
```

2. Open in **Apache NetBeans**

3. Configure database connection in `DBConnection.java`:
```java
private static final String DB_USER = "root";
private static final String DB_PASS = "";        // your MariaDB password
private static final String URL     = "jdbc:mariadb://localhost:3306/elearning";
```

4. Copy the MariaDB driver JAR to GlassFish:
   mariadb-java-client-3.3.3.jar → C:\glassfish7\glassfish\lib\

5. Right-click project → **Clean and Build**

6. Right-click project → **Run**

7. Open browser:
   http://localhost:8080/elearningsystem/
   
