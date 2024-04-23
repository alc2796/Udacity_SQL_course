SELECT *
FROM accounts
JOIN orders
ON accounts.id = orders.account_id;

SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty, accounts.website, accounts.primary_poc
FROM accounts
JOIN orders
ON accounts.id = orders.account_id;

-----------------------------------------------
SELECT a.name, a.primary_poc, w.occurred_at, w.channel
FROM web_events AS w
JOIN accounts AS a
ON a.id = w.account_id
WHERE a.name = 'Walmart';

SELECT r.name AS Region_Name, s.name AS Sales_Name, a.name AS Account_Name
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON s.id = a.sales_rep_id
ORDER BY a.name;

SELECT r.name AS region_name, a.name AS account_name, o.total_amt_usd/(o.total + 0.01) AS unit_price
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON s.id = a.sales_rep_id
JOIN orders AS o
ON a.id = o.account_id


-----------------------------------------------
SELECT r.name AS RegionName, s.name AS SalesName, a.name AS AccountName
FROM accounts AS a
JOIN sales_reps AS s
ON a.sales_rep_id = s.id
JOIN region AS r
ON r.id = s.region_id
--AND r.name = 'Midwest'
WHERE r.name = 'Midwest';
ORDER BY a.name;


SELECT r.name AS RegionName, s.name AS SalesName, a.name AS AccountName
FROM accounts AS a
JOIN sales_reps AS s
ON a.sales_rep_id = s.id
--AND s.name LIKE 'S%'
JOIN region AS r
ON r.id = s.region_id
--AND r.name = 'Midwest'
WHERE r.name = 'Midwest' AND s.name LIKE 'S%'
ORDER BY a.name;


SELECT r.name AS RegionName, s.name AS SalesName, a.name AS AccountName
FROM accounts AS a
JOIN sales_reps AS s
ON a.sales_rep_id = s.id
--AND s.name LIKE '% K%'
JOIN region AS r
ON r.id = s.region_id
--AND r.name = 'Midwest'
WHERE r.name = 'Midwest' AND s.name LIKE '% K%'
ORDER BY a.name;


SELECT r.name AS regionName, a.name AS accountName, o.total_amt_usd/(o.total + 0.01) AS unitPrice
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON s.id = a.sales_rep_id
JOIN orders AS o
ON a.id = o.account_id
--AND o.standard_qty > 100
WHERE o.standard_qty > 100;

SELECT r.name AS regionName, a.name AS accountName, o.total_amt_usd/(o.total + 0.01) AS unitPrice
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON s.id = a.sales_rep_id
JOIN orders AS o
ON a.id = o.account_id
--AND o.standard_qty > 100
--AND o.poster_qty > 50
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unitPrice;


SELECT r.name AS regionName, a.name AS accountName, o.total_amt_usd/(o.total + 0.01) AS unitPrice
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON s.id = a.sales_rep_id
JOIN orders AS o
ON a.id = o.account_id
--AND o.standard_qty > 100
--AND o.poster_qty > 50
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unitPrice DESC;

SELECT DISTINCT a.name AS accountName, w.channel AS channel
FROM web_events AS w
JOIN accounts AS a
ON w.account_id = a.id
--AND a.id = 1001;
WHERE a.id = 1001;


SELECT o.occurred_at, o.total, o.total_amt_usd, a.name AS accountName
FROM orders AS o
JOIN accounts AS a
ON a.id = o.account_id
--AND o.occurred_at BETWEEN '01-01-2015' AND '01-01-2016'
WHERE o.occurred_at BETWEEN '01-01-2015' AND '01-01-2016'
ORDER BY o.occurred_at; --no hace falta pero lo anado