# Online_Platforma
# **Задачі**

## **Задача 1. Базові SELECT**

1. Вивести всіх студентів, які зареєструвалися після 2024‑01‑01.
SELECT student_id, full_name, city,	reg_date 
FROM students
WHERE reg_date > '2024.01.01';


2. Вивести всі курси категорії `"Data Science"`.
SELECT course_id, course_name, category 
FROM courses
WHERE category = 'Data Science';

## **Задача 2. Групування та агрегація**

1. Порахувати кількість студентів у кожному місті.
SELECT city, COUNT(*) AS student_count FROM students
GROUP BY city;

2. Порахувати кількість курсів у кожній категорії.
SELECT category, COUNT(*) AS course_count FROM courses
GROUP BY category;


3. Порахувати середню оцінку по кожному курсу.
SELECT 
    c.course_id, 
    c.course_name, 
    AVG(p.score) AS average_score
FROM progress p
JOIN enrollments e ON e.enrollment_id = p.enrollment_id
JOIN courses c ON c.course_id = e.course_id
GROUP BY c.course_id;


## **Задача 3. JOIN‑аналіз**

1. Вивести список курсів разом з іменами викладачів.

SELECT 
    c.course_id, 
    c.course_name, 
    c.instructor_id,
    i.full_name
FROM courses c
JOIN instructors i ON c.instructor_id = i.instructor_id;

2. Вивести студентів та назви курсів, на які вони записані.
SELECT s.student_id, s.full_name, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

3. Порахувати, скільки студентів у кожного викладача.
SELECT i.instructor_id, i.full_name, COUNT(DISTINCT e.student_id) AS students_count
FROM instructors i
JOIN courses c ON i.instructor_id = c.instructor_id
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY i.instructor_id, i.full_name;

## **Задача 4. Аналітика прогресу**

1. Порахувати середню оцінку кожного студента.
![](task4_1.png)
2. Порахувати відсоток завершених уроків для кожного курсу.
SELECT 
    c.course_id,
    c.course_name,
    AVG(CASE WHEN sc.status = 'completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(l.lesson_id) AS completion_percentage
FROM 
    courses c
JOIN lessons l ON c.course_id = l.course_id
LEFT JOIN student_courses sc ON c.course_id


3. Знайти студентів, які завершили всі уроки у своїх курсах.


## **Задача 5. Віконні функції**

1. Для кожного курсу визначити рейтинг студентів за середнім балом.

2. Порахувати кумулятивну кількість уроків, завершених студентом у хронологічному порядку.
SELECT 
    sc.student_id,
    c.course_id,
    AVG(sc.score) AS average_score,
    RANK() OVER (PARTITION BY c.course_id ORDER BY AVG(sc.score) DESC) AS student_rank
FROM 
    student_courses sc
JOIN courses c ON sc.course_id = c.course_id
GROUP BY 
    sc.student_id, c.course_id;
