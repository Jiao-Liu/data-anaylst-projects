SELECT 
    e.exam_attempt_id,
    e.student_id,
    e.exam_id,
    i.exam_category,
    exam_passed,
    e.date_exam_completed AS date_exam_completed
FROM
    student_exams e
    join exam_info i using(exam_id);
    

select * from exam_info;