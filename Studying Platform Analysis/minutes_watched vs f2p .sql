# total minutes watch buket and ftp
	# table 1 (id,date_registered,last_date_to_watch)-->: all studet type of minutes watched before becoming a paid one(student info left join student purchsese)  free union paid 
		# duration before becoming a paid one(free：2022-10-31，paid: min(purchase date)-->board line before becoming a paid one
		# info left join purchase where p.student_id is null --> free student
        # info join purchase --> paid student
    # table 2 -->learning: table  1 join learning table(watch 0 and sum(minutes_watched))
		# table 1 left join learning on student id where learining student id is null--> wathch 0 minutes students 
        # table 1 join learning on student id sum(minutes_watched) group by student_id --> sum wathced minutes 
        # table 1 join learning on student id where watched date is outside of registered date and last_date_to_watch-->out of analysis date range consider as 0 minutes 
        
        

# ALL STUDENTS WITH PAYING STATUS AND LAST_DATE_TO_WATCH
WITH all_student_status as(
SELECT i.student_id,i.date_registered, 0 as paid,'2022-10-31'AS last_date_to_watch
FROM student_info i
LEFT JOIN student_purchases p
USING(student_id)
WHERE p.student_id is null 

UNION 

SELECT i.student_id,i.date_registered, 1 AS paid, min(date_purchased) AS last_date_to_watch
FROM student_info i 
JOIN student_purchases p
USING(student_id)
GROUP BY 1),


# students who haven't learn any minutes
total_minutes_watched1 as(
SELECT a.student_id,a.date_registered,a.paid,a.last_date_to_watch, 0 AS total_minutes_watched
FROM all_student_status a
LEFT JOIN student_learning l
USING(student_id)
WHERE l.student_id IS NULL 

UNION 

# each student total minutes watched in  analysis date range
SELECT a.student_id,a.date_registered,a.paid,a.last_date_to_watch,Round(SUM(l.minutes_watched),2) AS total_minutes_watched
FROM all_student_status a
JOIN student_learning l
USING(student_id)
WHERE date_watched BETWEEN date_registered AND last_date_to_watch
GROUP BY  
    a.student_id, 
    a.date_registered, 
    a.paid, 
    a.last_date_to_watch)
, 
total_minutes_watched2 as(
SELECT student_id,date_registered,paid,last_date_to_watch,total_minutes_watched
FROM total_minutes_watched1

union 

SELECT 
a.student_id,a.date_registered,a.paid,a.last_date_to_watch, 0 AS total_minutes_watched
FROM
    all_student_status a
        JOIN
    student_learning l USING (student_id)
WHERE
    l.date_watched NOT BETWEEN a.date_registered AND a.last_date_to_watch
        AND l.student_id NOT IN (SELECT 
            student_id
        FROM
           total_minutes_watched1)
GROUP BY a.student_id,a.date_registered,a.paid,a.last_date_to_watch)


,table_distribute_to_buckets as
(
SELECT 
    *,
    CASE
        WHEN
            total_minutes_watched = 0
                OR total_minutes_watched IS NULL
        THEN
            '[0]'
        WHEN
            total_minutes_watched > 0
                AND total_minutes_watched <= 5
        THEN
            '(0, 5]'
        WHEN
            total_minutes_watched > 5
                AND total_minutes_watched <= 10
        THEN
            '(5, 10]'
        WHEN
            total_minutes_watched > 10
                AND total_minutes_watched <= 15
        THEN
            '(10, 15]'
        WHEN
            total_minutes_watched > 15
                AND total_minutes_watched <= 20
        THEN
            '(15, 20]'
        WHEN
            total_minutes_watched > 20
                AND total_minutes_watched <= 25
        THEN
            '(20, 25]'
        WHEN
            total_minutes_watched > 25
                AND total_minutes_watched <= 30
        THEN
            '(25, 30]'
        WHEN
            total_minutes_watched > 30
                AND total_minutes_watched <= 40
        THEN
            '(30, 40]'
        WHEN
            total_minutes_watched > 40
                AND total_minutes_watched <= 50
        THEN
            '(40, 50]'
        WHEN
            total_minutes_watched > 50
                AND total_minutes_watched <= 60
        THEN
            '(50, 60]'
        WHEN
            total_minutes_watched > 60
                AND total_minutes_watched <= 70
        THEN
            '(60, 70]'
        WHEN
            total_minutes_watched > 70
                AND total_minutes_watched <= 80
        THEN
            '(70, 80]'
        WHEN
            total_minutes_watched > 80
                AND total_minutes_watched <= 90
        THEN
            '(80, 90]'
        WHEN
            total_minutes_watched > 90
                AND total_minutes_watched <= 100
        THEN
            '(90, 100]'
        WHEN
            total_minutes_watched > 100
                AND total_minutes_watched <= 110
        THEN
            '(100, 110]'
        WHEN
            total_minutes_watched > 110
                AND total_minutes_watched <= 120
        THEN
            '(110, 120]'
        WHEN
            total_minutes_watched > 120
                AND total_minutes_watched <= 240
        THEN
            '(120, 240]'
        WHEN
            total_minutes_watched > 240
                AND total_minutes_watched <= 480
        THEN
            '(240, 480]'
        WHEN
            total_minutes_watched > 480
                AND total_minutes_watched <= 1000
        THEN
            '(480, 1000]'
        WHEN
            total_minutes_watched > 1000
                AND total_minutes_watched <= 2000
        THEN
            '(1000, 2000]'
        WHEN
            total_minutes_watched > 2000
                AND total_minutes_watched <= 3000
        THEN
            '(2000, 3000]'
        WHEN
            total_minutes_watched > 3000
                AND total_minutes_watched <= 4000
        THEN
            '(3000, 4000]'
        WHEN
            total_minutes_watched > 4000
                AND total_minutes_watched <= 6000
        THEN
            '(4000, 6000]'
        ELSE '6000+'
    END AS buckets
FROM
    total_minutes_watched2 
)


select  
student_id,
date_registered,
paid as f2p,
total_minutes_watched,
buckets
from table_distribute_to_buckets;

    



select * from purchases_info where student_id = 275430;
select * from student_purchases where student_id = 263338;
select * from student_info where student_id = 258832;













