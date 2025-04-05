-- Part 1

-- Set up & Testing stuff
USE HotelBooking_db
SELECT * FROM Booking;
SELECT DISTINCT assigned_room_type FROM Booking

-- Question 1
SELECT reservation_status, COUNT(reservation_status) AS num_reservations -- first col = type of status, second col = num of status
FROM Booking
WHERE arrive_month = 'August' AND arrive_year = 2017 -- Only want from August 2017
GROUP BY reservation_status; 

-- Question 2
SELECT market_segment, COUNT(assigned_room_type) AS changed_room -- number of rooms that changed (the assigned room could also be reserved room)
FROM Booking
WHERE arrive_month = 'June' AND arrive_year = 2016 AND assigned_room_type != reserved_room_type -- June 2016 and have room change
GROUP BY market_segment 
ORDER BY changed_room DESC; -- ordering room change in descending order

-- Question 3
SELECT market_segment, AVG(daily_rate) AS avg_daily_rate, MAX(lead_time) AS max_lead_time, 
    COUNT(*) AS num_cancel -- '*' Could be any other attribute, it all works
FROM Booking
WHERE (arrive_month = 'January' OR arrive_month = 'February' OR arrive_month = 'March') AND arrive_year = 2017 AND reservation_status = 'Canceled'
GROUP BY arrive_month,market_segment; -- want to display the results for the month and the market segment type
 
-- Question 4
SELECT assigned_room_type, COUNT(*) AS longer_weekend -- Would not display room type P since it does not have a reservation that fits criteria
FROM Booking 
WHERE arrive_year = 2017 AND weekend_nights > week_nights
GROUP BY assigned_room_type
ORDER BY longer_weekend DESC;

-- Part 2

-- Set up & Testing stuff
USE UNIVERISTY;
SELECT * FROM tblLOCATION

-- Question 5
SELECT BuildingName
FROM tblBUILDING bil
JOIN tblLOCATION lo
ON bil.LocationID = lo.LocationID
WHERE LocationName = 'Stevens Way' AND BuildingTypeID = 5; -- Only want dorms, and ones on Stevens Way

-- Question 6
SELECT s.StudentLname AS student_last_name, s.StudentFname AS student_first_name
FROM tblSTUDENT s
JOIN tblCLASS_LIST cl ON s.StudentID = cl.StudentID
JOIN tblCLASS class ON cl.ClassID = class.ClassID
JOIN tblCOURSE co ON class.CourseID = co.CourseID -- get credits from joining this table
JOIN tblDEPARTMENT dept ON co.DeptID = dept.DeptID
JOIN tblCOLLEGE col ON dept.CollegeID = col.CollegeID -- get college that offer this course from here
WHERE col.CollegeName = 'Information School' AND class.YEAR BETWEEN 2015 AND 2020
GROUP BY s.StudentLname, s.StudentFname
HAVING SUM(co.Credits) >= 25 -- make sure this student has at least 25 credits

-- Question 7
SELECT TOP 5 sch.ScheduleName, COUNT(DISTINCT class.ClassID) AS number_of_classes, COUNT(DISTINCT cl.StudentID) AS enrollment
FROM tblSCHEDULE sch
JOIN tblCLASS class ON sch.ScheduleID = class.ScheduleID 
JOIN tblCLASS_LIST cl ON class.ClassID = cl.ClassID -- to get StudentID to use to calculate total enrollment
WHERE class.YEAR = 2020
GROUP BY sch.ScheduleName
ORDER BY number_of_classes DESC, enrollment DESC -- order in descending order by class and enrollment

-- Question 8
SELECT co.CourseName, COUNT(DISTINCT cl.StudentID) AS enrollment, SUM(cl.RegistrationFee) AS total_tuition
FROM tblCourse co
JOIN tblCLASS class ON co.CourseID = class.CourseID -- get the year from here
JOIN tblCLASS_LIST cl ON class.ClassID = cl.ClassID -- get the StudentID here to calculate # of students enrolled
JOIN tblDEPARTMENT dep ON co.DeptID = dep.DeptID -- get department course offered in
JOIN tblCOLLEGE col ON dep.CollegeID = col.CollegeID -- get college offered from information school
WHERE col.CollegeName = 'Information School' AND class.YEAR = 2019 AND co.CourseName 
    LIKE 'INFO%' AND co.CourseNumber >= 300 -- '%'used to represent everything else in the rest of the string "INFO"
GROUP BY co.CourseName