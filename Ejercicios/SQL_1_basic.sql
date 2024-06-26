SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd
LIMIT 20;

-----------------------------------------------

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC, account_id;

-----------------------------------------------

SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
ORDER BY gloss_amt_usd --esto es opcional pero lo ordeno de menor a mayor
LIMIT 5

SELECT *
FROM orders
WHERE gloss_amt_usd < 500
ORDER BY gloss_amt_usd --esto es opcional pero lo ordeno de menor a mayor
LIMIT 10

-----------------------------------------------

SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';

-----------------------------------------------

SELECT id, account_id, standard_amt_usd / standard_qty AS up_sp_eo
FROM orders
LIMIT 10;

SELECT id, account_id, poster_amt_usd / total_amt_usd AS perc
FROM orders
LIMIT 10;

-----------------------------------------------

SELECT id, name --id no necesario pero lo anado
FROM accounts
WHERE name LIKE 'C%';

SELECT id, name --id no necesario pero lo anado
FROM accounts
WHERE name LIKE '%one%';

SELECT id, name --id no necesario pero lo anado
FROM accounts
WHERE name LIKE '%S';

-----------------------------------------------

SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords');

-----------------------------------------------

SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');

SELECT *
FROM web_events
WHERE channel NOT IN ('organic', 'adwords');

SELECT name 
FROM accounts
WHERE name NOT LIKE 'C%';

SELECT name 
FROM accounts
WHERE name NOT LIKE '%one%';

SELECT name 
FROM accounts
WHERE name NOT LIKE '%S';

-----------------------------------------------

SELECT standard_qty, poster_qty, gloss_qty
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;

SELECT name
FROM accounts
WHERE name NOT LIKE 'C%' AND name LIKE '%s';

SELECT occurred_at, gloss_qty
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29
ORDER BY occurred_at; --no necesario pero anado

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords') AND occured_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occured_at DESC;

-----------------------------------------------

SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;

SELECT id
FROM orders
WHERE standard_qty = 0 AND (gloss_qty > 1000 OR poster_qty > 1000);

SELECT name
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%') AND ((primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%') AND primary_poc NOT LIKE '%eana%');

