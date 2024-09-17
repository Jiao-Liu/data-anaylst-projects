
# if the students in the engagement table become a subsriber


SELECT student_id,date_engaged,MAX(paid) AS paid
FROM(
SELECT 
e.student_id,
e.date_engaged, 
p.date_start,
p.date_end,
CASE 
WHEN date_start IS NULL AND date_end IS NULL THEN 0 # students engaged but not paying 
WHEN date_engaged BETWEEN date_start AND date_end THEN 1 # students engaged AND PAID
WHEN date_engaged NOT BETWEEN date_start AND date_end THEN 0 # students engaged but not paying 
END AS paid
FROM student_engagement e 
LEFT JOIN purchase_info p
USING(student_id))t
GROUP BY 1,2;



# 
select 
t. student_id,
t.date_engaged,
date_start,
date_end,
CASE 
WHEN date_start IS NULL AND date_end IS NULL THEN 0 # students engaged but not paying 
WHEN date_engaged BETWEEN date_start AND date_end THEN 1 # students engaged AND PAID
WHEN date_engaged NOT BETWEEN date_start AND date_end THEN 0 # students engaged but not paying 
END AS paid
from 
( select student_id,MAX(date_engaged) date_engaged
from student_engagement 
group by 1) t 
LEFT JOIN purchase_info p 
USING(student_id)