-- --------------------------------------------------------
-- Host:                         localhost
-- Server version:               12.3.2-MariaDB - MariaDB Server
-- Server OS:                    Win64
-- HeidiSQL Version:             12.20.0.7320
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Dumping structure for table elearning.assignment_submissions
CREATE TABLE IF NOT EXISTS `assignment_submissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `assignment_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `file_url` varchar(255) DEFAULT NULL,
  `answer_text` text DEFAULT NULL,
  `submitted_at` timestamp NULL DEFAULT current_timestamp(),
  `mark` int(11) DEFAULT NULL,
  `lecturer_comment` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `assignment_id` (`assignment_id`,`student_id`),
  KEY `student_id` (`student_id`),
  CONSTRAINT `1` FOREIGN KEY (`assignment_id`) REFERENCES `assignments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `2` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table elearning.assignment_submissions: ~0 rows (approximately)

-- Dumping structure for table elearning.assignments
CREATE TABLE IF NOT EXISTS `assignments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` int(11) NOT NULL,
  `lecturer_id` int(11) NOT NULL,
  `title` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `due_date` datetime NOT NULL,
  `max_marks` int(11) DEFAULT 100,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`),
  KEY `lecturer_id` (`lecturer_id`),
  CONSTRAINT `1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
  CONSTRAINT `2` FOREIGN KEY (`lecturer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table elearning.assignments: ~5 rows (approximately)

-- Dumping structure for table elearning.comments
CREATE TABLE IF NOT EXISTS `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `post_id` (`post_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table elearning.comments: ~0 rows (approximately)

-- Dumping structure for table elearning.course_lecturer
CREATE TABLE IF NOT EXISTS `course_lecturer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` int(11) NOT NULL,
  `lecturer_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `course_id` (`course_id`,`lecturer_id`),
  KEY `lecturer_id` (`lecturer_id`),
  CONSTRAINT `1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
  CONSTRAINT `2` FOREIGN KEY (`lecturer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table elearning.course_lecturer: ~1 rows (approximately)
INSERT INTO `course_lecturer` (`id`, `course_id`, `lecturer_id`) VALUES
	(5, 1, 11);

-- Dumping structure for table elearning.courses
CREATE TABLE IF NOT EXISTS `courses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table elearning.courses: ~29 rows (approximately)
INSERT INTO `courses` (`id`, `title`, `description`, `created_at`) VALUES
	(1, 'CSC402 - Programming I', 'This course is an introduction to problem-solving using computers. It emphasizes various aspects of problem-solving, mainly consisting of the problem domain, phases of problem-solving and basic techniques in designing a solution. The approach to problem-solving is via top-down design and structured programming. The emphasis is on solving problems using a computer rather than the syntactical aspects of the chosen programming language.', '2026-06-26 21:39:12'),
	(2, 'CSC413 - INTRODUCTION TO INTERACTIVE MULTIMEDIA', 'This course will introduce the essential topics in multimedia application development. It includes concepts in hypermedia, basic process and techniques in multimedia application development such as effective combination of audio, video, animation and graphics. Beside that, the implications of data storage and retrieval methods and also the role of teamwork in multimedia application development will also be highlighted. It will also discuss on multimedia computer hardware, current multimedia software packages, multimedia application concepts, data manipulation, file formats, media storage and memory management and configurations. Applications of multimedia for mobile and the Internet will also be emphasized.', '2026-06-26 21:41:35'),
	(3, 'CSC429 - COMPUTER ORGANIZATION AND ARCHITECTURE', 'This course introduces students to the organization and architecture of computer systems, beginning with the standard Von Neumann model and moving forward to more recent architectural concepts. Its goal is to study the evolution of computer architecture and the factors influencing the design of hardware and software elements of computer systems. Topics covered may include instruction-set architecture; number representation; processor micro-architecture; cache and memory organizations; input and output organization and architecture. By attending this course, the students will be exposed to the core computer components and will provide better understanding on computer performance and processing.', '2026-06-26 21:42:58'),
	(4, 'CTU552 - PHILOSOPHY AND CURRENT ISSUES', 'Kursus merangkumi hubungan ilmu falsafah dengan Falsafah Pendidikan Negara dan Rukunegara. Penggunaan falsafah sebagai alat untuk memurnikan budaya pemikiran dalam kehidupan melalui seni dan kaedah berfikir serta konsep insan. Topik utama dalam falsasah iaitu epistimologi, metafizik dan etika dibincangkan dalam konteks isu semasa. Penekanan diberikan kepada falsafah sebagai asas bagi menjalin dialog antara budaya serta memupuk nilai sepunya. Di hujung kursus ini pelajar akan mampu melihat disiplin-disiplin ilmu sebagai satu badan ilmu yang komprehensif dan terkait antara satu sama lain.', '2026-06-26 21:43:40'),
	(5, 'ICT450 - DATABASE', 'In the information age today, enormous amount of data is kept in files and databases. The knowledge to manipulate and manage these files is beyond doubt. By using a database package, the students will be able to appreciate the needs for database systems rather than the traditional file systems.', '2026-06-26 21:44:50'),
	(6, 'MAT406 - FOUNDATION MATHEMATICS', 'Foundation Mathematics is a main component in learning mathematics. This subject covers the additional algebraic and trigonometric skills needed by the students before they venture into the world of Calculus. It consists of eight major parts: number system, indices and logarithmic, functions, system of equations and inequalities, coordinate geometry, trigonometry, matrices, and vectors.', '2026-06-26 21:45:31'),
	(7, 'CSC404 - PROGRAMMING II', 'This course introduces the students to the techniques of programming using an imperative structured language. It covers single and multi-dimensional arrays, records, pointers and file processing concepts. Besides covering the basic syntax and semantics, the course emphasizes on problem solving methodology and modular programming techniques.', '2026-06-26 21:45:56'),
	(8, 'CTU554 - VALUES AND CIVILIZATION II', 'Kursus ini menerangkan tentang konsep etika daripada perspektif peradaban yang berbeza. la bertujuan bagi mengenal pasti sistem, tahap perkembangan, kemajuan dan kebudayaan sesuatu bangsa dalam mengukuhkan kesepaduan sosial. Selain itu, perbincangan berkaitan isu-isu kontemporari dalam aspek ekonomi, politik, sosial, budaya dan alam sekitar daripada perspektif etika dan peradaban dapat melahirkan pelajar yang bermoral dan profesional. Penerapan amalan pendidikan berimpak tinggi (HIEPs) yang bersesuaian digunakan dalam penyampaian kursus ini. Di hujung kursus ini pelajar akan dapat menghubungkaitkan etika dan kewarganegaraan berminda sivik.', '2026-06-26 21:46:16'),
	(9, 'ICT502 - Database Engineering', 'It covers the complete design, development, and implementation lifecycle of database systems , with a strong focus on advanced SQL, transaction management, query optimization, and data warehousing .', '2026-06-26 21:48:08'),
	(10, 'ITT400 - INTRODUCTION TO DATA COMMUNICATION AND NETWORKING', 'This course provides a foundation for the fundamentals of data communications and telecommunication technologies. The concepts, models, protocols, and standards of digital telecommunication are also covered. Students will also be exposed to the essentials of local area networks (LAN) and wide area network (WAN) technologies', '2026-06-26 21:48:29'),
	(11, 'MAT421 - CALCULUS I', 'It covers essential calculus concepts, including limits, derivatives, integrals, and their practical applications.', '2026-06-26 21:49:41'),
	(12, 'STA416 - APPLIED PROBABILITY AND STATISTICS', 'This subject will provide students with the basic knowledge of probability and statistics and its application in other disciplines. The topics included in this subject will provide a platform for students who will be taking statistics at higher level. Among the concepts introduced are descriptive statistics, probability concepts and special probability distributions. Materials learned in this course will also require some basic knowledge in calculus. The method of teaching and learning includes lecture, tutorial and discussion, and the assessments consist of tests, assignment, quiz, project and final examination.', '2026-06-26 21:50:36'),
	(13, 'CSC435 - OBJECT-ORIENTED PROGRAMMING', 'This course is the continuation of the Fundamental of Computer Problem Solving course. It will emphasis on solving simple to more complex problems using a programming language that supports Object-Oriented programming. The main concepts of Object-Oriented programming are discussed. Principles and techniques taught will include objects and classes, abstraction, encapsulation, inheritance and polymorphism. Students will also be taught on how to write event-driven GUI application and solve problems using text files.', '2026-06-26 21:50:58'),
	(14, 'CSC510 - DISCRETE STRUCTURES', 'This course discusses the basic tools of mathematics and logic to provide the logical foundation underlying the design and analysis of algorithms for problems solving in computer science. The course examines the fundamental discrete structures as sets, relations and graphs, definitions and proofs concerning boolean algebra, languages and grammar, and the verification of algorithms.', '2026-06-26 21:51:21'),
	(15, 'CSC520 - PRINCIPLES OF OPERATING SYSTEMS', 'The operating system is an essential part of a computer system. Similarly that the need to understand and appreciate the operating system is also indispensable to the computer science students. Operating systems should be studied for the reason of their existence: what they do, how they did it, and how they are designed and constructed.', '2026-06-26 21:51:45'),
	(16, 'CSC583 - ARTIFICIAL INTELLIGENCE ALGORITHMS', 'The aim of this course is to introduce students to the fundamentals of key intelligent systems technologies including expert systems, neural networks, fuzzy systems, evolutionary computation and swarm intelligence. Besides that, the students will also be familiarized with the integration of intelligent systems technologies for science and engineering applications.', '2026-06-26 21:52:11'),
	(17, 'LCC401 - ENGLISH FOR MEDIATING TEXTS', 'Reading and writing are the two essential skills for learning the English language at the tertiary level. These skills are widely used in various tasks and are applicable in the workplace. This MOOC aims to equip learners with advanced reading skills, enabling them to interpret and synthesise information effectively. Additionally, learners will be exposed to the practice of writing expository essays. In the writing component, learners will also be equipped with standardised reference and citation skills, enhancing their ability to produce well-documented written essays.', '2026-06-26 21:52:38'),
	(18, 'MAT423 - LINEAR ALGEBRA I', 'In this course, students will study the basics of linear algebra. Topics covered include matrix algebra, systems of linear equations, vector spaces, linear transformations and eigenvalues and eigenvectors.', '2026-06-26 21:53:10'),
	(19, 'CSC508 - DATA STRUCTURES', 'This course introduces the concept of data structures, including lists, trees and graphs for improving computational performance. It emphasizes on abstract data types, their representations, and role as models in the development of computer algorithms such as searching and sorting.', '2026-06-26 21:53:35'),
	(20, 'CSC569 - PRINCIPLES OF COMPILERS', 'The construction of a compiler involves three important phases. The lexical analysis phase deals with the identifying of lexeme items, the syntax analysis phase determines the underlying structure of the source program and the code generation phase produces the machine code. The syllabus covers from the evolution of program languages to the basics of a compiler: lexical analysis, syntax analysis, scanner and parser.', '2026-06-26 21:53:53'),
	(21, 'CSC577 - SOFTWARE ENGINEERING: THEORIES AND PRINCIPLES', 'This course introduces the theories and practices of Software Engineering, which includes software processes, requirement analysis, design, programming practices, verification and validation and software evolution for a large system. It also constructs a solid foundation for understanding and application of principles, techniques, technologies and tools in the development of a good software system. To help students understand these concepts, students will work in a team which lead a project flow through the entire software lifecycle.', '2026-06-26 21:54:16'),
	(22, 'CSC584 - ENTERPRISE PROGRAMMING', 'The course is designed to introduce students to intermediate level Java programming language and produce students who are able to solve extensive computer-based and enterprise web-based problems. It emphasizes various aspects of problem solving and develop applications using enterprise component technologies.', '2026-06-26 21:54:40'),
	(23, 'LCC500 - ENGLISH FOR WORKPLACE COMMUNICATION', 'This course aims to develop the studentsÂ¡Â¯ ability to communicate in English using appropriate and effective language expressions in work-related situations. It focuses on the principles of effective communication in the workplace and evaluating workplace conflicts or problems, providing solutions and proposing new initiatives. Students undertake a variety of activities designed to develop their communication skills, knowledge and understanding of the requirements of effective communication in the workplace. Tasks and activities suggested for each situation are discipline-based with an emphasis on oral communication.', '2026-06-26 21:55:17'),
	(24, 'CSC580 - Parallel Processing', 'It introduces students to the fundamentals of parallel algorithms, computational performance enhancement, and parallel programming paradigms like Message Passing Interface (MPI) and OpenMP.', '2026-06-26 21:56:36'),
	(25, 'CSC645 - ALGORITHM ANALYSIS AND DESIGN', 'This course focuses on both the design and analysis of algorithms. It provides students with basic knowledge and techniques required to design efficient algorithms and analyse their efficiency, as well as demonstrate the key relationships between problem solving, algorithm design, data structures, programs and algorithm analysis, and the effects of the choices. This course provides a fundamental platform for the strategies and design ideas of algorithms for solving fundamental problems in computing science.', '2026-06-26 21:56:59'),
	(26, 'CSC649 - SPECIAL TOPICS IN COMPUTER SCIENCE', 'It explores specialized computing frameworks, algorithms, and methodologies. Students focus on practical product development, critical thinking, and technologies like Artificial Intelligence (AI), Machine Learning (ML), and Data Mining.', '2026-06-26 21:57:52'),
	(27, 'CSP600 - PROJECT FORMULATION', 'In this course the student will exposed to the different types of research project and learn to propose a complete research project. The students will be guided to produce a proposal of an intended project. The guidance will include theoretical research and it can culminate in model program intended for testing out the theoretical findings.', '2026-06-26 21:58:15'),
	(28, 'ENT600 - TECHNOLOGY ENTREPRENEURSHIP', 'Behind every successful technology company is a visionary, effective and efficient technopreneur. In this course, students will be exposed to entrepreneurship and apply their entrepreneurial skills in developing an advanced technology that could be a basis for the creation and development of a technology-based venture. This subject is designed to inculcate the entrepreneurial skills among science and technology cluster students and promote the development of technology-based entrepreneurship knowledge. The course delivery combines both theoretical and practical aspects of technology entrepreneurship. Theoretical aspect is looking at the important elements in understanding technology entrepreneurship, while practical aspect is engaging the students to develop their technology based idea business blueprint. The course has two key components of face-to-face lectures and practical project-based assignments monitored with the course lecturer.', '2026-06-26 21:58:43'),
	(29, 'CSC662 - COMPUTER SECURITY APPROVED', 'The course will provide an overview of main problems and techniques of computer security. It will introduce the key security management issues, such as threats, attacks, objectives and measures. It will focus on technical security instruments deployed at various components of distributed systems, while keeping an eye on operational issues. Specific security mechanisms of common operating systems and network protocols will be covered. Exercises will contain "paper-and-pencil" problems for better understanding of theoretical fundamentals as well as some programming tasks.', '2026-06-26 21:59:09'),
	(30, 'CSP650 - PROJECT', 'This course will enable the students to experience the planning, analysis, design and development phases in handling information technology project. The student develops solutions based on the formulated problem. Students should be able to compile, analyse and present the project carried out in the form of a thesis. Students also should be able to communicate the project outcome effectively through oral and poster presentation.', '2026-06-26 21:59:34'),
	(31, 'EET699 - ENGLISH EXIT TEST', ' It typically comprises two components: a Writing paper and a Speaking paper, and results are based on CEFR levels rather than affecting your CGPA.', '2026-06-26 22:00:05'),
	(32, 'ICT652 - ETHICAL, SOCIAL, AND PROFESSIONAL ISSUES IN ICT', 'This course will cover the social issues related to society, issues on history, development and economics of ICT will be covered. The issues that will be discussed include the effects of the ICT application on the Malaysian society, the changing nature of work, the ethical issues and computer crime. The issues covered are relevant to being a responsible computer user, professional or personal. The course also expresses the Islamic perspective to the students as effort to elevate the value among the students.', '2026-06-26 22:00:30');

-- Dumping structure for table elearning.enrollments
CREATE TABLE IF NOT EXISTS `enrollments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `enrolled_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `student_id` (`student_id`,`course_id`),
  KEY `course_id` (`course_id`),
  CONSTRAINT `1` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table elearning.enrollments: ~0 rows (approximately)
INSERT INTO `enrollments` (`id`, `student_id`, `course_id`, `enrolled_at`) VALUES
	(13, 2, 1, '2026-07-06 03:26:07');

-- Dumping structure for table elearning.notes
CREATE TABLE IF NOT EXISTS `notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` int(11) NOT NULL,
  `lecturer_id` int(11) NOT NULL,
  `title` varchar(150) NOT NULL,
  `type` enum('pdf','video') NOT NULL,
  `file_url` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`),
  KEY `lecturer_id` (`lecturer_id`),
  CONSTRAINT `1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
  CONSTRAINT `2` FOREIGN KEY (`lecturer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table elearning.notes: ~9 rows (approximately)

-- Dumping structure for table elearning.posts
CREATE TABLE IF NOT EXISTS `posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL,
  `user_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `course_id` (`course_id`),
  CONSTRAINT `1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table elearning.posts: ~2 rows (approximately)

-- Dumping structure for table elearning.quiz_answers
CREATE TABLE IF NOT EXISTS `quiz_answers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `attempt_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `selected_option_id` int(11) NOT NULL,
  `is_correct` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `attempt_id` (`attempt_id`,`question_id`),
  KEY `question_id` (`question_id`),
  KEY `selected_option_id` (`selected_option_id`),
  CONSTRAINT `1` FOREIGN KEY (`attempt_id`) REFERENCES `quiz_attempts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `2` FOREIGN KEY (`question_id`) REFERENCES `quiz_questions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `3` FOREIGN KEY (`selected_option_id`) REFERENCES `quiz_options` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table elearning.quiz_answers: ~2 rows (approximately)

-- Dumping structure for table elearning.quiz_attempts
CREATE TABLE IF NOT EXISTS `quiz_attempts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quiz_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `score` int(11) DEFAULT NULL,
  `started_at` timestamp NULL DEFAULT current_timestamp(),
  `submitted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `quiz_id` (`quiz_id`,`student_id`),
  KEY `student_id` (`student_id`),
  CONSTRAINT `1` FOREIGN KEY (`quiz_id`) REFERENCES `quizzes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `2` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table elearning.quiz_attempts: ~0 rows (approximately)

-- Dumping structure for table elearning.quiz_options
CREATE TABLE IF NOT EXISTS `quiz_options` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question_id` int(11) NOT NULL,
  `option_text` varchar(255) NOT NULL,
  `is_correct` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `question_id` (`question_id`),
  CONSTRAINT `1` FOREIGN KEY (`question_id`) REFERENCES `quiz_questions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table elearning.quiz_options: ~4 rows (approximately)

-- Dumping structure for table elearning.quiz_questions
CREATE TABLE IF NOT EXISTS `quiz_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quiz_id` int(11) NOT NULL,
  `question_text` text NOT NULL,
  `question_type` enum('multiple_choice','true_false') NOT NULL,
  `marks` int(11) DEFAULT 1,
  `question_order` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `quiz_id` (`quiz_id`),
  CONSTRAINT `1` FOREIGN KEY (`quiz_id`) REFERENCES `quizzes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table elearning.quiz_questions: ~2 rows (approximately)

-- Dumping structure for table elearning.quizzes
CREATE TABLE IF NOT EXISTS `quizzes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` int(11) NOT NULL,
  `lecturer_id` int(11) NOT NULL,
  `title` varchar(150) NOT NULL,
  `quiz_code` varchar(10) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `quiz_code` (`quiz_code`),
  KEY `course_id` (`course_id`),
  KEY `lecturer_id` (`lecturer_id`),
  CONSTRAINT `1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
  CONSTRAINT `2` FOREIGN KEY (`lecturer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table elearning.quizzes: ~0 rows (approximately)

-- Dumping structure for table elearning.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('student','lecturer','admin') NOT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table elearning.users: ~16 rows (approximately)
INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`, `status`, `created_at`) VALUES
	(1, 'admin', 'admin@gmail.com', 'admin', 'admin', 'active', '2026-06-26 21:34:10'),
	(2, 'Amri Izwan', 'amri123@gmail.com', '$2a$10$o8vzpddQOcG8tyQKQ0SSa..rD244OaOVt2nyi5WAz9Ga3Vkay7F.i', 'student', 'active', '2026-06-26 22:30:56'),
	(3, 'Yushairul Haziq', 'yus123@gmail.com', '$2a$10$.JMgJHUmMp8a0AF18CFyfOU89G/xjizYLN3zME7NMPAynX2HsNsN.', 'student', 'active', '2026-06-26 22:31:29'),
	(4, 'Aqeel Azhar', 'ben123@gmail.com', '$2a$10$/4TSRZp6F4uoV9riAdz60OPhIdJLp7P2rggenuVk0r5nSrf3.VgMW', 'student', 'active', '2026-06-26 22:31:49'),
	(5, 'Faiz Fikri', 'faiz123@gmail.com', '$2a$10$pN.fqu.Gw5u0.EB5oPAU/eYNtikUgpYQGtIoJVSATRLMTCxCHSu5.', 'student', 'active', '2026-06-26 22:32:12'),
	(6, 'Haziq Haikal', 'haziq123@gmail.com', '$2a$10$/OBcyoKkqcLm5gWvDhEAke0gr5tEDlu81eXNrVY2pj8pASp5PCxtu', 'student', 'active', '2026-06-26 22:32:28'),
	(7, 'IWAN JP', 'iwan123@gmail.com', '$2a$10$cRx8dPNLVMNV4cIB.0CtF.dOXHwwU5hHBb6QEMluynE7mi1aHg6w6', 'student', 'active', '2026-06-26 22:32:58'),
	(8, 'Muhamad Aiman', 'aiman123@gmail.com', '$2a$10$4yPQnK51hMzbCsxVd4BVdejhyHWmYpP.GwwixED52HeZwMeAFOgvS', 'student', 'active', '2026-06-26 22:33:36'),
	(9, 'Syazwan Danial', 'syazwan123@gmail.com', '$2a$10$6AJYMHAczVHv35KPtbsNqORoibbhSNTEOJqN0vGaXfD9fp.XouSfC', 'student', 'active', '2026-06-26 22:34:10'),
	(10, 'RUBIAH BINTI ABU BAKAR', 'rubiah73@uitm.edu.my', '$2a$10$wcofetkqEbpQ3rXcRRrA1e4VgAKf5EGnNOG7Jq5AWPgqjQq6elpru', 'lecturer', 'active', '2026-06-26 22:35:56'),
	(11, 'AHMAD AIMAN BIN SHALLAHUDDIN', 'aiman@uitm.edu.my', '$2a$10$40zh0357qFV7sORBuCv1vur1NiReqK2w5JreqeQgV7TL9a5VZ/sCi', 'lecturer', 'active', '2026-06-26 22:36:37'),
	(12, 'NIK MARSYAHARIANI BINTI NIK DAUD', 'nikma944@uitm.edu.my', '$2a$10$64MDPgPdQGCNgstoJVIfv.INmKKhS0uhgrQEkLRXKTiORFe.aOA3e', 'lecturer', 'active', '2026-06-26 22:37:07'),
	(13, 'DR. FARAH MUNA BINTI MOHAMAD GHAZALI', 'farahmuna@uitm.edu.my', '$2a$10$2O4ie8wg7kOW/lTZqVBNXOfzPbEh2p9rNm3N7hckGGND.VC8EWRbu', 'lecturer', 'active', '2026-06-26 22:37:29'),
	(14, 'NURUL AKMAL BINTI AWANG', 'nurul.akmal@uitm.edu.my', '$2a$10$gl8Qwv4hkROUtYe1GWuHx.U87xIdJVYdk2h9p41RZOFOK7/EHnTmK', 'lecturer', 'active', '2026-06-26 22:38:13'),
	(15, 'DR. NORLINA BINTI MOHD SABRI', 'norli097@uitm.edu.my', '$2a$10$qzu98v8VstgeuBCXGEIPdO7SSbyuS5pmMNlsHxgv6Dopd9ZxYJgpm', 'lecturer', 'active', '2026-06-26 22:38:52'),
	(16, 'AHMAD FAKRULAZIZI BIN ABU BAKAR', 'ahmad1183@uitm.edu.my', '$2a$10$hV9xaCHKHboqnnVzXnc4EO6KOKd.ss1HrpVGdyxhijlpK6vlkEhwS', 'lecturer', 'active', '2026-06-26 22:39:17');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
