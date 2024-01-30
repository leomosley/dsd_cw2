-- Extension for case insensitive constraints
CREATE EXTENSION IF NOT EXISTS citext;

-- ----------------------------
-- Table structure for STUDENT
-- ----------------------------
CREATE SEQUENCE student_id_seq;
CREATE TABLE student (
  student_id SERIAL PRIMARY KEY,
  student_number VARCHAR(10) DEFAULT (
    'sti' || to_char(nextval('student_id_seq'), 'FM000000')
  ) UNIQUE NOT NULL,
  student_edu_email CHAR(22) DEFAULT (
    'sti' || to_char(currval('student_id_seq'), 'FM000000') || '@sti.edu.org'
  ) UNIQUE NOT NULL,
  student_fname VARCHAR(50) NOT NULL,
  student_mname VARCHAR(50),
  student_lname VARCHAR(50) NOT NULL,
  student_pronouns VARCHAR(20),
  student_addr1 VARCHAR(30) NOT NULL,
  student_addr2 VARCHAR(30),
  student_city VARCHAR(30) NOT NULL,
  student_postcode CHAR(8) NOT NULL,
  student_personal_email CITEXT UNIQUE,
  student_landline VARCHAR(30) UNIQUE,
  student_mobile VARCHAR(15) NOT NULL UNIQUE,
  student_dob DATE NOT NULL
);

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

-- ------------------------------------
-- Table structure for TUITION_PAYMENT
-- ------------------------------------
CREATE TABLE tuition_payment (
  tuition_payment_id SERIAL PRIMARY KEY,
  tuition_payment_reference VARCHAR(12) NOT NULL UNIQUE, 
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

-- --------------------------------
-- Table structure for DEPARTMENTS
-- --------------------------------
CREATE TABLE departments (
  dep_id SERIAL PRIMARY KEY,
  dep_name VARCHAR(50) NOT NULL,
  dep_type VARCHAR(50) NOT NULL,
  dep_description VARCHAR(200)
);

-- --------------------------------
-- Table structure for STAFF
-- --------------------------------
CREATE TABLE staff (
  staff_id SERIAL PRIMARY KEY,
  staff_number INT NOT NULL UNIQUE,
  staff_fname VARCHAR(50) NOT NULL,
  staff_mname VARCHAR(50),
  staff_lname VARCHAR(50) NOT NULL,
  staff_pronouns VARCHAR(50) NOT NULL,
  staff_addr1 VARCHAR(30) NOT NULL,
  staff_addr2 VARCHAR(30),
  staff_city VARCHAR(30) NOT NULL,
  staff_postcode CHAR(8) NOT NULL,
  staff_company_email CITEXT NOT NULL UNIQUE,
  staff_personal_email CITEXT UNIQUE,
  staff_landline VARCHAR(30) UNIQUE,
  staff_mobile VARCHAR(15) NOT NULL UNIQUE,
  staff_dob DATE NOT NULL
);

-- --------------------------------
-- Table structure for SALARY
-- --------------------------------
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