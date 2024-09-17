

### Purchase info 
# get all the paid students info which include purchase id ,student id,purchaset type, purchase date and renew date

DROP VIEW IF EXISTS purchase_info;

CREATE VIEW purchase_info AS (
SELECT 
purchase_id,
student_id,
purchase_type,
date_start,
IF(date_refunded IS NULL,date_end,date_refunded) AS date_end
FROM(
	SELECT 
	purchase_id,
	student_id,
	purchase_type,
	date_purchased AS date_start,
	CASE 
		WHEN purchase_type = 0 THEN DATE_ADD(MAKEDATE(YEAR(date_purchased),DAY(date_purchased)), INTERVAL MONTH(date_purchased) MONTH) # monthly
		WHEN purchase_type = 1 THEN DATE_ADD(MAKEDATE(YEAR(date_purchased),DAY(date_purchased)), INTERVAL MONTH(date_purchased)+2  MONTH) # seasonal
		WHEN purchase_type = 2 THEN DATE_ADD(MAKEDATE(YEAR(date_purchased),DAY(date_purchased)), INTERVAL MONTH(date_purchased)+11 MONTH) # annual
		END AS date_end,
	date_refunded
				 
	FROM student_purchases)t);
    

 SELECT * FROM purchase_info;
 
 
 
 