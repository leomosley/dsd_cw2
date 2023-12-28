CREATE TABLE student (
  student_id SERIAL PRIMARY KEY,
  student_number INT NOT NULL UNIQUE,
  student_fname VARCHAR(50) NOT NULL,
  student_mname VARCHAR(50),
  student_lname VARCHAR(50) NOT NULL,
  student_pronouns VARCHAR(20),
  student_addr1 VARCHAR(30) NOT NULL,
  student_addr2 VARCHAR(30),
  student_city VARCHAR(30) NOT NULL,
  student_postcode CHAR(8) NOT NULL,
  student_edu_email VARCHAR(150) NOT NULL,
  student_personal_email VARCHAR(150) NOT NULL,
  student_landline VARCHAR(30) UNIQUE,
  student_mobile VARCHAR(15) NOT NULL UNIQUE,
  student_dob DATE NOT NULL,

  -- Check emails are actually unique
  CONSTRAINT unique_edu_email UNIQUE (LOWER(student_edu_email)),
  CONSTRAINT unique_personal_email UNIQUE (LOWER(student_personal_email))
); 

CREATE TABLE tuition (
  tuition_id SERIAL PRIMARY KEY,
  tuition_amount DECIMAL(7, 2) NOT NULL,
  tuition_pad DECIMAL(7, 2) NOT NULL,
  tuition_remaining DECIMAL(7, 2) NOT NULL,
  tuition_remaining_perc DECIMAL(5, 2) NOT NULL,
  tuition_deadline DATE NOT NULL,

  CONSTRAINT valid_tuition_amount CHECK tuition_amount >= 0,
  CONSTRAINT valid_tuition_paid CHECK (tuition_paid >= 0 AND tuition_paid <= tuition_amount),
  CONSTRAINT valid_tuition_remaining CHECK (tuition_remaining >= 0 AND tuition_remaining <= tuition_amount),
  CONSTRAINT valid_tuition_remaining_perc CHECK (tuition_remaining_perc >= 0 AND tuition_remaining_perc <= 100)
);

CREATE TABLE tuition_payment (
  tuition_payment_id SERIAL PRIMARY KEY,
  tuition_payment_reference VARCHAR(12) NOT NULL UNIQUE, -- SQL function to generate?
  tuition_payment_amount DECIMAL(7, 2) NOT NULL,
  tuition_payment_date DATE NOT NULL,

  CONSTRAINT valid_tuition_payment_amount CHECK tuition_payment_amount >= 0
);

CREATE TABLE student_payments (
  tuition_payment_id INT,
  tuition_id INT,
  PRIMARY KEY (tuition_payment_id, tuition_id),
  FOREIGN KEY (tuition_payment_id) REFERENCES tuition_payment (tuition_payment_id),
  FOREIGN KEY (tuition_id) REFERENCES tuition (tuition_id)
);

CREATE TABLE student_tuition (
  student_id INT,
  tuition_id INT,
  PRIMARY KEY (student_id, tuition_id),
  FOREIGN KEY (student_id) REFERENCES student (student_id),
  FOREIGN KEY (tuition_id) REFERENCES tuition (tuition_id)
);

CREATE TABLE courses (
  course_id SERIAL PRIMARY KEY,
  teacher_id INT NOT NULL,
  course_name VARCHAR(50) NOT NULL,
  course_code INT NOT NULL UNIQUE,
  course_description TEXT,
  course_length SMALLINT NOT NULL,

  CONSTRAINT valid_course_length CHECK course_length > 0,

  FOREIGN KEY (teacher_id) REFERENCES teachers (teacher_id)
);

CREATE TABLE modules (
  module_id SERIAL PRIMARY KEY,
  teacher_id NOT NULL,
  module_name VARCHAR(50) NOT NULL,
  module_code INT NOT NULL UNIQUE,
  module_description TEXT,
  academ_lvl CHAR(2) NOT NULL,

  FOREIGN KEY (teacher_id) REFERENCES teachers (teacher_id)
);

CREATE TABLE course_module (
  course_id INT,
  module_id INT,
  PRIMARY KEY (course_id, module_id),
  FOREIGN KEY (course_id) REFERENCES courses (course_id)
  FOREIGN KEY (module_id) REFERENCES modules (module_id),
);

CREATE TABLE student_course (
  student_id INT,
  course_id INT,
  PRIMARY KEY (student_id, course_id),
  FOREIGN KEY (student_id) REFERENCES student (student_id),
  FOREIGN KEY (course_id) REFERENCES courses (course_id)
);

CREATE TABLE course_rep (
  student_id INT,
  course_id INT,
  PRIMARY KEY (student_id, course_id),
  FOREIGN KEY (student_id) REFERENCES student (student_id),
  FOREIGN KEY (course_id) REFERENCES courses (course_id)
);

CREATE TABLE student_course_progress (
  student_id INT,
  course_id INT,
  progress_perc DECIMAL(5, 2) NOT NULL,

  CONSTRAINT valid_progress_perc CHECK (progress_perc >= 0 AND progress_perc <= 100),

  PRIMARY KEY (student_id, course_id),
  FOREIGN KEY (student_id) REFERENCES student (student_id),
  FOREIGN KEY (course_id) REFERENCES courses (course_id)
);

CREATE TABLE student_module_progress (
  student_id INT,
  module_id INT,
  progress_perc DECIMAL(5, 2) NOT NULL,

  CONSTRAINT valid_progress_perc CHECK (progress_perc >= 0 AND progress_perc <= 100),

  PRIMARY KEY (student_id, module_id),
  FOREIGN KEY (student_id) REFERENCES student (student_id),
  FOREIGN KEY (module_id) REFERENCES modules (module_id)
);

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
  
  CONSTRAINT valid_due_date CONSTRAINT assignment_due_date >= assignment_set_date,
  FOREIGN KEY (module_id) REFERENCES modules (module_id)
);

CREATE TABLE module_assessment_grade (
  
);