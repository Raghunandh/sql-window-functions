'
Lets introduce the general syntax for analytic functions:
<analytic function> OVER (...)

Analytic functions are quite easy, their syntax is identical to aggregate functions. The difference is that aggregate functions calculate a cumulative result for all the rows in the window frame, while the analytic functions refer to single rows within the frame.
'

'
Lets take a look at the very first example. 
'
SELECT name, opened,
	LEAD(name) OVER(ORDER BY opened)
FROM website;
>>>
       name       |   opened   |       lead       |
------------------+------------+------------------+
 Gaming Heaven    | 2016-02-01 | All About Health |
 All About Health | 2016-03-15 | Around The World |
 Around The World | 2016-05-01 | null             |
'
The analytic function here is LEAD(name). LEAD with a single argument in the parentheses looks at the next row in the given order and shows the value in the column specified as the argument.
'

--For all the statistics of the website with id = 1, show the day, the number of users and the number of users on the next day.
SELECT day, users,
	LEAD(users) OVER(ORDER BY day)
FROM statistics
WHERE website_id = 1
>>>
    day     | users | lead  |
------------+-------+-------+
 2016-05-01 | 36169 | 29580 |
 2016-05-02 | 29580 | 30907 |
 2016-05-03 | 30907 | 19154 |
 2016-05-04 | 19154 | 10897 |
 2016-05-05 | 10897 | 24602 |
 2016-05-06 | 24602 | 19882 |
 2016-05-07 | 19882 | 26932 |
 2016-05-08 | 26932 | 39275 |
 
 
'
LEAD can be extremely useful when we want to calculate deltas, i.e. differences between two values. A typical example may look like this:
'
SELECT day, clicks,
	LEAD(clicks) OVER(ORDER BY day),
	clicks - LEAD(clicks) OVER(ORDER BY day) 
FROM statistics
WHERE website_id = 2;
>>>
    day     | clicks | lead | ?column? |
------------+--------+------+----------+
 2016-05-01 |    106 |  132 |      -26 |
 2016-05-02 |    132 |  144 |      -12 |
 2016-05-03 |    144 |  145 |       -1 |
 2016-05-04 |    145 |  128 |       17 |
 2016-05-05 |    128 |   83 |       45 |
 2016-05-06 |     83 |  202 |     -119 |
'
The above query calculates day-to-day deltas: the last column shows the difference in clicks between the current day and the next day. From a business point of view, this could easily tell us a lot about the website: if the deltas for many rows are positive, and possibly increasing, then the website is expanding. If, in turn, the deltas are mostly negative, we can start to worry about the performance of the website.
'

'
There is also another version of LEAD. It takes two arguments: LEAD(x,y). x remains the same – it specifies the column to return. y, in turn, is a number which defines the number of rows forward from the current value. For instance:
'
SELECT name, opened,
	LEAD(opened,2) OVER(ORDER BY opened)
FROM website;
'
This form of LEAD wont show the webpage with the opening date coming immediately after the current opening date. Instead, it will show the opening date 2 rows forward – the 1st row will show the 3rd date etc
'

-- Take the statistics for the website with id = 2 between 1 and 14 May 2016 and show the day, the number of users and the number of users 7 days later.
SELECT day, users,
	LEAD(users,7) OVER(ORDER BY day)
FROM statistics
WHERE website_id = 2 and day BETWEEN '2016-05-01' AND '2016-05-14';
>>>
    day     | users | lead |
------------+-------+------+
 2016-05-01 |  7058 | 5491 |
 2016-05-02 |  7716 | 3350 |
 2016-05-03 |  6877 | 9669 |
 2016-05-04 |  9498 | 8929 |
 2016-05-05 |  8350 | 5758 |
 2016-05-06 |  3508 | 6342 |
 
 
'
The last possible type of LEAD takes three arguments:
'
SELECT name, opened,
	LEAD(opened,2,'2000-01-01') OVER(ORDER BY opened)
FROM website;
'
The new (last) argument tells the function what it should return if no matching value is found. Previously, the last rows got NULLs from the function, because there were no "lead" (further) rows for them. Now, we can specify what should be displayed in such cases instead of the default NULL. Here, we show '2000-01-01'. Note that this value must be of the same type as the column itself: if we show dates with LEAD, the last argument must be a date too. We cannot show "not available" or 0 instead.
'

'
Of course, there is also a function that shows a previous value, and its name is LAG(x):
'
SELECT name, opened,
	LAG(name) OVER(ORDER BY opened)
FROM website;
'
Here, instead of showing the next opening date, we show the previous opening date. 

Note that we can always sort the rows in the reverse order with DESC and use LEAD(...) instead of LAG(...), or the other way around. In other words:

LEAD (...) OVER(ORDER BY...) is the same as LAG (...) OVER (ORDER BY ... DESC)
and
LEAD (...) OVER(ORDER BY DESC) is the same as LAG (...) OVER (ORDER BY ...)

And, of course, there is also an analogous version of LAG(x,y) and LAG(x,y,z).
'


'
LEAD and LAG are 2 functions which are always relative to the current row. Now, we will get to know three other functions that are independent of the current row.

The first one is FIRST_VALUE(x). This returns the first value in the column x in the given order. Take a look:
'
SELECT name, opened, budget,
	FIRST_VALUE(budget) OVER(ORDER BY opened)
FROM website;
>>>
       name       |   opened   | budget | first_value |
------------------+------------+--------+-------------+
 Gaming Heaven    | 2016-02-01 |   3000 |        3000 |
 All About Health | 2016-03-15 |    700 |        3000 |
 Around The World | 2016-05-01 |    500 |        3000 |
'
Here, we still sort rows by the opening date (ORDER BY opened), but we show the lowest budget instead of the first opening date (FIRST_VALUE(budget)). In this way, we can show the budget for the website that was opened first.

Note that this would be impossible to achieve with a simple MIN(...) function. MIN(budget) would simply show the smallest budget: 500 in this case. That is not the same as the budget of the first website (3000).
'

-- Show the statistics for website_id = 2. For each row, show the day, the number of users and the smallest number of users ever.
SELECT day, users,
	FIRST_VALUE(users) OVER(ORDER BY users)
FROM statistics
WHERE website_id = 2
>>>
    day     | users | first_value |
------------+-------+-------------+
 2016-05-09 |  3350 |        3350 |
 2016-05-06 |  3508 |        3350 |
 2016-05-19 |  3538 |        3350 |
 2016-05-20 |  3584 |        3350 |
 2016-05-25 |  3970 |        3350 |

				-- Above query can also be written as:
				SELECT day, users,
					MIN(users) OVER() as first_value
				FROM statistics
				WHERE website_id = 2
 

-- Show the statistics for website_id = 3. For each row, show the day, the revenue and the revenue on the first day.
SELECT day, revenue,
	FIRST_VALUE(revenue) OVER(ORDER BY day)
FROM statistics
WHERE website_id = 3
>>>
    day     | revenue | first_value |
------------+---------+-------------+
 2016-05-01 |    0.10 |        0.10 |
 2016-05-02 |    0.21 |        0.10 |
 2016-05-03 |    0.30 |        0.10 |
 2016-05-04 |    0.15 |        0.10 |
 2016-05-05 |    0.37 |        0.10 |
 
 
'
Of course, we can also find the last value: simply use LAST_VALUE(x) instead. But LAST_VALUE shows the current value instead of the highest value.
'
SELECT name, opened,
	LAST_VALUE(opened) OVER(ORDER BY opened)
FROM website;
>>>
       name       |   opened   | last_value |
------------------+------------+------------+
 Gaming Heaven    | 2016-02-01 | 2016-02-01 |
 All About Health | 2016-03-15 | 2016-03-15 |
 Around The World | 2016-05-01 | 2016-05-01 |
'
The query didnt work! Instead of the latest opening date, we saw the current opening date. In order to understand why this happened, we need to refer to the previous part of our course, where we talked about default window frames:

If there is an ORDER BY clause, RANGE UNBOUNDED PRECEDING will be used as the default window frame. And this is precisely the cause of our troubles. We indeed used ORDER BY within OVER(...), which is why LAST_VALUE(x) only considers the rows from the first row until the current row. The solution is quite simple: we need to define the right window frame:
'
SELECT name, opened,
	LAST_VALUE(opened) OVER(ORDER BY opened ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM website;
>>>
       name       |   opened   | last_value |
------------------+------------+------------+
 Gaming Heaven    | 2016-02-01 | 2016-05-01 |
 All About Health | 2016-03-15 | 2016-05-01 |
 Around The World | 2016-05-01 | 2016-05-01 |

 
-- Show the statistics for website_id = 1. For each row, show the day, the number of impressions and the number of impressions on the day with the most users.
SELECT day, impressions,
	LAST_VALUE(impressions) OVER(ORDER BY users ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM statistics
WHERE website_id = 1
>>>
    day     | impressions | last_value |
------------+-------------+------------+
 2016-05-15 |       59941 |     519701 |
 2016-05-20 |       86640 |     519701 |
 2016-05-05 |      163455 |     519701 |
 2016-05-21 |      152944 |     519701 |
 2016-05-27 |      191828 |     519701 |


'
The last function we will learn in this part is: NTH_VALUE(x,n). This function returns the value in the column x of the nth row in the given order.
'
SELECT name, opened,
	NTH_VALUE(opened,2) OVER(ORDER BY opened ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM website;
'
This time, we are showing the opening date of the current row together with the second row when sorted by the opening date. With NTH_VALUE, we also need to redefine the window frame. Otherwise, some rows will display incorrect values. We can always revert the order by adding the word DESC, which sometimes comes in handy with NTH_VALUE:

...OVER(ORDER BY opened DESC)...
' 
 
-- Take the statistics for the website with id = 2 between May 15 and May 31, 2016. Show the day, the revenue on that day and the third highest revenue in that period.
SELECT day, revenue,
	NTH_VALUE(revenue, 3) OVER(ORDER BY revenue desc ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM statistics
WHERE website_id = 2  and day BETWEEN '2016-05-15' AND '2016-05-31';
>>>
    day     | revenue | nth_value |
------------+---------+-----------+
 2016-05-17 |  100.64 |     54.38 |
 2016-05-30 |   60.08 |     54.38 |
 2016-05-22 |   54.38 |     54.38 |
 2016-05-31 |   53.26 |     54.38 |
 2016-05-26 |   48.72 |     54.38 |
 2016-05-28 |   47.52 |     54.38 |
 2016-05-19 |   40.46 |     54.38 |
 
 
-- Take the day May 14, 2016 and for each row, show: website_id, revenue on that day, the highest revenue from any website on that day (AS highest_revenue and the lowest revenue from any website on that day (as lowest_revenue).
SELECT website_id, revenue,
	FIRST_VALUE(revenue) OVER(order by revenue DESC) AS highest_revenue,
	LAST_VALUE(revenue) OVER(ORDER BY revenue DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as lowest_revenue
FROM statistics
WHERE day = '2016-05-14'
>>>
 website_id | revenue | highest_revenue | lowest_revenue |
------------+---------+-----------------+----------------+
          1 |   85.50 |           85.50 |           0.60 |
          2 |   38.71 |           85.50 |           0.60 |
          3 |    0.60 |           85.50 |           0.60 |
		  

 
 
----------
--REVIEW--
----------
'
* LEAD(x) and LAG(x) gives the next/previous value in the column x, respectively.
* LEAD(x,y) and LAG(x,y) gives the value in the column x of the row which is y rows after/before the current row, respectively.
* FIRST_VALUE(x) and LAST_VALUE(x) gives the first and last value in the column x, respectively.
* NTH_VALUE(x,n) gives the value in the column x of the n-th row.
* LAST_VALUE and NTH_VALUE usually require the window frame to be set to ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING.
'
































