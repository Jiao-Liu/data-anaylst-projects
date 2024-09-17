

# DIFFERENCE BETWEEN PAID AND FREE


SELECT 
    certificate_id, student_id, certificate_type, date_issued, MAX(paid) AS paid
FROM
    (SELECT 
        c.certificate_id,
            c.student_id,
            c.certificate_type,
            c.date_issued,
            p.date_start,
            p.date_end,
            CASE
                WHEN date_start IS NULL AND date_end IS NULL THEN 0
                WHEN date_issued BETWEEN date_start AND date_end THEN 1
                WHEN date_issued NOT BETWEEN date_start AND date_end THEN 0
            END AS paid
    FROM
        student_certificates c
    LEFT JOIN purchase_info p USING (student_id)) a
GROUP BY certificate_id;