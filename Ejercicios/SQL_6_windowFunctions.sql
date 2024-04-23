---------------------------- Ejemplos de uso ----------------------------

-------------------------------------
--------------EJEMPLO 1--------------
-------------------------------------

SELECT standard_amt_usd,
	   SUM(standard_amt_usd) OVER() AS grandTotal
FROM orders

--en este uso de OVER, como no hemos usado ninguno de los 3 posibles
--elementos del OVER, digamos que "ve" todas las filas y lo suma todo,
--es comos si hicieramos esto:

WITH t1 AS (SELECT standard_amt_usd,
	               SUM(standard_amt_usd) AS suma
            FROM orders
            GROUP BY 1)
SELECT SUM(suma)
FROM t1

--la diferencia es que con el OVER tenemos esa cifra en cada fila y no un unico valor

-------------------------------------
--------------EJEMPLO 2--------------
-------------------------------------

SELECT account_id,
	   standard_amt_usd,
       SUM(standard_amt_usd) OVER(PARTITION BY account_id) AS SumByID
FROM orders

--esto ahora te genera una tabla con tres columnas:
--primero el account_id (ira ordenado de menor a mayor), 
--repitiendose tantas veces el ID como filas haya con su ID
--segundo la columna con standard_amt_usd de cada orden
--tercero la columna SumByID que tiene como resultado la 
--suma de todos los standard_amt_usd de cada account_id


-------------------------------------
--------------EJEMPLO 3--------------
-------------------------------------

SELECT account_id,
	   standard_amt_usd,
       SUM(standard_amt_usd) OVER(PARTITION BY account_id ORDER BY standard_amt_usd) AS running_total_by_account
FROM orders

--esto ahora te genera una tabla con tres columnas:
--primero el account_id (ira ordenado de menor a mayor), 
--repitiendose tantas veces el ID como filas haya con su ID
--segundo la columna con standard_amt_usd ordenado de menor a mayor (por el ORDER BY del OVER)
--tercero la columna running_total_by_account que va sumando, fila a fila, el valor de standard_amt_usd con los anteriores



-------------------------------------
--------------EJEMPLO 4--------------
-------------------------------------
SELECT account_id,
	   standard_amt_usd,
	   FIRST_VALUE(standard_amt_usd) OVER (PARTITION BY account_id) AS firstAmt
FROM orders

--esto ahora te genera una tabla con tres columnas:
--primero el account_id (ira ordenado de menor a mayor), 
--repitiendose tantas veces el ID como filas haya con su ID
--segundo la columna con standard_amt_usd, esta vez sin estar ordenado
--tercero la columna firstAmt con la primera cantidad de standard_amt_usd por cada account_id

-------------------------------------
--------------EJEMPLO 5--------------
-------------------------------------
SELECT account_id,
	   standard_amt_usd,
	   FIRST_VALUE(standard_amt_usd) OVER (PARTITION BY account_id ORDER BY occurred_at) AS firstAmt
FROM orders

--esta vez es el mismo resultado que el ejemplo 3 pero el "first value" de la columna
--firstAmt es el primero que se hizo por fecha.
--Se puede comprobar con esta otra consulta:
SELECT account_id,
	   standard_amt_usd
FROM orders
ORDER BY account_id, occurred_at


-- NOTA --aplica lo mismo para el LAST_VALUE

-------------------------------------
--------------EJEMPLO 6--------------
-------------------------------------
SELECT account_id,
       ROW_NUMBER() OVER(PARTITION BY account_id) AS rowNumber
FROM orders

--nos devuelve el numero de cada fila filtrando por cada account_id




---------------------------- Window Functions 1 ----------------------------
SELECT standard_amt_usd,
       SUM(standard_amt_usd) OVER (ORDER BY occurred_at) as totalRunning
FROM orders

---------------------------- Window Functions 2 ----------------------------
SELECT standard_amt_usd,
       DATE_TRUNC('year', occurred_at) AS year,
       SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year', occurred_at) ORDER BY occurred_at) AS total_running
FROM orders


---------------------------- ROW_NUMBER() & RANK() ----------------------------
--Son parecidos, pero si con RANK tenemos el mismo valor en el ORDER BY, nos 
--devuelve el mismo valor

--Select the id, account_id, and total variable from the orders table, then 
--create a column called total_rank that ranks this total amount of paper 
--ordered (from highest to lowest) for each account using a partition. 
--Your final table should have these four columns.

SELECT id,
       account_id,
       total,
       RANK() OVER (PARTITION BY account_id ORDER BY total DESC) AS total_rank
FROM orders




-------------------------------------
-------------- EJEMPLO --------------
-------------------------------------

SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS max_std_qty
FROM orders


SELECT id,
       account_id,
       standard_qty,
       DENSE_RANK() OVER (PARTITION BY account_id) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id) AS max_std_qty
FROM orders


--If you remove the ORDER BY clause in each aggregation it just do the 
--operation for each account_id. For example the SUM is the total sum 
--of standard_qty of an account_id. Same for the rest. Regarding the 
--RANK_DENSE as there is no ORDER BY it is always 1.


---------------------------- ALIAS para distintas WINDOW ----------------------------

SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS max_std_qty
FROM orders
--pasamos a esto:
SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS dense_rank,
       SUM(standard_qty) OVER main_window AS sum_std_qty,
       COUNT(standard_qty) OVER main_window AS count_std_qty,
       AVG(standard_qty) OVER main_window AS avg_std_qty,
       MIN(standard_qty) OVER main_window AS min_std_qty,
       MAX(standard_qty) OVER main_window AS max_std_qty
FROM orders
WINDOW main_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at))


--Now, create and use an alias to shorten the following query (which is 
--different than the one in Derek's previous video) that has multiple 
--window functions. Name the alias account_year_window, which is more 
--descriptive than main_window in the example above.
SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS count_total_amt_usd,
       AVG(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS min_total_amt_usd,
       MAX(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS max_total_amt_usd
FROM orders

SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER account_year_window AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER account_year_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER account_year_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER account_year_window AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER account_year_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER account_year_window AS max_total_amt_usd
FROM orders
WINDOW account_year_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at))



--Imagine you're an analyst at Parch & Posey and you want to determine 
--how the current order's total revenue ("total" meaning from sales of 
--all types of paper) compares to the next order's total revenue.
--Modify Derek's query from the previous video in the SQL Explorer 
--below to perform this analysis. You'll need to use occurred_at and 
--total_amt_usd in the orders table along with LEAD to do so. In your 
--query results, there should be four columns: occurred_at, 
--total_amt_usd, lead, and lead_difference.

SELECT occurred_at,
       total_amt,
       LEAD(total_amt) OVER (ORDER BY occurred_at) AS lead,
       LEAD(total_amt) OVER (ORDER BY occurred_at) - total_amt AS lead_difference
FROM (
SELECT occurred_at,
       SUM(total_amt_usd) AS total_amt
FROM orders
GROUP BY 1
) t1


SELECT occurred_at,
       total_amt_usd,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) AS lead,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) - total_amt_usd AS lead_difference
FROM (
SELECT occurred_at,
       SUM(total_amt_usd) AS total_amt_usd
  FROM orders 
 GROUP BY 1
) sub




---------------------------- PERCENTILES ----------------------------

--Use the NTILE functionality to divide the accounts into 4 levels 
--in terms of the amount of standard_qty for their orders. Your 
--resulting table should have the account_id, the occurred_at time 
--for each order, the total amount of standard_qty paper purchased, 
--and one of four levels in a standard_quartile column.

SELECT account_id,
       occurred_at,
	   standard_qty,
	   NTILE(4) OVER (PARTITION BY account_id ORDER BY standard_qty) AS standard_quartile
FROM orders
ORDER BY account_id DESC --no se para que lo anade, pero lo meto para comparar
 
--Use the NTILE functionality to divide the accounts into two levels 
--in terms of the amount of gloss_qty for their orders. Your resulting 
--table should have the account_id, the occurred_at time for each order, 
--the total amount of gloss_qty paper purchased, and one of two levels 
--in a gloss_half column.

SELECT account_id,
       occurred_at,
	   gloss_qty,
	   NTILE(2) OVER (PARTITION BY account_id ORDER BY gloss_qty) AS gloss_half
FROM orders
ORDER BY account_id DESC --no se para que lo anade, pero lo meto para comparar

--Use the NTILE functionality to divide the orders for each account into 
--100 levels in terms of the amount of total_amt_usd for their orders. 
--Your resulting table should have the account_id, the occurred_at time 
--for each order, the total amount of total_amt_usd paper purchased, and 
--one of 100 levels in a total_percentile column.

SELECT account_id,
       occurred_at,
	   total_amt_usd,
	   NTILE(100) OVER (PARTITION BY account_id ORDER BY total_amt_usd) AS total_percentile
FROM orders
ORDER BY account_id DESC --no se para que lo anade, pero lo meto para comparar



