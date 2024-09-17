

# student learning(free and paid ) 85945, 117811



With student_learning_per_day AS(
	SELECT student_id,
	date_watched,
	Round(sum(minutes_watched),2) minutes_watched 
	FROM student_learning
    GROUP BY 1,2),
student_purchase_state AS(       
SELECT student_id,max(date_start)date_start,max(date_end)date_end
from purchase_info
group by 1)


SELECT student_id,minutes_watched,
CASE
                WHEN date_start IS NULL AND date_end IS NULL THEN 0
                WHEN date_watched BETWEEN date_start AND date_end THEN 1
                WHEN date_watched NOT BETWEEN date_start AND date_end THEN 0
            END AS paid 
FROM student_learning_per_day LEFT JOIN student_purchase_state USING(student_id);




