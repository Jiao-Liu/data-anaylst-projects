# onboarding 

# ALL the student_id in student_engagement is onboarded 
# ALL the student_id in student_info but not in student_engagement is not onboarded

SELECT *, 0 AS on_boarding
FROM student_info
WHERE student_id NOT IN(
SELECT DISTINCT student_id
FROM student_engagement
)
UNION 

SELECT *, 1 AS on_boarding
FROM student_info
WHERE student_id IN(
SELECT DISTINCT student_id
FROM student_engagement
)