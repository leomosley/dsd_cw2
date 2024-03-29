/*
  Group 5 DSD Coursework 2 Database Schema
  ERD PDF: https://drive.google.com/file/d/1iDu0xKDJ3Q3pOWQTRIYSET8nkVc8jzO_/view?usp=drive_link
  Github Repo: https://github.com/leomosley/dsd_cw2
*/

/* 
  Function to generate and return a random string of 
  numbers - length is specified through parameter (length INT).
*/
CREATE OR REPLACE FUNCTION generate_random_string(length INT)
RETURNS VARCHAR AS $$
DECLARE
  string VARCHAR;
BEGIN
  string := '';
  FOR i IN 1..length LOOP
    string := CONCAT(string, to_char(floor(random() * 10), 'FM0'));
  END LOOP;

  RETURN string;
END;
$$ LANGUAGE plpgsql;

/* 
  Function to generate and return a unique identifier of 
  length specified through parameter (length INT).

  Uses the UIDS table to store all generated uids to ensure
  that they are all unique. 
*/
CREATE OR REPLACE FUNCTION generate_uid(length INT)
RETURNS VARCHAR AS $$
DECLARE
  string VARCHAR;
BEGIN
  string := generate_random_string(length);

  WHILE EXISTS (SELECT uid FROM uids WHERE uid = string) LOOP
    string := generate_random_string(length);
  END LOOP;

  INSERT INTO uids (uid) VALUES (string);

  RETURN string;
END;
$$ LANGUAGE plpgsql;

-- ------------------------
-- Table structure for UIDS
-- ------------------------
CREATE TABLE uids (
  uid VARCHAR(250) PRIMARY KEY
);

-- ----------------------------
-- Table structure for STUDENT
-- ----------------------------
CREATE TABLE student (
  student_id SERIAL PRIMARY KEY,
  student_number CHAR(10) UNIQUE NOT NULL,
  student_edu_email CHAR(22) UNIQUE NOT NULL,
  student_fname VARCHAR(50) NOT NULL,
  student_mname VARCHAR(50),
  student_lname VARCHAR(50) NOT NULL,
  student_pronouns VARCHAR(20),
  student_addr1 VARCHAR(30) NOT NULL,
  student_addr2 VARCHAR(30),
  student_city VARCHAR(30) NOT NULL,
  student_postcode CHAR(8) NOT NULL,
  student_personal_email VARCHAR(150),
  student_landline VARCHAR(30) UNIQUE,
  student_mobile VARCHAR(15) NOT NULL UNIQUE,
  student_dob DATE NOT NULL
);

/* 
  Trigger function to create the student_number, the student_edu_email
  using the student_number, and ensure that the value for student_personal_email
  is lowercase.
*/
CREATE OR REPLACE FUNCTION set_student_emails()
RETURNS TRIGGER AS $$
BEGIN
  NEW.student_number := CONCAT('sti', generate_uid(7));
  NEW.student_edu_email := CONCAT(NEW.student_number, '@sti.edu.org');

  IF NEW.student_personal_email IS NOT NULL THEN 
    NEW.student_personal_email := LOWER(NEW.student_personal_email);
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

/* 
  Trigger to insert the created student_number, student_edu_email, and updated
  student_personal_email into the student table.
*/
CREATE TRIGGER insert_student_email_trigger
BEFORE INSERT ON student
FOR EACH ROW
EXECUTE FUNCTION set_student_emails();

/* 
  Functional index to enforce case insensitive uniqueness of the 
  student personal email.
*/
CREATE UNIQUE INDEX unique_student_personal_email_idx ON student (LOWER(student_personal_email));

CREATE INDEX idx_student_student_number ON student(student_number);

-- ----------------------------
-- Table structure for TUITION
-- ----------------------------
CREATE TABLE tuition (
  tuition_id SERIAL PRIMARY KEY,
  tuition_amount DECIMAL(7, 2) NOT NULL,
  tuition_paid DECIMAL(7, 2) NOT NULL,
  tuition_remaining DECIMAL(7, 2) NOT NULL,
  tuition_remaining_perc DECIMAL(5, 2) NOT NULL,
  tuition_deadline DATE NOT NULL,
  CONSTRAINT valid_tuition_amount CHECK (tuition_amount >= 0),
  CONSTRAINT valid_tuition_paid CHECK (tuition_paid >= 0 AND tuition_paid <= tuition_amount),
  CONSTRAINT valid_tuition_remaining CHECK (tuition_remaining >= 0 AND tuition_remaining <= tuition_amount),
  CONSTRAINT valid_tuition_remaining_perc CHECK (tuition_remaining_perc >= 0 AND tuition_remaining_perc <= 100)
);

CREATE INDEX idx_tuition_tuition_id ON tuition(tuition_id);

-- ------------------------------------
-- Table structure for TUITION_PAYMENT
-- ------------------------------------
CREATE TABLE tuition_payment (
  tuition_payment_id SERIAL PRIMARY KEY,
  tuition_payment_reference CHAR(12) DEFAULT (
    CONCAT('PY', generate_uid(10))
  ) NOT NULL UNIQUE, 
  tuition_payment_amount DECIMAL(7, 2) NOT NULL,
  tuition_payment_date DATE NOT NULL,
  CONSTRAINT valid_tuition_payment_amount CHECK (tuition_payment_amount >= 0)
);

-- -------------------------------------
-- Table structure for STUDENT_PAYMENTS
-- -------------------------------------
CREATE TABLE student_payments (
  tuition_payment_id INT,
  tuition_id INT,
  PRIMARY KEY (tuition_payment_id, tuition_id),
  FOREIGN KEY (tuition_payment_id) REFERENCES tuition_payment (tuition_payment_id),
  FOREIGN KEY (tuition_id) REFERENCES tuition (tuition_id)
);

/* 
  Trigger function to update the tuition after an insert into the 
  tuition_payment table. Calculates the tuition_paid, tuition_remaining, 
  and tuition_remaining_perc. 
*/
CREATE OR REPLACE FUNCTION update_tuition_after_payment()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE tuition AS t
    SET 
      tuition_paid = tuition_paid + tp.tuition_payment_amount,
      tuition_remaining = tuition_remaining - tp.tuition_payment_amount,
      tuition_remaining_perc = ((tuition_amount - (tuition_paid + tp.tuition_payment_amount)) / tuition_amount) * 100
    FROM tuition_payment AS tp
    WHERE tp.tuition_payment_id = NEW.tuition_payment_id AND tuition_id = NEW.tuition_id;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

/* 
  Trigger to update valeus in the tuition table after insert on 
  tuition_payment. 
*/
CREATE TRIGGER after_student_payments_insert
AFTER INSERT ON student_payments
FOR EACH ROW
EXECUTE FUNCTION update_tuition_after_payment();

CREATE INDEX idx_student_payments_tuition_id ON student_payments(tuition_id);

-- -------------------------------------
-- Table structure for STUDENT_TUITION
-- -------------------------------------
CREATE TABLE student_tuition (
  student_id INT,
  tuition_id INT,
  PRIMARY KEY (student_id, tuition_id),
  FOREIGN KEY (student_id) REFERENCES student (student_id),
  FOREIGN KEY (tuition_id) REFERENCES tuition (tuition_id)
);

CREATE INDEX idx_student_tuition_student_id ON student_tuition(student_id);

-- --------------------------------
-- Table structure for DEPARTMENTS
-- --------------------------------
CREATE TABLE departments (
  dep_id SERIAL PRIMARY KEY,
  dep_name VARCHAR(50) NOT NULL,
  dep_type VARCHAR(50) NOT NULL,
  dep_description VARCHAR(200)
);

-- -----------------------
-- Records of DEPARTMENTS
-- -----------------------
INSERT INTO departments (dep_name, dep_type, dep_description)
VALUES
('Arts', 'Educational', 'Department of Arts'),
('Humanities', 'Educational', 'Department of Humanities'),
('Computing', 'Educational', 'Department of Computing'),
('Mathematics', 'Educational', 'Department of Mathematics'),
('Finance', 'Administrative', NULL),
('Human Resources', 'Administrative', NULL);

-- --------------------------------
-- Table structure for STAFF
-- --------------------------------
CREATE TABLE staff (
  staff_id SERIAL PRIMARY KEY,
  staff_fname VARCHAR(50) NOT NULL,
  staff_mname VARCHAR(50),
  staff_lname VARCHAR(50) NOT NULL,
  staff_number CHAR(10) UNIQUE NOT NULL,
  staff_company_email CHAR(22) UNIQUE NOT NULL,
  staff_pronouns VARCHAR(50) NOT NULL,
  staff_addr1 VARCHAR(30) NOT NULL,
  staff_addr2 VARCHAR(30),
  staff_city VARCHAR(30) NOT NULL,
  staff_postcode CHAR(8) NOT NULL,
  staff_personal_email VARCHAR(150) UNIQUE,
  staff_landline VARCHAR(30) UNIQUE,
  staff_mobile VARCHAR(15) NOT NULL UNIQUE,
  staff_dob DATE NOT NULL
);

/* 
  Trigger function to create the staff_number, the staff_company_email
  using the staff_number, and ensure that the value for staff_personal_email
  is lowercase.
*/
CREATE OR REPLACE FUNCTION set_staff_emails()
RETURNS TRIGGER AS $$
BEGIN
  NEW.staff_number := LOWER(CONCAT(LEFT(NEW.staff_fname, 1), LEFT(NEW.staff_lname, 1), generate_uid(8)));
  NEW.staff_company_email := CONCAT(NEW.staff_number, '@sti.edu.org');

  IF NEW.staff_personal_email IS NOT NULL THEN 
    NEW.staff_personal_email := LOWER(NEW.staff_personal_email);
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;  

/* 
  Trigger to insert the staff_number, staff_company_email, and updated 
  staff_peersonal_email into the staff table.
*/
CREATE TRIGGER insert_staff_emails_trigger
BEFORE INSERT ON staff
FOR EACH ROW
EXECUTE FUNCTION set_staff_emails();

/* 
  Functional index to enforce case insensitive uniqueness of the 
  staff personal email.
*/
CREATE UNIQUE INDEX unique_staff_personal_email_idx ON staff (LOWER(staff_personal_email));

-- ---------------------------
-- Table structure for SALARY
-- ---------------------------
CREATE TABLE salary (
  salary_id SERIAL PRIMARY KEY,
  salary_base DECIMAL(8, 2) NOT NULL,
  salary_bonuses DECIMAL(8, 2) NOT NULL,
  salary_start_date DATE NOT NULL,
  salary_end_date DATE,
  CONSTRAINT valid_base CHECK (salary_base >= 0),
  CONSTRAINT valid_bonus CHECK (salary_bonuses >= 0)
);

-- ---------------------------------
-- Table structure for STAFF_SALARY
-- ---------------------------------
CREATE TABLE staff_salary (
  salary_id INT,
  staff_id INT,
  PRIMARY KEY (salary_id, staff_id),
  FOREIGN KEY (salary_id) REFERENCES salary (salary_id),
  FOREIGN KEY (staff_id) REFERENCES staff (staff_id)
);

-- ---------------------------
-- Table structure for HOURS
-- ---------------------------
CREATE TABLE hours (
  hour_id SERIAL PRIMARY KEY,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  date DATE NOT NULL,
  CONSTRAINT valid_times CHECK (start_time < end_time)
);

-- --------------------------------
-- Table structure for STAFF_HOURS
-- --------------------------------
CREATE TABLE staff_hours (
  hour_id INT,
  staff_id INT,
  PRIMARY KEY (hour_id, staff_id),
  FOREIGN KEY (hour_id) REFERENCES hours (hour_id),
  FOREIGN KEY (staff_id) REFERENCES staff (staff_id) 
);

-- --------------------------------
-- Table structure for DEDUCTION
-- --------------------------------
CREATE TABLE deduction (
  deduction_id SERIAL PRIMARY KEY,
  deduction_title VARCHAR(50),
  deduction_details VARCHAR(200),
  deduction_amount DECIMAL(8, 2) NOT NULL,
  CONSTRAINT valid_deduction CHECK (deduction_amount >= 0) 
);

-- -----------------------------------
-- Table structure for SALARY_PAYSLIP
-- -----------------------------------
CREATE TABLE salary_payslip (
  payslip_id SERIAL PRIMARY KEY,
  salary_id INT NOT NULL,
  issue_date DATE NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  net_pay DECIMAL(8, 2) NOT NULL,
  gross_pay DECIMAL(8, 2) NOT NULL,
  payment_method VARCHAR(30) NOT NULL,
  tax_code VARCHAR(10) NOT NULL,
  tax_period INT NOT NULL,
  national_insurance_num CHAR(9) NOT NULL,
  hourly_rate DECIMAL(6, 2) NOT NULL,
  CONSTRAINT valid_net_pay CHECK (net_pay >= 0 AND net_pay <= gross_pay),
  CONSTRAINT valid_gross_pay CHECK (gross_pay >= 0 AND gross_pay >= net_pay),
  FOREIGN KEY (salary_id) REFERENCES salary (salary_id)
);

-- -------------------------------------
-- Table structure for SALARY_DEDUCTION
-- -------------------------------------
CREATE TABLE salary_deduction (
  deduction_id INT,
  salary_id INT,
  PRIMARY KEY (deduction_id, salary_id),
  FOREIGN KEY (deduction_id) REFERENCES deduction (deduction_id),
  FOREIGN KEY (salary_id) REFERENCES salary (salary_id) 
);

-- -------------------------------------
-- Table structure for DEPARTMENT_STAFF
-- -------------------------------------
CREATE TABLE department_staff (
  dep_staff_id SERIAL PRIMARY KEY,
  dep_id INT NOT NULL,
  FOREIGN KEY (dep_id) REFERENCES departments (dep_id)
);

-- ------------------------------------------
-- Table structure for DEPARTMENT_STAFF_LIST
-- ------------------------------------------
CREATE TABLE department_staff_list (
  dep_staff_id INT,
  staff_id INT,
  staff_dep_head BOOLEAN NOT NULL,
  PRIMARY KEY (dep_staff_id, staff_id),
  FOREIGN KEY (dep_staff_id) REFERENCES department_staff (dep_staff_id),
  FOREIGN KEY (staff_id) REFERENCES staff (staff_id)
);

-- -----------------------------
-- Table structure for TEACHERS
-- -----------------------------
CREATE TABLE teachers (
  teacher_id SERIAL PRIMARY KEY,
  staff_id INT NOT NULL,
  teacher_role VARCHAR(50) NOT NULL,
  teacher_research_area VARCHAR(150),
  FOREIGN KEY (staff_id) REFERENCES staff (staff_id)
);

-- -----------------------------
-- Table structure for COURSES
-- -----------------------------
CREATE TABLE courses (
  course_id SERIAL PRIMARY KEY,
  teacher_id INT NOT NULL,
  course_name VARCHAR(50) NOT NULL,
  course_code INT NOT NULL UNIQUE,
  course_description TEXT,
  course_length SMALLINT NOT NULL,
  CONSTRAINT valid_course_length CHECK (course_length > 0),
  FOREIGN KEY (teacher_id) REFERENCES teachers (teacher_id)
);

-- --------------------------------------
-- Table structure for DEPARTMENT_COURSES
-- --------------------------------------
CREATE TABLE department_courses (
  dep_id INT,
  course_id INT,
  PRIMARY KEY (dep_id, course_id),
  FOREIGN KEY (dep_id) REFERENCES departments (dep_id),
  FOREIGN KEY (course_id) REFERENCES courses (course_id)
);

-- -----------------------------
-- Table structure for MODULES
-- -----------------------------
CREATE TABLE modules (
  module_id SERIAL PRIMARY KEY,
  teacher_id INT NOT NULL,
  module_name VARCHAR(50) NOT NULL,
  module_code INT NOT NULL UNIQUE,
  module_description TEXT,
  academ_lvl CHAR(2) NOT NULL,
  FOREIGN KEY (teacher_id) REFERENCES teachers (teacher_id)
);

-- ---------------------------------
-- Table structure for COURSE_MODULE
-- ---------------------------------
CREATE TABLE course_module (
  course_id INT,
  module_id INT,
  PRIMARY KEY (course_id, module_id),
  FOREIGN KEY (course_id) REFERENCES courses (course_id),
  FOREIGN KEY (module_id) REFERENCES modules (module_id)
);

-- ----------------------------------
-- Table structure for STUDENT_COURSE
-- ----------------------------------
CREATE TABLE student_course (
  student_id INT,
  course_id INT,
  PRIMARY KEY (student_id, course_id),
  FOREIGN KEY (student_id) REFERENCES student (student_id),
  FOREIGN KEY (course_id) REFERENCES courses (course_id)
);

CREATE INDEX idx_student_course_student_id ON student_course(student_id);
CREATE INDEX idx_student_course_course_id ON student_course(course_id);

-- --------------------------------
-- Table structure for COURSE_REP
-- --------------------------------
CREATE TABLE course_rep (
  student_id INT,
  course_id INT,
  PRIMARY KEY (student_id, course_id),
  FOREIGN KEY (student_id) REFERENCES student (student_id),
  FOREIGN KEY (course_id) REFERENCES courses (course_id)
);

-- --------------------------------------------
-- Table structure for STUDENT_COURSE_PROGRESS
-- --------------------------------------------
CREATE TABLE student_course_progress (
  student_id INT,
  course_id INT,
  progress_perc DECIMAL(5, 2) NOT NULL,
  CONSTRAINT valid_progress_perc CHECK (progress_perc >= 0 AND progress_perc <= 100),
  PRIMARY KEY (student_id, course_id),
  FOREIGN KEY (student_id) REFERENCES student (student_id),
  FOREIGN KEY (course_id) REFERENCES courses (course_id)
);

-- -------------------------------------------
-- Table structure for STUDENT_MODULE_PROGRESS
-- -------------------------------------------
CREATE TABLE student_module_progress (
  student_id INT,
  module_id INT,
  progress_perc DECIMAL(5, 2) NOT NULL,
  CONSTRAINT valid_progress_perc CHECK (progress_perc >= 0 AND progress_perc <= 100),
  PRIMARY KEY (student_id, module_id),
  FOREIGN KEY (student_id) REFERENCES student (student_id),
  FOREIGN KEY (module_id) REFERENCES modules (module_id)
);

-- ---------------------------------------
-- Table structure for MODULE_ASSIGNMENTS
-- ---------------------------------------
CREATE TABLE module_assignments (
  assignment_id SERIAL PRIMARY KEY,
  module_id INT NOT NULL,
  assignment_title VARCHAR(50) NOT NULL,
  assignment_set_date DATE NOT NULL,
  assignment_due_date DATE NOT NULL,
  assignment_set_time TIME NOT NULL,
  assignment_due_time TIME NOT NULL,
  assignment_description TEXT,
  assignment_type VARCHAR(100) NOT NULL,
  CONSTRAINT valid_due_date CHECK (assignment_due_date >= assignment_set_date),
  FOREIGN KEY (module_id) REFERENCES modules (module_id)
);

-- ---------------------------------------
-- Table structure for MODULE_ASSESSMENTS
-- ---------------------------------------
CREATE TABLE module_assessments (
  assessment_id SERIAL PRIMARY KEY,
  module_id INT NOT NULL,
  assessment_title VARCHAR(50) NOT NULL,
  assessment_set_date DATE NOT NULL,
  assessment_due_date DATE NOT NULL,
  assessment_set_time TIME NOT NULL,
  assessment_due_time TIME NOT NULL,
  assessment_description TEXT,
  assessment_type VARCHAR(100) NOT NULL,
  assessment_weighting DECIMAL(5, 2) NOT NULL,
  CONSTRAINT valid_due_date CHECK (assessment_due_date >= assessment_set_date),
  CONSTRAINT valid_weighting CHECK (assessment_weighting >= 0 AND assessment_weighting <= 100),
  FOREIGN KEY (module_id) REFERENCES modules (module_id)
);

-- --------------------------------------------
-- Table structure for MODULE_ASSIGNMENT_GRADE
-- --------------------------------------------
CREATE TABLE module_assignment_grade (
  assignment_id INT,
  student_id INT,
  assignment_grade DECIMAL(5, 2) NOT NULL,
  CONSTRAINT valid_grade CHECK (assignment_grade >= 0),
  PRIMARY KEY (assignment_id, student_id),
  FOREIGN KEY (assignment_id) REFERENCES module_assignments (assignment_id),
  FOREIGN KEY (student_id) REFERENCES student (student_id)
);

-- --------------------------------------------
-- Table structure for MODULE_ASSESSMENT_GRADE
-- --------------------------------------------
CREATE TABLE module_assessment_grade (
  assessment_id INT,
  student_id INT,
  assessment_grade DECIMAL(5, 2) NOT NULL,
  CONSTRAINT valid_grade CHECK (assessment_grade >= 0),
  PRIMARY KEY (assessment_id, student_id),
  FOREIGN KEY (assessment_id) REFERENCES module_assessments (assessment_id),
  FOREIGN KEY (student_id) REFERENCES student (student_id)
);

-- -------------------------------------
-- Table structure for TEACHING_SESSION
-- -------------------------------------
CREATE TABLE teaching_session (
  session_id SERIAL PRIMARY KEY,
  module_id INT NOT NULL,
  session_type VARCHAR(50) NOT NULL,
  session_start_time TIME NOT NULL,
  session_length DECIMAL(6,2) NOT NULL,
  session_date DATE NOT NULL,
  session_notes TEXT,
  CONSTRAINT valid_length CHECK (session_length > 0),
  FOREIGN KEY (module_id) REFERENCES modules (module_id)
);

-- -------------------------------------
-- Table structure for TEACHERS_SESSIONS
-- -------------------------------------
CREATE TABLE teachers_sessions (
  teacher_id INT,
  session_id INT,
  PRIMARY KEY (teacher_id, session_id),
  FOREIGN KEY (teacher_id) REFERENCES teachers (teacher_id),
  FOREIGN KEY (session_id) REFERENCES teaching_session (session_id)
);

-- ------------------------------------------
-- Table structure for ACADEMIC_HELP_SESSIONS
-- ------------------------------------------
CREATE TABLE academic_help_sessions (
  ah_session_id SERIAL PRIMARY KEY,
  student_id INT NOT NULL,
  ah_session_type VARCHAR(50) NOT NULL,
  ah_session_start_time TIME NOT NULL,
  ah_session_length DECIMAL(6,2) NOT NULL,
  ah_session_date DATE NOT NULL,
  ah_session_notes TEXT,
  CONSTRAINT valid_length CHECK (ah_session_length > 0),
  FOREIGN KEY (student_id) REFERENCES student (student_id)
);

-- ------------------------------------------
-- Table structure for TEACHERS_AH_SESSIONS
-- ------------------------------------------
CREATE TABLE teachers_ah_sessions (
  teacher_id INT,
  ah_session_id INT,
  PRIMARY KEY (teacher_id, ah_session_id),
  FOREIGN KEY (teacher_id) REFERENCES teachers (teacher_id),
  FOREIGN KEY (ah_session_id) REFERENCES academic_help_sessions (ah_session_id)
);

-- --------------------------------
-- Records of TEACHERS_AH_SESSIONS
-- --------------------------------
INSERT INTO teachers_ah_sessions (teacher_id, ah_session_id)
VALUES
(1, 1),
(2, 2),
(3, 3);

-- -------------------------------
-- Table structure for ATTENDANCE
-- -------------------------------
CREATE TABLE attendance (
  student_id INT,
  session_id INT,
  attendance_record BOOLEAN NOT NULL,
  PRIMARY KEY (student_id, session_id),
  FOREIGN KEY (student_id) REFERENCES student (student_id),
  FOREIGN KEY (session_id) REFERENCES teaching_session (session_id)
);

-- ------
-- VIEWS 
-- ------
/* 
  View to retrieve the contact information of students.
*/

CREATE OR REPLACE VIEW student_contact_information AS
SELECT
  student_number AS "Student Number",
  CONCAT_WS(' ', student_fname, student_mname, student_lname) AS "Name",
  student_edu_email AS "Student Email",
  student_personal_email AS "Personal Email",
  student_mobile AS "Mobile",
  student_landline AS "Landline",
  CONCAT_WS(', ', student_addr1, student_addr2, student_city, student_postcode) AS "Address"
FROM student
ORDER BY "Student Number"; 

/* 
  View to retrieve the contact information of staff members.
*/
CREATE OR REPLACE VIEW staff_contact_information AS
SELECT
  staff_number AS "Staff Number",
  CONCAT_WS(' ', staff_fname, staff_mname, staff_lname) AS "Name",
  staff_company_email AS "Company Email",
  staff_personal_email AS "Personal Email",
  staff_mobile AS "Mobile",
  staff_landline AS "Landline",
  CONCAT_WS(', ', staff_addr1, staff_addr2, staff_city, staff_postcode)
FROM staff
ORDER BY "Staff Number"; 

/* 
  View to retrieve information about the courses students are enrolled in.
*/
CREATE OR REPLACE VIEW student_course_information AS
SELECT
  s.student_number AS "Student Number",
  CONCAT_WS(' ', student_fname, student_mname, student_lname) AS "Name",
  c.course_name AS "Course",
  c.course_code AS "Course Code",
  c.course_id AS "Course ID"
FROM
  student AS s
  JOIN student_course AS sc ON s.student_id = sc.student_id
  JOIN courses AS c ON sc.course_id = c.course_id
ORDER BY "Student Number";

/* 
  View to retrieve information about students tuition.
*/
CREATE OR REPLACE VIEW student_tuition_information AS
SELECT
  s.student_number AS "Student Number",
  CONCAT_WS(' ', student_fname, student_mname, student_lname) AS "Name",
  t.tuition_id AS "Tuition ID",
  t.tuition_amount AS "Tuition Amount",
  t.tuition_paid AS "Tuition Paid",
  t.tuition_remaining AS "Tuition Remaining",
  CONCAT(t.tuition_remaining_perc, '%') AS "% Tuition Remaining",
  COALESCE(sp.num_payments, 0) AS "Num Payments"
FROM 
  student AS s
  JOIN student_tuition AS st ON s.student_id = st.student_id
  JOIN tuition AS t ON st.tuition_id = t.tuition_id
  LEFT JOIN (
    SELECT 
      tuition_id, 
      COUNT(*) AS num_payments
    FROM student_payments
    GROUP BY tuition_id
  ) AS sp ON t.tuition_id = sp.tuition_id
ORDER BY "Tuition Remaining";