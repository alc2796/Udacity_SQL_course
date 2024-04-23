---------------------------- FULL OUTER JOIN ----------------------------
--We want to see each account who has a sales rep and each sales 
--rep that has an account (all of the columns in these returned 
--rows will be full)

SELECT *
FROM accounts AS a
JOIN sales_reps AS s
ON s.id = a.sales_rep_id



--But also each account that does not have a sales rep and each 
--sales rep that does not have an account (some of the columns 
--in these returned rows will be empty)

SELECT *
FROM accounts AS a
FULL OUTER JOIN sales_reps AS s --se puede escribir FULL JOIN solamente
ON s.id = a.sales_rep_id
WHERE s.id IS NULL or a.sales_rep_id IS NULL



---------------------------- INEQUALITY JOIN ----------------------------

SELECT a.name AS account_name,
       a.primary_poc,
       s.name AS sales_name
FROM accounts AS a
LEFT JOIN sales_reps AS s
ON a.sales_rep_id = s.id
AND a.primary_poc < s.name


---------------------------- SELF JOIN ----------------------------

SELECT w1.id AS w1_id,
       w1.account_id AS w1_account_id,
	   w1.occurred_at AS w1_occurred_at,
	   w1.channel AS w1_channel, 
	   w2.id AS w2_id,
       w2.account_id AS w2_account_id,
	   w2.occurred_at AS w2_occurred_at,
	   w2.channel AS w2_channel
FROM web_events AS w1
LEFT JOIN web_events AS w2
ON w1.account_id = w2.account_id
AND w2.occurred_at > w1.occurred_at
AND w2.occurred_at <= w1.occurred_at + INTERVAL '1 day'   
ORDER BY w1.account_id, w2.occurred_at




SELECT channel,
	   COUNT(*) AS sessions
FROM web_events
GROUP BY 1
ORDER BY 2 DESC