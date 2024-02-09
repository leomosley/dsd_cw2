-- Inserting sample data into STUDENT table
INSERT INTO student (student_fname, student_mname, student_lname, student_pronouns, student_addr1, student_addr2, student_city, student_postcode, student_personal_email, student_landline, student_mobile, student_dob)
VALUES
('John', NULL, 'Doe', 'He/Him', '123 Main Street', NULL, 'London', 'SW1A 1AA', 'john.doe@example.com', '0201234567', '07891234567', '1995-05-15'),
('Jane', NULL, 'Smith', 'She/Her', '456 Park Avenue', NULL, 'Manchester', 'M1 1AA', 'jane.smith@example.com', '0161234567', '07987654321', '1994-10-20');

INSERT INTO student (student_fname, student_mname, student_lname, student_pronouns, student_addr1, student_addr2, student_city, student_postcode, student_personal_email, student_landline, student_mobile, student_dob)
VALUES
('John', NULL, 'Doe', 'He/Him', '123 Main Street', NULL, 'London', 'SW1A 1AA', 'JOHN.doe@example.com', '0201234512', '07891232567', '1995-05-15');

-- Inserting sample data into STAFF table
INSERT INTO staff (staff_fname, staff_mname, staff_lname, staff_number, staff_company_email, staff_pronouns, staff_addr1, staff_addr2, staff_city, staff_postcode, staff_personal_email, staff_landline, staff_mobile, staff_dob)
VALUES
('John', NULL, 'Smith', NULL, NULL, 'He/Him', '789 Elm Street', NULL, 'London', 'SW1A 2AA', 'john.smith@example.com', '0202345678', '07891234567', '1980-03-25'),
('Jane', NULL, 'Doe', NULL, NULL, 'She/Her', '987 Oak Avenue', NULL, 'Manchester', 'M1 2AA', 'jane.doe@example.com', '0162345678', '07987654321', '1975-07-10');

-- Inserting sample data into DEPARTMENTS table
INSERT INTO departments (dep_name, dep_type, dep_description)
VALUES
('Computer Science', 'Science', 'Department of Computer Science'),
('Mathematics', 'Science', 'Department of Mathematics');

-- Inserting sample data into TUITION table
INSERT INTO tuition (tuition_amount, tuition_paid, tuition_remaining, tuition_remaining_perc, tuition_deadline)
VALUES
(1000.00, 500.00, 500.00, 50.00, '2024-06-30'),
(1500.00, 1000.00, 500.00, 33.33, '2024-07-31');

-- Inserting sample data into TUITION_PAYMENT table
INSERT INTO tuition_payment (tuition_payment_amount, tuition_payment_date)
VALUES
(500.00, '2024-03-15'),
(1000.00, '2024-05-20');

-- Inserting sample data into STUDENT_PAYMENTS table
INSERT INTO student_payments (tuition_payment_id, tuition_id)
VALUES
(1, 1),
(2, 2);

-- Inserting sample data into STUDENT_TUITION table
INSERT INTO student_tuition (student_id, tuition_id)
VALUES
(1, 1),
(2, 2);

-- Inserting sample data into DEPARTMENT_STAFF table
INSERT INTO department_staff (dep_id)
VALUES
(1),
(2);

-- Inserting sample data into DEPARTMENT_STAFF_LIST table
INSERT INTO department_staff_list (dep_staff_id, staff_id, staff_dep_head)
VALUES
(1, 1, TRUE),
(2, 2, FALSE);

-- Inserting sample data into TEACHERS table
INSERT INTO teachers (staff_id, teacher_role, teacher_research_area)
VALUES
(1, 'Professor', 'Computer Vision'),
(2, 'Assistant Professor', 'Number Theory');

-- Inserting sample data into COURSES table
INSERT INTO courses (teacher_id, course_name, course_code, course_description, course_length)
VALUES
(1, 'Computer Vision', 101, 'Introduction to Computer Vision', 12),
(2, 'Number Theory', 102, 'Introduction to Number Theory', 10);

-- Inserting sample data into DEPARTMENT_COURSES table
INSERT INTO department_courses (dep_id, course_id)
VALUES
(1, 1),
(2, 2);

-- Inserting sample data into MODULES table
INSERT INTO modules (teacher_id, module_name, module_code, module_description, academ_lvl)
VALUES
(1, 'Image Processing', 10101, 'Introduction to Image Processing', 'UG'),
(2, 'Prime Numbers', 10201, 'Introduction to Prime Numbers', 'UG');

-- Inserting sample data into COURSE_MODULE table
INSERT INTO course_module (course_id, module_id)
VALUES
(1, 1),
(2, 2);

-- Inserting sample data into STUDENT_COURSE table
INSERT INTO student_course (student_id, course_id)
VALUES
(1, 1),
(2, 2);

-- Inserting sample data into COURSE_REP table
INSERT INTO course_rep (student_id, course_id)
VALUES
(1, 1),
(2, 2);

-- Inserting sample data into STUDENT_COURSE_PROGRESS table
INSERT INTO student_course_progress (student_id, course_id, progress_perc)
VALUES
(1, 1, 80.00),
(2, 2, 75.00);

-- Inserting sample data into STUDENT_MODULE_PROGRESS table
INSERT INTO student_module_progress (student_id, module_id, progress_perc)
VALUES
(1, 1, 90.00),
(2, 2, 85.00);

-- Inserting sample data into MODULE_ASSIGNMENTS table
INSERT INTO module_assignments (module_id, assignment_title, assignment_set_date, assignment_due_date, assignment_set_time, assignment_due_time, assignment_description, assignment_type)
VALUES
(1, 'Image Processing Assignment 1', '2024-03-01', '2024-03-15', '08:00:00', '23:59:59', 'Assignment on basic image processing techniques', 'Individual'),
(2, 'Prime Numbers Assignment 1', '2024-02-15', '2024-02-28', '08:00:00', '23:59:59', 'Assignment on properties of prime numbers', 'Group');

-- Inserting sample data into MODULE_ASSESSMENTS table
INSERT INTO module_assessments (module_id, assessment_title, assessment_set_date, assessment_due_date, assessment_set_time, assessment_due_time, assessment_description, assessment_type, assessment_weighting)
VALUES
(1, 'Image Processing Midterm Exam', '2024-04-01', '2024-04-10', '09:00:00', '12:00:00', 'Midterm exam covering topics in image processing', 'Individual', 40.00),
(2, 'Prime Numbers Final Exam', '2024-04-15', '2024-04-30', '09:00:00', '12:00:00', 'Final exam covering topics in prime numbers', 'Individual', 50.00);

-- Inserting sample data into MODULE_ASSESSMENT_GRADE table
INSERT INTO module_assessment_grade (assessment_id, student_id, assessment_grade)
VALUES
(1, 1, 85.00),
(2, 2, 90.00);

-- Inserting sample data into MODULE_ASSIGNMENT_GRADE table
INSERT INTO module_assignment_grade (assignment_id, student_id, assignment_grade)
VALUES
(1, 1, 80.00),
(2, 2, 85.00);

-- Inserting sample data into TEACHING_SESSION table
INSERT INTO teaching_session (module_id, session_type, session_start_time, session_length, session_date, session_notes)
VALUES
(1, 'Lecture', '09:00:00', 2.5, '2024-02-15', 'Introduction to Image Processing'),
(2, 'Workshop', '13:00:00', 2.0, '2024-02-15', 'Properties of Prime Numbers');

-- Inserting sample data into TEACHERS_SESSIONS table
INSERT INTO teachers_sessions (teacher_id, session_id)
VALUES
(1, 1),
(2, 2);

-- Inserting sample data into ACADEMIC_HELP_SESSIONS table
INSERT INTO academic_help_sessions (student_id, ah_session_type, ah_session_start_time, ah_session_length, ah_session_date, ah_session_notes)
VALUES
(1, 'Tutoring', '14:00:00', 1.0, '2024-03-01', 'Image Processing concepts'),
(2, 'Tutoring', '15:00:00', 1.5, '2024-03-01', 'Prime Numbers theory');

-- Inserting sample data into TEACHERS_AH_SESSIONS table
INSERT INTO teachers_ah_sessions (teacher_id, ah_session_id)
VALUES
(1, 1),
(2, 2);

-- Inserting sample data into ATTENDANCE table
INSERT INTO attendance (student_id, session_id, attendance_record)
VALUES
(1, 1, TRUE),
(2, 2, TRUE);