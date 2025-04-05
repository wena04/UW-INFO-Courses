USE HotelBooking_db
Go
/*Part 1: Aggregate Functions
1)	Write a query to return reservation status and the total number of bookings for each status for the month of August 2017.
2)	Write a query to return market segment and the total number of room type changes for June 2016 arrivals. Sort the output in descending order of total number or room type changes. (Hint: a room type change occurs when the reserved room type is different from assigned room type).
3)	Write a query to display market segment, average daily rate, maximum lead time, and the number of cancellations for January to March arrival months in 2017 that were canceled.
4)	Write a query to return assigned room type and the number of bookings for 2017 arrivals where the guests stayed longer during weekend than weekdays. Sort the results in descending order of the number of bookings.
*/

--1)	Write a query to return reservation status and the total number of bookings for each status for the month of August 2017.

SELECT reservation_status, COUNT(*) AS num_bookings
FROM Booking 
WHERE reservation_status_date BETWEEN '2017-08-01' AND '2017-08-31'
GROUP BY reservation_status

/*
2)	Write a query to return market segment and the total number of room type changes for June 2016 arrivals. 
Sort the output in descending order of total number or room type changes. (Hint: a room type change occurs 
when the reserved room type is different from assigned room type).
*/
SELECT market_segment, COUNT(*) AS num_room_changes
FROM Booking
WHERE arrive_year = 2016 
	AND arrive_month = 'June' 
	AND reserved_room_type <> assigned_room_type
GROUP BY market_segment
ORDER BY num_room_changes DESC

/*
3)	Write a query to display market segment, average daily rate, maximum lead time, and the number of cancellations 
for January to March arrival months in 2017 that were canceled.
*/
SELECT market_segment, AVG(daily_rate) AS avg_daily_rate, MAX(lead_time) AS max_lead_time, COUNT(*) AS num_cancellations
FROM Booking
WHERE arrive_year = 2017 
	AND arrive_month BETWEEN 'January' AND 'March'  
	AND reservation_status = 'Canceled'
GROUP BY market_segment

/*
4)	Write a query to return assigned room type and the number of bookings for 2017 arrivals where the guests 
stayed longer during weekend than weekdays. Sort the results in descending order of the number of bookings.
*/
SELECT assigned_room_type, COUNT(*) AS num_bookings
FROM Booking
WHERE arrive_year = 2017 
	AND weekend_nights > week_nights
GROUP BY assigned_room_type
ORDER BY num_bookings DESC


/*
Part 2. Table Joins
For this part, use the UNIVERSITY database (what you used for lab 2). This is a medium-sized database with several tables. You are provided with the ERD for this database.
What you should do
Write SQL queries to answer the following questions:
5.	Write the SQL query to display building name for dorms located on Stevens Way.
6.	Write the SQL query to display the last name and first name of students who completed at least 25 credits of information school courses from 2015 to 2020.
7.	Write the SQL query to return schedule name, total distinct number of classes and enrollment for each schedule for the year 2020. Sort the results in descending order of the number of classes and enrollment and limit your output to top 5 schedules ONLY. 
8.	Write the SQL query to return course name, enrollment, and total tuition fees per course for information school courses offered in 2019 that begin with “INFO” and the course number is 300 and higher.  
What to Submit
•	Save your work as SQL script (file) and upload it to Canvas.
*/
USE UNIVERSITY
GO
--5.	Write the SQL query to display building name for dorms located on Stevens Way.
SELECT BuildingName
FROM tblBUILDING b 
	JOIN tblLOCATION lo ON b.LocationID = lo.LocationID
	JOIN tblBUILDING_TYPE bt ON b.BuildingTypeID = bt.BuildingTypeID
WHERE bt.BuildingTypeName = 'Dormitory' 
	AND lo.LocationName = 'Stevens Way'

/*
6.	Write the SQL query to display the last name and first name of students who completed at least 25 credits 
of information school courses from 2015 to 2020.
*/
SELECT StudentLname, StudentFname
FROM tblSTUDENT s
	JOIN tblCLASS_LIST cl ON s.StudentID = cl.StudentID
	JOIN tblCLASS c ON cl.ClassID = c.ClassID
	JOIN tblCOURSE co ON c.CourseID = co.CourseID
	JOIN tblDEPARTMENT d ON co.DeptID = d.DeptID
	JOIN tblCOLLEGE cg ON d.CollegeID = cg.CollegeID
WHERE cg.CollegeName = 'Information School' 
	AND c.YEAR BETWEEN 2015 AND 2020
GROUP BY StudentLname, StudentFname
HAVING SUM(co.Credits) >= 25

/*
7.	Write the SQL query to return schedule name, total distinct number of classes and enrollment for each schedule for the year
2020. Sort the results in descending order of the number of classes and enrollment and limit your output to top 5 schedules ONLY.
*/
SELECT TOP 5 ScheduleName, COUNT(DISTINCT c.ClassID) AS NumClasses, COUNT(DISTINCT cl.StudentID) AS Enrollment
FROM tblSCHEDULE sc
	JOIN tblCLASS c ON sc.ScheduleID = c.ScheduleID
	JOIN tblCLASS_LIST cl ON c.ClassID = cl.ClassID
WHERE c.YEAR = 2020
GROUP BY ScheduleName
ORDER BY NumClasses DESC, Enrollment DESC

/*
8.	Write the SQL query to return course name, enrollment, and total tuition fees per course for information school courses
offered in 2019 that begin with “INFO” and the course number is 300 and higher. 
*/
SELECT CourseName,  COUNT(DISTINCT cl.StudentID) AS Enrollment, SUM(cl.RegistrationFee) AS TotalTuition
FROM tblCOURSE co
	JOIN tblCLASS c ON co.CourseID = c.CourseID
	JOIN tblCLASS_LIST cl ON c.ClassID = cl.ClassID
	JOIN tblDEPARTMENT d ON co.DeptID = d.DeptID
	JOIN tblCOLLEGE cg ON d.CollegeID = d.CollegeID
WHERE c.YEAR = 2019 
	AND cg.CollegeName = 'Information School'
	AND CourseName LIKE 'INFO%'
	AND CourseNumber >=300
GROUP BY CourseName