------------------ FIRST SUBQUERY ------------------
--We want to find the average number of events for 
--each day for each channel. The first table will 
--provide us the number of events for each day and 
--channel, and then we will need to average these 
--values together using a second query.

SELECT channel,
	   day,
       AVG(event_count) AS event_avg
FROM
	(SELECT channel, 
			DATE_TRUNC('day', occurred_at) AS day,
			COUNT(*) AS event_count
	FROM web_events
	GROUP BY 1, 2) sub
GROUP BY 1, 2
ORDER BY 3 DESC


--Now create a subquery that provides all of the
--data from your first query

SELECT *
FROM
	(SELECT channel, 
			DATE_TRUNC('day', occurred_at) AS day,
			COUNT(*) AS event_count
	FROM web_events
	GROUP BY 1, 2) sub
    ORDER BY event_count DESC
	
--Match each channel to its corresponding average
--number of events per day
SELECT channel,
       AVG(event_count) AS event_avg
FROM
	(SELECT channel, 
			DATE_TRUNC('day', occurred_at) AS day,
			COUNT(*) AS event_count
	FROM web_events
	GROUP BY 1, 2) sub
GROUP BY channel
ORDER BY event_avg DESC


------------------ MORE ON SUBQUERIES ------------------ 
--Use DATE_TRUNC to pull month level information about
--the first order ever placed in the orders table

SELECT DATE_TRUNC('month', MIN(occurred_at)) AS month
FROM orders


--Use the result of the previous query to find only the 
--orders that took place in the same month and year as
--the first order, and then pull the average for each
--tyme of paper qty in this month

SELECT *
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
	  (SELECT DATE_TRUNC('month', MIN(occurred_at))
		FROM orders)
ORDER BY occurred_at

--The average amount of standard paper sold on the first 
--month that any order was placed in the orders table 
--(in terms of quantity).

SELECT AVG(standard_qty) AS standard_avg,
       AVG(gloss_qty) AS gloss_avg,
	   AVG(poster_qty) AS poster_avg,
	   SUM(total_amt_usd) AS total_amt_usd
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
	  (SELECT DATE_TRUNC('month', MIN(occurred_at))
		FROM orders)



--The average amount of gloss paper sold on the first 
--month that any order was placed in the orders table 
--(in terms of quantity).

SELECT AVG(standard_qty) AS standard_avg,
       AVG(gloss_qty) AS gloss_avg,
	   AVG(poster_qty) AS poster_avg,
	   SUM(total_amt_usd) AS total_amt_usd
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
	  (SELECT DATE_TRUNC('month', MIN(occurred_at))
		FROM orders)


--The average amount of poster paper sold on the first 
--month that any order was placed in the orders table 
--(in terms of quantity).

SELECT AVG(standard_qty) AS standard_avg,
       AVG(gloss_qty) AS gloss_avg,
	   AVG(poster_qty) AS poster_avg,
	   SUM(total_amt_usd) AS total_amt_usd
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
	  (SELECT DATE_TRUNC('month', MIN(occurred_at))
		FROM orders)



--The total amount spent on all orders on the first 
--month that any order was placed in the orders table 
--(in terms of usd).

SELECT AVG(standard_qty) AS standard_avg,
       AVG(gloss_qty) AS gloss_avg,
	   AVG(poster_qty) AS poster_avg,
	   SUM(total_amt_usd) AS total_amt_usd
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
	  (SELECT DATE_TRUNC('month', MIN(occurred_at))
		FROM orders)


------------------ SUBQUERY MANIA ------------------

--Provide the name of the sales_rep in each region 
--with the largest amount of total_amt_usd sales.

SELECT t3.region_name, t3.sales_name, t3.sum_total_amt
FROM
	(SELECT  region_name,
			MAX(sum_total_amt) AS total_amt
		FROM
			(SELECT r.name AS region_name,
				   s.name AS sales_name,
				   SUM(total_amt_usd) AS sum_total_amt
			FROM region AS r
			JOIN sales_reps AS s
			ON s.region_id = r.id
			JOIN accounts AS a
			ON a.sales_rep_id = s.id
			JOIN orders AS o
			ON o.account_id = a.id
			GROUP BY region_name, sales_name) t1
	GROUP BY region_name) t2

JOIN (SELECT r.name AS region_name,
				   s.name AS sales_name,
				   SUM(total_amt_usd) AS sum_total_amt
			FROM region AS r
			JOIN sales_reps AS s
			ON s.region_id = r.id
			JOIN accounts AS a
			ON a.sales_rep_id = s.id
			JOIN orders AS o
			ON o.account_id = a.id
			GROUP BY region_name, sales_name) t3

ON t3.region_name = t2.region_name AND t3.sum_total_amt = t2.total_amt


--For the region with the largest (sum) of sales 
--total_amt_usd, how many total (count) orders were 
--placed?

--saco la region y la suma total de ventas
SELECT r.name AS region_name,
	   SUM(total_amt_usd) AS total_amt
FROM region AS r
JOIN sales_reps AS s
ON s.region_id = r.id
JOIN accounts AS a
ON a.sales_rep_id = s.id
JOIN orders AS o
ON o.account_id = a.id
GROUP BY region_name
ORDER BY SUM(total_amt_usd) DESC
LIMIT 1;

--aqui hago un join de la tabla de arriba y cuento
--el numero de ordenes cuando la region coincide 
--con la que he buscado
SELECT COUNT(o.*)
FROM region AS r
JOIN sales_reps AS s
ON s.region_id = r.id
JOIN accounts AS a
ON a.sales_rep_id = s.id
JOIN orders AS o
ON o.account_id = a.id
JOIN
	(SELECT r.name AS region_name,
		   SUM(total_amt_usd) AS total_amt
	FROM region AS r
	JOIN sales_reps AS s
	ON s.region_id = r.id
	JOIN accounts AS a
	ON a.sales_rep_id = s.id
	JOIN orders AS o
	ON o.account_id = a.id
	GROUP BY region_name
	ORDER BY SUM(total_amt_usd) DESC
	LIMIT 1) t1
ON t1.region_name = r.name
GROUP BY r.name, t1.region_name
HAVING r.name = t1.region_name

--How many accounts had more total purchases than the 
--account name which has bought the most standard_qty 
--paper throughout their lifetime as a customer?

--esto me da la mayor suma total, por nombre de cuenta, 
--de standard_qty comprado en toda la vida
SELECT total_standard_qty
FROM	(SELECT a.name AS account_name,
				SUM(standard_qty) AS total_standard_qty
		 FROM orders AS o
		 JOIN accounts AS a
		 ON o.account_id = a.id
		 GROUP BY a.name
		 ORDER BY total_standard_qty DESC
		 LIMIT 1) t1
		 
--esto me saca una tabla con el nombre de las cuentas
--cuya cantidad total de compras supera al valor
--obtenido arriba
SELECT a.name AS account_name,
	   SUM(total) AS total_qty
FROM orders AS o
JOIN accounts AS a
ON o.account_id = a.id
GROUP BY a.name
HAVING SUM(total) > (SELECT total_standard_qty
				 FROM	(SELECT a.name AS account_name,
						 SUM(standard_qty) AS total_standard_qty
				 FROM orders AS o
				 JOIN accounts AS a
				 ON o.account_id = a.id
				 GROUP BY a.name
				 ORDER BY total_standard_qty DESC
				 LIMIT 1) t1
)
ORDER BY SUM(total) DESC

--aqui saco ya el numero de cuentas
SELECT COUNT(*)
FROM
	(SELECT a.name AS account_name,
		   SUM(total) AS total_qty
	FROM orders AS o
	JOIN accounts AS a
	ON o.account_id = a.id
	GROUP BY a.name
	HAVING SUM(total) > (SELECT total_standard_qty
					 FROM	(SELECT a.name AS account_name,
							 SUM(standard_qty) AS total_standard_qty
					 FROM orders AS o
					 JOIN accounts AS a
					 ON o.account_id = a.id
					 GROUP BY a.name
					 ORDER BY total_standard_qty DESC
					 LIMIT 1) t1
	)
	ORDER BY SUM(total) DESC)


--For the customer that spent the most (in total over 
--their lifetime as a customer) total_amt_usd, how many 
--web_events did they have for each channel?

--aqui saco el account ID del cliente que mas ha gastado
SELECT account_id,
	   SUM(total_amt_usd) AS total_amt
FROM orders
GROUP BY account_id
ORDER BY SUM(total_amt_usd) DESC
LIMIT 1

--me quedo con el ID
SELECT account_id
FROM (SELECT account_id,
	   SUM(total_amt_usd) AS total_amt
		FROM orders
		GROUP BY account_id
		ORDER BY SUM(total_amt_usd) DESC
		LIMIT 1) t1

--ahora saco todos los canales contando los eventos
SELECT channel, 
	   COUNT(*) AS number_of_events
FROM web_events
WHERE account_id = (SELECT account_id
					FROM (SELECT account_id,
						   SUM(total_amt_usd) AS total_amt
							FROM orders
							GROUP BY account_id
							ORDER BY SUM(total_amt_usd) DESC
							LIMIT 1) t1
					)
GROUP BY channel
ORDER BY number_of_events DESC

--What is the lifetime average amount spent in terms of 
--total_amt_usd for the top 10 total spending accounts?

SELECT account_id,
	   SUM(total_amt_usd) AS total_amt,
	   AVG(total_amt_usd) AS avg_amt
FROM orders
GROUP BY account_id
ORDER BY SUM(total_amt_usd) DESC
LIMIT 10

--este lo habia interpretado mal, queria la media de los 10 primeros, no la media de cada uno, pero lo demas bien

--What is the lifetime average amount spent in terms of 
--total_amt_usd, including only the companies that spent 
--more per order, on average, than the average of all 
--orders.

--SELECT account_id,
--	   CASE WHEN total_amt_usd != 0 THEN total/total_amt_usd ELSE 0 END AS total_per_order,
--	   AVG(total_amt_usd) AS avg_amt
--FROM orders
--GROUP BY account_id, total, total_amt_usd
--ORDER BY avg_amt DESC
--LIMIT 10

--ESTE NO ESTA CORREGIDO, PERO PASO DE MIRAR PORQUE NO ESTA BIEN EN LA PAGINA



------------------ WITH ------------------
--Provide the name of the sales_rep in each  
--region with the largest amount of 
--total_amt_usd sales.

--saco una tabla con el nombre de la venta, region y suma total
SELECT s.name AS sales_name,
       r.name AS region_name,
	   SUM(o.total_amt_usd) AS total_amt
FROM region AS r
JOIN sales_reps AS s
ON s.region_id = r.id
JOIN accounts AS a
ON a.sales_rep_id = s.id
JOIN orders AS o
ON o.account_id = a.id
GROUP BY 1,2
ORDER BY 3 DESC


WITH t1 AS (SELECT s.name AS sales_name,
				   r.name AS region_name,
				   SUM(o.total_amt_usd) AS total_amt
				FROM region AS r
				JOIN sales_reps AS s
				ON s.region_id = r.id
				JOIN accounts AS a
				ON a.sales_rep_id = s.id
				JOIN orders AS o
				ON o.account_id = a.id
				GROUP BY 1,2
				ORDER BY 3 DESC),
				
	 t2 AS (SELECT region_name,
				   MAX(total_amt) AS total_amt
			FROM t1
			GROUP BY 1
			ORDER BY 2 DESC)
SELECT t1.sales_name, t1.region_name, t1.total_amt
FROM t1
JOIN t2
ON t2.region_name = t1.region_name AND t2.total_amt = t1.total_amt


--For the region with the largest (sum) of sales 
--total_amt_usd, how many total (count) orders were 
--placed?

WITH t1 AS (SELECT r.name AS region_name,
				   SUM(o.total_amt_usd) AS total_amt
			FROM region AS r
			JOIN sales_reps AS s
			ON s.region_id = r.id
			JOIN accounts AS a
			ON a.sales_rep_id = s.id
			JOIN orders AS o
			ON o.account_id = a.id
			GROUP BY 1
			ORDER BY 2 DESC
			LIMIT 1),
	 t2 AS (SELECT region_name
			 FROM t1)
SELECT r.name,
	   COUNT (o.*)
FROM region AS r
JOIN sales_reps AS s
ON s.region_id = r.id
JOIN accounts AS a
ON a.sales_rep_id = s.id
JOIN orders AS o
ON o.account_id = a.id
JOIN t2 
ON t2.region_name = r.name
GROUP BY 1

--How many accounts had more total purchases 
--than the account name which has bought the 
--most standard_qty paper throughout their 
--lifetime as a customer?

WITH t1 AS (SELECT a.name AS account_name,
				   SUM(standard_qty) AS standard_qty
			FROM accounts AS a
			JOIN orders AS o
			ON o.account_id = a.id
			GROUP BY 1
			ORDER BY 2 DESC
			LIMIT 1),
	 t2 AS (SELECT a.name AS account_name,
				   SUM(total) AS total_sum
			FROM accounts AS a
			JOIN orders AS o
			ON o.account_id = a.id
			GROUP BY 1
			HAVING SUM(total) > (SELECT standard_qty FROM t1)
			ORDER BY 2 DESC)
SELECT COUNT(*)
FROM t2


--For the customer that spent the most (in 
--total over their lifetime as a customer) 
--total_amt_usd, how many web_events did 
--they have for each channel?

WITH t1 AS (SELECT a.id AS account_id,
				   SUM(total_amt_usd) AS total_amt
			FROM orders AS o
			JOIN accounts AS a
			ON a.id = o.account_id
			GROUP BY 1
			ORDER BY 2 DESC
			LIMIT 1)
SELECT w.channel AS channel,
	   COUNT(w.*) AS num_of_events
FROM web_events AS w
WHERE w.account_id = (SELECT account_id FROM t1)
GROUP BY channel
ORDER BY num_of_events DESC

--no he puesto el nombre del cliente pero el resultado es correcto

--What is the lifetime average amount spent 
--in terms of total_amt_usd for the top 10 
--total spending accounts?

WITH t1 AS (SELECT a.name AS account_name,
				   SUM(total_amt_usd) AS total_spent
			FROM orders AS o
			JOIN accounts AS a
			ON a.id = o.account_id
			GROUP BY 1
			ORDER BY 2 DESC
			LIMIT 10)
SELECT AVG(total_spent) AS total_avg
FROM t1

--What is the lifetime average amount spent 
--in terms of total_amt_usd, including only 
--the companies that spent more per order, 
--on average, than the average of all orders.

--igual que apartado anterior










