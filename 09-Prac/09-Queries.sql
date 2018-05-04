--For each distinctive movie, show the title, the average customer rating for that movie, the average customer rating for the entire genre and the average customer rating for all movies.
with subquery as(
	select m.title, 
		avg(r.rating) over() as avg1,
		avg(r.rating) over(partition by movie_id) as avg2,
		avg(r.rating) over(partition by genre) as avg3
	from movie m, review r
	where m.id = r.movie_id
	)
select title, avg(avg1), avg(avg2), avg(avg3) from subquery group by title
>>>
          title          |        avg         |        avg         |        avg         |
-------------------------+--------------------+--------------------+--------------------+
 Plan 9 From Outer Space | 5.7222222222222222 | 1.7500000000000000 | 3.6666666666666667 |
 Godfather               | 5.7222222222222222 | 8.0000000000000000 | 8.6250000000000000 |
 Avatar                  | 5.7222222222222222 | 7.5000000000000000 | 3.6666666666666667 |
 Showgirls               | 5.7222222222222222 | 3.0000000000000000 | 3.0000000000000000 |
 Titanic                 | 5.7222222222222222 | 9.2500000000000000 | 8.6250000000000000 |
 
 
--For each customer, show the following information: first_name, last_name, the average payment_amount from single rentals by that customer and the average payment_amount from single rentals by any customer from the same country.
select c.first_name, c.last_name,
	avg(s.payment_amount) over(partition by c.id),
    avg(s.payment_amount) over(partition by c.country)
from customer c, single_rental s
where c.id = s.customer_id
>>>
 first_name | last_name  |         avg         |         avg         |
------------+------------+---------------------+---------------------+
 Kathryn    | Reed       |  7.0000000000000000 | 12.5000000000000000 |
 Catherine  | Coleman    | 18.0000000000000000 | 12.5000000000000000 |
 Catherine  | Coleman    | 18.0000000000000000 | 12.5000000000000000 |
 Kathryn    | Reed       |  7.0000000000000000 | 12.5000000000000000 |
 Jeffrey    | Washington | 20.8571428571428571 | 18.9000000000000000 |
 Janet      | Simmons    | 14.3333333333333333 | 18.9000000000000000 |
 Jeffrey    | Washington | 20.8571428571428571 | 18.90000
 
 
--Show the first and last name of the customer who bought the second most recent giftcard along with the date when the payment took place. Assume that an individual rank is assigned for each giftcard purchase.
with ranking as(
    select c.first_name, c.last_name, g.payment_date,
        row_number() over(order by g.payment_date desc) as rank
    from customer c, giftcard g
    where c.id = g.customer_id
    )
select first_name, last_name, payment_date from ranking where rank=2
>>>
 first_name | last_name | payment_date |
------------+-----------+--------------+
 Eric       | Rivera    | 2016-04-07   |
 

--For each single rental, show the rental_date, the title of the movie rented, its genre, the payment_amount and the rank of the rental in terms of the price paid (the most expensive rental should have rank = 1). The ranking should be created separately for each movie genre. Allow the same rank for multiple rows and allow gaps in numbering too.
select s.rental_date, m.title, m.genre, s.payment_amount,
	rank() over(partition by m.genre order by s.payment_amount desc)
from single_rental s, movie m
where s.movie_id = m.id 
>>>
 rental_date |          title          |    genre    | payment_amount | rank |
-------------+-------------------------+-------------+----------------+------+
 2016-04-03  | Showgirls               | documentary |             63 |    1 |
 2016-03-21  | Showgirls               | documentary |             21 |    2 |
 2016-02-10  | Showgirls               | documentary |             15 |    3 |
 2016-03-20  | Showgirls               | documentary |             12 |    4 |
 2016-04-09  | Showgirls               | documentary |              6 |    5 |
 2016-02-20  | Titanic                 | drama       |             28 |    1 |
 
 
--For each single rental, show the id, rental_date, payment_amount and the running total of payment_amounts of all rentals from the oldest one (in terms of rental_date) until the current row.
SELECT id, rental_date, payment_amount,
  	SUM(payment_amount) OVER(ORDER BY rental_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM single_rental
>>>
 id | rental_date | payment_amount | sum |
----+-------------+----------------+-----+
 19 | 2016-01-06  |             49 |  49 |
  7 | 2016-01-07  |              9 |  58 |
 20 | 2016-01-12  |             21 |  79 |
  4 | 2016-02-09  |              8 |  87 |
 11 | 2016-02-10  |             15 | 102 |
 15 | 2016-02-20  |             28 | 130 |
 
 
-- For each subscription, show the following columns: id, length, platform, payment_date, payment_amount and the future cashflows calculated as the total money from all subscriptions starting from the beginning of the payment_date of the current row (i.e. include any other payments on the very same date) until the very end.
SELECT id, length, platform, payment_date, payment_amount,
  	SUM(payment_amount) OVER(ORDER BY payment_date RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
FROM subscription
>>>
 id | length | platform | payment_date | payment_amount | sum  |
----+--------+----------+--------------+----------------+------+
  8 |    180 | mobile   | 2016-05-08   |           1440 | 5143 |
  7 |     30 | mobile   | 2016-05-25   |            240 | 3703 |
  2 |      7 | desktop  | 2016-06-10   |             49 | 3463 |
  6 |     30 | desktop  | 2016-06-23   |            180 | 3414 |
  1 |      7 | desktop  | 2016-07-16   |             49 | 3234 |
  4 |     30 | tablet   | 2016-07-20   |            210 | 3185 |
  3 |      7 | desktop  | 2016-07-20   |             35 | 3185 |
 10 |    180 | tablet   | 2016-07-29   |           1260 | 2940 |
  9 |    180 | desktop  | 2016-08-21   |           1440 | 1680 |
  5 |     30 | mobile   | 2016-08-31   |            240 |  240 |  
  
  
-- For each single rental, show the following information: rental_date, title of the movie rented, genre of the movie, payment_amount and the highest payment_amount for any movie in the same genre rented from the first day up to the current rental_date.
SELECT rental_date, title, genre, payment_amount,
  	MAX(payment_amount) OVER(PARTITION BY genre ORDER BY rental_date ROWS UNBOUNDED PRECEDING)
FROM single_rental s, movie m
WHERE s.movie_id = m.id
>>>
 rental_date |          title          |    genre    | payment_amount | max |
-------------+-------------------------+-------------+----------------+-----+
 2016-02-10  | Showgirls               | documentary |             15 |  15 |
 2016-03-20  | Showgirls               | documentary |             12 |  15 |
 2016-03-21  | Showgirls               | documentary |             21 |  21 |
 2016-04-03  | Showgirls               | documentary |             63 |  63 |
 2016-04-09  | Showgirls               | documentary |              6 |  63 |
 2016-01-12  | Godfather               | drama       |             21 |  21 |
 2016-02-20  | Titanic                 | drama       |             28 |  28 |
 
 
--For each giftcard, show its amount_worth, payment_amount and two more columns: the payment_amount of the first and last giftcards purchased in terms of the payment_date.
SELECT amount_worth, payment_amount,
  	FIRST_VALUE(payment_amount) OVER(ORDER BY payment_date),
    LAST_VALUE(payment_amount) OVER(ORDER BY payment_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM giftcard;
>>>
 amount_worth | payment_amount | first_value | last_value |
--------------+----------------+-------------+------------+
          100 |             99 |          99 |         78 |
          100 |             83 |          99 |         78 |
           50 |             36 |          99 |         78 |
          100 |             73 |          99 |         78 |
           30 |             15 |          99 |         78 |
           50 |             33 |          99 |         78 |
           30 |             15 |          99 |         78 |
		   
		   
-- For each rental date, show the rental_date, the sum of payment amounts (column name payment_amounts) from single_rentals on that day, the sum of payment_amounts on the previous day and the difference between these two values.
WITH subquery AS(
    SELECT rental_date, SUM(payment_amount) AS payment_amounts
    FROM single_rental
    GROUP BY rental_date
  	ORDER BY rental_date
  )
SELECT rental_date, payment_amounts, LAG(payment_amounts) OVER(), payment_amounts-LAG(payment_amounts) OVER() as difference
FROM subquery
>>>
 rental_date | payment_amounts | lag | difference |
-------------+-----------------+-----+------------+
 2016-01-06  |              49 |null |       null |
 2016-01-07  |               9 |  49 |        -40 |
 2016-01-12  |              21 |   9 |         12 |
 2016-02-09  |               8 |  21 |        -13 |
 2016-02-10  |              15 |   8 |          7 |
 2016-02-20  |              28 |  15 |         13 |
 2016-03-08  |              24 |  28 |         -4 |
 
 
-- For each customer, show the following information: first_name, last_name, the sum of payments (AS sum_of_payments) for all single rentals and the sum of payments of the median customer in terms of the sum of payments (since there are 7 customers, pick the 4th customer as the median).
WITH subquery AS(
    SELECT first_name, last_name, SUM(payment_amount) AS sum_of_payments
    FROM single_rental s, customer c
    WHERE c.id = s.customer_id
    GROUP BY first_name, last_name
  	ORDER BY sum_of_payments
  )
SELECT first_name, last_name, sum_of_payments,
	NTH_VALUE(sum_of_payments, 4) OVER()
FROM subquery
>>>
 first_name | last_name  | sum_of_payments | nth_value |
------------+------------+-----------------+-----------+
 Kathryn    | Reed       |              14 |        36 |
 Ryan       | Young      |              28 |        36 |
 Brandon    | Thomas     |              30 |        36 |
 Catherine  | Coleman    |              36 |        36 |
 Janet      | Simmons    |              43 |        36 |
 Eric       | Rivera     |             126 |        36 |
 Jeffrey    | Washington |             146 |        36 |
 
 
-- For each movie, show its title, genre, editor_rating and its rank based on editor_rating for all the movies in the same genre.
SELECT title, genre, editor_rating,
  	RANK() OVER(PARTITION BY genre ORDER BY editor_rating DESC)
FROM movie;
>>>
          title          |    genre    | editor_rating | rank |
-------------------------+-------------+---------------+------+
 Showgirls               | documentary |             3 |    1 |
 Titanic                 | drama       |            10 |    1 |
 Godfather               | drama       |             8 |    2 |
 Avatar                  | fantasy     |             8 |    1 |
 Plan 9 From Outer Space | fantasy     |             2 |    2 |
 
 
-- For each review, show the following information: its id, title of the movie, the rating and the previous rating given by any customer to the same movie when sorted by the id of the reviews.
SELECT r.id, m.title, r.rating,
  	LAG(r.rating) OVER(PARTITION BY m.id ORDER BY r.id)
FROM review r, movie m
WHERE r.movie_id = m.id;
>>>
 id |          title          | rating | lag |
----+-------------------------+--------+-----+
  1 | Avatar                  |      7 |null |
  2 | Avatar                  |      8 |   7 |
  3 | Titanic                 |     10 |null |
  4 | Titanic                 |     10 |  10 |
  5 | Titanic                 |      8 |  10 |
  6 | Titanic                 |      9 |   8 |
  7 | Godfather               |      9 |null |
  
  
-- For each movie, show the following information: title, genre, average user rating for that movie and its rank in the respective genre based on that average rating in descending order (so that the best movies will be shown first).
WITH subquery AS(
    SELECT m.title, m.genre, AVG(r.rating)	
    FROM review r, movie m
    WHERE r.movie_id = m.id
    GROUP BY m.title, m.genre
  )
SELECT title, genre, avg, 
	RANK() OVER(PARTITION BY genre ORDER BY avg DESC)
FROM subquery
>>>
          title          |    genre    |        avg         | rank |
-------------------------+-------------+--------------------+------+
 Showgirls               | documentary | 3.0000000000000000 |    1 |
 Titanic                 | drama       | 9.2500000000000000 |    1 |
 Godfather               | drama       | 8.0000000000000000 |    2 |
 Avatar                  | fantasy     | 7.5000000000000000 |    1 |
 Plan 9 From Outer Space | fantasy     | 1.7500000000000000 |    2 |
 
 
-- For each platform, show the following columns: platform, sum of subscription payments for that platform and its rank based on that sum (the platform with the highest sum should get the rank of 1).
WITH ranking AS(
	SELECT platform, SUM(payment_amount)
	FROM subscription
	GROUP BY platform
)
SELECT platform, sum, RANK() OVER(ORDER BY sum DESC) FROM ranking
>>>
 platform | sum  | rank |
----------+------+------+
 mobile   | 1920 |    1 |
 desktop  | 1753 |    2 |
 tablet   | 1470 |    3 |
 
			-- Another way to write the above query
			SELECT platform, SUM(payment_amount),
				RANK() OVER(ORDER BY SUM(payment_amount) DESC)
			FROM subscription
			GROUP BY platform
			>>>
			 platform | sum  | rank |
			----------+------+------+
			 mobile   | 1920 |    1 |
			 desktop  | 1753 |    2 |
			 tablet   | 1470 |    3 |
 
 
-- Divide subscriptions into three groups (buckets) based on the payment_amount. Group the rows based on those buckets. Show the following columns: bucket, minimal payment_amount in that bucket and maximal payment_amount in that bucket.
SELECT bucket, MIN(payment_amount), MAX(payment_amount)
FROM
	(SELECT payment_amount,
		NTILE(3) OVER(ORDER BY payment_amount) as bucket
	FROM subscription
	) c
GROUP BY bucket
>>>
 bucket | min  | max  |
--------+------+------+
      1 |   35 |  180 |
      3 | 1260 | 1440 |
      2 |  210 |  240 |
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
