---------------------------- LEFT & RIGH ----------------------------
--In the accounts table, there is a column holding the website 
--for each company. The last three digits specify what type of 
--web address they are using. A list of extensions (and pricing) 
--is provided here(opens in a new tab). Pull these extensions and 
--provide how many of each website type exist in the accounts table.

SELECT RIGHT(website, 3) AS extension,
	   COUNT(*) AS total
FROM accounts
GROUP BY 1
ORDER BY 2 DESC
--tenemos "org", "com" y "net"



--There is much debate about how much the name (or even the first 
--letter of a company name)(opens in a new tab) matters. Use the 
--accounts table to pull the first letter of each company name to 
--see the distribution of company names that begin with each letter 
--(or number).

SELECT LEFT(name, 1) AS first_letter,
	   COUNT(*) AS total
FROM accounts
GROUP BY 1
ORDER BY 2 DESC

--Use the accounts table and a CASE statement to create two groups: 
--one group of company names that start with a number and a second 
--group of those company names that start with a letter. What 
--proportion of company names start with a letter?
SELECT SUM(num) nums, SUM(letter) letters
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                          THEN 1 ELSE 0 END AS num, 
            CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                          THEN 0 ELSE 1 END AS letter
         FROM accounts) t1;	

--Consider vowels as a, e, i, o, and u. What proportion of company 
--names start with a vowel, and what percent start with anything else?
SELECT SUM(vowels) vowels, SUM(other) other
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') 
                           THEN 1 ELSE 0 END AS vowels, 
             CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') 
                          THEN 0 ELSE 1 END AS other
            FROM accounts) t1;


---------------------------- POSITION & STRPOS ----------------------------

--Use the accounts table to create first and last name columns that hold 
--the first and last names for the primary_poc
SELECT --primary_poc,
	   --POSITION(' ' IN primary_poc) AS position,
	   LEFT(primary_poc, POSITION(' ' IN primary_poc) - 1) AS first_name,
       RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) AS second_name
FROM accounts


--Now see if you can do the same thing for every rep name in the sales_reps 
--table. Again provide first and last name columns.
SELECT --name,
	   --POSITION(' ' IN name) AS position,
	   LEFT(name, POSITION(' ' IN name) - 1) AS first_name,
       RIGHT(name, LENGTH(name) - POSITION(' ' IN name)) AS second_name
FROM sales_reps


--Each company in the accounts table wants to create an email address 
--for each primary_poc. The email address should be the first name 
--of the primary_poc . last name primary_poc @ company name .com.

--You may have noticed that in the previous solution some of the 
--company names include spaces, which will certainly not work in an 
--email address. See if you can create an email address that will 
--work by removing all of the spaces in the account name, but 
--otherwise your solution should be just as in question 1. 

WITH t1 AS(SELECT name,
				  REPLACE(name, ' ', '') AS name_together,
				  primary_poc,
				  LEFT(primary_poc, POSITION(' ' IN primary_poc) - 1) AS first_name,
				  RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) AS second_name
			FROM accounts)
SELECT  name,
		name_together,
		primary_poc,
       CONCAT(first_name,'.', second_name, '@', name_together, '.com')
FROM t1


--We would also like to create an initial password, which they will 
--change after their first log in. The first password will be:
--the first letter of the primary_poc's first name (lowercase) 
--then the last letter of their first name (lowercase),
--the first letter of their last name (lowercase), 
--the last letter of their last name (lowercase), 
--the number of letters in their first name, 
--the number of letters in their last name, 
--and then the name of the company they are working with, all capitalized with no spaces.

WITH t1 AS(SELECT name,
				  UPPER(REPLACE(name, ' ', '')) AS name_together,
				  primary_poc,
				  LOWER(LEFT(primary_poc, POSITION(' ' IN primary_poc) - 1)) AS first_name,
				  LOWER(RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc))) AS second_name
			FROM accounts)
SELECT *,
		CONCAT(
			LEFT(first_name, 1),
			RIGHT(first_name, 1),
			LEFT(second_name, 1),
			RIGHT(second_name, 1),
			LENGTH(first_name),
			LENGTH(second_name),
			name_together) AS pass
FROM t1

--todo correcto, solo que dejo mas info de las columnas por haber ido paso a paso


---------------------------- CAST ----------------------------
--Write a query to change the date into the correct SQL date
--format. You will need to use at least SUBSTR and CONCAT.

WITH t1 AS(SELECT SUBSTR(date, 1, 2) AS month,
				   SUBSTR(date, 4, 2) AS day,
				   SUBSTR(date, 7, 4) AS year
			FROM sf_crime_data)
SELECT (year || '-' || month || '-' || day) :: DATE AS date
FROM t1;

--lo podria haber metido todo en el mismo sitio, asi:

SELECT date AS orig_date, 
		(SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2))::DATE AS new_date
FROM sf_crime_data;



---------------------------- COALESCE ----------------------------

SELECT *
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL; 


SELECT COALESCE(o.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, o.*
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;


SELECT COALESCE(o.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, o.standard_qty, o.gloss_qty, o.poster_qty, o.total, o.standard_amt_usd, o.gloss_amt_usd, o.poster_amt_usd, o.total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;


SELECT COALESCE(o.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty, COALESCE(o.gloss_qty,0) gloss_qty, COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total, COALESCE(o.standard_amt_usd,0) standard_amt_usd, COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, COALESCE(o.poster_amt_usd,0) poster_amt_usd, COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;


SELECT COUNT(*)
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;


SELECT COALESCE(o.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty, COALESCE(o.gloss_qty,0) gloss_qty, COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total, COALESCE(o.standard_amt_usd,0) standard_amt_usd, COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, COALESCE(o.poster_amt_usd,0) poster_amt_usd, COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;