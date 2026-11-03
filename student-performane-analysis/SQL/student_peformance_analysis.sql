USE student_performance_db;

-- Total number of students
SELECT COUNT(*) AS total_students
FROM student_performance;

-- Average final grade
SELECT AVG(G3) AS average_final_grade
FROM student_performance;

-- Pass rate
SELECT
    COUNT(CASE WHEN G3 >= 10 THEN 1 END) AS students_passing,
    COUNT(*) AS total_students,
    ROUND(
        COUNT(CASE WHEN G3 >= 10 THEN 1 END)
        * 100.0 / COUNT(*), 2
    ) AS pass_rate
FROM student_performance;

/* CHECK PASS STATUS OF STUDENTS */
SELECT `Pass Status`, COUNT(*) AS total_students
FROM student_performance
GROUP BY `Pass Status`;

/* CHECK the total number of recorded absences across all students */
SELECT SUM(absences), COUNT(*) AS total_students
FROM student_performance;

/* CHECK the highest final grade for each school */
SELECT school, MAX(G3) AS highest_final_grade
FROM student_performance
GROUP BY school;

/* CHECK how many students belong to each age group */
SELECT age, COUNT(*) AS total_students
FROM student_performance
GROUP BY age;

/* CHECK FOR CLASSIFICATION OF STUDENTS BASED ON THEIR FINAL GRADE */
SELECT G3,
    CASE
		WHEN G3 >= 15 THEN 'High'
        WHEN G3 >= 10 THEN 'Medium'
        ELSE 'LOW'
	END AS performance_level
FROM student_performance;

/* CHECK FOR COUNT OF STUDENTS BASED ON THEIR PERFORMANCE LEVEL */
SELECT
	CASE
		WHEN G3 >= 15 THEN 'High'
        WHEN G3 >= 10 THEN 'Medium'
        ELSE 'Low'
	END AS performance_level,
    COUNT(*) AS total_students
FROM student_performance
GROUP BY performance_level
ORDER BY total_students DESC;

SELECT
    COUNT(*) AS total_students,
    SUM(CASE
        WHEN `Pass Status` = 'Pass' THEN 1
        ELSE 0
    END) AS students_passed,
    ROUND(
        100.0 * SUM(CASE
            WHEN `Pass Status` = 'Pass' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS pass_rate_percentage
FROM student_performance;


/* Calculate the main KPIs */
SELECT
    COUNT(*) AS total_students,
    ROUND(AVG(G3), 2) AS average_final_grade,
    MAX(G3) AS highest_final_grade,
    MIN(G3) AS lowest_final_grade,
    ROUND(AVG(absences), 2) AS average_absences
FROM student_performance;

/* Comparing average grades by school */
SELECT
    school,
    COUNT(*) AS total_students,
    ROUND(AVG(G3), 2) AS average_final_grade
FROM student_performance
GROUP BY school
ORDER BY average_final_grade DESC;

/* Check the pass rate */
SELECT
    COUNT(*) AS total_students,
    SUM(CASE
        WHEN G3 >= 10 AND `Pass Status` = 'Pass' THEN 1
        ELSE 0
    END) AS correctly_labelled_passes,
    SUM(CASE
        WHEN G3 < 10 AND `Pass Status` = 'Fail' THEN 1
        ELSE 0
    END) AS correctly_labelled_fails,
    SUM(CASE
        WHEN (G3 >= 10 AND `Pass Status` != 'Pass')
          OR (G3 < 10 AND `Pass Status` != 'Fail')
        THEN 1
        ELSE 0
    END) AS mismatched_records
FROM student_performance;

/* Examine the grade distributions */
SELECT
    CASE
        WHEN G3 >= 15 THEN 'High (15–20)'
        WHEN G3 >= 10 THEN 'Medium (10–14)'
        ELSE 'Low (0–9)'
    END AS performance_level,
    COUNT(*) AS total_students,
    ROUND(100.0 * COUNT(*) /
        (SELECT COUNT(*) FROM student_performance), 2
    ) AS percentage
FROM student_performance
GROUP BY performance_level;

