SELECT SUM(poster_qty)
FROM orders

SELECT SUM(standard_qty)
FROM orders

SELECT SUM(total_amt_usd)
FROM orders

SELECT o.id, o.standard_amt_usd + o.gloss_amt_usd AS standard_gloss_amt
FROM orders AS o;

SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS standard_price_per_unit
FROM orders;


-----------------------------------------------
SELECT MIN (occurred_at)
FROM orders;


SELECT occured_at
FROM orders
LIMIT 1

SELECT MAX(occurred_at)
FROM web_events

SELECT occured_at
FROM web_events
ORDER BY occured_at DESC
LIMIT 1

SELECT AVG(standard_amt_usd) AS standard_qty_med,
       AVG(poster_amt_usd) AS poster_qty_med,
       AVG(gloss_amt_usd) AS gloss_qty_med,
       AVG(standard_qty) AS standardMed,
       AVG(poster_qty) AS posterMed,
       AVG(gloss_qty) AS glossMed
FROM orders;


------------------GROUP BY PART I-----------------------------
SELECT a.name, o.occurred_at
FROM accounts a
JOIN orders o
ON a.id = o.account_id
ORDER BY occurred_at
LIMIT 1;


SELECT a.name, 
       SUM(o.standard_amt_usd + o.gloss_amt_usd + o.poster_amt_usd)
	   --SUM(o.total_amt_usd)
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
GROUP BY a.name;


SELECT w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id 
ORDER BY w.occurred_at DESC
LIMIT 1;


SELECT channel, COUNT(*)
FROM web_events
GROUP BY channel;


SELECT a.primary_poc
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
ORDER BY w.occurred_at
LIMIT 1;


SELECT a.name, MIN(o.total_amt_usd) AS minOrderUSD
FROM orders AS o
JOIN accounts AS a
ON o.account_id = a.id
GROUP BY a.name
ORDER BY minOrderUSD;


SELECT r.name, COUNT(s.id)
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
GROUP BY r.name;

------------------GROUP BY PART II-----------------------------
SELECT a.name,
       AVG(o.standard_qty) AS standard_avg,
       AVG(o.poster_qty) AS poster_avg,
       AVG(o.gloss_qty) AS gloss_avg
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
GROUP BY a.name


SELECT a.name,
       AVG(o.standard_amt_usd) AS standard_amt_usd,
       AVG(o.poster_amt_usd) AS poster_amt_usd,
       AVG(o.gloss_amt_usd) AS gloss_amt_usd
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
GROUP BY a.name

--en la web usa COUNT(*), pero con w.channel descarto que haya algun NULL
SELECT s.name, w.channel, COUNT(w.channel) AS occurrences
FROM web_events AS w
JOIN accounts AS a
ON a.id = w.account_id
JOIN sales_reps AS s
ON s.id = a.sales_rep_id
GROUP BY s.name, w.channel
ORDER BY occurrences DESC;

--en la web usa COUNT(*), pero con w.channel descarto que haya algun NULL
SELECT r.name, w.channel, COUNT(w.channel) AS occurrence
FROM web_events AS w
JOIN accounts AS a
ON a.id = w.account_id
JOIN sales_reps AS s
ON s.id = a.sales_rep_id
JOIN region AS r
ON r.id = s.region_id
GROUP BY r.name, w.channel
ORDER BY occurrence DESC


------------------ HAVING -----------------------------
--How many of the sales reps have more than 5 accounts that they manage? --> 34
SELECT s.name, COUNT(a.*) AS sales_accounts
FROM accounts AS a
JOIN sales_reps AS s
ON a.sales_rep_id = s.id
GROUP BY s.name
HAVING COUNT(a.*) > 5;

--How many accounts have more than 20 orders? --> 120
SELECT a.name, COUNT(o.*) AS total_order_account
FROM accounts AS a
JOIN orders AS o
ON o.account_id = a.id
GROUP BY a.name
HAVING COUNT(o.*) > 20;

--Which account has the most orders? --> Leucadia National
SELECT a.name, COUNT(o.*) AS total_order_account
FROM accounts AS a
JOIN orders AS o
ON o.account_id = a.id
GROUP BY a.name
ORDER BY total_order_account DESC;

--habia interpretrado la suma total de cada orden por separado, no la suma
--Which accounts spent more than 30,000 usd total across all orders?
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY total_spent;
--SELECT a.name, MIN(o.total_amt_usd)
--FROM accounts AS a
--JOIN orders AS o
--ON o.account_id = a.id
--GROUP BY a.name
--HAVING MIN(o.total_amt_usd) > 30000;

--habia interpretrado la suma total de cada orden por separado, no la suma
--Which accounts spent less than 1,000 usd total across all orders?
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY total_spent;

--SELECT a.name, MAX(o.total_amt_usd)
--FROM accounts AS a
--JOIN orders AS o
--ON o.account_id = a.id
--GROUP BY a.name
--HAVING MAX(o.total_amt_usd) < 1000;

--Which account has spent the most with us? --> EOG Resources
SELECT a.name, SUM(o.total_amt_usd) AS total_spent
FROM accounts AS a
JOIN orders AS o
ON o.account_id = a.id
GROUP BY a.name
ORDER BY total_spent DESC;

--Which account has spent the least with us? --> Nike
SELECT a.name, SUM(o.total_amt_usd) AS total_spent
FROM accounts AS a
JOIN orders AS o
ON o.account_id = a.id
GROUP BY a.name
ORDER BY total_spent;

--Which accounts used facebook as a channel to contact customers more than 6 times? --> 46 resultados
SELECT a.name, COUNT(w.channel)
FROM accounts AS a
JOIN web_events AS w
ON w.account_id = a.id
WHERE w.channel = 'facebook'
GROUP BY a.name
HAVING COUNT(w.channel) > 6

--esto lo mio, mismo resultado
--SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
--FROM accounts a
--JOIN web_events w
--ON a.id = w.account_id
--GROUP BY a.id, a.name, w.channel
--HAVING COUNT(*) > 6 AND w.channel = 'facebook'
--ORDER BY use_of_channel;

--Which account used facebook most as a channel? --> Gilead Sciences
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 1;

--esto lo mio, mismo resultado
SELECT a.name, COUNT(w.channel) AS chanel_count
FROM accounts AS a
JOIN web_events AS w
ON w.account_id = a.id
WHERE w.channel = 'facebook'
GROUP BY a.name
ORDER BY chanel_count DESC

--Which channel was most frequently used by most accounts?
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 10;



------------------ DATE FUNCTIONS -----------------------------

--Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals?
--2016
SELECT SUM(o.total_amt_usd) AS total_sales,
       DATE_PART('year', o.occurred_at) AS year
FROM orders AS o
GROUP BY year
ORDER BY total_sales DESC;

--Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?
--diciembre
SELECT SUM(o.total_amt_usd) AS total_sales,
       DATE_PART('month', o.occurred_at) AS month
FROM orders AS o
GROUP BY month
ORDER BY total_sales DESC;


--Which year did Parch & Posey have the greatest sales in terms of total number of orders? Are all years evenly represented by the dataset?
--2016
SELECT COUNT(o.*) AS total_orders,
       DATE_PART('year', o.occurred_at) AS year
FROM orders AS o
GROUP BY year
ORDER BY total_orders DESC;

--Which month did Parch & Posey have the greatest sales in terms of total number of orders? Are all months evenly represented by the dataset?
--diciembre
SELECT COUNT(o.*) AS total_orders,
       DATE_PART('month', o.occurred_at) AS month
FROM orders AS o
GROUP BY month
ORDER BY total_orders DESC;

--In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
--05/2016
SELECT DATE_PART('month', o.occurred_at) AS month,
       DATE_PART('year', o.occurred_at) AS year,
       SUM(o.gloss_amt_usd) AS total_gloss_usd
FROM orders AS o
JOIN accounts AS a
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY year, month
ORDER BY total_gloss_usd DESC
LIMIT 1

--se puede hacer sin necesidad de filtrar el ano, con truncar hasta el mes la fecha tendriamos toda la info
SELECT DATE_TRUNC('month', o.occurred_at) ord_date, SUM(o.gloss_amt_usd) tot_spent
FROM orders o 
JOIN accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;




------------------ CASE -----------------------------
--Write a query to display for each order, the account 
--ID, total amount of the order, and the level of the 
--order - ‘Large’ or ’Small’ - depending on if the order 
--is $3000 or more, or smaller than $3000.

SELECT o.id, o.total,
       CASE WHEN o.total < 3000 THEN 'Small'
            WHEN o.total >= 3000 THEN 'Large' END AS type
FROM orders AS o
ORDER BY o.id;


--Write a query to display the number of orders in each
--of three categories, based on the total number of 
--items in each order. The three categories are: 
--'At Least 2000', 'Between 1000 and 2000' and 
--'Less than 1000'.

SELECT  COUNT(*),
		CASE WHEN o.total < 1000 THEN 'Less than 1000'
			 WHEN o.total >= 1000 AND o.total <= 2000 THEN 'Between 1000 and 2000'
			 WHEN o.total > 2000 THEN 'At least 2000' END as order_type
FROM orders AS o
GROUP BY order_type


--We would like to understand 3 different levels of 
--customers based on the amount associated with their 
--purchases. The top level includes anyone with a 
--Lifetime Value (total sales of all orders) greater 
--than 200,000 usd. The second level is between 200,000 
--and 100,000 usd. The lowest level is anyone under 
--100,000 usd. Provide a table that includes the level 
--associated with each account. You should provide the 
--account name, the total sales of all orders for the 
--customer, and the level. Order with the top spending 
--customers listed first.

SELECT a.name,
	   SUM(o.total_amt_usd) AS total_sales_usd,
	   CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'Over 200000'
			WHEN SUM(o.total_amt_usd) BETWEEN 100000 AND 200000 THEN 'Between 100000 and 200000'
			WHEN SUM(o.total_amt_usd) < 100000 THEN 'Under 100000' END AS sales_type
FROM orders as o
JOIN accounts as a
ON o.account_id = a.id
GROUP BY a.name
ORDER BY total_sales_usd DESC

--We would now like to perform a similar calculation 
--to the first, but we want to obtain the total amount 
--spent by customers only in 2016 and 2017. Keep the same 
--levels as in the previous question. Order with the top 
--spending customers listed first.

SELECT a.name,
	   SUM(o.total_amt_usd) AS total_sales_usd,
	   DATE_PART('year', o.occurred_at) AS year,
	   CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'Over 200000'
			WHEN SUM(o.total_amt_usd) BETWEEN 100000 AND 200000 THEN 'Between 100000 and 200000'
			WHEN SUM(o.total_amt_usd) < 100000 THEN 'Under 100000' END AS sales_type
FROM orders as o
JOIN accounts as a
ON o.account_id = a.id
WHERE DATE_PART('year', o.occurred_at) BETWEEN 2016 AND 2017
--WHERE occurred_at > '2015-12-31' con esto tiene en cuenta que la base de datos solo llega a 2017, pero si tuviera mas datos hay que filtrar
GROUP BY a.name, year
ORDER BY total_sales_usd DESC


--We would like to identify top performing sales reps, 
--which are sales reps associated with more than 200 orders. 
--Create a table with the sales rep name, the total number 
--of orders, and a column with top or not depending on if 
--they have more than 200 orders. Place the top sales 
--people first in your final table.

--SELECT s.name,
--       COUNT(o.*) AS total_orders
--FROM sales_reps AS s
--JOIN accounts AS a
--ON a.sales_rep_id = s.id
--JOIN orders AS o
--ON o.account_id = a.id
--GROUP BY s.name
--HAVING COUNT(o.*) > 200
--ORDER BY total_orders DESC;

SELECT s.name,
       COUNT(*) AS total_orders,
	   CASE WHEN COUNT(*) > 200 THEN 'Top' ELSE 'Not' END AS top_sales
FROM sales_reps AS s
JOIN accounts AS a
ON a.sales_rep_id = s.id
JOIN orders AS o
ON o.account_id = a.id
GROUP BY s.name
ORDER BY total_orders DESC;

--The previous didn not account for the middle, nor the 
--dollar amount associated with the sales. Management 
--decides they want to see these characteristics 
--represented as well. We would like to identify top 
--performing sales reps, which are sales reps associated 
--with more than 200 orders or more than 750000 in total 
--sales. The middle group has any rep with more than 150 
--orders or 500000 in sales. Create a table with the sales 
--rep name, the total number of orders, total sales across 
--all orders, and a column with top, middle, or low depending 
--on this criteria. Place the top sales people based on dollar 
--amount of sales first in your final table. You might see a 
--few upset sales people by this criteria!

SELECT s.name,
       COUNT(*) AS total_orders,
	   SUM(o.total_amt_usd) AS total_usd,
	   CASE WHEN (COUNT(*) > 200) OR SUM(o.total_amt_usd) > 750000 THEN 'Top' 
	        WHEN (COUNT(*) BETWEEN 150 AND 200) OR SUM(o.total_amt_usd) BETWEEN 500000 AND 750000 THEN 'Mid'
			ELSE 'Low' END AS top_sales
FROM sales_reps AS s
JOIN accounts AS a
ON a.sales_rep_id = s.id
JOIN orders AS o
ON o.account_id = a.id
GROUP BY s.name
ORDER BY total_orders DESC;