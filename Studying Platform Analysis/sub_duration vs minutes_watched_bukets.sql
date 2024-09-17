
 # Paid students: The relationship between different subscription days and watching minutes.
# table 1--> determate the subscription duration in purchase info table, date_start is the first_paid_day, if min(date_end)<= 2022-10-31 then date_end, 2022-1031 last_paid_day
# table 2--> table 1 join learning table on student_id and wathched date between date_satrt and last_paid_day : all paid students total minutes watched in date range
				# table 1 left join learning table on student_id where l.student_id is null : paid students who watched 0 minutes
                # union two selects: all paid students total minutes watched during date range
# table 3--> all from table two union table 1 join learning table where date_watched is not between date range: 0 minitues-->  minutes wathced out of the date range consider 0 minutes
# table 4--> subscribtion in days datediff(last_paid_day,first_paid_day) as difference_in_days
# table 5--> based on table 4 create bukets of days 


with table_paid_duration as
(
SELECT 
    student_id,
    MIN(date_start) AS first_paid_day,
    IF(MAX(date_end) <= '2022-10-31',
        MAX(date_end),
        '2022-10-31') AS last_paid_day
FROM
    purchase_info
GROUP BY student_id
),
table_content_watched_1 as
(
SELECT 
    d.*, ROUND(SUM(l.minutes_watched), 2) AS total_minutes_watched
FROM
    table_paid_duration d
        JOIN
    student_learning l USING (student_id)
WHERE
    date_watched BETWEEN first_paid_day AND last_paid_day
GROUP BY d.student_id

UNION

SELECT 
    d.*, 0 AS total_minutes_watched
FROM
    table_paid_duration d
        LEFT JOIN
    student_learning l USING (student_id)
WHERE
    l.student_id IS NULL
),
table_content_watched_2 as
(
SELECT 
    *
FROM
    table_content_watched_1

UNION 

SELECT 
    d.*, 0 AS total_minutes_watched
FROM
    table_paid_duration d
        JOIN
    student_learning l USING (student_id)
WHERE
    date_watched NOT BETWEEN first_paid_day AND last_paid_day
        AND l.student_id NOT IN (SELECT 
            student_id
        FROM
            table_content_watched_1)
),
table_duration_in_days as
(
SELECT 
    *,
    DATEDIFF(last_paid_day, first_paid_day) AS difference_in_days
FROM
    table_content_watched_2
),
table_distribute_to_buckets as
(
SELECT 
    d.*,
    i.date_registered,
    CASE
        WHEN
            total_minutes_watched = 0
                OR total_minutes_watched IS NULL
        THEN
            '[0]'
        WHEN
            total_minutes_watched > 0
                AND total_minutes_watched <= 30
        THEN
            '(0, 30]'
        WHEN
            total_minutes_watched > 30
                AND total_minutes_watched <= 60
        THEN
            '(30, 60]'
        WHEN
            total_minutes_watched > 60
                AND total_minutes_watched <= 120
        THEN
            '(60, 120]'
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
        END AS user_buckets
FROM
    table_duration_in_days d
    join
    student_info i
    using(student_id)
)
SELECT 
    student_id,
    date_registered,
    total_minutes_watched,
    difference_in_days AS num_paid_days,
    user_buckets AS 'buckets'
FROM
    table_distribute_to_buckets; 