/* MIDTERM EXAM SOLUTION */
--=================================================
USE Apps_db 
GO

/*
QUESTION 1
  Write a SQL query to return user ID, the date of the latest App review, name of the 
  App a user reviewed, and the Metacritic score for the App where the following
  requirements are met:

The App reviewed is of Action genre.
The user has completed more than 1 review.
The user recommended the App (i.e., IsRecommneded = 1).
Other users found the review to be neither helpful nor funny.
*/
SELECT ar.UserID, MAX(ReviewDate) AS 'Latest Review',a.[Name], a.MetacriticScore 
FROM AppRecommendations ar
JOIN Apps a ON ar.AppID = a.AppID
JOIN AppGenres ag ON a.AppID = ag.AppID
JOIN Genres g ON ag.GenreID = g.GenreID
WHERE g.GenreName='Action'
AND ar.IsRecommended = 1
GROUP BY ar.UserID, a.[Name], a.MetacriticScore
HAVING SUM(ar.Helpful) = 0 AND SUM(ar.Funny) = 0
AND COUNT(ar.ReviewID) > 1
GO
--========================================================

/*
QUESTION 2
Create a SELECT query stored procedure (give it a descriptive name of your choice and 
prefix the name of the procedure with you initials). This procedure, given correct 
parameter values should return query results to the user.

Your procedure should have the following parameters:

App platform
Genre name
Start date and end date for the user to specify date ranges for the release date of 
the App. Your final query output should display:

user base (determined using Lower limit and Upper Limit columns in the Apps table)
Please use the following labels for user base groups:
0-20000
20000-50000
50000-100000
100000-200000
200000-500000
500000-1000000
1000000 - 2000000
2000000 - 5000000
5000000 - 10000000
10000000 - 20000000

revenue (based on the original App price)
discounted revenue (Based on the final App price), and
revenue lost (i.e., Revenue - discounted revenue)
Note: Use the midpoint of the Lower limit and Upper limit to compute revenue values 
(e.g., Revenue = AVG(LowerLimit + UpperLimit)*PriceOriginal).

NOTE: Round revenue, discounted revenue and revenue lost to 2 decimal places.

Additionally, you query should mee the following conditions:

Exclude Apps for which the original price is equal to 0 and the Upper Limit of
user base is equal to 0.
Please compile and test the procedure with the following values:

Platform: Mac
Genre: Action
Start date: 2017-01-01
End date:  2017-12-31
 
*/
CREATE OR ALTER PROCEDURE usoGetInstalledBaseRev
(@plat varchar(50),
@G_name varchar(50),
@start_date DATE,
@end_date DATE)
AS
BEGIN
WITH cte_recomm
AS
(SELECT a.AppID, AVG(a.LowerLimit +a.UpperLimit)*a.PriceFinal AS DescRevenue,
AVG(a.LowerLimit +a.UpperLimit)*a.PriceOriginal AS Revenue
FROM Apps a
JOIN AppPlatforms ap ON a.AppID = ap.AppID
JOIN Platforms p ON ap.PlatformID = p.PlatformID
JOIN AppGenres ag ON a.AppID = ag.AppID
JOIN Genres g ON ag.GenreID = g.GenreID

WHERE PriceOriginal >0 AND a.UpperLimit > 0
AND p.Platform = @Plat --'Mac'
AND g.GenreName = @G_name --'Action'
AND a.ReleaseDate BETWEEN @start_date AND @end_date --> '2017-12-31'
GROUP BY a.AppID,a.PriceFinal, a.PriceOriginal
)
-------------------
SELECT(CASE WHEN a. LowerLimit = 0 AND a.UpperLimit =20000
		THEN '0-20000'
		WHEN a. LowerLimit = 20000 AND a.UpperLimit =50000
		THEN '20000-50000'
		WHEN a. LowerLimit = 50000 AND a.UpperLimit =100000
		THEN '50000-100000'
		WHEN a. LowerLimit = 100000 AND a.UpperLimit =200000
		THEN '100000-200000'
		WHEN a. LowerLimit = 200000 AND a.UpperLimit =500000
		THEN '200000-500000'
		WHEN a. LowerLimit = 500000 AND a.UpperLimit =1000000
		THEN '500000-1000000'
		WHEN a. LowerLimit = 1000000 AND a.UpperLimit =2000000
		THEN '1000000 - 2000000'
		WHEN a. LowerLimit = 2000000 AND a.UpperLimit =5000000
		THEN '2000000 - 5000000'
		WHEN a. LowerLimit = 5000000 AND a.UpperLimit =10000000
		THEN '5000000 - 10000000'
		--WHEN a. LowerLimit = 10000000 AND a.UpperLimit =20000000
		ELSE '10000000 - 20000000'
		END) AS 'User Base',
	ROUND(SUM(Revenue),2) AS Revenue1, ROUND(SUM(DescRevenue),2) AS RedRevenue, 
	ROUND(SUM(Revenue-DescRevenue),2) AS LostRevenue
FROM Apps a
JOIN cte_recomm ON a.AppID = cte_recomm.AppID

GROUP BY
(CASE WHEN a. LowerLimit = 0 AND a.UpperLimit =20000
		THEN '0-20000'
		WHEN a. LowerLimit = 20000 AND a.UpperLimit =50000
		THEN '20000-50000'
		WHEN a. LowerLimit = 50000 AND a.UpperLimit =100000
		THEN '50000-100000'
		WHEN a. LowerLimit = 100000 AND a.UpperLimit =200000
		THEN '100000-200000'
		WHEN a. LowerLimit = 200000 AND a.UpperLimit =500000
		THEN '200000-500000'
		WHEN a. LowerLimit = 500000 AND a.UpperLimit =1000000
		THEN '500000-1000000'
		WHEN a. LowerLimit = 1000000 AND a.UpperLimit =2000000
		THEN '1000000 - 2000000'
		WHEN a. LowerLimit = 2000000 AND a.UpperLimit =5000000
		THEN '2000000 - 5000000'
		WHEN a. LowerLimit = 5000000 AND a.UpperLimit =10000000
		THEN '5000000 - 10000000'
		--WHEN a. LowerLimit = 10000000 AND a.UpperLimit =20000000
		ELSE '10000000 - 20000000'
		END)
	RETURN;
END
GO
--test the procedure
EXEC usoGetInstalledBaseRev 'Mac', 'Action', '2017-01-01', '2017-12-31'
GO
--====================================================================

/*
QUESTION 3
3). Write a query to return App id and App name for Apps that meet the following 
requirements:

The platform is Mac 
The App belongs to BOTH Action and Adventure genres
The App was recommended in the Action genre (i.e., IsRecommended=1) but not in 
the Adventure genre (i.e., IsRecommended =0).
Limit the output to top 50 rows only.
 
*/
SELECT DISTINCT a.AppID, a.Name
FROM Apps a
JOIN AppPlatforms ap ON a.AppID = ap.AppID
JOIN Platforms p ON ap.PlatformID = p.PlatformID
JOIN AppRecommendations ar ON a.AppID = ap.AppID
JOIN AppGenres ag ON a.AppID = ag.AppID
JOIN Genres g ON ag.GenreID = g.GenreID
WHERE p.Platform = 'Mac' AND g.GenreName ='Action'
AND ar.IsRecommended=1
INTERSECT
SELECT DISTINCT a.AppID, a.Name
FROM Apps a
JOIN AppPlatforms ap ON a.AppID = ap.AppID
JOIN Platforms p ON ap.PlatformID = p.PlatformID
JOIN AppRecommendations ar ON a.AppID = ap.AppID
JOIN AppGenres ag ON a.AppID = ag.AppID
JOIN Genres g ON ag.GenreID = g.GenreID
WHERE p.Platform = 'Mac' AND g.GenreName ='Adventure'
AND ar.IsRecommended=0
GO
--=============================================================
/*
QUESTION 4
Write a query to return App ID for Apps that meet the following conditions:

Belong to above the average number of Genres per App
Have at least 250 recommendations by users
*/
WITH cte_numgenres
AS
(SELECT a.AppID, COUNT(ag.GenreID) NumGenres
FROM Apps a JOIN AppGenres ag ON a.AppID = ag.AppID
JOIN Genres g ON ag.GenreID = g.GenreID
GROUP BY a.AppID),
cte_numrecomms
AS
(SELECT a.AppID, COUNT(ar.AppID) NumRecomms
FROM Apps a JOIN AppRecommendations ar ON a.AppID = ar.AppID
WHERE ar.IsRecommended  =1
GROUP BY a.AppID
HAVING COUNT(ar.AppID) >250)

SELECT cte_numgenres.AppID
FROM cte_numgenres JOIN cte_numrecomms
ON cte_numgenres.AppID = cte_numrecomms.AppID
WHERE cte_numgenres.NumGenres > (SELECT AVG(NumGenres) FROM cte_numgenres)
AND cte_numrecomms.NumRecomms > (SELECT AVG(NumRecomms) FROM cte_numrecomms)
GO
--====================================================================
/*
QUESTION 5
Write a SQL query to return User ID, the number of total reviews 
the user has completed, the number of positive reviews 
(i.e., IsRecommneded = 1 or YES) the user has completed, and 
the percent share of the number of positive reviews in the
total number of reviews completed by the user.
Consider only the users who have completed at least 100 reviews. 
Sort the results in a descending order of the percentage share of 
positive reviews completed by the user.

Caution: IsRecommended Column is defined as BIT datatype
which cannot be used in numerical computations. 
You may have to CAST it as Integer.

*/
WITH cte_tot_numrates
AS
(
SELECT DISTINCT ar.userID, COUNT(ar.AppID) Numrates
FROM AppRecommendations ar 
--WHERE ar.UserID = 2363417
GROUP BY ar.userID
HAVING COUNT(ar.AppID) >= 100),

cte_pos_numrates
AS
(
SELECT DISTINCT ar.userID, COUNT(ar.AppID) PosNumrates
FROM AppRecommendations ar 
--WHERE ar.UserID = 2363417
GROUP BY ar.userID, ar.IsRecommended
HAVING COUNT(ar.AppID) >= 100 AND SUM(CAST(ar.IsRecommended AS INT)) >0)

SELECT cte1.userID, cte1.Numrates, cte2.PosNumrates AS 'Positive Ratings',
CAST((100.00*PosNumrates/Numrates) AS NUMERIC(8,2)) 'Pct Pos'
FROM cte_tot_numrates cte1 
JOIN cte_pos_numrates cte2 ON cte1.UserID = cte2.userID
ORDER BY 'Pct Pos' DESC
GO
--=========================================================

/*
QUESTION 6
Write a SQL query to return App ID and App name for which the following conditions are met:

The App belongs to either Action or Adventure genres.
The average hours users have played the App is greater than the average hours across 
the Apps in either of these two genres.
At least 50 users have found the App recommendations funny.
The app does not belong to either Sports or Strategy genres.
For the Apps that belong to the Sports and Strategy genres, at least 25 users
have found the App recommendations funny and at least 15 have found 
the App recommendations helpful.

*/
WITH
cte_cats1
AS
(SELECT DISTINCT a.AppID, a.Name, AVG(ar.HoursPLayed) 'avgHours1'
FROM Apps a
JOIN AppRecommendations ar ON a.AppID = ar.AppID
JOIN AppGenres ag ON a.AppID = ag.AppID
JOIN Genres g ON ag.GenreID = g.GenreID
WHERE g.GenreName IN ('Action', 'Adventure')
GROUP BY a.AppID, a.Name
HAVING SUM(ar.Funny) >= 50 
),
cte_cats2
AS
(SELECT DISTINCT a.AppID, a.Name, AVG(ar.HoursPLayed) 'avgHours2'
FROM Apps a
JOIN AppRecommendations ar ON a.AppID = ar.AppID
JOIN AppGenres ag ON a.AppID = ag.AppID
JOIN Genres g ON ag.GenreID = g.GenreID
WHERE g.GenreName IN ('Sports', 'Strategy')
GROUP BY a.AppID, a.Name
HAVING SUM(ar.Funny) >= 25 AND SUM(ar.Helpful) >=15
)

SELECT c1.AppID, c1.Name
FROM cte_cats1 C1
WHERE c1.[avgHours1] > (SELECT AVG(avgHours1) FROM cte_cats1)
EXCEPT
SELECT c2.AppID, c2.Name
FROM cte_cats2 c2
GO
--=================================================

/*
QUESTION 7
Write a SQL query to return Genre name, number of unrecommended Apps, and 
the percentage share of those unrecommended apps in the total number of 
Apps across all genres. The percentage share should be displayed rounded to 
2 decimal places.

Caution: IsRecommended Column is defined as BIT datatype which cannot be used in 
numerical computations. You may have to CAST it as Integer.

*/
WITH cte1
AS
(SELECT COUNT(*) AS NumApps
FROM Apps),

cte2
As
(SELECT a.AppID, g.GenreName, COUNT(ag.AppID) As NumApps1
FROM AppRecommendations ar
JOIN Apps a ON ar.AppID = a.AppID
JOIN AppGenres ag ON a.AppID = ag.AppID
JOIN Genres g ON ag.GenreID = g.GenreID
--WHERE IsRecommended=0
GROUP BY a.AppID, g.GenreName
HAVING SUM(CAST(ar.IsRecommended AS INT)) = 0)

SELECT cte2.GenreName, SUM(cte2.NumApps1) AS NumApps,
CAST((100.00*(SUM(cte2.NumApps1))/cte1.NumApps)AS numeric(8,3)) AS pctShare
FROM
cte1 CROSS JOIN cte2
GROUP BY cte2.GenreName,cte1.NumApps
GO
--=======================================================