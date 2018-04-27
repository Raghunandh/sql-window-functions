'
Window frames define precisely which rows should be taken into account when computing the results and are always relative to the current row. In this way, we can create new kinds of queries.

For instance, we may say that for each row, 3 rows before and 3 rows after it are taken into account; or rows from the beginning of the partition until the current row. 

The are two kinds of window frames: those with the keyword ROWS and those with RANGE instead. The general syntax is as follows:
			<window function>
			OVER (...  ORDER BY <order_column>
				[ROWS|RANGE] <window frame extent>)
  
Of course, other elements might be added above (for instance, a PARTITION BY clause), which is why we put dots (...) in the brackets. For now, we will focus on the meaning of ROWS and RANGE.
Lets take a look at the example:
'
		SELECT id, total_price, 
			SUM(total_price) OVER(ORDER BY placed ROWS UNBOUNDED PRECEDING)
		FROM single_order
		>>>
		 id | total_price |   sum    |
		----+-------------+----------+
		  5 |      602.03 |   602.03 |
		  6 |     3599.83 |  4201.86 |
		  4 |     2659.63 |  6861.49 |
		  7 |     4402.04 | 11263.53 |
		  1 |     3876.76 | 15140.29 |
'
In the above query, we sum the column total_price. For each row, we add the current row AND all the previously introduced rows (UNBOUNDED PRECEDING) to the sum. As a result, the sum will increase with each new order. This is similar to finding the cumulative sum.
'

'
Okay. Lets jump into the brackets of OVER(...) and discuss the details. We will start with ROWS first. The general syntax is as follows:
'
			ROWS BETWEEN lower_bound AND upper_bound
'			
We know BETWEEN already – it is used to define a range. So far, we have used it to define a range of values – this time, we are going to use it to define a range of rows instead. The bounds can be any of the five options:

		* UNBOUNDED PRECEDING – the first possible row.
		* PRECEDING – the n-th row before the current row
		* CURRENT ROW – simply current row.
		* FOLLOWING – the n-th row after the current row.
		* UNBOUNDED FOLLOWING – the last possible row.

The lower bound must come BEFORE the upper bound. In other words, a construction like: ...ROWS BETWEEN CURRENT ROW AND UNBOUNDED PRECEDING does not make sense and we will get an error if we run it.

Lets look at an example:
'
			SELECT id, total_price,
				SUM(total_price) OVER(ORDER BY placed ROWS UNBOUNDED PRECEDING) AS running_total,
				SUM(total_price) OVER(ORDER BY placed ROWS between 3 PRECEDING and 3 FOLLOWING) AS sum_3_before_after
			FROM single_order
			ORDER BY placed;
			>>>
			 id | total_price | running_total | sum_3_before_after |
			----+-------------+---------------+--------------------+
			  5 |      602.03 |        602.03 |           11263.53 |
			  6 |     3599.83 |       4201.86 |           15140.29 |
			  4 |     2659.63 |       6861.49 |           19089.50 |
			  7 |     4402.04 |      11263.53 |           21288.96 |
			  1 |     3876.76 |      15140.29 |           25660.36 |


-- For each order, show its id, the placed date, and the third column which will count the number of orders up to the current order when sorted by the placed date.
select id, placed, 
	count(*) over (order by placed ROWS UNBOUNDED PRECEDING )
from single_order
>>>
 id |   placed   | count |
----+------------+-------+
  5 | 2016-06-13 |     1 |
  6 | 2016-06-13 |     2 |
  4 | 2016-06-13 |     3 |
  7 | 2016-06-29 |     4 |
  1 | 2016-07-10 |     5 |
  2 | 2016-07-10 |     6 |
  

-- Warehouse workers always need to pick the products for orders by hand and one by one. For positions with order_id = 5, calculate the remaining sum of all the products to pick. For each position from that order, show its id, the id of the product, the quantity and the quantity of the remaining items (including the current row) when sorted by the id in the ascending order.
select id, product_id, quantity, 
	sum(quantity) over(order by id ROWS BETWEEN CURRENT ROW and UNBOUNDED FOLLOWING)
from order_position 
where order_id=5
>>>
 id | product_id | quantity | sum |
----+------------+----------+-----+
  5 |          1 |       16 |  77 |
 20 |          6 |       21 |  61 |
 26 |          5 |        4 |  40 |
 33 |          4 |        5 |  36 |
 35 |          6 |       29 |  31 |
 44 |          5 |        2 |   2 |
 
 
-- Now, for each single_order, show its placed date, total_price, the average price calculated by taking 2 previous orders, the current order and 2 following orders (in terms of the placed date) and the ratio of the total_price to the average price calculated as before.
select placed, total_price,
	avg(total_price) over(order by placed ROWS BETWEEN 2 PRECEDING and 2 FOLLOWING),
	total_price/avg(total_price) over(order by placed ROWS BETWEEN 2 PRECEDING and 2 FOLLOWING)
from single_order
>>>
   placed   | total_price |          avg          |        ?column?        |
------------+-------------+-----------------------+------------------------+
 2016-06-13 |      602.03 | 2287.1633333333333333 | 0.26322125369271105839 |
 2016-06-13 |     3599.83 | 2815.8825000000000000 |     1.2784020640065770 |
 2016-06-13 |     2659.63 | 3028.0580000000000000 | 0.87832861854033179021 |
 2016-06-29 |     4402.04 | 3697.4940000000000000 |     1.1905468947346500 |
 
 
'
If our window frame has CURRENT ROW as one of the boundaries, we can also use some abbreviated syntax to make things easier:
	* ROWS UNBOUNDED PRECEDING means BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	* ROWS n PRECEDING means BETWEEN n PRECEDING AND CURRENT ROW
	* ROWS CURRENT ROW means BETWEEN CURRENT ROW AND CURRENT ROW
The same rules applies for FOLLOWING. As a way of example, the following query:
'
			SELECT id, name, introduced,
			  COUNT(id) OVER(ORDER BY introduced ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
			FROM product;
'
Can be rewritten to:
'
			SELECT id, name, introduced,
			  COUNT(id) OVER(ORDER BY introduced ROWS UNBOUNDED PRECEDING)
			FROM product;

-- Pick those stock changes which refer to product_id = 3. For each of them, show the id, changed date, quantity, and the running total, indicating the current stock status. Sort the rows by the changed date in the ascending order.
SELECT id, changed, quantity,
	SUM(quantity) OVER(ORDER BY id ROWS UNBOUNDED PRECEDING)
FROM stock_change
WHERE product_id = 3
>>>
 id |  changed   | quantity | sum |
----+------------+----------+-----+
 17 | 2016-07-24 |       23 |  23 |
 19 | 2016-08-11 |       77 | 100 |


--For each single_order, show its placed date, total_price and the average price from the current single_order and three previous orders (in terms of the placed date).
SELECT placed, total_price,
	AVG(total_price) OVER(ORDER BY placed ROWS 3 PRECEDING)
FROM single_order
>>>
   placed   | total_price |          avg          |
------------+-------------+-----------------------+
 2016-06-13 |      602.03 |  602.0300000000000000 |
 2016-06-13 |     3599.83 | 2100.9300000000000000 |
 2016-06-13 |     2659.63 | 2287.1633333333333333 |
 2016-06-29 |     4402.04 | 2815.8825000000000000 |
 2016-07-10 |     3876.76 | 3634.5650000000000000 |
 

'
It is time to look at another type of window frame: RANGE

The difference between ROWS and RANGE is that RANGE will take into account all rows "that have the same value in the column which we order by". This might be helpful with dates. Consider the following problem: we want to calculate the running sum from all orders sorted by date. We could write something like this:
'
			SELECT id, placed, total_price,
			  SUM(total_price) OVER (ORDER BY placed ROWS UNBOUNDED PRECEDING)
			FROM single_order;
			>>>
			 id |   placed   | total_price |   sum    |
			----+------------+-------------+----------+
			  5 | 2016-06-13 |      602.03 |   602.03 |
			  6 | 2016-06-13 |     3599.83 |  4201.86 |
			  4 | 2016-06-13 |     2659.63 |  6861.49 |
			  7 | 2016-06-29 |     4402.04 | 11263.53 |
			  1 | 2016-07-10 |     3876.76 | 15140.29 |
			  2 | 2016-07-10 |     3949.21 | 19089.50 |
 ' 
And it works fine. But our boss could say: hey, I dont really need to see how the running sum changed during single days. Just show the values at the end of the day; if there are multiple orders on a single day, add them together.

The above may be implemented by changing ROWS to RANGE as shown below: 
'
			SELECT id, placed, total_price,
			  SUM(total_price) OVER (ORDER BY placed RANGE UNBOUNDED PRECEDING)
			FROM single_order;
			>>>
			 id |   placed   | total_price |   sum    |
			----+------------+-------------+----------+
			  5 | 2016-06-13 |      602.03 |  6861.49 |
			  6 | 2016-06-13 |     3599.83 |  6861.49 |
			  4 | 2016-06-13 |     2659.63 |  6861.49 |
			  7 | 2016-06-29 |     4402.04 | 11263.53 |
			  1 | 2016-07-10 |     3876.76 | 19089.50 |
			  2 | 2016-07-10 |     3949.21 | 19089.50 |


-- Modify the example so that it shows the average total_price for single days for each row
SELECT id, placed, total_price,
  AVG(total_price) OVER(ORDER BY placed RANGE CURRENT ROW)
FROM single_order;
>>>
 id |   placed   | total_price |          avg          |
----+------------+-------------+-----------------------+
  5 | 2016-06-13 |      602.03 | 2287.1633333333333333 |
  6 | 2016-06-13 |     3599.83 | 2287.1633333333333333 |
  4 | 2016-06-13 |     2659.63 | 2287.1633333333333333 |
  7 | 2016-06-29 |     4402.04 | 4402.0400000000000000 |
  1 | 2016-07-10 |     3876.76 | 3912.9850000000000000 |
  2 | 2016-07-10 |     3949.21 | 3912.9850000000000000 |
  
  
'The difference between ROWS and RANGE is similar to the difference between the ranking functions ROW_NUMBER and RANK(). The query with ROWS sums the total_price for all rows which have their ROW_NUMBER less than or equal to the row number of the current row.

The query with RANGE sums the total_price for all rows which have their RANK() less than or equal to the rank of the current row.
'

'
The window frame of RANGE is defined just like the window frame of ROWS: use BETWEEN ... AND ..., or the abbreviated version.

We can use UNBOUNDED PRECEDING and UNBOUNDED FOLLOWING, as well as CURRENT ROW, but we cannot use "n PRECEDING" and "n FOLLOWING" with RANGE.

Why? With ROWS, we always knew that there was a single current row, and so we could easily calculate the previous/next rows. With RANGE, the database must understand what "three preceding values" means. It is easy to understand "three preceding days" but what are "three numbers preceding 14.5"? The SQL standard defined the meaning of n PRECEDING and n FOLLOWING for RANGE, but the database usually do not implement it.
'


-- For each stock_change with product_id = 7, show its id, quantity, changed date and another column which will count the number of stock changes with product_id = 7 on that particular date.
SELECT id, quantity, changed,
	COUNT(*) OVER(ORDER BY changed RANGE CURRENT ROW)
FROM stock_change
WHERE product_id = 7
>>>
 id | quantity |  changed   | count |
----+----------+------------+-------+
 14 |       19 | 2016-07-14 |     1 |
 16 |      -13 | 2016-08-28 |     1 |
 15 |      -72 | 2016-09-13 |     1 |
 
 

-- For each stock_change, show id, product_id, quantity, changed date and the total quantity change from all stock_change for that product.
SELECT id, product_id, quantity, changed,
	SUM(quantity) OVER(ORDER BY product_id RANGE CURRENT ROW)
FROM stock_change
>>>
 id | product_id | quantity |  changed   | sum  |
----+------------+----------+------------+------+
 18 |          1 |       24 | 2016-08-17 | -137 |
  5 |          1 |      -58 | 2016-08-09 | -137 |
  6 |          1 |      -84 | 2016-09-28 | -137 |
  9 |          1 |      -43 | 2016-06-07 | -137 |
 20 |          1 |       24 | 2016-08-28 | -137 |
 10 |          2 |      -79 | 2016-07-27 | -156 |
  2 |          2 |      -91 | 2016-08-16 | -156 |
 13 |          2 |      -37 | 2016-08-02 | -156 |
  4 |          2 |       51 | 2016-06-10 | -156 |
 17 |          3 |       23 | 2016-07-24 |  100 |
 19 |          3 |       77 | 2016-08-11 |  100 |
 11 |          4 |       93 | 2016-09-22 |  223 |
  7 |          4 |       56 | 2016-06-09 |  223 |
  
  
--For each stock_change, show its id, changed date and the number of any stock changes that took place on the same day or any time earlier.
SELECT id, changed,
	COUNT(*) OVER(ORDER BY changed RANGE UNBOUNDED PRECEDING)
FROM stock_change
>>>
 id |  changed   | count |
----+------------+-------+
  9 | 2016-06-07 |     1 |
  3 | 2016-06-08 |     2 |
  7 | 2016-06-09 |     3 |
  4 | 2016-06-10 |     4 |
 12 | 2016-06-13 |     5 |
 14 | 2016-07-14 |     6 |
 
 
-- Our finance department needs to calculate future cashflows for each date. Let's help them. In order to do that, we need to show each order: its id, placed date, total_price and the total sum of all prices of orders from the very same day or any later date.
SELECT id, placed, total_price,
	SUM(total_price) OVER(ORDER BY placed RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
FROM single_order
>>>
 id |   placed   | total_price |   sum    |
----+------------+-------------+----------+
  5 | 2016-06-13 |      602.03 | 41441.08 |
  6 | 2016-06-13 |     3599.83 | 41441.08 |
  4 | 2016-06-13 |     2659.63 | 41441.08 |
  7 | 2016-06-29 |     4402.04 | 34579.59 |
  1 | 2016-07-10 |     3876.76 | 30177.55 |
  2 | 2016-07-10 |     3949.21 | 30177.55 |
  
  
'
You may wonder what the default window frame is when it is not explicitly specified. This may differ between databases, but the most typical rule is as follows:

	* If we dont specify an ORDER BY clause within OVER(...), the whole partition of rows will be used as the window frame.
	* If we do specify an ORDER BY clause within OVER(...), the database will assume RANGE UNBOUNDED PRECEDING as the window frame. 
'

  
----------
--REVIEW--
----------
'
It is time to review what we have learned in this part:

	* You can define a window frame within OVER(...). The syntax is: [ROWS|RANGE] <window frame definition>.
	* ROWS always treats rows individually (like the ROW_NUMBER() function), RANGE also adds rows which share the same value in the column we order by (like the RANK() function).
	* <window frame definition> is defined with BETWEEN <lower bound> AND <upper bound>, where the bounds may be defined with:
		UNBOUNDED PRECEDING, n PRECEDING (ROWS only), CURRENT ROW, n FOLLOWING (ROWS only), UNBOUNDED FOLLOWING
'






























































