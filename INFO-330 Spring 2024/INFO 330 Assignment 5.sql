/*INFO 330 Assignment 5, Author: Anthony Wen */
USE UNIVERSITY
GO

/*Question 1: Write a SQL query to determine the top 25 students from each U.S. state with the highest GPA 
 among all students and all classes during the years between 1990 and 1995, 
 (i.e., partition the results by the student's permanent state).  
 Your query should list Student ID, First name, Last name, Year, GPA, and GPA rank. */

WITH GPA_Calculation AS (
    SELECT s.StudentID, s.StudentFName, s.StudentLName, s.StudentPermState, 
         SUM(cl.Grade * cr.Credits) / SUM(cr.Credits) AS GPA
    FROM tblSTUDENT s
    JOIN tblCLASS_LIST cl ON s.StudentID = cl.StudentID
    JOIN tblCLASS c ON cl.ClassID = c.ClassID
    JOIN tblCOURSE cr ON c.CourseID = cr.CourseID
    WHERE c.Year BETWEEN 1990 AND 1995
    GROUP BY s.StudentID, s.StudentFName, s.StudentLName, s.StudentPermState
),
Ranked_Students AS (
    SELECT *,DENSE_RANK() OVER (PARTITION BY StudentPermState ORDER BY GPA DESC) AS GPA_Rank
    FROM GPA_Calculation
)
SELECT StudentID, StudentFName, StudentLName, StudentPermState, Year, GPA, GPA_Rank
FROM Ranked_Students
WHERE GPA_Rank <= 25
ORDER BY StudentPermState, GPA_Rank
GO


/*Question 2: Write a SQL query to determine the 20th highest GPA between 2010 and 2020 for all Information School classes. 
Your query should show Student ID, First name, Last name, College Name, Year, GPA, and GPA rank. 
(Hint: Your query should account for the possibility of ties, even though this query returns only one row in this case.*/

WITH GPA_Calculation AS (
    SELECT s.StudentID, s.StudentFName, s.StudentLName, co.CollegeName,
        SUM(cl.Grade * cr.Credits) / SUM(cr.Credits) AS GPA
    FROM tblSTUDENT s
    JOIN tblCLASS_LIST cl ON s.StudentID = cl.StudentID
    JOIN tblCLASS c ON cl.ClassID = c.ClassID
    JOIN tblCOURSE cr ON c.CourseID = cr.CourseID
    JOIN tblDEPARTMENT d ON cr.DeptID = d.DeptID
    JOIN tblCOLLEGE co ON d.CollegeID = co.CollegeID
    WHERE c.YEAR BETWEEN 2010 AND 2020 AND co.CollegeName = 'Information School'
    GROUP BY s.StudentID, s.StudentFName, s.StudentLName, co.CollegeName
),
Ranked_GPA AS (
    SELECT *, DENSE_RANK() OVER (ORDER BY GPA DESC) AS GPA_Rank
    FROM GPA_Calculation
)
SELECT StudentID, StudentFName, StudentLName, CollegeName, GPA, GPA_Rank
FROM Ranked_GPA
WHERE GPA_Rank = 20

/*Question 3: Write a SQL query to divide Information School students into 100 groups sorted in a descending order of GPA for the years from 2020 to 2023. 
Your query should show Student ID, First name, Last name, GPA, and GPA group. */

WITH GPA_Calculation AS (
    SELECT s.StudentID, s.StudentFName, s.StudentLName, co.CollegeName,
        CAST (SUM(cl.Grade * cr.Credits) / SUM(cr.Credits) AS DECIMAL (5,2)) AS GPA,
        NTILE(100) OVER (ORDER BY SUM(cl.Grade * cr.Credits) / SUM(cr.Credits) DESC) AS GPAGroup
    FROM tblSTUDENT s
    JOIN tblCLASS_LIST cl ON s.StudentID = cl.StudentID
    JOIN tblCLASS c ON cl.ClassID = c.ClassID
    JOIN tblCOURSE cr ON c.CourseID = cr.CourseID
    JOIN tblDEPARTMENT d ON cr.DeptID = d.DeptID
    JOIN tblCOLLEGE co ON d.CollegeID = co.CollegeID
    WHERE c.[YEAR] BETWEEN 2020 AND 2023 AND co.CollegeName = 'Information School'
    GROUP BY s.StudentID, s.StudentFName, s.StudentLName,co.CollegeName
)
SELECT StudentID, StudentFName, StudentLName, GPA, GPAGroup
FROM GPA_Calculation
ORDER BY GPA DESC


/*Question 4: Write a Query to show the percentage change in yearly enrollment for the Information School from 2010 to 2020. 
Your query should return year, current year's enrollment, previous year's enrollment, and percentage change in enrollment. Order or sort the results by year.*/

WITH Enrollment AS (
    SELECT c.Year, COUNT(DISTINCT s.StudentID) AS EnrollmentCount
    FROM tblSTUDENT s
    JOIN tblCLASS_LIST cl ON s.StudentID = cl.StudentID
    JOIN tblCLASS c ON cl.ClassID = c.ClassID
    JOIN tblCOURSE cr ON c.CourseID = cr.CourseID
    JOIN tblDEPARTMENT d ON cr.DeptID = d.DeptID
    JOIN tblCOLLEGE co ON d.CollegeID = co.CollegeID
    WHERE c.Year BETWEEN 2010 AND 2020 AND co.CollegeName = 'Information School'
    GROUP BY c.YEAR
)
SELECT
   Year,
   EnrollmentCount,
   LAG(EnrollmentCount, 1, NULL) OVER (ORDER BY Year) AS prevYearEnrollment,
   CAST (100 * ((EnrollmentCount - LAG(EnrollmentCount) OVER(ORDER BY Year))) / LAG(EnrollmentCount) OVER (ORDER BY Year) AS NUMERIC (3)) AS percentageChange
FROM Enrollment
ORDER BY Year DESC
