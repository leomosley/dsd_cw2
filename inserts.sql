INSERT INTO student (student_fname, student_mname, student_lname, student_pronouns, student_addr1, student_addr2, student_city, student_postcode, student_personal_email, student_landline, student_mobile, student_dob) 
VALUES
('Felita', 'Grange', 'Fairham', null, '789 Oak Ln', '19th Floor', 'Manchester', 'VH02 1IO', 'gfairham0@ask.com', '4287150585', '8523892044', '2007-08-28'),
('Maye', 'Elsie', 'Congdon', 'he', '456 Elm Ave', 'Room 1930', 'Birmingham', 'FT6F 0XH', null, '6518467478', '4621357895', '2008-06-23'),
('Mick', 'Wylie', 'Healey', null, '321 Pine Rd', 'Room 193', 'Leeds', 'GRG 2PR', 'whealey2@tamu.edu', '4656734700', '2164921507', '2006-03-09'),
('Pyotr', 'Kayne', 'Dempsey', 'she', '456 Elm Ave', 'PO Box 20656', 'Liverpool', 'JJRB 4KS', 'kdempsey3@ox.ac.uk', '1701146630', '7542836744', '2004-07-30'),
('Jone', null, 'Micco', 'he', '456 Elm Ave', 'PO Box 72085', 'Manchester', 'SA1L 9GG', 'wmicco4@a8.net', '5667564201', '2267927475', '2004-12-13'),
('Toni', 'Dino', 'Dieton', null, '987 Maple Blvd', 'Apt 1509', 'Liverpool', 'G9R 7EW', 'ddieton5@nasa.gov', '2678574325', '8292691515', '2005-02-12'),
('Laure', 'Howard', 'Fallon', '', '321 Pine Rd', 'Room 300', 'Leeds', 'XLR 5MM', 'hfallon6@istockphoto.com', '5418303558', '2792673665', '2008-04-25'),
('Becca', null, 'Solway', null, '321 Pine Rd', 'PO Box 15959', 'London', 'IV4 0NJ', 'fsolway7@princeton.edu', '2439487477', '7176026661', '2006-12-28'),
('Wally', 'Tiffanie', 'Long', null, '123 Main St', '8th Floor', 'Glasgow', 'U27 1JY', 'tlong8@sbwire.com', '1893931406', '6942592115', '2004-01-26'),
('Gayler', 'Nikos', 'Lorand', 'she', '456 Elm Ave', 'PO Box 43934', 'London', 'KR 3JR', 'nlorand9@businesswire.com', '9229076112', '6263756861', '2008-04-21');


-- Insert into student table
INSERT INTO student (student_fname, student_lname, student_pronouns, student_addr1, student_city, student_postcode, student_mobile, student_dob)
VALUES ('John', 'Doe', 'he/him', '123 Main St', 'London', 'SW1A 1AA', '1234567890', '1990-01-01'),
       ('Jane', 'Smith', 'she/her', '456 Oak St', 'Manchester', 'M1 1AA', '9876543210', '1985-05-15'),
       ('Michael', 'Johnson', 'they/them', '789 Elm St', 'Glasgow', 'G1 1AA', '7890123456', '1978-09-30');

-- Insert into tuition table
INSERT INTO tuition (tuition_amount, tuition_paid, tuition_remaining, tuition_remaining_perc, tuition_deadline)
VALUES (1000.00, 500.00, 500.00, 50.00, '2024-06-30'),
       (1500.00, 1000.00, 500.00, 33.33, '2024-07-31'),
       (1200.00, 600.00, 600.00, 50.00, '2024-08-31');

-- Insert into tuition_payment table
INSERT INTO tuition_payment (tuition_payment_amount, tuition_payment_date)
VALUES (250.00, '2024-01-15'),
       (300.00, '2024-02-10'),
       (200.00, '2024-03-20');

-- Insert into student_payments table
INSERT INTO student_payments (tuition_payment_id, tuition_id)
VALUES (1, 1),
       (2, 2),
       (3, 3);

-- Insert into student_tuition table
INSERT INTO student_tuition (student_id, tuition_id)
VALUES (1, 1),
       (2, 2),
       (3, 3);

-- Insert into departments table
INSERT INTO departments (dep_name, dep_type, dep_description)
VALUES ('Computer Science', 'Science', 'Department of Computer Science'),
       ('Mathematics', 'Science', 'Department of Mathematics'),
       ('History', 'Humanities', 'Department of History');

-- Insert into staff table
INSERT INTO staff (staff_fname, staff_lname, staff_pronouns, staff_addr1, staff_city, staff_postcode, staff_mobile, staff_dob)
VALUES ('Emily', 'Taylor', 'she/her', '789 Pine St', 'Birmingham', 'B1 1AA', '6543210987', '1987-07-20'),
       ('David', 'Brown', 'he/him', '101 Maple Ave', 'Leeds', 'LS1 1AA', '1239876543', '1976-03-12'),
       ('Sophie', 'Clark', 'she/her', '222 Elm St', 'Liverpool', 'L1 1AA', '7896541230', '1995-11-05');

-- Insert into salary table
INSERT INTO salary (salary_base, salary_bonuses, salary_start_date, salary_end_date)
VALUES (30000.00, 5000.00, '2024-01-01', NULL),
       (35000.00, 6000.00, '2024-02-01', NULL),
       (32000.00, 5500.00, '2024-03-01', NULL);

-- Insert into staff_salary table
INSERT INTO staff_salary (salary_id, staff_id)
VALUES (1, 1),
       (2, 2),
       (3, 3);

-- Insert into hours table
INSERT INTO hours (start_time, end_time, date)
VALUES ('08:00:00', '12:00:00', '2024-01-15'),
       ('09:00:00', '17:00:00', '2024-02-10'),
       ('10:00:00', '16:00:00', '2024-03-20');

-- Insert into staff_hours table
INSERT INTO staff_hours (hour_id, staff_id)
VALUES (1, 1),
       (2, 2),
       (3, 3);

-- Insert into deduction table
INSERT INTO deduction (deduction_title, deduction_details, deduction_amount)
VALUES ('Tax', 'Income tax deduction', 200.00),
       ('Health Insurance', 'Health insurance deduction', 100.00),
       ('Pension', 'Pension contribution', 150.00);

-- Insert into salary_payslip table
INSERT INTO salary_payslip (salary_id, issue_date, start_date, end_date, net_pay, gross_pay, payment_method, tax_code, tax_period, national_insurance_num, hourly_rate)
VALUES (1, '2024-01-31', '2024-01-01', '2024-01-31', 3000.00, 3500.00, 'Bank Transfer', 'BR', 1, 'AB123456C', 20.00),
       (2, '2024-02-29', '2024-02-01', '2024-02-29', 3250.00, 3750.00, 'Bank Transfer', 'BR', 2, 'CD789012E', 21.00),
       (3, '2024-03-31', '2024-03-01', '2024-03-31', 3100.00, 3600.00, 'Bank Transfer', 'BR', 3, 'EF345678D', 20.50);

-- Insert into salary_deduction table
INSERT INTO salary_deduction (deduction_id, salary_id)
VALUES (1, 1),
       (2, 1),
       (3, 1);

-- Insert into department_staff table
INSERT INTO department_staff (dep_id)
VALUES (1),
       (2),
       (3);

-- Insert into department_staff_list table
INSERT INTO department_staff_list (dep_staff_id, staff_id, staff_dep_head)
VALUES (1, 1, TRUE),
       (2, 2, TRUE),
       (3, 3, FALSE);

-- Insert into teachers table
INSERT INTO teachers (staff_id, teacher_role, teacher_research_area)
VALUES (1, 'Professor', 'Artificial Intelligence'),
       (2, 'Lecturer', 'Pure Mathematics'),
       (3, 'Assistant Professor', 'Modern History');

-- Insert into courses table
INSERT INTO courses (teacher_id, course_name, course_code, course_description, course_length)
VALUES (1, 'Introduction to AI', 1001, 'A foundational course in artificial intelligence', 12),
       (2, 'Calculus I', 2001, 'Introduction to differential and integral calculus', 14),
       (3, 'World War II History', 3001, 'A study of World War II events and consequences', 10);

-- Insert into department_courses table
INSERT INTO department_courses (dep_id, course_id)
VALUES (1, 1),
       (2, 2),
       (3, 3);

-- Insert into modules table
INSERT INTO modules (teacher_id, module_name, module_code, module_description, academ_lvl)
VALUES (1, 'Machine Learning Fundamentals', 10001, 'Basic concepts and algorithms in machine learning', 'UG'),
       (2, 'Differentiation', 20001, 'Introduction to differentiation techniques', 'UG'),
       (3, 'The Rise of Fascism', 30001, 'A historical analysis of the rise of fascism in Europe', 'UG');

-- Insert into course_module table
INSERT INTO course_module (course_id, module_id)
VALUES (1, 1),
       (2, 2),
       (3, 3);

-- Insert into student_course table
INSERT INTO student_course (student_id, course_id)
VALUES (1, 1),
       (2, 2),
       (3, 3);

-- Insert into course_rep table
INSERT INTO course_rep (student_id, course_id)
VALUES (1, 1),
       (2, 2),
       (3, 3);

-- Insert into student_course_progress table
INSERT INTO student_course_progress (student_id, course_id, progress_perc)
VALUES (1, 1, 80.0),
       (2, 2, 70.0),
       (3, 3, 90.0);

-- Insert into student_module_progress table
INSERT INTO student_module_progress (student_id, module_id, progress_perc)
VALUES (1, 1, 85.0),
       (2, 2, 75.0),
       (3, 3, 95.0);

-- Insert into module_assignments table
INSERT INTO module_assignments (module_id, assignment_title, assignment_set_date, assignment_due_date, assignment_set_time, assignment_due_time, assignment_description, assignment_type)
VALUES (1, 'Assignment 1', '2024-01-15', '2024-01-30', '09:00:00', '23:59:59', 'Assignment on basic ML concepts', 'Individual'),
       (2, 'Homework 1', '2024-02-10', '2024-02-28', '10:00:00', '23:59:59', 'Homework problems on differentiation', 'Individual'),
       (3, 'Essay', '2024-03-20', '2024-04-10', '08:00:00', '23:59:59', 'Essay on the events leading to WWII', 'Individual');

-- Insert into module_assessments table
INSERT INTO module_assessments (module_id, assessment_title, assessment_set_date, assessment_due_date, assessment_set_time, assessment_due_time, assessment_description, assessment_type, assessment_weighting)
VALUES (1, 'Midterm Exam', '2024-01-25', '2024-01-25', '09:00:00', '12:00:00', 'Midterm examination covering course material', 'Exam', 30.0),
       (2, 'Quiz', '2024-02-15', '2024-02-15', '10:00:00', '11:00:00', 'Short quiz on differentiation concepts', 'Quiz', 20.0),
       (3, 'Final Paper', '2024-03-30', '2024-03-30', '08:00:00', '23:59:59', 'Research paper on WWII', 'Paper', 40.0);

-- Insert into module_assessment_grade table
INSERT INTO module_assessment_grade (assessment_id, student_id, assessment_grade)
VALUES (1, 1, 85.0),
       (2, 2, 90.0),
       (3, 3, 88.0);

-- Insert into module_assignment_grade table
INSERT INTO module_assignment_grade (assignment_id, student_id, assignment_grade)
VALUES (1, 1, 90.0),
       (2, 2, 85.0),
       (3, 3, 92.0);

-- Insert into teaching_session table
INSERT INTO teaching_session (module_id, session_type, session_start_time, session_length, session_date, session_notes)
VALUES (1, 'Lecture', '08:00:00', 2.5, '2024-01-20', 'Introduction to machine learning concepts'),
       (2, 'Tutorial', '09:00:00', 1.5, '2024-02-15', 'Problem-solving session on differentiation'),
       (3, 'Seminar', '10:00:00', 3.0, '2024-03-25', 'Discussion on WWII causes and effects');

-- Insert into teachers_sessions table
INSERT INTO teachers_sessions (teacher_id, session_id)
VALUES (1, 1),
       (2, 2),
       (3, 3);

-- Insert into academic_help_sessions table
INSERT INTO academic_help_sessions (student_id, ah_session_type, ah_session_start_time, ah_session_length, ah_session_date, ah_session_notes)
VALUES (1, 'Maths', '08:00:00', 1.0, '2024-01-25', 'Help with calculus problems'),
       (2, 'History', '09:00:00', 2.0, '2024-02-20', 'Discussion on WWII events'),
       (3, 'AI', '10:00:00', 1.5, '2024-03-30', 'Machine learning algorithm assistance');

-- Insert into teachers_ah_sessions table
INSERT INTO teachers_ah_sessions (teacher_id, ah_session_id)
VALUES (1, 1),
       (2, 2),
       (3, 3);

-- Insert into attendance table
INSERT INTO attendance (student_id, session_id, attendance_record)
VALUES (1, 1, TRUE),
       (2, 2, TRUE),
       (3, 3, TRUE);
