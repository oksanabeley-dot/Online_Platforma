# Online_Platforma
# **Задачі**

## **Задача 1. Базові SELECT**

1.1 Вивести всіх студентів, які зареєструвалися після 2024‑01‑01.
SELECT student_id, full_name, city,	reg_date 
FROM students
WHERE reg_date > '2024.01.01';


1.2 Вивести всі курси категорії `"Data Science"`.
SELECT course_id, course_name, category 
FROM courses
WHERE category = 'Data Science';

## **Задача 2. Групування та агрегація**

2.1 Порахувати кількість студентів у кожному місті.
SELECT city, COUNT(*) AS student_count FROM students
GROUP BY city;

2.2 Порахувати кількість курсів у кожній категорії.
SELECT category, COUNT(*) AS course_count FROM courses
GROUP BY category;


2.3 Порахувати середню оцінку по кожному курсу.
SELECT c.course_id, c.course_name, AVG(p.score) AS average_score
FROM progress p
JOIN enrollments e ON e.enrollment_id = p.enrollment_id
JOIN courses c ON c.course_id = e.course_id
GROUP BY c.course_id;


## **Задача 3. JOIN‑аналіз**

3.1 Вивести список курсів разом з іменами викладачів.
SELECT c.course_id, c.course_name, c.instructor_id, i.full_name
FROM courses c
JOIN instructors i ON c.instructor_id = i.instructor_id;

3.2 Вивести студентів та назви курсів, на які вони записані.
SELECT s.student_id, s.full_name, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

3.3. Порахувати, скільки студентів у кожного викладача.
SELECT i.instructor_id, i.full_name, COUNT(DISTINCT e.student_id) AS students_count
FROM instructors i
JOIN courses c ON i.instructor_id = c.instructor_id
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY i.instructor_id, i.full_name;

## **Задача 4. Аналітика прогресу**

4.1. Порахувати середню оцінку кожного студента.
SELECT s.student_id, s.full_name, AVG(p.score) AS average_score
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN progress p ON e.enrollment_id = p.enrollment_id
GROUP BY s.student_id;

4.2. Порахувати відсоток завершених уроків для кожного курсу.
SELECT c.course_id, c.course_name,
         COUNT(CASE WHEN p.completed = TRUE THEN 1 END) * 100.0 / COUNT(p.lesson_number) AS completion_percentage
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN progress p ON e.enrollment_id = p.enrollment_id
GROUP BY c.course_id;


4.3. Знайти студентів, які завершили всі уроки у своїх курсах.
SELECT s.student_id, s.full_name,
         COUNT(CASE WHEN p.completed = TRUE THEN 1 END) * 100.0 / COUNT(p.lesson_number) AS completion_percentage
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN progress p ON e.enrollment_id = p.enrollment_id
GROUP BY s.student_id
HAVING COUNT(CASE WHEN p.completed = TRUE THEN 1 END) * 100.0 / COUNT(p.lesson_number) = 100;

## **Задача 5. Віконні функції**

5.1. Для кожного курсу визначити рейтинг студентів за середнім балом.
SELECT 
    ROW_NUMBER() OVER (ORDER BY average_score DESC) AS rating_num,
    student_id,
    full_name,
    average_score
FROM (
    SELECT 
        s.student_id,
        s.full_name,
        AVG(p.score) AS average_score
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN progress p ON e.enrollment_id = p.enrollment_id
    GROUP BY s.student_id
) t
ORDER BY average_score DESC;
-- DENSE_RANK() OVER (ORDER BY average_score DESC) AS rating_num
-- 👉 Присвоює місце (рейтинг) кожному рядку
-- 👉 Однакові значення отримують однаковий номер
-- 👉 Немає пропусків у нумерації

5.2. Порахувати кумулятивну кількість уроків, завершених студентом у хронологічному порядку.
SELECT
    ROW_NUMBER() OVER (ORDER BY first_enroll_date) AS row_num,
    first_enroll_date,
    student_id,
    full_name,
    cumulative_lessons
FROM (SELECT 
    MIN(e.enroll_date) AS first_enroll_date,
    s.student_id,
    s.full_name,
    COUNT(p.lesson_number) AS cumulative_lessons
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN progress p ON e.enrollment_id = p.enrollment_id
GROUP BY s.student_id, s.full_name) t 
ORDER BY first_enroll_date;
-- ROW_NUMBER() OVER (ORDER BY …) пишеш те, за чим хочеш нумерувати рядки,
-- але це має бути вже готова колонка (або вираз)
5.3. Для кожної категорії курсів знайти топ‑1 курс за кількістю студентів.
SELECT 
    category,
    course_id,
    course_name,
    student_count
FROM (
    SELECT 
        c.category,
        c.course_id,
        c.course_name,
        COUNT(DISTINCT e.student_id) AS student_count,
        ROW_NUMBER() OVER (PARTITION BY c.category ORDER BY COUNT(DISTINCT e.student_id) DESC) AS row_num
    FROM courses c
    JOIN enrollments e ON c.course_id = e.course_id
    GROUP BY c.category, c.course_id, c.course_name
) t
WHERE row_num = 1;

-- ROW_NUMBER() → нумерує рядки у межах кожного вікна
-- OVER(...) → визначає вікно, тобто групу рядків, над якими працює функція
-- 1️⃣ PARTITION BY c.category
-- Розбиває всі курси на групи за категоріями
-- Нумерація починається заново для кожної категорії
-- 2️⃣ ORDER BY COUNT(DISTINCT e.student_id) DESC
-- Визначає порядок нумерації рядків у межах категорії
-- Курс з найбільшою кількістю студентів отримає row_num = 1