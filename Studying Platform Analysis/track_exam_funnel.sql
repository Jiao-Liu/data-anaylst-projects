# Table 1: Get all enrolled students and left join the students who took the course exam to obtain all the course exam information for all enrolled students.
# Table 2: Table 1 left join table 2 (track info) to obtain all enrolled students' course exam information and determine if the course belongs to the track.
# Table 3: Table 2 left join table 3 (certificate info), obtain all enrolled students' course exam information and whether they obtained a certificate.
# Condition: If the course_exam table is NULL, it means that the enrolled student didn’t take the course exam. If the course_exam table is not NULL but the track_info table is NULL, it means that the course is not part of the track (0). Only when both the course_exam and track_info are not NULL, it confirms that the student took the course exam for that track (1).
# Condition for certificate: If attempted_course_exam is 1 and certificate is not NULL, the student obtained a certificate for the course. All other conditions mean no certificate.
# Table 4: For exam_category = 3, get the information of all students who took the track exam.
# Table 5: Left join table 3 with table 4 to get the information of enrolled students who took the final track exam
# Table 6: For certificate_type = 2, get the students' information who obtained a track certificate.
# Table 7: Table 5 left join table 6 to get the enrolled students who obtained the final track certificate.
# Table 8: Aggregate the data by track_id. For example, COUNT(track_id) will give the total number of enrolled students, SUM(attempted_course_exam) will give the number of students who attempted the course exam, SUM(course_certificate) will give the number of students who obtained a course certificate, COUNT(final_exam) will give the number of students who took the final exam, and COUNT(track_certificate) will give the number of students who obtained the final track certificate.
# Table 9: Pivot the data from rows to columns.





# get all the student's info and course of course exam 
with table_course_exams as
(
SELECT DISTINCT
    se.student_id, e.course_id
FROM
    student_exams se
        JOIN
    exam_info e USING (exam_id)
WHERE
    e.exam_category = 2
),
# all the students id and course id of who obtained a certificate
table_course_certificates as
(
SELECT DISTINCT
    student_id, course_id
FROM
    student_certificates
WHERE
    certificate_type = 1
),


# enrolled student left join student who took course exam-->all enrolled students + which course they attempted 
# left join track_info-->all enrolled student + course exam attempted +if course is in the track
# left join course certificate-->all enrolled student + course exam attempted +if course is in the track+if they obtained a certificate
table_attempted_course_exam_certificate_issued as
(
SELECT 
    student_id,
    enrolled_in_track_id,
    MAX(attempted_course_exam) AS attempted_course_exam,
    MAX(certificate_course_id) as certificate_course_id
FROM
(-- Get the successful course exams
SELECT 
    c.*,
    CASE
        WHEN cc.course_id IS NULL THEN 0
        WHEN
            cc.course_id IS NOT NULL
                AND c.attempted_course_exam = 0 
        THEN
            0
        WHEN
            cc.course_id IS NOT NULL
                AND c.attempted_course_exam = 1
        THEN
            1
    END AS certificate_course_id
    FROM
( -- Get the enrollment in track and the attempted_course_exam column
SELECT 
        a.student_id,
            a.track_id as enrolled_in_track_id,
            a.course_id,
            b.track_id, # 课程说属track ID
            CASE
                WHEN a.course_id IS NULL THEN 0 
                WHEN
                    a.course_id IS NOT NULL
                        AND b.track_id IS NULL #有做course考试，但是不属于track里面的课程
                THEN
                    0
                WHEN
                    a.course_id IS NOT NULL
                        AND b.track_id IS NOT NULL 
                THEN
                    1
            END AS attempted_course_exam
    FROM
        (-- Get the course id's of the course exams that a student has attempted


        SELECT DISTINCT
    *
FROM
    student_career_track_enrollments en
        LEFT JOIN
    table_course_exams ex USING (student_id)
ORDER BY student_id , track_id , course_id) a
    LEFT JOIN career_track_info b ON a.track_id = b.track_id
        AND a.course_id = b.course_id) c
	LEFT JOIN table_course_certificates cc ON c.student_id = cc.student_id
	AND c.course_id = cc.course_id ) d
GROUP BY student_id , enrolled_in_track_id
),


# all students info and track info of who took career exam
table_track_exams as
(
SELECT DISTINCT
    se.student_id, e.track_id
FROM
    student_exams se
        JOIN
    exam_info e USING (exam_id)
WHERE
    e.exam_category = 3
),
# left join course certificate-->all enrolled student + course exam attempted +if course is in the track+if they obtained a certificate
# left join career track exam student --> all enrolled student + course exam attempted +if course is in the track+if they obtained a certificate+career track exam info
table_attempted_final_exam as
(
SELECT DISTINCT
    i.*, ex.track_id AS attempted_track_id
FROM
    table_attempted_course_exam_certificate_issued i
        LEFT JOIN
    table_track_exams ex ON i.student_id = ex.student_id
        AND i.enrolled_in_track_id = ex.track_id
),
# student who obtained a track exam certificate
table_certificates as
(
SELECT 
    student_id, track_id, cast(date_issued as date) as date_issued
FROM
    student_certificates
WHERE
    certificate_type = 2
),
# left join career track certificate-->all enrolled student + course exam attempted +if course is in the track+if they obtained a certificate+career track exam info+career track certificate info
table_issued_certificates as
(
SELECT DISTINCT
    e.*, c.track_id as certificate_track_id, c.date_issued
FROM
    table_attempted_final_exam e
    LEFT JOIN
    table_certificates c
    ON e.student_id = c.student_id
        AND e.enrolled_in_track_id = c.track_id
),

# aggregate: group by track id- count/ sum each columns  to get total numbers of each steps 
table_final as
(
SELECT 
    enrolled_in_track_id AS track_id,
    COUNT(enrolled_in_track_id) AS enrolled_in_track_id,
    SUM(attempted_course_exam) AS attempted_course_exam,
    SUM(certificate_course_id) AS certificate_course_id,
    COUNT(attempted_track_id) AS attempted_track_id,
    COUNT(certificate_track_id) AS certificate_track_id
FROM
    table_issued_certificates
GROUP BY enrolled_in_track_id
),


# transform
table_reordered as
(
SELECT 
    'Enrolled in a track' AS 'action',
    enrolled_in_track_id AS 'track',
    COUNT(enrolled_in_track_id) AS 'count'
FROM
    table_issued_certificates
GROUP BY enrolled_in_track_id
UNION
SELECT 
    'Attempted a course exam' AS 'action',
    enrolled_in_track_id AS 'track',
    SUM(attempted_course_exam) AS 'count'
FROM
    table_issued_certificates
GROUP BY enrolled_in_track_id
UNION
SELECT 
    'Completed a course exam' AS 'action',
    enrolled_in_track_id AS 'track',
    SUM(certificate_course_id) AS 'count'
FROM
    table_issued_certificates
GROUP BY enrolled_in_track_id
UNION
SELECT 
    'Attempted a final exam' AS 'action',
    enrolled_in_track_id AS 'track',
    COUNT(attempted_track_id) AS 'count'
FROM
    table_issued_certificates
GROUP BY enrolled_in_track_id
UNION
SELECT 
    'Earned a career track certificate' AS 'action',
    enrolled_in_track_id AS 'track',
    COUNT(certificate_track_id) AS 'count'
FROM
    table_issued_certificates
GROUP BY enrolled_in_track_id
)
select * from table_reordered;










