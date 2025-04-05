-- INFO 330 Section AB
-- Anthony Wen


-- Question 1a
/* 

    EMPLOYEE TABLE:
        Primary Key (PK): Emp_ID
        Foreign Key (FK): Job_Code
    BENEFIT TABLE:
        Primary Key (PK): (Emp_ID, Plan_ID) (composite key)
        Foreign Key (FK): Emp_ID, Plan_ID
    JOB table:
        Primary Key (PK): Job_Code
    PLAN table:
        Primary Key (PK): Plan_ID

*/

-- Question 1b
/* 

YES: every table has a primary key or a unique identifier, there are foreign keys that can reference and connect the data in the tables together

*/

-- Question 1c
CREATE TABLE JOB (
    Job_Code INTEGER NOT NULL PRIMARY KEY IDENTITY(1,1),
    Job_Type VARCHAR(50)
);

CREATE TABLE EMPLOYEE (
    Emp_ID INTEGER NOT NULL PRIMARY KEY IDENTITY(1,1),
    Emp_Lname VARCHAR(50),
    Job_Code INTEGER,
    FOREIGN KEY (Job_Code) REFERENCES JOB(Job_Code)
);

-- Question 1d
INSERT INTO JOB (Job_Code, Job_Type) VALUES (1, 'Clerical');
INSERT INTO JOB (Job_Code, Job_Type) VALUES (2, 'Technical');
INSERT INTO JOB (Job_Code, Job_Type) VALUES (3, 'Managerial');

/* Question 2: Consider the following rela!onal schema that describes a pa!ent visit to a doctor, along with diagnosis, treatment code, and charge:
VISIT(Doctor_ID, Pa!ent_ID, Pa!ent_Name, Visit_Date, Diagnosis, Treat_Code, Charge)
Doctor_ID and Pa!ent_ID a%ributes are the composite primary key. Assume that diagnosis is determined uniquely for each pa!ent by a doctor. Also, assume that each treatment code has a fixed charge (regardless of pa!ent).
Explain briefly using the generalized defini!ons of second normal form (2NF) and third normal form (3NF) why the VISIT en!ty is not in in 2NF and 3NF. (3 marks) */

/* 

Definition of what 2NF and 3NF is according to prof's PPT:
A table is in second normal form (2NF) when:
It is in 1NF, and
It includes no partial dependencies; that is, no attribute is dependent on only a portion of the primary key
A table is in third normal form (3NF) when:
It is in 2NF, and
It includes no transitive dependencies; that is, no attribute is dependent on another non-key attribute
We make a new table to eliminate transitive dependency and reassign the corresponding dependent attributes

For the visit table, Patient Name column is dependent only on Patient lD. 
TreatCode and Charge also only rely on DoctorId and not on the complete candidate key, so it does not fit 2NF
Thus also violating 3NF due to transitive dependencies.

*/

/* Question 4 Write SQL code to return minage,, maxage, work_type, number of charities, average charity rating, total funds (based on totalcontributions) , lowest amount, and highest amount. 
Limit output to where the number of charities is at least 20. Average charity rating should be displayed rounded to 2 decimal places.
(Hint: there will be 30 rows of output). The excerpt below shows sample rows. */

SELECT ag.minage AS minage, ag.maxage AS maxage, wt.work_type AS work_type,
    COUNT(c.charity_id) AS numCharities, CAST(AVG(cp.overall_score) AS DECIMAL(5,2)) AS avaCharityRating,
    SUM(cp.total_contributions) AS totalFunds, MIN(cp.total_contributions) AS lowestAmt, MAX(cp.total_contributions) AS highestAmt
FROM AgeGroups ag
JOIN Charities c ON c.age_group_id = ag.age_group_id
JOIN CharityPerformance cp ON cp.charity_id = c.charity_id
JOIN WorkType wt ON wt.work_type_id = c.work_type_id
GROUP BY ag.minage, ag.maxage, wt.work_type
HAVING COUNT(c.charity_id) >= 20;

/* Question 5 Write a query to return sub category, total funds (based on total contributions), and sub category's share of total funds.
Your query should return sub categories with a percentage share of at least 10 percent listed by name.  
Those with percent shares less than 10 percent should be aggregated into one category called 'Other'. 
Percentage share should be displayed rounded to 2 decimal places. The Excerpt below shows the expected output. */

WITH SubCategoryFunds AS (
    SELECT 
        sc.sub_category,
        SUM(cp.total_contributions) AS TotalFunds,
        CAST(SUM(cp.total_contributions) * 100.0 / (SELECT SUM(cp2.total_contributions) FROM Charities c2 JOIN CharityPerformance cp2 ON c2.charity_id = cp2.charity_id) AS DECIMAL(18,2)) AS PctShare
    FROM Charities c
    JOIN SubCategories sc ON c.sub_category_id = sc.sub_category_id
    JOIN CharityPerformance cp ON c.charity_id = cp.charity_id
    GROUP BY sc.sub_category
)
SELECT 
    CASE 
        WHEN PctShare >= 10 THEN sub_category
        ELSE 'Other'
    END AS SubCategory,
    SUM(TotalFunds) AS TotalFunds,
    SUM(PctShare) AS PctShare
FROM SubCategoryFunds
GROUP BY 
    CASE 
        WHEN PctShare >= 10 THEN sub_category
        ELSE 'Other'
    END;


/* Question 6 a). Write a query to return work type, charity name, city, total contributions, and rank. 
Note: there should be no gaps in the ranking. Please limit the output to top 5 charities only for each work type.  
Note: there should be 172 rows in the output.  The Excerpt below shows sample output. (5 marks)

 */

SELECT work_type, charity_name, city, total_contributions,Rank
FROM 
    (SELECT wt.work_type, c.charity_name, l.city, cp.total_contributions,
        ROW_NUMBER() OVER (PARTITION BY wt.work_type ORDER BY cp.total_contributions DESC) AS Rank
    FROM Charities c
    JOIN CharityPerformance cp ON c.charity_id = cp.charity_id
    JOIN Locations l ON c.location_id = l.location_id
    JOIN WorkType wt ON c.work_type_id = wt.work_type_id
    ) AS RankedCharitiesSubquery
WHERE Rank <= 5
ORDER BY work_type, Rank;


/* Question 6b b). Write a query to return city, number of charities, total funds, average funds per charity, and the city's percentage share of total funds.  
Average funds and percent share should be displayed rounded to 2 decimal places. 
Display the output with the results grouped into 100 buckets sorted by descending order of total funds, and then by descending order of the number of charities. 
Limit the output the top 2 percentiles (i.e., top 2 buckets) only. Note: there should ne a total of 12 rows. Your output should be like the excerpt shown below. (5 marks) */

WITH CityCharityFunds AS (
    SELECT l.city, COUNT(c.charity_id) AS num_charities,
        SUM(cp.total_contributions) AS totFunds, AVG(cp.total_contributions) AS avg_funds_per_charity,
        ROUND((SUM(cp.total_contributions) / (SELECT SUM(cp2.total_contributions) FROM Charities c2 JOIN CharityPerformance cp2 ON c2.charity_id = cp2.charity_id)) * 100, 2) AS pct_share_tot_funds
    FROM Charities c
    JOIN CharityPerformance cp ON c.charity_id = cp.charity_id
    JOIN Locations l ON c.location_id = l.location_id
    GROUP BY l.city
),
RankedCities AS (
    SELECT 
        city,
        num_charities,
        totFunds,
        avg_funds_per_charity,
        pct_share_tot_funds,
        NTILE(100) OVER (ORDER BY totFunds DESC, num_charities DESC) AS city_bucket
    FROM CityCharityFunds
)
SELECT 
    city, num_charities, totFunds, ROUND(avg_funds_per_charity, 2) AS avg_funds_per_charity,
    pct_share_tot_funds, city_bucket
FROM RankedCities
WHERE city_bucket <= 2
ORDER BY city_bucket, totFunds DESC, num_charities DESC;