--### СТВОРЮЄМО НЕОБХІДНІ ТАБЛИЦІ ДЛЯ ОНЛАЙН УЧБОВОЇ ПЛАТФОРМИ:
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    full_name  TEXT NOT NULL,
    city       TEXT,
    reg_date   DATE
);
CREATE TABLE instructors (
    instructor_id SERIAL PRIMARY KEY,
    full_name     TEXT NOT NULL,
    specialization TEXT
);
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name TEXT NOT NULL,
    category    TEXT,
    instructor_id INT REFERENCES instructors(instructor_id)
);
CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(student_id),
    course_id  INT REFERENCES courses(course_id),
    enroll_date DATE
);
CREATE TABLE progress (
    progress_id SERIAL PRIMARY KEY,
    enrollment_id INT REFERENCES enrollments(enrollment_id),
    lesson_number INT,
    score NUMERIC(5,2),     -- оцінка за урок
    completed BOOLEAN
);
--### НАПОВНЮЄМО СТВОРЕНІ ТАБЛИЦІ ДАННИМИ:
INSERT INTO students (full_name, city, reg_date) VALUES
('Anna Kovalenko', 'Kyiv', '2024-01-12'),
('Dmytro Shevchenko', 'Lviv', '2024-02-05'),
('Olena Bondar', 'Kharkiv', '2024-03-18'),
('Serhii Melnyk', 'Odesa', '2024-01-25'),
('Iryna Tkachenko', 'Dnipro', '2024-04-02'),
('Maksym Horbunov', 'Kyiv', '2024-02-20'),
('Kateryna Polishchuk', 'Lviv', '2024-03-01'),
('Yurii Kravets', 'Kharkiv', '2024-03-22'),
('Sofiia Levchenko', 'Odesa', '2024-04-10'),
('Vladyslav Chernenko', 'Kyiv', '2024-01-30');
INSERT INTO instructors (full_name, specialization) VALUES
('Oleh Marchenko', 'Data Science'),
('Tetiana Ivanova', 'Web Development'),
('Roman Sydorenko', 'Machine Learning'),
('Natalia Hlushko', 'UI/UX Design'),
('Andrii Petrenko', 'Databases');
INSERT INTO courses (course_name, category, instructor_id) VALUES
('Python for Beginners', 'Programming', 1),
('Data Analysis with SQL', 'Data Science', 5),
('Machine Learning Basics', 'Machine Learning', 3),
('Frontend Development with React', 'Web Development', 2),
('UI/UX Fundamentals', 'Design', 4),
('Advanced SQL Analytics', 'Data Science', 5),
('Deep Learning Intro', 'Machine Learning', 3),
('JavaScript Essentials', 'Programming', 2);
INSERT INTO enrollments (student_id, course_id, enroll_date) VALUES
(1, 1, '2024-02-01'),
(1, 2, '2024-02-10'),
(2, 2, '2024-02-15'),
(2, 4, '2024-03-01'),
(3, 3, '2024-03-20'),
(3, 6, '2024-03-25'),
(4, 1, '2024-02-05'),
(4, 5, '2024-04-01'),
(5, 2, '2024-04-05'),
(5, 7, '2024-04-12'),
(6, 4, '2024-03-10'),
(7, 5, '2024-03-15'),
(8, 6, '2024-04-02'),
(9, 3, '2024-04-15'),
(10, 1, '2024-02-20');
INSERT INTO progress (enrollment_id, lesson_number, score, completed) VALUES
-- Enrollment 1 (Anna, Python)
(1, 1, 85, TRUE),
(1, 2, 90, TRUE),
(1, 3, 88, TRUE),
-- Enrollment 2 (Anna, SQL)
(2, 1, 92, TRUE),
(2, 2, 87, TRUE),
(2, 3, 95, TRUE),
-- Enrollment 3 (Dmytro, SQL)
(3, 1, 78, TRUE),
(3, 2, 82, TRUE),
(3, 3, 80, FALSE),
-- Enrollment 4 (Dmytro, React)
(4, 1, 88, TRUE),
(4, 2, 90, TRUE),
-- Enrollment 5 (Olena, ML)
(5, 1, 91, TRUE),
(5, 2, 89, TRUE),
(5, 3, 93, TRUE),
-- Enrollment 6 (Olena, Advanced SQL)
(6, 1, 85, TRUE),
(6, 2, 87, TRUE),
-- Enrollment 7 (Serhii, Python)
(7, 1, 70, TRUE),
(7, 2, 75, FALSE),
-- Enrollment 8 (Serhii, UI/UX)
(8, 1, 95, TRUE),
(8, 2, 97, TRUE),
-- Enrollment 9 (Iryna, SQL)
(9, 1, 88, TRUE),
(9, 2, 92, TRUE),
(9, 3, 90, TRUE),
-- Enrollment 10 (Iryna, Deep Learning)
(10, 1, 84, TRUE),
(10, 2, 86, TRUE),
-- Enrollment 11 (Maksym, React)
(11, 1, 80, TRUE),
(11, 2, 82, TRUE),
-- Enrollment 12 (Kateryna, UI/UX)
(12, 1, 98, TRUE),
(12, 2, 96, TRUE),
-- Enrollment 13 (Yurii, Advanced SQL)
(13, 1, 75, TRUE),
(13, 2, 78, TRUE),
-- Enrollment 14 (Sofiia, ML)
(14, 1, 89, TRUE),
(14, 2, 91, TRUE),
(14, 3, 94, TRUE),
-- Enrollment 15 (Vladyslav, Python)
(15, 1, 82, TRUE),
(15, 2, 85, TRUE),
(15, 3, 88, TRUE);


--### ЗАПИТИ ДО БАЗИ ДАНИХ:
1. Вивести всіх студентів, які зареєструвалися після 2024‑01‑01
SELECT full_name FROM students
WHERE reg_date > '2024.01.01';

full_name
Anna Kovalenko
Dmytro Shevchenko
Olena Bondar
Serhii Melnyk
Iryna Tkachenko
Maksym Horbunov
Kateryna Polishchuk
Yurii Kravets
Sofiia Levchenko
Vladyslav Chernenko

# Online_Platforma
# **Задачі**

## **Задача 1. Базові SELECT**

1. Вивести всіх студентів, які зареєструвалися після 2024‑01‑01.
![](task1_1-1.png)

2. Вивести всі курси категорії `"Data Science"`.
![](task1_2.png)

## **Задача 2. Групування та агрегація**

1. Порахувати кількість студентів у кожному місті.
![](task2_1.png)
2. Порахувати кількість курсів у кожній категорії.
![](task2_2.png)
3. Порахувати середню оцінку по кожному курсу.
![](task2_3.png)

## **Задача 3. JOIN‑аналіз**

1. Вивести список курсів разом з іменами викладачів.
![](task3_1.png)
2. Вивести студентів та назви курсів, на які вони записані.
![](task3_2.png)
3. Порахувати, скільки студентів у кожного викладача.
![](task3_3.png)

## **Задача 4. Аналітика прогресу**

1. Порахувати середню оцінку кожного студента.
![](task4_1.png)
2. Порахувати відсоток завершених уроків для кожного курсу.

3. Знайти студентів, які завершили всі уроки у своїх курсах.


## **Задача 5. Віконні функції**

1. Для кожного курсу визначити рейтинг студентів за середнім балом.

2. Порахувати кумулятивну кількість уроків, завершених студентом у хронологічн

