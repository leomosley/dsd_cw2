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

-- -------------------
-- Records of STUDENT
-- -------------------
INSERT INTO student (student_fname, student_mname, student_lname, student_pronouns, student_addr1, student_addr2, student_city, student_postcode, student_personal_email, student_landline, student_mobile, student_dob)
VALUES
('Alex', NULL, 'Braun', 'He/Him', '123 Main Street', 'Mayfair', 'London', 'SW1A 1AA', 'alex.braun@gmail.com', '0201234570', '07891234572', '1995-05-15'),
('Jane', NULL, 'Smith', 'She/Her', '456 Park Avenue', NULL, 'Manchester', 'M1 1AA', 'jane.smith@outlook.com', '0161234569', '07987654323', '1994-10-20'),
('John', 'James', 'Doe', 'He/Him', '123 Main Street', 'Kensington', 'London', 'SW1A 1AA', 'JOHN.doe@yahoo.com', '0201234571', '07891234573', '1995-05-15'),
('Emily', NULL, 'Johnson', 'She/Her', '789 Oak Lane', NULL, 'Birmingham', 'B1 1AA', 'emily.johnson@mail.co.uk', '0123456789', '07712345678', '1997-08-18'),
('Michael', 'Luke', 'Brown', 'He/Him', '1010 Maple Street', NULL, 'Edinburgh', 'EH1 1AA', 'michael.brown@example.com', '0131234567', '07723456789', '1996-12-03'),
('Emma', NULL, 'Williams', 'She/Her', '789 Cedar Street', NULL, 'London', 'SW1A 2AB', 'emma.williams@example.com', '0203456789', '07892345678', '1999-04-15'),
('Alexander', 'James', 'Brown', 'He/Him', '456 Birch Avenue', NULL, 'Manchester', 'M1 2AB', 'alexander.brown@example.com', '0163456789', '07998765432', '1998-08-20'),
('Olivia', NULL, 'Taylor', 'She/Her', '101 Elm Street', NULL, 'Glasgow', 'G2 1AB', 'olivia.taylor@example.com', '0142345671', '07871234571', '2000-02-25'),
('William', 'John', 'Thomas', 'He/Him', '789 Oak Lane', NULL, 'Bristol', 'BS2 1AB', 'will.thomas@example.com', '0113456780', '07912345681', '1997-06-30');

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

-- -------------------
-- Records of TUITION
-- -------------------
INSERT INTO tuition (tuition_amount, tuition_paid, tuition_remaining, tuition_remaining_perc, tuition_deadline)
VALUES
(2800.00, 0, 2800.00, 0, '2024-07-01'),
(2900.00, 0, 2900.00, 0, '2024-08-05'),
(3000.00, 0, 3000.00, 0, '2024-07-10'),
(3100.00, 0, 3100.00, 0, '2024-08-15'),
(3200.00, 0, 3200.00, 0, '2024-07-20'),
(3300.00, 0, 3300.00, 0, '2024-08-25'),
(3400.00, 0, 3400.00, 0, '2024-07-30'),
(3500.00, 0, 3500.00, 0, '2024-08-05'),
(3600.00, 0, 3600.00, 0, '2024-07-10'),
(1500.00, 0, 1500.00, 0, '2024-07-31');

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

-- ---------------------------
-- Records of TUITION_PAYMENT
-- ---------------------------
INSERT INTO tuition_payment (tuition_payment_amount, tuition_payment_date)
VALUES
(300.00, '2024-03-15'),
(200.00, '2024-03-20'),
(400.00, '2024-04-10'),
(600.00, '2024-04-20'),
(500.00, '2024-05-10'),
(200.00, '2024-05-20'),
(700.00, '2024-05-10'),
(300.00, '2024-05-20'),
(400.00, '2024-05-10'),
(600.00, '2024-05-20'),
(800.00, '2024-05-10'),
(300.00, '2024-05-20'),
(500.00, '2024-05-10'),
(400.00, '2024-05-20'),
(200.00, '2024-05-10');

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

-- ---------------------------
-- Records of STUDENT_PAYMENT
-- ---------------------------
INSERT INTO student_payments (tuition_payment_id, tuition_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 1),
(12, 3),
(13, 6),
(14, 2),
(15, 8);

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

-- ---------------------------
-- Records of STUDENT_TUITION
-- ---------------------------
INSERT INTO student_tuition (student_id, tuition_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(9, 10);

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

-- -----------------
-- Records of STAFF
-- -----------------
INSERT INTO staff (staff_fname, staff_mname, staff_lname, staff_pronouns, staff_addr1, staff_addr2, staff_city, staff_postcode, staff_personal_email, staff_landline, staff_mobile, staff_dob)
VALUES
('John', NULL, 'Smith', 'He/Him', '789 Elm Street', NULL, 'London', 'SW1A 2AA', 'john.smith@example.com', '0201234567', '07891234567', '1980-03-25'),
('Jane', NULL, 'Doe', 'She/Her', '987 Oak Avenue', NULL, 'Manchester', 'M1 2AA', 'jAne.doe@example.com', '0161234567', '07987654321', '1975-07-10'),
('Laura', 'Lily', 'Taylor', 'She/Her', '456 Elm Street', NULL, 'Glasgow', 'G1 1AA', 'laura.taylor@example.com', '0201234512', '07891232567', '1985-05-20'),
('David', NULL, 'Clark', 'He/Him', '789 Pine Avenue', NULL, 'Bristol', 'BS1 1AA', 'david.clark@example.com', '0123456789', '07712345678', '1978-09-12'),
('Michael', NULL, 'Johnson', 'He/Him', '123 Cedar Street', NULL, 'London', 'SW1A 2AA', 'michael.johnson@example.com', '0131234567', '07723456789', '1983-02-15'),
('Emily', 'Anne', 'Harris', 'She/Her', '456 Birch Avenue', NULL, 'Manchester', 'M1 2AB', 'emily.harris@example.com', '0203456789', '07892345678', '1977-11-30'),
('Daniel', 'James', 'Anderson', 'He/Him', '789 Oak Lane', NULL, 'Glasgow', 'G2 1AB', 'dan.anderson@example.com', '0163456789', '07998765432', '1982-06-25'),
('Sophia', NULL, 'Wilson', 'She/Her', '101 Maple Street', NULL, 'Bristol', 'BS2 1AB', 'sophia.wilson@example.com', '0142345678', '07871234567', '1980-09-18'),
('Oliver', 'Robert', 'Martin', 'He/Him', '789 Elm Street', NULL, 'London', 'SW1A 1AA', 'oliver.martin@example.com', '0113456789', '07912345678', '1975-04-10'),
('Amelia', NULL, 'Thompson', 'She/Her', '456 Oak Avenue', NULL, 'Manchester', 'M1 1AA', 'amelia.thompson@example.com', '0202345678', '07891234568', '1978-08-05'),
('Ethan', 'William', 'White', 'He/Him', '789 Pine Avenue', NULL, 'Glasgow', 'G1 1AA', 'ethan.white@example.com', '0162345679', '07987654322', '1983-11-20'),
('Ava', NULL, 'Davis', 'She/Her', '101 Cedar Street', NULL, 'Bristol', 'BS1 1AA', 'ava.davis@example.com', '0141234578', '07876543210', '1981-03-15'),
('Noah', 'Edward', 'Wilson', 'He/Him', '123 Birch Avenue', NULL, 'London', 'SW1A 2AB', 'noah.wilson@example.com', '0203456790', '07892345679', '1976-06-30'),
('Isabella', NULL, 'Harris', 'She/Her', '456 Maple Street', NULL, 'Manchester', 'M1 2AB', 'isabella.harris@example.com', '0163456791', '07998765433', '1979-09-25'),
('James', 'Alexander', 'Brown', 'He/Him', '789 Oak Lane', NULL, 'Glasgow', 'G2 1AB', 'james.brown@example.com', '0112345670', '07871234568', '1984-12-10'),
('Charlotte', NULL, 'Wilson', 'She/Her', '101 Elm Street', NULL, 'Bristol', 'BS2 1AB', 'charlotte.wilson@example.com', '0142345679', '07876543211', '1977-02-05'),
('Benjamin', 'Michael', 'Lee', 'He/Him', '789 Pine Avenue', NULL, 'London', 'SW1A 1AA', 'benjamin.lee@example.com', '0112345671', '07901234569', '1982-05-20'),
('Mia', NULL, 'Roberts', 'She/Her', '456 Cedar Street', NULL, 'Manchester', 'M1 1AA', 'mia.roberts@example.com', '0201234568', '07891234569', '1975-08-15'),
('William', 'Daniel', 'Thomas', 'He/Him', '789 Elm Street', NULL, 'Glasgow', 'G1 1AA', 'william.thomas@example.com', '0161234568', '07987554322', '1980-10-30'),
('Evelyn', NULL, 'Evans', 'She/Her', '101 Oak Avenue', NULL, 'Bristol', 'BS1 1AA', 'evelyn.evans@example.com', '0142348579', '07872234568', '1973-11-25'),
('Sophie', NULL, 'Roberts', 'She/Her', '123 Maple Street', NULL, 'London', 'SW1A 2AA', 'sophie.roberts@example.com', '0113256780', '07912345679', '1988-09-15'),
('Jack', 'William', 'Harris', 'He/Him', '456 Birch Avenue', NULL, 'Manchester', 'M1 2AB', 'jack.harris@example.com', '0142345670', '07871234570', '1977-12-20'),
('Emily', 'Grace', 'Wilson', 'She/Her', '789 Oak Lane', NULL, 'Glasgow', 'G2 1AB', 'emily.wilson@example.com', '0113256781', '07912345680', '1982-06-25'),
('Daniel', 'Thomas', 'Anderson', 'He/Him', '101 Cedar Street', NULL, 'Bristol', 'BS1 1AB', 'daniel.anderson@example.com', '0201234569', '07891234571', '1979-03-30');

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

-- ------------------
-- Records of SALARY
-- ------------------
INSERT INTO salary (salary_base, salary_bonuses, salary_start_date, salary_end_date) 
VALUES 
(50000.00, 5000.00, '2023-01-01', '2023-12-31'),
(60000.00, 6000.00, '2024-01-01', '2024-12-31'),
(55000.00, 5500.00, '2025-01-01', NULL);

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

-- ------------------------
-- Records of STAFF_SALARY
-- ------------------------
INSERT INTO staff_salary (salary_id, staff_id)
VALUES
(1, 1), 
(1, 2), 
(1, 3), 
(1, 4), 
(1, 5),
(1, 6), 
(1, 7), 
(1, 8),
(2, 9), 
(2, 10), 
(2, 11), 
(2, 12),
(2, 13), 
(2, 14), 
(2, 15), 
(2, 16),
(3, 17), 
(3, 18), 
(3, 19), 
(3, 20), 
(3, 21), 
(3, 22),
(3, 23),
(3, 24);

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

-- -----------------
-- Records of HOURS
-- -----------------
INSERT INTO hours (start_time, end_time, date)
VALUES
('09:00:00', '17:00:00', '2023-01-01'),
('08:00:00', '16:30:00', '2023-01-02'),
('10:00:00', '18:00:00', '2023-01-03');

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

-- -----------------------
-- Records of STAFF_HOURS
-- -----------------------
INSERT INTO staff_hours (hour_id, staff_id)
VALUES
(1, 1), 
(1, 2), 
(1, 3), 
(1, 4), 
(1, 5), 
(1, 6), 
(1, 7), 
(1, 8),
(2, 9), 
(2, 10), 
(2, 11), 
(2, 12), 
(2, 13), 
(2, 14), 
(2, 15), 
(2, 16),
(3, 17), 
(3, 18), 
(3, 19), 
(3, 20), 
(3, 21), 
(3, 22), 
(3, 23), 
(3, 24);

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

-- ---------------------
-- Records of DEDUCTION
-- ---------------------
INSERT INTO deduction (deduction_title, deduction_details, deduction_amount)
VALUES
('Tax', 'Income tax deduction for January', 1500.00),
('Health Insurance', 'Monthly health insurance premium', 200.00),
('Pension', 'Contribution to employee pension plan', 500.00);

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

-- -------------------------
-- Records of SALARY_PAYSLIP
-- -------------------------
INSERT INTO salary_payslip (salary_id, issue_date, start_date, end_date, net_pay, gross_pay, payment_method, tax_code, tax_period, national_insurance_num, hourly_rate)
VALUES
(1, '2023-01-31', '2023-01-01', '2023-01-31', 4500.00, 5000.00, 'Direct Deposit', '1250L', 1, 'AB123456C', 20.00),
(2, '2023-02-28', '2023-02-01', '2023-02-28', 5500.00, 6000.00, 'Cheque', '1200L', 2, 'CD987654A', 25.00),
(3, '2023-03-31', '2023-03-01', '2023-03-31', 5000.00, 5500.00, 'Bank Transfer', '1300L', 3, 'EF345678B', 22.00);

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

-- ----------------------------
-- Records of SALARY_DEDUCTION
-- ----------------------------
INSERT INTO salary_deduction (deduction_id, salary_id)
VALUES
(1, 1), 
(2, 1),
(1, 2), 
(3, 2),
(2, 3), 
(3, 3);

-- -------------------------------------
-- Table structure for DEPARTMENT_STAFF
-- -------------------------------------
CREATE TABLE department_staff (
  dep_staff_id SERIAL PRIMARY KEY,
  dep_id INT NOT NULL,
  FOREIGN KEY (dep_id) REFERENCES departments (dep_id)
);

-- ---------------------------
-- Records of DEPARTMENT_STAFF
-- ---------------------------
INSERT INTO department_staff (dep_id)
VALUES
(1),
(2),
(3),
(4),
(5),
(6);

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

-- ---------------------------------
-- Records of DEPARTMENT_STAFF_LIST
-- ---------------------------------
INSERT INTO department_staff_list (dep_staff_id, staff_id, staff_dep_head)
VALUES
(1, 1, TRUE),
(1, 2, FALSE),
(1, 3, FALSE),
(1, 4, FALSE),
(1, 5, FALSE),
(2, 6, TRUE),
(2, 7, FALSE),
(2, 8, FALSE),
(2, 9, FALSE),
(2, 10, FALSE),
(3, 11, TRUE),
(3, 12, FALSE),
(3, 13, FALSE),
(3, 14, FALSE),
(3, 15, FALSE),
(4, 16, TRUE),
(4, 17, FALSE),
(4, 18, FALSE),
(4, 19, FALSE),
(4, 20, FALSE),
(5, 21, TRUE),
(5, 22, FALSE),
(6, 23, TRUE),
(6, 24, FALSE);

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

-- --------------------
-- Records of TEACHERS
-- --------------------
INSERT INTO teachers (staff_id, teacher_role, teacher_research_area)
VALUES
(1, 'Teaching Fellow', 'Drama'),
(2, 'Professor', 'Literature'),
(3, 'Assistant Professor', NULL),
(4, 'Academic Tutor', 'Music'),
(5, 'Teaching Fellow', 'Creative Writing'),
(6, 'Professor', 'History'),
(7, 'Assistant Professor', 'Philosophy'),
(8, 'Teaching Fellow', 'Linguistics'),
(9, 'Academic Tutor', NULL),
(10, 'Teaching Fellow', 'Cultural Studies'),
(11, 'Professor', 'Computer Science'),
(12, 'Assistant Professor', 'Information Technology'),
(13, 'Teaching Fellow', 'Data Science'),
(14, 'Academic Tutor', 'Artificial Intelligence'),
(15, 'Teaching Fellow', 'Cybersecurity'),
(16, 'Professor', 'Pure Mathematics'),
(17, 'Assistant Professor', NULL),
(18, 'Teaching Fellow', 'Statistics'),
(19, 'Academic Tutor', 'Operations Research'),
(20, 'Teaching Fellow', 'Mathematical Physics');

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

-- --------------------
-- Records of COURSES
-- --------------------
INSERT INTO courses (teacher_id, course_name, course_code, course_description, course_length)
VALUES
(1, 'Introduction to Theater', 101, 'An introductory course covering the basics of theater and performance art.', 2),
(2, 'Literary Analysis', 201, 'An in-depth exploration of literary theory and critical analysis.', 3),
(5, 'Creative Writing Workshop', 301, 'A hands-on workshop focusing on various forms of creative writing.', 4),
(6, 'World History', 102, 'A comprehensive survey of world history from ancient civilizations to modern times.', 2),
(8, 'Introduction to Linguistics', 202, 'An overview of the scientific study of language and its structure.', 3),
(10, 'Cultural Studies Seminar', 302, 'An examination of cultural phenomena and their impact on society.', 4),
(11, 'Introduction to Computer Science', 103, 'Fundamental concepts and principles of computer science and programming.', 2),
(13, 'Data Science Fundamentals', 203, 'An introduction to data analysis, machine learning, and statistical modeling.', 3),
(15, 'Cybersecurity Essentials', 303, 'A hands-on course covering essential cybersecurity concepts and practices.', 4),
(16, 'Calculus I', 104, 'An introductory course on differential and integral calculus.', 2),
(18, 'Statistics for Decision Making', 204, 'A study of basic statistical methods for decision-making in various fields.', 3),
(20, 'Mathematical Physics', 304, 'An advanced course integrating mathematical techniques with principles of physics.', 4);

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
-- Records of DEPARTMENT_COURSES
-- ------------------------------
INSERT INTO department_courses (dep_id, course_id)
VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 4),
(2, 5),
(2, 6),
(3, 7),
(3, 8),
(3, 9),
(4, 10),
(4, 11),
(4, 12); 

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

-- -------------------
-- Records of MODULES
-- -------------------
INSERT INTO modules (teacher_id, module_name, module_code, module_description, academ_lvl)
VALUES
(1, 'Theater History', 10101, 'An overview of the history of theater from ancient times to the present.', 'L4'),
(1, 'Acting Techniques', 10102, 'Exploration of various acting techniques and methods.', 'L5'),
(2, 'Introduction to Literary Theory', 20101, 'An introduction to different approaches to literary analysis.', 'L4'),
(2, 'Critical Reading Skills', 20102, 'Development of critical reading and analysis skills.', 'L5'),
(5, 'Fiction Writing', 30101, 'Workshop focusing on writing short stories and novels.', 'L4'),
(5, 'Poetry Workshop', 30102, 'Workshop focusing on writing poetry and verse.', 'L6'),
(6, 'Ancient Civilizations', 10201, 'Study of the rise and fall of ancient civilizations.', 'L4'),
(6, 'Modern History', 10202, 'Exploration of major events and developments in modern history.', 'L5'),
(8, 'Phonetics and Phonology', 20201, 'Study of speech sounds and their patterns.', 'L4'),
(8, 'Syntax and Semantics', 20202, 'Study of sentence structure and meaning in language.', 'L6'),
(10, 'Popular Culture', 30201, 'Examination of the impact of popular culture on society.', 'L5'),
(10, 'Gender Studies', 30202, 'Exploration of gender roles and identities in cultural contexts.', 'L6'),
(11, 'Introduction to Programming', 10301, 'Fundamentals of programming using a high-level language.', 'L4'),
(11, 'Algorithms and Data Structures', 10302, 'Study of algorithms and data structures used in computer science.', 'L5'),
(13, 'Statistical Analysis', 20301, 'Introduction to statistical methods for data analysis.', 'L5'),
(13, 'Machine Learning Basics', 20302, 'Fundamentals of machine learning algorithms and techniques.', 'L6'),
(15, 'Network Security', 30301, 'Study of principles and techniques for securing computer networks.', 'L5'),
(15, 'Ethical Hacking', 30302, 'Introduction to ethical hacking and penetration testing.', 'L7'),
(16, 'Differential Calculus', 10401, 'Study of rates of change and slopes of curves.', 'L5'),
(16, 'Integral Calculus', 10402, 'Study of accumulation and area under curves.', 'L6'),
(18, 'Descriptive Statistics', 20401, 'Presentation and analysis of data using graphical and numerical methods.', 'L6'),
(18, 'Inferential Statistics', 20402, 'Estimation and hypothesis testing using statistical methods.', 'L7'),
(20, 'Classical Mechanics', 30401, 'Study of the motion of objects and systems under the influence of forces.', 'L6'),
(20, 'Quantum Mechanics', 30402, 'Introduction to the principles of quantum mechanics.', 'L7');

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

-- -------------------------
-- Records of COURSE_MODULE
-- -------------------------
INSERT INTO course_module (course_id, module_id)
VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5),
(3, 6),
(4, 7),
(4, 8),
(5, 9),
(5, 10),
(6, 11),
(6, 12),
(7, 13),
(7, 14),
(8, 15),
(8, 16),
(9, 17),
(9, 18),
(10, 19),
(10, 20),
(11, 21),
(11, 22),
(12, 23),
(12, 24);

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

-- --------------------------
-- Records of STUDENT_COURSE
-- --------------------------
INSERT INTO student_course (student_id, course_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(9, 10);

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

-- ----------------------
-- Records of COURSE_REP
-- ----------------------
INSERT INTO course_rep (student_id, course_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(9, 10);

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

-- -----------------------------------
-- Records of STUDENT_COURSE_PROGRESS
-- -----------------------------------
INSERT INTO student_course_progress (student_id, course_id, progress_perc)
VALUES
(1, 1, 22.12),
(2, 2, 15.28),
(3, 3, 30.45),
(4, 4, 10.75),
(5, 5, 42.33),
(6, 6, 25.69),
(7, 7, 35.57),
(8, 8, 18.91),
(9, 9, 48.04),
(9, 10, 38.72);

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

-- -----------------------------------
-- Records of STUDENT_MODULE_PROGRESS
-- -----------------------------------
INSERT INTO student_module_progress (student_id, module_id, progress_perc)
VALUES
(1, 1, 22.12),
(1, 2, 15.28),
(2, 3, 30.45),
(2, 4, 10.75),
(3, 5, 42.33),
(3, 6, 25.69),
(4, 7, 35.57),
(4, 8, 18.91),
(5, 9, 48.04),
(5, 10, 38.72),
(6, 11, 22.12),
(6, 12, 15.28),
(7, 13, 30.45),
(7, 14, 10.75),
(8, 15, 42.33),
(8, 16, 25.69),
(9, 17, 35.57),
(9, 18, 18.91),
(9, 19, 48.04),
(9, 20, 38.72);

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

-- ------------------------------
-- Records of MODULE_ASSIGNMENTS
-- ------------------------------
INSERT INTO module_assignments (module_id, assignment_title, assignment_set_date, assignment_due_date, assignment_set_time, assignment_due_time, assignment_description, assignment_type)
VALUES
(1, 'Theater History Assignment 1', '2024-02-15', '2024-03-01', '09:00:00', '23:59:59', 'Assignment on theater history related to Module 1', 'Worksheet'),
(2, 'Acting Techniques Assignment 1', '2024-02-15', '2024-03-01', '09:00:00', '23:59:59', 'Assignment on acting techniques related to Module 2', 'Worksheet'),
(3, 'Literary Theory Assignment 1', '2024-02-15', '2024-03-01', '09:00:00', '23:59:59', 'Assignment on literary theory related to Module 3', 'Worksheet'),
(4, 'Critical Reading Skills Assignment 1', '2024-02-15', '2024-03-01', '09:00:00', '23:59:59', 'Assignment on critical reading skills related to Module 4', 'Worksheet'),
(5, 'Fiction Writing Assignment 1', '2024-02-15', '2024-03-01', '09:00:00', '23:59:59', 'Assignment on fiction writing related to Module 5', 'Worksheet'),
(6, 'Poetry Workshop Assignment 1', '2024-02-15', '2024-03-01', '09:00:00', '23:59:59', 'Assignment on poetry workshop related to Module 6', 'Worksheet'),
(7, 'Ancient Civilizations Assignment 1', '2024-02-15', '2024-03-01', '09:00:00', '23:59:59', 'Assignment on ancient civilizations related to Module 7', 'Worksheet'),
(8, 'Modern History Assignment 1', '2024-02-15', '2024-03-01', '09:00:00', '23:59:59', 'Assignment on modern history related to Module 8', 'Worksheet'),
(9, 'Phonetics and Phonology Assignment 1', '2024-02-15', '2024-03-01', '09:00:00', '23:59:59', 'Assignment on phonetics and phonology related to Module 9', 'Worksheet'),
(10, 'Syntax and Semantics Assignment 1', '2024-02-15', '2024-03-01', '09:00:00', '23:59:59', 'Assignment on syntax and semantics related to Module 10', 'Worksheet'),
(11, 'Popular Culture Assignment 1', '2024-02-15', '2024-03-01', '09:00:00', '23:59:59', 'Assignment on popular culture related to Module 11', 'Worksheet'),
(12, 'Gender Studies Assignment 1', '2024-02-15', '2024-03-01', '09:00:00', '23:59:59', 'Assignment on gender studies related to Module 12', 'Worksheet'),
(13, 'Programming Assignment 1', '2024-02-15', '2024-03-01', '09:00:00', '23:59:59', 'Assignment on programming related to Module 13', 'Worksheet'),
(14, 'Algorithms and Data Structures Assignment 1', '2024-02-15', '2024-03-01', '09:00:00', '23:59:59', 'Assignment on algorithms and data structures related to Module 14', 'Worksheet'),
(15, 'Statistical Analysis Assignment 1', '2024-02-15', '2024-03-01', '09:00:00', '23:59:59', 'Assignment on statistical analysis related to Module 15', 'Worksheet'),
(16, 'Machine Learning Basics Assignment 1', '2024-02-15', '2024-03-01', '09:00:00', '23:59:59', 'Assignment on machine learning basics related to Module 16', 'Worksheet'),
(17, 'Network Security Assignment 1', '2024-02-15', '2024-03-01', '09:00:00', '23:59:59', 'Assignment on network security related to Module 17', 'Worksheet'),
(18, 'Ethical Hacking Assignment 1', '2024-02-15', '2024-03-01', '09:00:00', '23:59:59', 'Assignment on ethical hacking related to Module 18', 'Worksheet'),
(19, 'Differential Calculus Assignment 1', '2024-02-15', '2024-03-01', '09:00:00', '23:59:59', 'Assignment on differential calculus related to Module 19', 'Worksheet'),
(20, 'Integral Calculus Assignment 1', '2024-02-15', '2024-03-01', '09:00:00', '23:59:59', 'Assignment on integral calculus related to Module 20', 'Worksheet');

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

-- ------------------------------
-- Records of MODULE_ASSESSMENTS
-- ------------------------------
INSERT INTO module_assessments (module_id, assessment_title, assessment_set_date, assessment_due_date, assessment_set_time, assessment_due_time, assessment_description, assessment_type, assessment_weighting)
VALUES
(1, 'Theater History Midterm Exam', '2024-04-01', '2024-04-15', '09:00:00', '12:00:00', 'Midterm exam on theater history related to Module 1', 'Exam', 40.00),
(2, 'Acting Techniques Final Exam', '2024-04-15', '2024-04-30', '09:00:00', '12:00:00', 'Final exam on acting techniques related to Module 2', 'Exam', 50.00),
(3, 'Literary Theory Essay', '2024-03-01', '2024-03-15', '09:00:00', '23:59:59', 'Essay on literary theory related to Module 3', 'Coursework', 30.00),
(4, 'Critical Reading Skills Quiz', '2024-03-15', '2024-03-31', '09:00:00', '23:59:59', 'Quiz on critical reading skills related to Module 4', 'Quiz', 20.00),
(5, 'Fiction Writing Portfolio', '2024-05-01', '2024-05-15', '09:00:00', '23:59:59', 'Portfolio submission on fiction writing related to Module 5', 'Coursework', 30.00),
(6, 'Poetry Workshop Presentation', '2024-04-15', '2024-04-30', '09:00:00', '12:00:00', 'Presentation on poetry workshop related to Module 6', 'Presentation', 20.00),
(7, 'Ancient Civilizations Research Paper', '2024-03-01', '2024-03-15', '09:00:00', '23:59:59', 'Research paper on ancient civilizations related to Module 7', 'Coursework', 40.00),
(8, 'Modern History Group Project', '2024-04-01', '2024-04-15', '09:00:00', '23:59:59', 'Group project on modern history related to Module 8', 'Group Project', 30.00),
(9, 'Phonetics and Phonology Test', '2024-03-15', '2024-03-31', '09:00:00', '23:59:59', 'Test on phonetics and phonology related to Module 9', 'Test', 20.00),
(10, 'Syntax and Semantics Presentation', '2024-04-15', '2024-04-30', '09:00:00', '12:00:00', 'Presentation on syntax and semantics related to Module 10', 'Presentation', 30.00),
(11, 'Popular Culture Essay', '2024-05-01', '2024-05-15', '09:00:00', '23:59:59', 'Essay on popular culture related to Module 11', 'Coursework', 40.00),
(12, 'Gender Studies Debate', '2024-04-01', '2024-04-15', '09:00:00', '12:00:00', 'Debate on gender studies related to Module 12', 'Debate', 30.00),
(13, 'Programming Assignment 2', '2024-04-01', '2024-04-15', '09:00:00', '23:59:59', 'Second programming assignment related to Module 13', 'Coursework', 30.00),
(14, 'Algorithms and Data Structures Project', '2024-04-15', '2024-04-30', '09:00:00', '23:59:59', 'Project on algorithms and data structures related to Module 14', 'Project', 40.00),
(15, 'Statistical Analysis Test', '2024-03-01', '2024-03-15', '09:00:00', '23:59:59', 'Test on statistical analysis related to Module 15', 'Test', 30.00),
(16, 'Machine Learning Basics Assignment 2', '2024-04-01', '2024-04-15', '09:00:00', '23:59:59', 'Second assignment on machine learning basics related to Module 16', 'Coursework', 30.00),
(17, 'Network Security Assignment 2', '2024-04-15', '2024-04-30', '09:00:00', '23:59:59', 'Second assignment on network security related to Module 17', 'Coursework', 40.00),
(18, 'Ethical Hacking Practical Exam', '2024-03-01', '2024-03-15', '09:00:00', '12:00:00', 'Practical exam on ethical hacking related to Module 18', 'Exam', 30.00),
(19, 'Differential Calculus Quiz', '2024-03-15', '2024-03-31', '09:00:00', '23:59:59', 'Quiz on differential calculus related to Module 19', 'Quiz', 20.00),
(20, 'Integral Calculus Project', '2024-04-15', '2024-04-30', '09:00:00', '23:59:59', 'Project on integral calculus related to Module 20', 'Project', 40.00);

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
-- -----------------------------------
-- Records of MODULE_ASSIGNMENT_GRADE
-- -----------------------------------
INSERT INTO module_assignment_grade (assignment_id, student_id, assignment_grade)
VALUES
(1, 1, 85),
(2, 1, 72),
(3, 2, 90),
(4, 2, 65),
(5, 3, 78),
(6, 3, 80),
(7, 4, 70),
(8, 4, 88),
(9, 5, 95),
(10, 5, 84),
(11, 6, 75),
(12, 6, 60),
(13, 7, 85),
(14, 7, 72),
(15, 8, 90),
(16, 8, 65),
(17, 9, 78),
(18, 9, 80),
(19, 9, 70),
(20, 9, 88);

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

-- -----------------------------------
-- Records of MODULE_ASSESSMENT_GRADE
-- -----------------------------------
INSERT INTO module_assessment_grade (assessment_id, student_id, assessment_grade)
VALUES
(1, 1, 85),
(2, 1, 72),
(3, 2, 90),
(4, 2, 65),
(5, 3, 78),
(6, 3, 80),
(7, 4, 70),
(8, 4, 88),
(9, 5, 95),
(10, 5, 84),
(11, 6, 75),
(12, 6, 60),
(13, 7, 85),
(14, 7, 72),
(15, 8, 90),
(16, 8, 65),
(17, 9, 78),
(18, 9, 80),
(19, 9, 70),
(20, 9, 88);

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

-- ----------------------------
-- Records of TEACHING_SESSION
-- ----------------------------
INSERT INTO teaching_session (module_id, session_type, session_start_time, session_length, session_date, session_notes)
VALUES
(1, 'Lecture', '09:00:00', 60.00, '2024-03-05', 'Introduction to Theater History'),
(2, 'Workshop', '13:00:00', 120.00, '2024-03-06', 'Acting Techniques Practical Session'),
(3, 'Seminar', '10:00:00', 120.00, '2024-03-07', 'Discussion on Literary Theory Approaches'),
(4, 'Tutorial', '11:00:00', 60.00, '2024-03-08', 'Critical Reading Skills Group Exercise'),
(5, 'Workshop', '14:00:00', 120.00, '2024-03-09', 'Fiction Writing Workshop Session'),
(6, 'Workshop', '13:00:00', 120.00, '2024-03-10', 'Poetry Workshop Analysis Session'),
(7, 'Lecture', '09:00:00', 60.00, '2024-03-11', 'Ancient Civilizations Overview'),
(8, 'Seminar', '10:00:00', 60.00, '2024-03-12', 'Modern History Discussion Forum'),
(9, 'Tutorial', '11:00:00', 60.00, '2024-03-13', 'Phonetics and Phonology Practice Exercises'),
(10, 'Seminar', '14:00:00', 60.00, '2024-03-14', 'Syntax and Semantics Case Studies'),
(11, 'Lecture', '09:00:00', 60.00, '2024-03-15', 'Introduction to Popular Culture'),
(12, 'Tutorial', '11:00:00', 120.00, '2024-03-16', 'Gender Studies Debate Session'),
(13, 'Lecture', '09:00:00', 60.00, '2024-03-17', 'Introduction to Programming Basics'),
(14, 'Seminar', '10:00:00', 60.00, '2024-03-18', 'Algorithms and Data Structures Review'),
(15, 'Workshop', '13:00:00', 120.00, '2024-03-19', 'Statistical Analysis Lab Session'),
(16, 'Workshop', '14:00:00', 120.00, '2024-03-20', 'Introduction to Machine Learning Workshop'),
(17, 'Seminar', '10:00:00', 60.00, '2024-03-21', 'Network Security Discussion'),
(18, 'Workshop', '13:00:00', 120.00, '2024-03-22', 'Ethical Hacking Practice Session'),
(19, 'Tutorial', '11:00:00', 120.00, '2024-03-23', 'Differential Calculus Problem Solving'),
(20, 'Seminar', '10:00:00', 120.00, '2024-03-24', 'Integral Calculus Discussion Forum');

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

-- ----------------------------
-- Records of TEACHER_SESSIONS
-- ----------------------------
INSERT INTO teachers_sessions (teacher_id, session_id)
VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(5, 5),
(5, 6),
(6, 7),
(6, 8),
(8, 9),
(8, 10),
(10, 11),
(10, 12),
(11, 13),
(11, 14),
(13, 15),
(13, 16),
(15, 17),
(15, 18),
(16, 19),
(16, 20);

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

-- ----------------------------------
-- Records of ACADEMIC_HELP_SESSIONS
-- ----------------------------------
INSERT INTO academic_help_sessions (student_id, ah_session_type, ah_session_start_time, ah_session_length, ah_session_date, ah_session_notes)
VALUES
(1, 'One-on-One Tutoring', '14:00:00', 1.00, '2024-02-15', 'Tutoring session for exam preparation'),
(2, 'One-on-One Tutoring', '10:00:00', 1.50, '2024-02-17', 'Tutoring session for math assignment'),
(3, 'One-on-One Tutoring', '13:30:00', 2.00, '2024-02-18', 'Tutoring session for essay writing skills');

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

-- ----------------------
-- Records of ATTENDANCE
-- ----------------------
INSERT INTO attendance (student_id, session_id, attendance_record)
VALUES
(1, 1, TRUE),
(1, 2, TRUE),
(2, 3, TRUE),
(2, 4, FALSE),
(3, 5, TRUE),
(3, 6, TRUE),
(4, 7, TRUE),
(4, 8, TRUE),
(5, 9, TRUE),
(5, 10, FALSE),
(6, 11, TRUE),
(6, 12, TRUE),
(7, 13, TRUE),
(7, 14, TRUE),
(8, 15, TRUE),
(8, 16, TRUE),
(9, 17, TRUE),
(9, 18, TRUE),
(9, 19, FALSE),
(9, 20, TRUE);

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
  CONCAT_WS(', ', student_addr1, student_addr2, student_city, student_postcode)
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