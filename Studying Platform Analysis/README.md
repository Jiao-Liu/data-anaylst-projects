**Studying Platform Analysis**
------

About
----
This project focuses on analyzing customer behavior. We aim to explore the engagement differences between free and paid students, onboarding rates, the most popular courses based on different metrics, study durations between free and paid students, the number of exam attempts, and pass rates. This project involves extensive use of joins, subqueries, and CTEs to retrieve all the necessary data for future analysis.

purchase :1--> monthly subscription
		     2--> quarterly subscription
		     3-->annual subscription
Exam Path: 
		Enroll a track 
		Take course exam
		Get course exam certificate
		Take track exam
		Get track exam certificate 

Questions 
----
1. Engagement
	1.  number of engaged students
	2. Difference between free and paid student 
	3. Engagement changing overtime 
	4. Marketing campaign effects engagement?
	5. How long do students stay engagement?
	6. Difference between free and paid student
2. Onboarding 
	1. number onboarding / number of total registered students
3. Course
	1. Most watched and enjoyed course on the platform
	2. Average minutes watched per course = total minutes watched from a course / # of students watched the course 
	3. Completion rate = Average minutes watched per course/ duration of the course length
4. Studying 
	1. Minutes watched by student on average
	2. Difference between free and paid student 
	3. FTP conversion rate based on minutes watched 
		1. number subscribers / # students registered*100
	4. Average subscription duration based on the minutes watched on the platform
5. Exam 
	1. number of exam taken?
	2. exam success rates on different type of exams(practice/course/career track)
	3. 1:Practice exam, 2: course exam, 3:track exam
	4. career track: 1 DA,2 BA,3 DS
	5. certificate: 1. course ,2 career

Visualization
---
Tableau:https://public.tableau.com/app/profile/jiao.liu/viz/customerbehavior_17216699392750/Overview
