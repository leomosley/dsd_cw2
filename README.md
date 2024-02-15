# Group 5's DSD CW2 Database Implementation
This is our groups physical implementation of the relational database for Stellar Tutors Inc. It consists of all entities outlined in the ERD 
([View PDF here](https://drive.google.com/file/d/1iDu0xKDJ3Q3pOWQTRIYSET8nkVc8jzO_/view?usp=drive_link)) 
along with inserts of mock data to test/prove functionalty of the database.

## Installation
First create and connect to the database using your psql shell. Replace `YOUR_DATABASE` with whatever you wish to name the database.

```sql
CREATE DATABASE YOUR_DATABASE;
```

```
\c YOUR_DATABASE;
```

Then copy and paste the contents of [Group05_CW2.sql](/Group05_CW2.sql) into the psql shell. This will create all functions, triggers, indexes, tables, views, 
and all inserts - you wish to create the database without inserts copy and paste the contents of the [schema.sql](/schema.sql) instead.

## Usage
When inserting into certain tables make sure not to include columns which are generated by a default value or trigger. Instead use the insert format shown below:

### ```student``` Table
```student_number``` & ```student_edu_email``` are ignored.
```sql
INSERT INTO student (student_fname, student_mname, student_lname, student_pronouns, student_addr1, student_addr2, student_city, student_postcode, student_personal_email, student_landline, student_mobile, student_dob)
VALUES
-- ...values
```

### ```staff``` Table
```staff_number``` & ```staff_company_email``` are ignored.
```sql
INSERT INTO staff (staff_fname, staff_mname, staff_lname, staff_pronouns, staff_addr1, staff_addr2, staff_city, staff_postcode, staff_personal_email, staff_landline, staff_mobile, staff_dob)
VALUES
-- ...values
```

### ```tuition_payment``` Table
```tuition_payment_reference``` is ignored.
```sql
INSERT INTO tuition_payment (tuition_payment_amount, tuition_payment_date)
VALUES
-- ...values
```

## Using Views

### Student Contact Information View

**Description:** Retrieves contact information for students.

**Usage:** 
```sql
SELECT * FROM student_contact_information;
```

**Columns:**
- Student Number
- Name
- Student Email
- Personal Email
- Mobile
- Landline
- Address

### Staff Contact Information View

**Description:** Retrieves contact information for staff members.

**Usage:** 
```sql
SELECT * FROM staff_contact_information;
```

**Columns:**
- Staff Number
- Name
- Company Email
- Personal Email
- Mobile
- Landline
- Address

### Student Course Information View

**Description:** Retrieves information about courses students are enrolled in.

**Usage:** 
```sql
SELECT * FROM student_course_information;
```

**Columns:**
- Student Number
- Name
- Course
- Course Code
- Course ID

### Student Tuition Information View

**Description:** Retrieves information about students' tuition.

**Usage:** 
```sql
SELECT * FROM student_tuition_information;
```

**Columns:**
- Student Number
- Name
- Tuition ID
- Tuition Amount
- Tuition Paid
- Tuition Remaining
- % Tuition Remaining
- Num Payments

