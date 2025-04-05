-- Setting up to do the query
USE PizzaSales_db

/* Question 1: Write a query to return order hour, number of orders, revenue generated, and the
percentage share of hourly revenue in total revenue across all hours for the month of
July 2015. Sort the results in descending order of percent of total sales.
(Hint: Use DATEPART() function to extract hour from order time). Also, you need a
subquery here because there are 2 levels: the hour level, and the aggregate level).*/

-- Main query for hourly
SELECT  DATEPART(hour,OrderTime) AS OrderHour, COUNT(DISTINCT OrderDetails.OrderID) AS NumberOfOrders, SUM(Price*Quantity) AS TotalRevenue, 
SUM(Price*Quantity)/(SELECT SUM(Price*Quantity) -- Do subquery to get Total Revenue for ALL HOURS of the month 
    FROM Orders 
    JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
    WHERE OrderDate BETWEEN '2015-07-01' AND '2015-07-31')*100 AS PctOfTotSales
FROM Orders
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
WHERE OrderDate BETWEEN '2015-07-01' AND '2015-07-31'
GROUP BY DATEPART(hour,OrderTime)
ORDER BY PctOfTotSales DESC;

/* Question 2: Write a query to return the top 10 ingredients used in the chicken pizza category but not in the
classic pizza category, and the top 10 ingredients used in the veggie pizza category but not in the
supreme pizza category. Note: Your final ingredient list may not necessarily have 10 ingredients
because of the various conditions that have to be met. (Hint: you may find it helpful to use temp
tables, subqueries, and Union set operator). */

-- First Temp Query for Chicken but not Classic Pizza
SELECT DISTINCT TOP 10 i.IngredientName, COUNT(i.IngredientID) AS Frequency1
INTO #NOTCLASSIC1
    FROM Ingredients i 
    JOIN PizzaIngredients pin on i.IngredientID = pin.IngredientID
    JOIN Pizzas p On p.PizzaID =pin.PizzaID
    JOIN Categories c ON p.CategoryID = c.CategoryID
    WHERE c.CategoryName = 'Chicken' AND i.IngredientName NOT IN 
    (SELECT DISTINCT i.IngredientName
    FROM Ingredients i 
    JOIN PizzaIngredients pin on i.IngredientID = pin.IngredientID
    JOIN Pizzas p On p.PizzaID =pin.PizzaID
    JOIN Categories c ON p.CategoryID = c.CategoryID
    WHERE c.CategoryName = 'Classic') -- end of subquery
GROUP BY i.IngredientName 
ORDER BY Frequency1 DESC  

-- Second Temp table to select for Veggie and not in Supreme Pizza
SELECT DISTINCT TOP 10 i.IngredientName, COUNT(i.IngredientID) AS Frequency1
INTO #NOTSUPREME1
    FROM Ingredients i 
    JOIN PizzaIngredients pin on i.IngredientID = pin.IngredientID
    JOIN Pizzas p On p.PizzaID =pin.PizzaID
    JOIN Categories c ON p.CategoryID = c.CategoryID
    WHERE c.CategoryName = 'Veggie' AND i.IngredientName NOT IN 
    (SELECT DISTINCT i.IngredientName
    FROM Ingredients i 
    JOIN PizzaIngredients pin on i.IngredientID = pin.IngredientID
    JOIN Pizzas p On p.PizzaID =pin.PizzaID
    JOIN Categories c ON p.CategoryID = c.CategoryID
    WHERE c.CategoryName = 'Supreme') -- end of subquery
GROUP BY i.IngredientName 
ORDER BY Frequency1 DESC 

-- SELECT * FROM #NOTSUPREME1
-- SELECT * FROM #NOTCLASSIC1
DROP TABLE #NOTSUPREME1;
DROP TABLE #NOTCLASSIC1;
-- Main Query Using the Temp Tables 
SELECT IngredientName
FROM #NOTSUPREME1 
UNION
SELECT IngredientName
FROM #NOTCLASSIC1

/* one method with only 3 rows as answers somehow?
WITH NotSupreme AS -- first CTE to choose ingredients in veggie
(
    SELECT TOP 10 IngredientName, COUNT(PizzaIngredients.IngredientID) AS Frequency1
    FROM PizzaIngredients
        JOIN Ingredients ON PizzaIngredients.IngredientID = Ingredients.IngredientID
        JOIN Pizzas ON PizzaIngredients.PizzaID = Pizzas.PizzaID
        JOIN Categories ON Pizzas.CategoryID = Categories.CategoryID
    WHERE CategoryName = 'Veggie' 
    GROUP BY IngredientName
    HAVING IngredientName NOT IN 
        (SELECT IngredientName 
            FROM PizzaIngredients
                JOIN Ingredients ON PizzaIngredients.IngredientID = Ingredients.IngredientID
                JOIN Pizzas ON PizzaIngredients.PizzaID = Pizzas.PizzaID
                JOIN Categories ON Pizzas.CategoryID = Categories.CategoryID
            WHERE CategoryName = 'Supreme'
            GROUP BY IngredientName
        )
    ORDER BY Frequency1 DESC
),
NotClassic AS 
(
    SELECT TOP 10 IngredientName, COUNT(PizzaIngredients.IngredientID) AS Frequency2
    FROM PizzaIngredients
        JOIN Ingredients ON PizzaIngredients.IngredientID = Ingredients.IngredientID
        JOIN Pizzas ON PizzaIngredients.PizzaID = Pizzas.PizzaID
        JOIN Categories ON Pizzas.CategoryID = Categories.CategoryID
    WHERE CategoryName = 'Chicken'
    GROUP BY IngredientName
    HAVING IngredientName NOT IN 
        (SELECT IngredientName 
            FROM PizzaIngredients
                JOIN Ingredients ON PizzaIngredients.IngredientID = Ingredients.IngredientID
                JOIN Pizzas ON PizzaIngredients.PizzaID = Pizzas.PizzaID
                JOIN Categories ON Pizzas.CategoryID = Categories.CategoryID
            WHERE CategoryName = 'Classic'
            GROUP BY IngredientName
        )
    ORDER BY Frequency2 DESC
)

SELECT NotSupreme.IngredientName
FROM NotSupreme
    JOIN NotClassic ON NotSupreme.IngredientName = NotClassic.IngredientName;
*/

/* Another way to do it using CTE?
WITH CTE_Chicken AS
(
    SELECT TOP 10 i.IngredientName, COUNT(*) AS Frequency1
    FROM PizzaIngredients
        JOIN Ingredients i ON PizzaIngredients.IngredientID = i.IngredientID
        JOIN Pizzas ON PizzaIngredients.PizzaID = Pizzas.PizzaID
        JOIN Categories c ON Pizzas.CategoryID = c.CategoryID
    WHERE c.CategoryName = 'Chicken'
    GROUP BY IngredientName
    ORDER BY Frequency1 DESC
),
CTE_Classic AS
(
    SELECT TOP 10 i.IngredientName, COUNT(*) AS Frequency2
    FROM PizzaIngredients
        JOIN Ingredients i ON PizzaIngredients.IngredientID = i.IngredientID
        JOIN Pizzas ON PizzaIngredients.PizzaID = Pizzas.PizzaID
        JOIN Categories c ON Pizzas.CategoryID = c.CategoryID
    WHERE c.CategoryName = 'Classic'
    GROUP BY IngredientName
    ORDER BY Frequency2 DESC
),
CTE_Veggie AS
(
    SELECT TOP 10 i.IngredientName, COUNT(*) AS Frequency3
    FROM PizzaIngredients
        JOIN Ingredients i ON PizzaIngredients.IngredientID = i.IngredientID
        JOIN Pizzas ON PizzaIngredients.PizzaID = Pizzas.PizzaID
        JOIN Categories c ON Pizzas.CategoryID = c.CategoryID
    WHERE c.CategoryName = 'Veggie'
    GROUP BY IngredientName
    ORDER BY Frequency3 DESC
),
CTE_Supreme AS
(
    SELECT TOP 10 i.IngredientName, COUNT(*) AS Frequency4
    FROM PizzaIngredients
        JOIN Ingredients i ON PizzaIngredients.IngredientID = i.IngredientID
        JOIN Pizzas ON PizzaIngredients.PizzaID = Pizzas.PizzaID
        JOIN Categories c ON Pizzas.CategoryID = c.CategoryID
    WHERE c.CategoryName = 'Supreme'
    GROUP BY IngredientName
    ORDER BY Frequency4 DESC
)

SELECT CTE_Chicken.IngredientName
FROM CTE_Chicken
LEFT JOIN CTE_Classic ON CTE_Chicken.IngredientName = CTE_Classic.IngredientName
WHERE CTE_Classic.IngredientName IS NULL

UNION ALL

SELECT CTE_Veggie.IngredientName
FROM CTE_Veggie
LEFT JOIN CTE_Supreme ON CTE_Veggie.IngredientName = CTE_Supreme.IngredientName
WHERE CTE_Supreme.IngredientName IS NULL;
*/

/* Question 3: Write a query to return the list of ingredients (i.e., ingredient name) that are used in either
classic or supreme pizza categories but not in chicken or veggie pizza categories.*/

SELECT DISTINCT IngredientName 
FROM Ingredients i
JOIN PizzaIngredients pi ON i.IngredientID = pi.IngredientID
JOIN Pizzas p ON pi.PizzaID = p.PizzaID
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName IN ('Classic', 'Supreme')
AND pi.IngredientID NOT IN ( -- subquery to pizzas we don't want
    SELECT pi.IngredientID
    FROM PizzaIngredients pi
    JOIN Pizzas p ON pi.PizzaID = p.PizzaID
    JOIN Categories c ON p.CategoryID = c.CategoryID
    WHERE c.CategoryName IN ('Chicken', 'Veggie'))

/* Question 4: Write a query to return pizza name and the number of ingredients in the pizza for pizzas with the
number of ingredients greater the average number of ingredients across all pizzas. (Hint: there
are two levels of aggregations in this query. So, it is a good idea to use CTEs and/or subqueries to
manage those levels of aggregations). */

SELECT p.PizzaName, COUNT(DISTINCT pi.IngredientID) AS NumIngredients -- Notice the distinct to make sure it's different ingredients
FROM Pizzas p
JOIN PizzaIngredients pi ON p.PizzaID = pi.PizzaID
GROUP BY p.PizzaName
HAVING COUNT(DISTINCT pi.IngredientID) >
    (SELECT AVG(NumIngredients) FROM (SELECT COUNT(DISTINCT IngredientID) AS NumIngredients FROM PizzaIngredients 
    GROUP BY PizzaID)
    AS Avg)
ORDER BY NumIngredients DESC -- Getting the output in a nicer looking order from largest to smallest







