/*
These queries cover tasks related to data cleaning, identifying and removing duplicates, 
filling in missing data, and performing various statistical analyses. */


SELECT * From world_life_expectancy;

### Fing Duplicates and deleting duplicates 

# Find duplicate Country and Year combinations and count their occurrences
SELECT Country,Year, CONCAT(Country,Year),Count(CONCAT(Country,Year))
FROM world_life_expectancy
GROUP BY 1,2,3
Having count(CONCAT(Country,Year))>1;


# Identify duplicate records and assign a row number to each duplicate, keeping only the first occurrence
SELECT *
FROM(
SELECT Row_id,concat(Country,Year),
ROW_NUMBER()OVER(PARTITION BY concat(Country,Year) order by concat(Country,Year) ) AS rn
FROM world_life_expectancy) AS t
WHERE rn >1;

# Delete duplicate records, keeping only the first occurrence within each group
DELETE FROM world_life_expectancy
WHERE Row_id IN (
		SELECT Row_id
FROM(
SELECT Row_id,concat(Country,Year),
ROW_NUMBER()OVER(PARTITION BY concat(Country,Year) ORDER BY concat(Country,Year) ) AS rn
FROM world_life_expectancy) AS t
WHERE rn >1
);


### Finding Empty Country Status and Filling Based on Other Rows

# Find records where the Status field is empty
SELECT * 
FROM world_life_expectancy
WHERE Status = '';

# Find all distinct non-empty statuses
SELECT DISTINCT Status
FROM world_life_expectancy
WHERE Status <> '';

# Find countries with a status of "Developing"
SELECT DISTINCT Country 
FROM world_life_expectancy
WHERE Status = 'Developing';

# Update records with an empty status to "Developing" based on existing records for the same country
UPDATE world_life_expectancy
SET Status = 'Developing'
WHERE Country IN (
		SELECT DISTINCT Country 
		FROM world_life_expectancy
		WHERE Status = 'Developing');
        

# Update empty statuses to "Developing" based on other rows for the same country
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = '' And t2.Status <> '' AND t2.Status = 'Developing';


# Update empty statuses to "Developed" based on other rows for the same country
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = '' And t2.Status <> '' AND t2.Status = 'Developed';



###  Filling Empty "Lifeexpectancy" Fields


# Find records where the "Lifeexpectancy" field is empty
SELECT * 
FROM world_life_expectancy
WHERE `Lifeexpectancy` ='' ;

# Calculate the fill value for empty "Lifeexpectancy" fields based on the average of the previous and following years
SELECT t1.Country,t1.Year,t1.`Lifeexpectancy`,
t2.Country,t2.Year,t2.`Lifeexpectancy`,
t3.Country,t3.Year,t3.`Lifeexpectancy`,
Round((t2.`Lifeexpectancy`+ t3.`Lifeexpectancy`)/2,1)
FROM world_life_expectancy t1 JOIN world_life_expectancy t2
	ON t1.Country = t2.Country AND t1.year = t2.year-1 Join world_life_expectancy t3
    ON t1.Country = t3.Country AND t1.year = t3.year + 1
WHERE t1.`Lifeexpectancy` = '';

# Update the empty 'Lifeexpectancy' column with the average of the previous and following years
UPDATE world_life_expectancy t1 
Join world_life_expectancy t2
	ON t1.Country = t2.Country AND t1.year = t2.year-1 JOIN world_life_expectancy t3
    ON t1.Country = t3.Country AND t1.year = t3.year + 1
SET t1.`Lifeexpectancy` = Round((t2.`Lifeexpectancy`+ t3.`Lifeexpectancy`)/2,1)
WHERE t1.`Lifeexpectancy` = '';


### Finding the Life Expectancy Difference Over the Past 15 Years

# Find the maximum difference in life expectancy over the past 15 years for each country
SELECT Country,
min(`Lifeexpectancy`),
max(`Lifeexpectancy`),ROUND(max(`Lifeexpectancy`)-min(`Lifeexpectancy`),2) AS life_increase_15_years
FROM world_life_expectancy
GROUP BY country
HAVING min(`Lifeexpectancy`) <> 0 AND max(`Lifeexpectancy`) <> 0
ORDER BY life_increase_15_years DESC;


### Average Life Expectancy Per Year
# Calculate the average life expectancy for each year
SELECT Year, ROUND(avg(`Lifeexpectancy`),2)
FROM world_life_expectancy
WHERE `Lifeexpectancy`<> 0
GROUP BY Year
ORDER  BY Year;



###  Average Life Expectancy and GDP by Country

# Calculate the average life expectancy and GDP for each country
SELECT Country,ROUND(AVG(`Lifeexpectancy`),1) AS life_exp,ROUND(AVG(GDP),1) AS gdp
FROM world_life_expectancy
GROUP BY Country
HAVING life_exp >0 AND GDP >0
ORDER BY GDP desc;


### Average Life Expectancy Based on GDP Groups
# Calculate the number of countries and average life expectancy for high-GDP (>= 1500) and low-GDP (< 1500) groups
SELECT 
	SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_Gdp_Count,
    AVG(CASE WHEN GDP >= 1500 THEN `Lifeexpectancy` ELSE NULL END)High_Gdp_Life_expectancy,
    SUM(CASE WHEN GDP < 1500 THEN 1 ELSE 0 END) Low_Gdp_Count,
    AVG(CASE WHEN GDP < 1500 THEN `Lifeexpectancy` ELSE NULL END)Low_Gdp_Life_expectancy
FROM world_life_expectancy;

###  Average Life Expectancy by Country Status
# Calculate the average life expectancy based on country status (Developing/Developed)
SELECT Status, ROUND(AVG(`Lifeexpectancy`),1)
FROM world_life_expectancy
GROUP BY Status;

# Calculate the number of countries and average life expectancy by country status
SELECT Status, COUNT(DISTINCT Country), ROUND(AVG(`Lifeexpectancy`),1)
FROM world_life_expectancy
GROUP BY Status
;


### Average Life Expectancy by Country and BMI
# Calculate the average life expectancy and BMI for each country, ordered by BMI in ascending order
SELECT Country, ROUND(AVG(`Lifeexpectancy`),1) AS Life_Exp, ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND BMI > 0
ORDER BY BMI ASC
;



### Rolling Total of Adult Mortality in Countries Containing "United"
# Calculate the rolling total of adult mortality for countries containing "United" in their name
SELECT Country,
Year,
`Lifeexpectancy`,
`AdultMortality`,
SUM(`AdultMortality`) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy
WHERE Country LIKE '%United%'
;











