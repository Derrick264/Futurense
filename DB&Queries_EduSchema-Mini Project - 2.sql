CREATE DATABASE EduSchema;
USE EduSchema;
CREATE TABLE Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE
);
CREATE TABLE Instructors (
    instructor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE
);
CREATE TABLE Courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(255),
    description TEXT,
    start_date DATE,
    end_date DATE,
    instructor_id INT,
    FOREIGN KEY (instructor_id) REFERENCES Instructors(instructor_id)
);
CREATE TABLE Grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    grade CHAR(2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);
CREATE TABLE Deleted_Items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(50),
    deleted_id INT,
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    details TEXT
);

DELIMITER $$

CREATE TRIGGER after_student_delete
AFTER DELETE ON Students
FOR EACH ROW
BEGIN
    INSERT INTO Deleted_Items (table_name, deleted_id, details)
    VALUES ('Students', OLD.student_id, CONCAT('first_name: ', OLD.first_name, ', last_name: ', OLD.last_name, ', email: ', OLD.email));
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER after_instructor_delete
AFTER DELETE ON Instructors
FOR EACH ROW
BEGIN
    INSERT INTO Deleted_Items (table_name, deleted_id, details)
    VALUES ('Instructors', OLD.instructor_id, CONCAT('first_name: ', OLD.first_name, ', last_name: ', OLD.last_name, ', email: ', OLD.email));
END$$

DELIMITER ;

-- Trigger for archiving deleted courses
-- Change the delimiter to $$ to handle multi-statement triggers
DELIMITER $$

-- Create the trigger
CREATE TRIGGER after_course_delete
AFTER DELETE ON Courses
FOR EACH ROW
BEGIN
    INSERT INTO Deleted_Items (table_name, deleted_id, details)
    VALUES ('Courses', OLD.course_id, CONCAT('course_name: ', OLD.course_name, ', description: ', OLD.description, ', start_date: ', OLD.start_date, ', end_date: ', OLD.end_date, ', instructor_id: ', OLD.instructor_id));
END$$
-- Step 1: Change the delimiter
DELIMITER $$

-- Step 2: Create the trigger
CREATE TRIGGER after_course_delete
AFTER DELETE ON Courses
FOR EACH ROW
BEGIN
    INSERT INTO Deleted_Items (table_name, deleted_id, details)
    VALUES ('Courses', OLD.course_id, CONCAT('course_name: ', OLD.course_name, ', description: ', OLD.description, ', start_date: ', OLD.start_date, ', end_date: ', OLD.end_date, ', instructor_id: ', OLD.instructor_id));
END$$

-- Step 3: Reset the delimiter back to default
DELIMITER ;

INSERT INTO Students (first_name, last_name, email)
VALUES ('John', 'Doe', 'john.doe@example.com');

INSERT INTO Students (first_name, last_name, email)
VALUES ('Jane', 'Smith', 'jane.smith@example.com');

INSERT INTO Students (first_name, last_name, email)
VALUES ('Michael', 'Brown', 'michael.brown@example.com');

INSERT INTO Instructors (first_name, last_name, email)
VALUES ('Professor', 'Johnson', 'prof.johnson@example.com');

INSERT INTO Instructors (first_name, last_name, email)
VALUES ('Dr', 'Williams', 'dr.williams@example.com');

INSERT INTO Instructors (first_name, last_name, email)
VALUES ('Ms', 'Davis', 'ms.davis@example.com');

INSERT INTO Courses (course_name, description, start_date, end_date, instructor_id)
VALUES ('Introduction to Programming', 'Basic programming concepts', '2024-07-01', '2024-08-15', 1);

INSERT INTO Courses (course_name, description, start_date, end_date, instructor_id)
VALUES ('Database Management Systems', 'Fundamentals of DBMS', '2024-07-15', '2024-09-01', 2);

INSERT INTO Courses (course_name, description, start_date, end_date, instructor_id)
VALUES ('Web Development', 'Building dynamic websites', '2024-08-01', '2024-09-15', 3);


INSERT INTO Grades (student_id, course_id, grade)
VALUES (1, 1, 85);

-- Assuming student_id 2 enrolled in course_id 2
INSERT INTO Grades (student_id, course_id, grade)
VALUES (2, 2, 78);

-- Assuming student_id 3 enrolled in course_id 3
INSERT INTO Grades (student_id, course_id, grade)
VALUES (3, 3, 92);

INSERT INTO Students (first_name, last_name, email)
VALUES ('John', 'Doe', 'john.doe@example.com');

ALTER TABLE Grades
DROP FOREIGN KEY grades_ibfk_1;

ALTER TABLE Grades
ADD CONSTRAINT grades_ibfk_1
FOREIGN KEY (student_id) REFERENCES Students(student_id)
ON DELETE CASCADE;

select * from Students;
select * from Deleted_items;
INSERT INTO Students (first_name, last_name, email)
VALUES ('Ajay', 'anisen', 'john.doe@example.com');
INSERT INTO Students (first_name, last_name, email)
VALUES ('Aswin', 'D', 'aswin.doe@example.com');
INSERT INTO Students (first_name, last_name, email)
VALUES ('deepak', 's', 'deepal.doe@example.com');
