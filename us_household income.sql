

/**This set of queries performs a comprehensive data cleaning and analysis process, 
including identifying and removing duplicates, standardizing text data, filling missing values, 
joining datasets, and analyzing household income by various dimensions such as state, 
area type, and city.*/



###  Basic Table Queries and Initial Setup

# Retrieve all rows from the USHouseholdIncome table (contains 32,533 rows)
SELECT * FROM USHouseholdIncome; #32533 rows

# Retrieve all rows from the ushouseholdincome_statistics table (contains 32,526 rows)
SELECT * FROM ushouseholdincome_statistics; # 32526 rows


# Rename the 'id' column to 'ID' in the ushouseholdincome_statistics table for consistency
ALTER TABLE ushouseholdincome_statistics RENAME COLUMN  `id` TO `ID` ;


### Finding and Deleting Duplicates

# Find duplicate IDs in the USHouseholdIncome table
SELECT id,count(id)
FROM USHouseholdIncome 
GROUP BY id
HAVING count(id) > 1
;

# Find duplicate IDs in the ushouseholdincome_statistics table
SELECT ID,count(ID)
FROM ushouseholdincome_statistics
GROUP BY ID
HAVING count(ID) > 1
;

# Delete duplicate rows in the USHouseholdIncome table, keeping only the first occurrence
DELETE FROM USHouseholdIncome
WHERE row_id IN(
SELECT row_id
FROM(
SELECT row_id,
id, 
ROW_NUMBER()OVER(PARTITION BY id ORDER BY id) AS rn
FROM USHouseholdIncome) AS t
WHERE rn > 1);

### Standardizing State Names

# Display distinct state names to identify any inconsistencies
SELECT DISTINCT State_Name
FROM USHouseholdIncome;

# Correct the spelling of 'Georgia' in the State_Name column
UPDATE USHouseholdIncome
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

# Correct the spelling of 'Alabama' in the State_Name column
UPDATE USHouseholdIncome
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';

### Checking and Filling Missing Values

# Check distinct values in the State_ab column to ensure consistency
SELECT DISTINCT State_ab
FROM USHouseholdIncome;

# Find records where the Place column is NULL
SELECT *
FROM USHouseholdIncome
WHERE Place IS NULL;

# Confirm specific records where the Place column is NULL, based on County and City
SELECT * 
FROM USHouseholdIncome
WHERE County = 'Autauga County' AND City = 'Vinemont';

# Update the Place column to 'Autaugaville' where it is NULL and matches specific County
UPDATE USHouseholdIncome
SET Place = 'Autaugaville'
WHERE Place IS NULL AND County = 'Autauga County';



### Checking and Updating the Type Column

# Count occurrences of each value in the Type column
SELECT Type,Count(*)
FROM USHouseholdIncome
GROUP BY Type;

# Standardize the Type column by correcting 'Boroughs' to 'Borough'
UPDATE USHouseholdIncome 
SET Type = 'Borough'
WHERE Type = 'Boroughs';

### Checking for Missing or Zero Land and Water Areas
# Find rows where both Aland (land area) and Awater (water area) are either NULL or 0
SELECT Aland,Awater
FROM USHouseholdIncome
WHERE (Awater = 0 OR Awater IS NULL OR Awater = '')
AND (Aland = 0 OR Aland IS NULL OR Aland = '');

### Top 10 States by Land and Water Area

# Find the top 10 states by total land area
SELECT State_Name,SUM(Aland),SUM(Awater)
FROM USHouseholdIncome
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10;

# Find the top 10 states by total water area
SELECT State_Name,SUM(Aland),SUM(Awater)
FROM USHouseholdIncome
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10;
 

### Join table 
# Perform an inner join between USHouseholdIncome and ushouseholdincome_statistics on the ID column
SELECT * 
FROM USHouseholdIncome u
JOIN ushouseholdincome_statistics s
	ON u.id = s.ID;

### Analyzing Household Income by State

# Find the bottom 5 states by average household income
SELECT u.State_Name,ROUND(Avg(Mean),1),ROUND(Avg(Median),1)
FROM USHouseholdIncome u
JOIN ushouseholdincome_statistics s
	ON u.id = s.ID
GROUP BY  u.State_Name
ORDER BY 2
LIMIT 5; 

# Find the top 5 states by average household income
SELECT u.State_Name,ROUND(Avg(Mean),1),ROUND(Avg(Median),1)
FROM USHouseholdIncome u
JOIN ushouseholdincome_statistics s
	ON u.id = s.ID
GROUP BY  u.State_Name
ORDER BY 2 DESC
LIMIT 5; 


### Analyzing Income by Type of Area
# Analyze average household income by type of area, filtering out types with fewer than 100 occurrences
SELECT Type,COUNT(Type),ROUND(Avg(Mean),1),ROUND(Avg(Median),1)
FROM USHouseholdIncome u
JOIN ushouseholdincome_statistics s
	ON u.id = s.ID
GROUP BY  Type
HAVING COUNT(Type) > 100
ORDER BY 3 DESC; 

# Check which state has areas labeled as 'Community'==> Puerto rico
SELECT * 
FROM USHouseholdIncome
WHERE Type = 'Community';

### Analyzing Income in Big Cities
# Analyze average household income in Texas cities
SELECT u.State_Name,City,ROUND(Avg(Mean),1),ROUND(Avg(Median),1)
FROM USHouseholdIncome u
JOIN ushouseholdincome_statistics s
	ON u.id = s.ID
WHERE u.State_Name = 'Texas' 
GROUP BY  1,2
ORDER BY 3 DESC;




