/* 
  Student Table Constraints:
  - Test the uniqueness constraint on student_edu_email.
  - Test the uniqueness constraint on student_number.
  - Test the uniqueness constraint on student_mobile.
  - Test the format of student_edu_email to ensure it ends with '@sti.edu.org'.
  - Test the format of student_personal_email to ensure it is in lowercase.
  
  Tuition Table Constraints:
  - Test the validity of tuition_amount to ensure it's non-negative.
  - Test the validity of tuition_paid to ensure it's non-negative and not exceeding the total amount.
  - Test the validity of tuition_remaining to ensure it's non-negative and not exceeding the total amount.
  - Test the validity of tuition_remaining_perc to ensure it's between 0 and 100.
  
  Tuition Payment Table Constraints:
  - Test the uniqueness constraint on tuition_payment_reference.
  - Test the validity of tuition_payment_amount to ensure it's non-negative.
  
  Student Payments Table Constraints:
  - Test the referential integrity constraint with tuition_payment_id referencing tuition_payment.
  - Test the referential integrity constraint with tuition_id referencing tuition.
  
  Student Tuition Table Constraints:
  - Test the referential integrity constraint with student_id referencing student.
  - Test the referential integrity constraint with tuition_id referencing tuition.
  
  Salary Table Constraints:
  - Test the validity of salary_base to ensure it's non-negative.
  - Test the validity of salary_bonuses to ensure it's non-negative.
  
  Staff Salary Table Constraints:
  - Test the referential integrity constraint with salary_id referencing salary.
  - Test the referential integrity constraint with staff_id referencing staff.
  
  Staff Hours Table Constraints:
  - Test the referential integrity constraint with hour_id referencing hours.
  - Test the referential integrity constraint with staff_id referencing staff.
  
  Deduction Table Constraints:
  - Test the validity of deduction_amount to ensure it's non-negative.
  
  Salary Deduction Table Constraints:
  - Test the referential integrity constraint with deduction_id referencing deduction.
  - Test the referential integrity constraint with salary_id referencing salary.
*/