-- =========================================================
-- EASY CHALLENGES
-- =========================================================
Q.1 Show first name, last name, and gender of patients whose gender is 'M'
 ANS. SELECT first_name, last_name, gender FROM patients WHERE gender='M';

Q.2 Show first name and last name of patients who does not have allergies. (null)
ANS. SELECT first_name, last_name FROM patients WHERE allergies IS NULL;

Q.3 Show first name of patients that start with the letter 'C'
ANS. SELECT first_name FROM patients WHERE first_name LIKE 'C%'; 

Q.4 Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)
ANS. SELECT first_name, last_name FROM patients WHERE weight BETWEEN 100 AND 120;

Q.5 Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'
ANS. UPDATE patients SET allergies='NKA' WHERE allergies IS NULL;

Q.6 Show first name and last name concatinated into one column to show their full name.
ANS. SELECT CONCAT(first_name,' ' ,last_name) AS full_name FROM patients;

Q.7 Show first name, last name, and the full province name of each patient.
ANS. SELECT P.first_name, P.last_name, PR.province_name
FROM patients P JOIN province_names PR
ON P.province_id = PR.province_id

Q.8 Show how many patients have a birth_date with 2010 as the birth year.
ANS. SELECT COUNT(*) FROM patients
WHERE YEAR(birth_date) = 2010;

Q.9 Show the first_name, last_name, and height of the patient with the greatest height.
ANS. SELECT first_name, last_name, MAX(height) FROM patients;

Q.10 Show all columns for patients who have one of the following patient_ids:
1,45,534,879,1000
ANS . SELECT * FROM patients WHERE patient_id IN(1, 45, 534, 879, 1000);


-- =========================================================
-- MEDIUM CHALLENGES
-- ========================================================

Q.1 Show unique birth years from patients and order them by ascending.
ANS. select distinct(YEAR(birth_date)) AS birth_year FROM patients
order by birth_year ASC;

Q.2 Show unique first names from the patients table which only occurs once in the list.
ANS. SELECT first_name AS unique_name FROM patients
GROUP BY first_name
HAVING COUNT(first_name) = 1
ORDER BY unique_name ASC;

Q.3 Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.
ANS. SELECT P.patient_id, P.first_name, P.last_name FROM patients P
JOIN admissions A
ON P.patient_id = A.patient_id
WHERE diagnosis IS 'Dementia';

Q.4 Show the total amount of male patients and the total amount of female patients in the patients table.
Display the two results in the same row.
ANS. SELECT
COUNT(gender='M' OR NULL) AS male_count,
COUNT(gender='F' OR NULL) AS female_count
FROM patients;

Q.5 Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.
 ANS. SELECT first_name, last_name, birth_date FROM patients
WHERE birth_date LIKE '197%'
order by birth_date ASC;

Q.6 Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'
ANS. SELECT MAX(weight) - MIN(weight) AS weight_data FROM patients
WHERE last_name = 'Maroni';

Q.7 Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters
  ANS.SELECT patient_id, attending_doctor_id, diagnosis
FROM admissions
WHERE(MOD(patient_id, 2)!=0 AND attending_doctor_id IN(1, 5, 19))
or
(attending_doctor_id LIKE '%2%' AND patient_id BETWEEN 100 AND 999);

Q.8 Display patient's full name,
height in the units feet rounded to 1 decimal,
weight in the unit pounds rounded to 0 decimals,
birth_date,
gender non abbreviated.

Convert CM to feet by dividing by 30.48.
Convert KG to pounds by multiplying by 2.205.
  
 ANS.  SELECT concat(first_name, ' ', last_name) AS patient_name,
ROUND(height/30.48, 1) AS height,
ROUND(weight*2.205, 0) AS weight,
birth_date,
CASE
WHEN gender='M' THEN 'MALE'
WHEN gender='F' THEN 'FEMALE'
ELSE gender
END AS gender
FROM patients;
  
Q.9 Show patient_id, first_name, last_name from patients whose does not have any records in the admissions table. (Their patient_id does not exist in any admissions.patient_id rows.)
 ANS. SELECT P.patient_id, P.first_name, P.last_name
FROM patients P 
LEFT JOIN admissions A ON A.patient_id = P.patient_id
WHERE A.patient_id IS NULL;



-- =========================================================
-- HARD CHALLENGES
-- =========================================================



Q.1 Show patient_id, first_name, last_name, and attending doctor's specialty.
Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'

Check patients, admissions, and doctors tables for required information.

ANS. SELECT p.patient_id, p.first_name AS patient_first_name, p.last_name AS patient_last_name,
D.specialty AS attending_doctor_speciality
FROM patients p
JOIN admissions A ON p.patient_id = A.patient_id
JOIN doctors D ON D.doctor_id = A.attending_doctor_id
WHERE A.diagnosis = 'Epilepsy' AND D.first_name = 'Lisa'

Q.2 Show patient_id, weight, height, isObese from the patients table.

Display isObese as a boolean 0 or 1.

Obese is defined as weight(kg)/(height(m)2) >= 30.

weight is in units kg.

height is in units cm.

ANS. SELECT patient_id, weight, height,
CASE
WHEN(weight/POWER(height/100.0, 2))>=30 THEN 1
ELSE 0
END AS isObese
FROM patients

Q.3 Each admission costs $50 for patients without insurance, and $10 for patients with insurance. All patients with an even patient_id have insurance.

Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance. Add up the admission_total cost for each has_insurance group.

ANS. SELECT
CASE
	WHEN patient_id % 2 = 0 THEN 'Yes'
    ELSE 'No'
    END AS has_insurance,
    SUM(
      CASE
      WHEN patient_id % 2 = 0 THEN 10
      ELSE 50
      END 
      )AS cost_after_insurance
FROM admissions
    group by
    CASE
   		 WHEN patient_id % 2 = 0 THEN 'Yes'
     	 ELSE 'No'
    END;

Q.4 We are looking for a specific patient. Pull all columns for the patient who matches the following criteria:
- First_name contains an 'r' after the first two letters.
- Identifies their gender as 'F'
- Born in February, May, or December
- Their weight would be between 60kg and 80kg
- Their patient_id is an odd number
- They are from the city 'Kingston'

ANS. SELECT * FROM patients
WHERE first_name LIKE '__r%' 
	AND gender = 'F'
    AND MONTH(birth_date) IN (2, 5, 12)
    AND weight BETWEEN 60 AND 80
    AND patient_id % 2 != 0
    AND city = 'Kingston';

Q.5 All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.

The password must be the following, in order:
1. patient_id
2. the numerical length of patient's last_name
3. year of patient's birth_date

ANS. SELECT DISTINCT p.patient_id, 
CONCAT(
  p.patient_id,
  LENGTH(p.last_name),
  YEAR(p.birth_date)
  )AS temp_password
FROM patients p
JOIN admissions A ON p.patient_id = A.patient_id;

Q.6 We need a breakdown for the total amount of admissions each doctor has started each year. Show the doctor_id, doctor_full_name, specialty, year, total_admissions for that year.

ANS. SELECT D.doctor_id, CONCAT(D.first_name, ' ', D.last_name) AS doctor_full_name, 
D.specialty, YEAR(A.admission_date) AS selected_year, COUNT(*) AS total_admissions
FROM admissions A JOIN doctors D ON A.attending_doctor_id = D.doctor_id
GROUP BY
D.doctor_id,
D.first_name,
D.last_name,
D.specialty,
year(A.admission_date);
