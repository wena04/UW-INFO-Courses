/* ASSIGNMENT 3 SOLUTION */
--select the database to use

use PizzaSales_db
GO

SELECT TOP 5 * FROM OrderDetails
SELECT TOP 5 * FROM Orders
GO
--===============================================
/*Question 1
1.	Write a query to return order hour, number of orders, revenue 
generated, and the percentage share of hourly revenue in total 
revenue across all hours for the month of July 2015. Sort the results 
in descending order of percent of total sales. 
(Hint: Use DATEPART() function to extract hour from order time). 
Also, you need a subquery here because there are 2 levels: the hour 
level, and the aggregate level).
*/
WITH cte_tot_sales 
AS
	(SELECT SUM(Quantity*Price) AS TotSales
	FROM OrderDetails od 
		JOIN Orders o ON od.OrderID = o.OrderID
		WHERE o.OrderDate  BETWEEN '2015-07-01' AND '2015-07-01'
	)

SELECT DATEPART(HOUR, o.OrderTime) AS 'Orde Hour',SUM(od.Quantity*od.Price) AS hrRevenue, 
CAST((SUM(od.Quantity*od.Price)/cts.TotSales)*100 AS NUMERIC(5,2)) AS PctOfTotSales
FROM cte_tot_sales cts, Orders o 
JOIN OrderDetails od ON o.OrderID= od.OrderID
WHERE o.OrderDate  BETWEEN '2015-07-01' AND '2015-07-01'
GROUP BY DATEPART(HOUR, o.OrderTime), cts.TotSales
ORDER BY PctOfTotSales DESC
GO
--===============================================
/*Question 2
2.	Write a query to return the top 10 ingredients used in the chicken
pizza category but not in the classic pizza category, and the top 10 
ingredients used in the veggie pizza category but not in the supreme 
pizza category. Note: Your final ingredient list may not necessarily 
have 10 ingredients because of the various conditions that have to be
met. (Hint: you may find it helpful to use temp tables, subqueries, 
and Union set operator).

*/
	--first temp table
	SELECT DISTINCT TOP 10 IngredientName, COUNT(pig.IngredientID) AS Frequency1
	INTO #temp_chicken
	FROM PizzaIngredients pig
		JOIN Ingredients ig ON pig.IngredientID = ig.IngredientID
		JOIN Pizzas p ON p.PizzaID = pig.PizzaID
		JOIN Categories c ON p.CategoryID = c.CategoryID
	WHERE c.CategoryName = 'Chicken'
	GROUP BY IngredientName
	ORDER BY Frequency1 DESC
	
--Second temp table
SELECT DISTINCT TOP 10 IngredientName, COUNT(pig.IngredientID) AS Frequency2
INTO #temp_veggie
	FROM PizzaIngredients pig
		JOIN Ingredients ig ON pig.IngredientID = ig.IngredientID
		JOIN Pizzas p ON p.PizzaID = pig.PizzaID
		JOIN Categories c ON p.CategoryID = c.CategoryID
	WHERE c.CategoryName = 'Veggie'
	GROUP BY IngredientName
	ORDER BY Frequency2 DESC 

--Main query (joins the 2 temp tables)
	SELECT #temp_chicken.IngredientName 
	FROM #temp_chicken 
	WHERE IngredientName NOT IN (SELECT IngredientName FROM Ingredients i1 
									JOIN PizzaIngredients pin1 ON i1.IngredientID = pin1.IngredientID
									JOIN Pizzas p1 ON pin1.PizzaID = p1.PizzaID
									JOIN Categories c1 ON p1.CategoryID = c1.CategoryID
									WHERE c1.CategoryName = 'Classic')

UNION

	SELECT #temp_veggie.IngredientName 
	FROM #temp_veggie
	WHERE IngredientName NOT IN (SELECT IngredientName FROM Ingredients i1 
									JOIN PizzaIngredients pin1 ON i1.IngredientID = pin1.IngredientID
									JOIN Pizzas p1 ON pin1.PizzaID = p1.PizzaID
									JOIN Categories c1 ON p1.CategoryID = c1.CategoryID
									WHERE c1.CategoryName = 'supreme')

--==============================================

/* Question 3
3.	Write a query to return the list of ingredients (i.e., ingredient 
name) that are used in either classic or supreme pizza categories but
not in chicken or veggie pizza categories.
*/

SELECT DISTINCT IngredientName
FROM Ingredients i1 
	JOIN PizzaIngredients pin1 ON i1.IngredientID = pin1.IngredientID
	JOIN Pizzas p1 ON pin1.PizzaID = p1.PizzaID
	JOIN Categories c1 ON p1.CategoryID = c1.CategoryID
	WHERE c1.CategoryName IN ('Classic','supreme')
	AND IngredientName NOT IN (SELECT DISTINCT IngredientName
					FROM Ingredients i1 
						JOIN PizzaIngredients pin1 ON i1.IngredientID = pin1.IngredientID
						JOIN Pizzas p1 ON pin1.PizzaID = p1.PizzaID
						JOIN Categories c1 ON p1.CategoryID = c1.CategoryID
						WHERE c1.CategoryName IN ('Chicken','Veggie'))

--===================================
/* Question 4
4.	Write a query to return pizza name and the number of ingredients 
in the pizza for pizzas with the number of ingredients greater the 
average number of ingredients across all pizzas. (Hint: there are two
levels of aggregations in this query. So, it is a good idea to use CTEs 
and/or subqueries to manage those levels of aggregations).
*/
WITH cte_numIngred 
AS (SELECT p.PizzaName, COUNT(DISTINCT pin.IngredientID) AS NumIngredients
FROM Pizzas p JOIN PizzaIngredients pin ON p.PizzaID = pin.PizzaID
GROUP BY p.PizzaName)

SELECT p.PizzaName, COUNT(DISTINCT pin.IngredientID) AS NumIngreds
FROM Pizzas p JOIN PizzaIngredients pin ON p.PizzaID = pin.PizzaID
GROUP BY p.PizzaName
HAVING COUNT(DISTINCT pin.IngredientID) > (SELECT AVG(NumIngredients) FROM cte_numIngred)

