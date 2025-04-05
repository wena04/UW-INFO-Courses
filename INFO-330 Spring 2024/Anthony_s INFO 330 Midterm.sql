USE Apps_db;

/* 1).  Write a SQL query to return user ID, the date of the latest App review, name of the App a user reviewed, and the Metacritic score for the App where the following requirements are met:

The App reviewed is of Action genre.
The user has completed more than 1 review.
The user recommended the App (i.e., IsRecommneded = 1).
Other users found the review to be neither helpful nor funny. */

SELECT UserID, Apps.Name AS AppName, MAX(ReviewDate) AS LatestReviewDate, MetacriticScore AS MetacriticScore
FROM dbo.AppRecommendations
    JOIN dbo.Apps ON AppRecommendations.AppID = Apps.AppID
    JOIN dbo.AppGenres ON Apps.AppID = AppGenres.AppID
WHERE IsRecommended = 1 AND Helpful = 0 AND Funny = 0 AND GenreID = 2   -- Action Genre is GenreID = 2
GROUP BY UserID, Apps.Name, MetacriticScore
HAVING COUNT(UserID) > 1 

/*2). Create a SELECT query stored procedure (give it a descriptive name of your choice and prefix the name of the procedure with you initials). This procedure, given correct parameter values should return query results to the user.

Your procedure should have the following parameters:

App platform
Genre name
Start date and end date for the user to specify date ranges for the release date of the App.
Your final query output should display:

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
Note: Use the midpoint of the Lower limit and Upper limit to compute revenue values (e.g., Revenue = AVG(LowerLimit + UpperLimit)*PriceOriginal).

NOTE: Round revenue, discounted revenue and revenue lost to 2 decimal places.

Additionally, you query should mee the following conditions:

Exclude Apps for which the original price is equal to 0 and the Upper Limit of user base is equal to 0. */

-- creating the procedure
CREATE PROCEDURE aw_get
    @Platform VARCHAR(100),
    @GenreName VARCHAR(100),
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    -- Creating a CTE 
    WITH cte_AppDetails AS (
        SELECT
            A.AppID, A.Name, A.PriceOriginal, A.PriceFinal, A.LowerLimit, A.UpperLimit, AVG(A.LowerLimit + A.UpperLimit) AS Midpoint
        FROM dbo.Apps A
            JOIN dbo.AppGenres AG ON A.AppID = AG.AppID
            JOIN dbo.Genres G ON AG.GenreID = G.GenreID
            JOIN dbo.AppPlatforms AP ON A.AppID = AP.AppID
            JOIN dbo.Platforms P ON AP.PlatformID = P.PlatformID
        WHERE
            P.Platform = @Platform
            AND G.GenreName = @GenreName
            AND A.ReleaseDate BETWEEN @StartDate AND @EndDate
        GROUP BY A.AppID, A.Name, A.PriceOriginal, A.PriceFinal, A.LowerLimit, A.UpperLimit
    )
    SELECT
        CASE
            WHEN Midpoint BETWEEN 0 AND 20000 THEN '0-20000'
            WHEN Midpoint BETWEEN 20001 AND 50000 THEN '20000-50000'
            WHEN Midpoint BETWEEN 50001 AND 100000 THEN '50000-100000'
            WHEN Midpoint BETWEEN 100001 AND 200000 THEN '100000-200000'
            WHEN Midpoint BETWEEN 200001 AND 500000 THEN '200000-500000'
            WHEN Midpoint BETWEEN 500001 AND 1000000 THEN '500000-1000000'
            WHEN Midpoint BETWEEN 1000001 AND 2000000 THEN '1000000-2000000'
            WHEN Midpoint BETWEEN 2000001 AND 5000000 THEN '2000000-5000000'
            WHEN Midpoint BETWEEN 5000001 AND 10000000 THEN '5000000-10000000'
            WHEN Midpoint > 10000000 THEN '10000000-20000000'
        END AS UserBase,
        ROUND(Midpoint * PriceOriginal, 2) AS Revenue,
        ROUND(Midpoint * PriceFinal, 2) AS DiscountedRevenue,
        ROUND((Midpoint * PriceOriginal)-(Midpoint * PriceFinal), 2) AS RevenueLost
    FROM cte_AppDetails -- Data comes from the CTE we wrote before
    WHERE PriceOriginal != 0 AND UpperLimit != 0 -- exclude Apps for which the original price is equal to 0 and the Upper Limit of user base is equal to 0
    ORDER BY RevenueLost DESC, UserBase; -- order to see the revenue lost first
END;
GO

DROP PROCEDURE aw_get;

EXEC aw_get
    @Platform = 'Mac',
    @GenreName = 'Action',
    @StartDate = '2017-01-01',
    @EndDate = '2017-12-31'

/* Question 3. Write a query to return App id and App name for Apps that meet the following requirements:
The platform is Mac 
The App belongs to BOTH Action and Adventure genres
The App was recommended in the Action genre (i.e., IsRecommended=1) but not in the Adventure genre (i.e., IsRecommended =0).
Limit the output to top 50 rows only. */


SELECT TOP 50 a.AppID, a.Name
FROM Apps a, AppGenres ag, Genres g, AppPlatforms ap, Platforms p, AppRecommendations ar
WHERE a.AppID = ag.AppID AND ag.GenreID = g.GenreID AND a.AppID = ap.AppID AND ap.PlatformID = p.PlatformID AND p.Platform = 'Mac'
    AND ((g.GenreName = 'Action' AND ar.IsRecommended = 1) OR (g.GenreName = 'Adventure' AND ar.IsRecommended = 0))
GROUP BY a.AppID, a.Name
HAVING COUNT(DISTINCT g.GenreName) = 2;

/* Question 4.  Write a query to return App ID for Apps that meet the following conditions:
Belong to above the average number of Genres per App
Have at least 250 recommendations by users */

-- get the number of genres every app has
WITH Genre_num AS (
    SELECT A.AppID, COUNT(DISTINCT AG.GenreID) AS GenreCount
    FROM dbo.Apps A
    JOIN dbo.AppGenres AG ON A.AppID = AG.AppID 
    GROUP BY A.AppID
),

RecommendationCounts AS (
    SELECT AppID, COUNT(*) AS RecommendationCount
    FROM dbo.AppRecommendations
    GROUP BY AppID
    HAVING COUNT(*) >= 250  -- Filter apps to have at least 250 recommendations
)

-- Final query to find apps 
SELECT DISTINCT A.AppID
FROM dbo.Apps A
JOIN dbo.AppGenres AG ON A.AppID = AG.AppID
JOIN RecommendationCounts RC ON A.AppID = RC.AppID
JOIN Genre_num GA ON A.AppID = GA.AppID
WHERE GA.GenreCount > (SELECT AVG(GenreCount) FROM Genre_num) AND RC.RecommendationCount >= 250;

/*5). Write a SQL query to return User ID, the number of total reviews the user has completed, the number of positive reviews (i.e., IsRecommneded = 1 or YES) the user has completed, and the percent share of the number of positive reviews in the total number of reviews completed by the user.

Consider only the users who have completed at least 100 reviews. Sort the results in a descending order of the percentage share of positive reviews completed by the user.

Caution: IsRecommended Column is defined as BIT datatype which cannot be used in numerical computations. You may have to CAST it as Integer.
*/

SELECT UserID, COUNT(*) AS TotalReviews, SUM(CAST(IsRecommended AS INT)) AS PositiveReviews,
    CAST((100.0 * SUM(CAST(IsRecommended AS INT)) / COUNT(*)) AS DECIMAL(5,2)) AS PercentagePositiveReviews
FROM dbo.AppRecommendations
GROUP BY UserID
HAVING COUNT(*) >= 100
ORDER BY PercentagePositiveReviews DESC; 

/*6) Write a SQL query to return App ID and App name for which the following conditions are met:

 The App belongs to either Action or Adventure genres.
The average hours users have played the App is greater than the average hours across the Apps in either of these two genres.
At least 50 users have found the App recommendations funny.
The app does not belong to either Sports or Strategy genres.
For the Apps that belong to the Sports and Strategy genres, at least 25 users have found the App recommendations funny and at least 15 have found the App recommendations helpful. */

WITH GenreFiltered AS (
    SELECT a.AppID, a.Name
    FROM Apps a
        JOIN AppGenres ag ON a.AppID = ag.AppID
        JOIN Genres g ON ag.GenreID = g.GenreID
    WHERE g.GenreName IN ('Action', 'Adventure')
      AND a.AppID NOT IN (
        SELECT AppID FROM AppGenres ag
        JOIN Genres g ON ag.GenreID = g.GenreID
        WHERE g.GenreName IN ('Sports', 'Strategy')
    )
),
AverageHours AS (
    SELECT a.AppID, AVG(ar.HoursPlayed) AS AvgHoursPlayed
    FROM AppRecommendations ar
        JOIN GenreFiltered a ON ar.AppID = a.AppID
    GROUP BY a.AppID
    HAVING AVG(ar.HoursPlayed) > (
        SELECT AVG(HoursPlayed)
        FROM AppRecommendations ar
            JOIN AppGenres ag ON ar.AppID = ag.AppID
            JOIN Genres g ON ag.GenreID = g.GenreID
        WHERE g.GenreName IN ('Action', 'Adventure')
    )
),
FunnyRecommendations AS (
    SELECT a.AppID
    FROM AppRecommendations ar
        JOIN GenreFiltered a ON ar.AppID = a.AppID
    GROUP BY a.AppID
    HAVING SUM(CASE WHEN ar.Funny > 0 THEN 1 ELSE 0 END) >= 50
),
SportsStrategy AS (
    SELECT a.AppID
    FROM Apps a
        JOIN AppGenres ag ON a.AppID = ag.AppID
        JOIN Genres g ON ag.GenreID = g.GenreID
        JOIN AppRecommendations ar ON a.AppID = ar.AppID
    WHERE g.GenreName IN ('Sports', 'Strategy')
    GROUP BY a.AppID
    HAVING SUM(CASE WHEN ar.Funny > 0 THEN 1 ELSE 0 END) >= 25 AND SUM(CASE WHEN ar.Helpful > 0 THEN 1 ELSE 0 END) >= 15
)

SELECT gf.AppID, gf.Name
FROM GenreFiltered gf
    JOIN AverageHours ah ON gf.AppID = ah.AppID
    JOIN FunnyRecommendations fr ON gf.AppID = fr.AppID
UNION
SELECT a.AppID, a.Name
FROM Apps a
    JOIN SportsStrategy ss ON a.AppID = ss.AppID;

/* 7). Write a SQL query to return Genre name, number of unrecommended Apps, and the percentage share of those unrecommended apps in the total number of Apps across all genres. The percentage share should be displayed rounded to 2 decimal places.

Caution: IsRecommended Column is defined as BIT datatype which cannot be used in numerical computations. You may have to CAST it as Integer.*/

SELECT g.GenreName, COUNT(CASE WHEN CAST(ar.IsRecommended AS INT) = 0 THEN 1 ELSE NULL END) AS UnrecommendedApps, ROUND(100.0 * COUNT(CASE WHEN CAST(ar.IsRecommended AS INT) = 0 THEN 1 ELSE NULL END) / (SELECT COUNT(*) FROM AppRecommendations WHERE CAST(IsRecommended AS INT) = 0), 2) AS PercentageShare
FROM Genres g
    JOIN AppGenres ag ON g.GenreID = ag.GenreID
    JOIN Apps a ON ag.AppID = a.AppID
    JOIN AppRecommendations ar ON a.AppID = ar.AppID
GROUP BY g.GenreName

