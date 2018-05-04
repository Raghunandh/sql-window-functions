'
At the end of this part, we will compare window functions with other elements of SELECT queries. We will find out how to use window functions in various parts of the query and where we are not allowed to do so.
'

'
All query elements are processed in a very strict order:

FROM - the database gets the data from tables in FROM clause and if necessary performs the JOINs,
WHERE - the data are filtered with conditions specified in WHERE clause,
GROUP BY - the data are grouped by with conditions specified in WHERE clause,
Aggregate functions - the aggregate functions are applied to the groups created in the GROUP BY phase,
HAVING - the groups are filtered with the given condition,
Window functions,
SELECT - the database selects the given columns,
DISTINCT - repeated values are removed,
UNION/INTERSECT/EXCEPT - the database applies set operations,
ORDER BY - the results are sorted,
OFFSET - the first rows are skipped,
LIMIT/FETCH/TOP - only the first rows are selected

Practically, this order means that we cant put window functions anywhere in the FROM, WHERE, GROUP BY or HAVING clauses. This is because at the time of calculating these elements, window functions are not yet calculated - and it is impossible to use something which is not already available.
'

-- Find the id, country and views for those auctions where the number of views was below the average.
With selection as(
	select id, country, views,
		avg(views) over() as average
	from auction
	)
select id, country, views from selection where views < average
>>>
 id | country | views |
----+---------+-------+
  1 | Spain   |    93 |
  6 | Spain   |    27 |
  8 | Spain   |   158 |
 11 | France  |    44 |
 15 | Germany |    92 |
 16 | Germany |    17 |
 17 | UK      |   155 |
 18 | UK      |    63 |
 
 
-- we would like to show those countries (country name and average final price) that have the average final price higher than the average price from all over the world. 
SELECT country, AVG(final_price) 
FROM auction 
GROUP BY country 
HAVING AVG(final_price) > (Select AVG(final_price) from auction);
>>>
 country |         avg          |
---------+----------------------+
 Italy   | 194.2833333333333333 |
 Germany | 155.4425000000000000 |
 UK      | 185.9633333333333333 |
 
 
-- divide all auctions into 6 equal groups based on the asking_price in ascending order. Show columns group_no, minimal, average and maximal value for that group. Sort by the group in ascending order.
SELECT group_no, MIN(asking_price), avg(asking_price), MAX(asking_price)
FROM
  (SELECT asking_price,
    	ntile(6) OVER(ORDER BY asking_price) as group_no
  FROM auction) c
GROUP BY group_no;
>>>
 group_no |  min   |         avg          |  max   |
----------+--------+----------------------+--------+
        4 | 135.16 | 144.5450000000000000 | 151.71 |
        1 |  20.87 |  33.6660000000000000 |  43.15 |
        5 | 157.81 | 162.9700000000000000 | 171.26 |
        3 | 115.76 | 121.1025000000000000 | 124.85 |
        6 | 172.98 | 187.0800000000000000 | 196.07 |
        2 |  51.44 |  69.6550000000000000 | 106.18 |


'
To sum up this section, we just have to remember the following rule: the only places where we can use window functions without having to write subqueries are the SELECT and ORDER BY clauses. In all other places we have to use subqueries.
'


'
Before, we said that window functions were calculated after the GROUP BY clause. This has a very important implication for our queries: if the query uses any aggregates, GROUP BY or HAVING, the window function sees the group rows instead of the original table rows.

To get a better understanding of this phenomenon, take a look at the following example:
'
SELECT category_id, final_price, 
	AVG(final_price) OVER() 
FROM auction;
'
This simple query will show the id and final_price of each auction alongside the average final_price from all the auctions. Now, take a look at the modified example with grouping:
'
SELECT category_id, MAX(final_price), 
   AVG(final_price) OVER() 
FROM auction 
GROUP BY category_id;
>>>
ERROR: column "auction.final_price" must appear in the GROUP BY clause or be used in an aggregate function Line: 3 Position in the line: 19
'
This query does not work. This is because we cant use the column final_price in the window function. Once the rows have been grouped, there is no final_price value that makes sense for all the rows together.

However, lets take a look at another modification of this example:
'
SELECT category_id, MAX(final_price) AS max_final, 
	AVG(MAX(final_price)) OVER()
FROM auction
GROUP BY category_id;
>>>
 category_id | max_final |         avg          |
-------------+-----------+----------------------+
           4 |    237.86 | 223.2200000000000000 |
           1 |    219.66 | 223.2200000000000000 |
           5 |    218.99 | 223.2200000000000000 |
           3 |    242.16 | 223.2200000000000000 |
           2 |    197.43 | 223.2200000000000000 |
'
The query will now succeed because we used an aggregate function (MAX(final_price)) that was indeed available after grouping the rows. By the way, this is the only place where we can nest aggregate functions inside one another.

The best way to correctly create queries with window functions and GROUP BY is as follows: 
	First, create the query with GROUP BY, but without window functions. 
	Run the query in the database. 
	Now, the columns we see in the result are the only columns we can use in our window functions.
'


-- Group the auctions by the country. Show the country, the minimal number of participants in an auction and the average minimal number of participants across all countries.
SELECT country, MIN(participants),
	AVG(MIN(participants)) OVER()
FROM auction
GROUP BY country
>>>
 country | min |        avg         |
---------+-----+--------------------+
 Spain   |   3 | 7.2000000000000000 |
 Italy   |   3 | 7.2000000000000000 |
 Germany |   2 | 7.2000000000000000 |
 France  |   7 | 7.2000000000000000 |
 UK      |  21 | 7.2000000000000000 |
 
 
'
We may make a ranking based on an aggregate function. Take a look:
'
SELECT country, COUNT(id),
	RANK() OVER(ORDER BY COUNT(id) DESC)
FROM auction
GROUP BY country;
>>>
 country | count | rank |
---------+-------+------+
 Spain   |     8 |    1 |
 Italy   |     6 |    2 |
 Germany |     4 |    3 |
 France  |     4 |    3 |
 UK      |     3 |    5 |
'
We grouped auctions with respect to the country, counted the number of auctions from each country, and then we created a ranking based on that count of auctions.
'


'
Another thing we can do with window functions when rows are grouped are leads, lags and day-to-day deltas.
'
SELECT ended, SUM(final_price) AS sum_price,
	LAG(SUM(final_price)) OVER(ORDER BY ended)
FROM auction
GROUP BY ended
ORDER BY ended
>>>
   ended    | sum_price |   lag   |
------------+-----------+---------+
 2017-01-05 |   1381.91 |    null |
 2017-01-06 |   1585.82 | 1381.91 |
 2017-01-07 |    405.52 | 1585.82 |
 2017-01-08 |    200.11 |  405.52 |
 2017-01-09 |    285.44 |  200.11 |
 
 
'
Finally, we can use window functions with PARTITION BY on grouped rows. One thing we need to remember is that the window function will only see grouped rows, not the original rows. For example:
'
SELECT country, ended, SUM(views) AS views_on_day,
	SUM(SUM(views)) OVER(PARTITION BY country) AS views_country
FROM auction
GROUP BY country, ended
ORDER BY country, ended
>>>
 country |   ended    | views_on_day | views_country |
---------+------------+--------------+---------------+
 France  | 2017-01-05 |          426 |           768 |
 France  | 2017-01-06 |           44 |           768 |
 France  | 2017-01-08 |          298 |           768 |
 Germany | 2017-01-05 |          267 |           610 |
 Germany | 2017-01-06 |          343 |           610 |
'
The query might require a bit of explanation. First of all, we grouped all rows by the country and ended. Then, we showed the country name and date when the auctions ended. Look what happens in the next two columns. First, we simply sum the views in accordance with our GROUP BY clause, i.e. we get the sum of views in all auctions from the particular country on the particular day. But look what happens next. We use a window function to sum all daily sums for a particular country. As a result, we get the sum of views for a particular country on all days.
'


----------
--REVIEW--
----------
'
	* Window functions can only appear in the SELECT and ORDER BY clauses.
	* If you need window functions in other parts of the query, use a subquery.
	* If the query uses aggregates or GROUP BY, remember that the window function can only see the grouped rows instead of the original table rows.
'
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
































