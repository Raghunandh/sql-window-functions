'
In Part 3, we learned what PARTITION BY is. It allows us to compute certain functions independently for groups of rows and still maintain their individual character. In Part 3, we only used PARTITION BY with the aggregate functions which we had known before: AVG(), COUNT(), MAX(), MIN(), SUM(). None of these functions required the use of ORDER BY: the order of rows simply doesnt matter in this case.

However, in part 4,5 and 6, we got to know new elements where the order does matter: ranking functions, window frames and analytical functions.

In this part, we will learn how to use PARTITION BY with these new elements. Each time, we will also need an ORDER BY clause – hence the name of the part: PARTITION BY ORDER BY. Remember to keep the order: PARTITION BY comes before ORDER BY, or it simply wont make any sense
'

-- Take into account the period between August 10 and August 14, 2016. For each row of sales, show the following information: store_id, day, number of customers and the rank based on the number of customers in the particular store
select store_id, day, customers,
	rank() over(partition by store_id order by customers)
from sales
where day between '2016-08-10' and '2016-08-14'
>>>
 store_id |    day     | customers | rank |
----------+------------+-----------+------+
        1 | 2016-08-10 |       524 |    1 |
        1 | 2016-08-13 |       669 |    2 |
        1 | 2016-08-14 |       721 |    3 |
        1 | 2016-08-12 |      1024 |    4 |
        1 | 2016-08-11 |      1416 |    5 |
        2 | 2016-08-13 |      1586 |    1 |
        2 | 2016-08-11 |      1880 |    2 |
        2 | 2016-08-12 |      1900 |    3 |
        2 | 2016-08-14 |      1984 |    4 |


--Take the sales between August 1 and August 10, 2016. For each row, show the store_id, the day, the revenue on that day and quartile number (quartile means we divide the rows into four groups) based on the revenue of the given store in the descending order.
SELECT store_id, day, revenue,
	NTILE(4) over(PARTITION BY store_id ORDER BY revenue DESC)
FROM sales
WHERE day between '2016-08-01' and '2016-08-10'
>>>
 store_id |    day     | revenue  | ntile |
----------+------------+----------+-------+
        1 | 2016-08-06 |  6909.54 |     1 |
        1 | 2016-08-01 |  6708.16 |     1 |
        1 | 2016-08-04 |  6604.80 |     1 |
        1 | 2016-08-05 |  6409.46 |     2 |
        1 | 2016-08-07 |  5596.67 |     2 |
        1 | 2016-08-08 |  4254.43 |     2 |
		
		
--The CTE in the parentheses in the below query creates a separate ranking of stores in each country based on their rating. In the outer query, we simply return the rows with the right rank. As a result, we'll see the best store in each country
WITH ranking AS (
  SELECT country, city,
		RANK() OVER(PARTITION BY country ORDER BY rating DESC) AS rank
  FROM store
)
SELECT country, city FROM ranking WHERE rank = 1;
>>>
 country |   city    |
---------+-----------+
 France  | Paris     |
 Germany | Frankfurt |
 Spain   | Madrid    |
 
 
--For each store, show a row with three columns: store_id, the revenue on the best day in that store in terms of the revenue and the day when that best revenue was achieved.
WITH ranking AS(
  SELECT store_id, revenue, day,
      RANK() over(PARTITION BY store_id ORDER BY revenue DESC)
  FROM sales
)
SELECT store_id, revenue, day from ranking where rank=1;
>>>
 store_id | revenue  |    day     |
----------+----------+------------+
        1 |  6909.54 | 2016-08-06 |
        2 | 24547.27 | 2016-08-08 |
        3 | 15845.45 | 2016-08-02 |
        4 | 19693.13 | 2016-08-09 |
        5 | 15665.50 | 2016-08-05 |
        6 | 10493.54 | 2016-08-14 |
		
		
-- Let's analyze sales data between August 1 and August 3, 2016. For each row, show store_id, day, transactions and the ranking of the store on that day in terms of the number of transactions as compared to other stores. The store with the greatest number should get rank = 1. Use individual row ranks even when two rows share the same value.
SELECT store_id, day, transactions,
	ROW_NUMBER() over(PARTITION BY day ORDER BY transactions DESC)
FROM sales
WHERE day between '2016-08-01' and '2016-08-03'
>>>
 store_id |    day     | transactions | row_number |
----------+------------+--------------+------------+
       10 | 2016-08-01 |          195 |          1 |
        7 | 2016-08-01 |          146 |          2 |
        9 | 2016-08-01 |          136 |          3 |
        8 | 2016-08-01 |          127 |          4 |
        4 | 2016-08-01 |          123 |          5 |
		
		
--For each day of the sales statistics, show the day, the store_id of the best store in terms of the revenue on that day, and that revenue.
WITH ranking as(
  SELECT day, store_id, revenue,
      RANK() over(PARTITION BY day ORDER BY revenue DESC)
  FROM sales
)
SELECT day, store_id, revenue FROM ranking WHERE rank=1
>>>
    day     | store_id | revenue  |
------------+----------+----------+
 2016-08-01 |       10 | 16536.36 |
 2016-08-02 |        2 | 17056.00 |
 2016-08-03 |        4 | 19661.13 |
 2016-08-04 |        2 | 12473.08 |
 2016-08-05 |        5 | 15665.50 |
 2016-08-06 |        4 | 13722.67 |
 
 
--Divide the sales results for each store into four groups based on the number of transactions and for each store, show the rows in the group with the lowest numbers of transactions: store_id, day, transactions.
WITH ranking AS(
	SELECT store_id, day, transactions,
		NTILE(4) over(PARTITION BY store_id ORDER BY transactions) as rank
	FROM sales
)
SELECT day, store_id, transactions FROM ranking WHERE rank=1
>>>
    day     | store_id | transactions |
------------+----------+--------------+
 2016-08-14 |        1 |           30 |
 2016-08-09 |        1 |           30 |
 2016-08-03 |        1 |           30 |
 2016-08-13 |        1 |           33 |
 2016-08-01 |        2 |           71 |
 2016-08-12 |        2 |           76 |
 2016-08-10 |        2 |           85 |
 
 
'
Now, lets see how we can use window frames along with PARTITION BY...ORDER BY...
'
-- Show sales statistics between August 1 and August 7, 2016. For each row, show store_id, day, revenue and the best revenue in the respective store up to that date.
SELECT store_id, day, revenue,
  	MAX(revenue) OVER(PARTITION BY store_id ORDER BY day ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM sales
WHERE day BETWEEN '2016-08-01' and '2016-08-07'
>>>
 store_id |    day     | revenue  |   max    |
----------+------------+----------+----------+
        1 | 2016-08-01 |  6708.16 |  6708.16 |
        1 | 2016-08-02 |  3556.00 |  6708.16 |
        1 | 2016-08-03 |  2806.82 |  6708.16 |
        1 | 2016-08-04 |  6604.80 |  6708.16 |
        1 | 2016-08-05 |  6409.46 |  6708.16 |
        1 | 2016-08-06 |  6909.54 |  6909.54 |
		

'
Now, lets talk about the use of analytical functions with PARTITION BY ORDER BY. In the below example, we show the country, city and opening_day of each store, but we also show the city where the next store was opened – in the same country, of course
'
SELECT country, city, opening_day,
  	LEAD(city,1,'NaN') OVER(PARTITION BY country ORDER BY opening_day)
FROM store;
>>>
 country |   city    | opening_day |   lead    |
---------+-----------+-------------+-----------+
 France  | Nice      | 2014-03-15  | Lyon      |
 France  | Lyon      | 2014-09-24  | Paris     |
 France  | Paris     | 2014-12-05  | Bordeaux  |
 France  | Bordeaux  | 2015-07-29  | NaN       |
 Germany | Berlin    | 2014-12-15  | Frankfurt |
 Germany | Frankfurt | 2015-03-14  | Hamburg   |
 
 
-- For each store, show the sales in the period between August 5, 2016 and August 10, 2016: store_id, day, number of transactions, number of transactions on the previous day and the difference between these two values.
SELECT store_id, day, transactions,
  	LAG(transactions) OVER(PARTITION BY store_id ORDER BY day),
    transactions - LAG(transactions) OVER(PARTITION BY store_id ORDER BY day)
FROM sales
WHERE day BETWEEN '2016-08-05' and '2016-08-10'
>>>
 store_id |    day     | transactions | lag | ?column? |
----------+------------+--------------+-----+----------+
        1 | 2016-08-05 |           66 |null |     null |
        1 | 2016-08-06 |          123 |  66 |       57 |
        1 | 2016-08-07 |           61 | 123 |      -62 |
        1 | 2016-08-08 |           63 |  61 |        2 |
        1 | 2016-08-09 |           30 |  63 |      -33 |
        1 | 2016-08-10 |           48 |  30 |       18 |
        2 | 2016-08-05 |          147 |null |     null |
        2 | 2016-08-06 |          137 | 147 |      -10 |
        2 | 2016-08-07 |           93 | 137 |      -44 |
        2 | 2016-08-08 |          267 |  93 |      174 |
		
		
-- Show sales figures in the period between August 1 and August 3: for each store, show the store_id, the day, the revenue and the date with the best revenue in that period as best_revenue_day.
SELECT store_id, day, revenue,
  	FIRST_VALUE(day) OVER(PARTITION BY store_id ORDER BY revenue DESC) as best_revenue_day
FROM sales
WHERE day BETWEEN '2016-08-01' and '2016-08-03'
>>>
 store_id |    day     | revenue  | best_revenue_day |
----------+------------+----------+------------------+
        1 | 2016-08-01 |  6708.16 | 2016-08-01       |
        1 | 2016-08-02 |  3556.00 | 2016-08-01       |
        1 | 2016-08-03 |  2806.82 | 2016-08-01       |
        2 | 2016-08-02 | 17056.00 | 2016-08-02       |
        2 | 2016-08-03 |  7209.78 | 2016-08-02       |
        2 | 2016-08-01 |  4828.00 | 2016-08-02       |
        3 | 2016-08-02 | 15845.45 | 2016-08-02       |
		
		
--For each row, show the following columns: store_id, day, customers and the number of clients in the 5th greatest store in terms of the number of customers on that day.
SELECT store_id, day, customers,
  	NTH_VALUE(customers, 5) OVER(PARTITION BY day ORDER BY customers DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM sales
>>>
 store_id |    day     | customers | nth_value |
----------+------------+-----------+-----------+
        4 | 2016-08-01 |      2218 |      1896 |
       10 | 2016-08-01 |      2140 |      1896 |
        8 | 2016-08-01 |      1912 |      1896 |
        9 | 2016-08-01 |      1897 |      1896 |
        7 | 2016-08-01 |      1896 |      1896 |
        2 | 2016-08-01 |      1704 |      1896 |
        1 | 2016-08-01 |      1465 |      1896 |
        3 | 2016-08-01 |      1379 |      1896 |
        5 | 2016-08-01 |       773 |      1896 |
        6 | 2016-08-01 |       348 |      1896 |
		










