
'
PARTITION BY works in a similar way as GROUP BY: it partitions the rows into groups, based on the columns in PARTITION BY clause. Unlike GROUP BY, PARTITION BY does not collapse rows.

Imagine writing a query using regular GROUP BY: we would have to use a correlated subquery and a JOIN. The query would neither be readable nor efficient. We no longer want to pay that price and PARTITION BY is the solution. Thanks to PARTITION BY, we can easily get the information about individual rows AND the information about the groups these rows belong to. 
' 

-- Show the id of each journey, its date and the number of journeys that took place on that date.
select id, date, 
	count(*) over(partition by date) 
from journey
>>>
id |    date    | count |
----+------------+-------+
 21 | 2016-01-03 |     7 |
  9 | 2016-01-03 |     7 |
 30 | 2016-01-04 |     8 |
 26 | 2016-01-04 |     8 |
 15 | 2016-01-05 |     8 |
 11 | 2016-01-05 |     8 |
 
 
 -- (Using more than 1 column in Partition By) Show the id of each journey, the date on which it took place, the model of the train that was used, the max_speed of that train and the highest max_speed from all the trains that ever went on the same route on the same day.
select j.id, j.date, t.model, t.max_speed,
	max(t.max_speed) over(partition by j.route_id, j.date)
from journey j, train t
where j.train_id = t.id
>>>
id |    date    |      model       | max_speed | max |
----+------------+------------------+-----------+-----+
  1 | 2016-01-03 | InterCity 100    |       160 | 160 |
 26 | 2016-01-04 | Pendolino 390    |       240 | 240 |
 18 | 2016-01-05 | Pendolino ETR310 |       240 | 240 |
 23 | 2016-01-05 | Pendolino 390    |       240 | 240 |
 
 
--For each ticket, show its id, price and, the column named ratio. The ratio is the ticket price to the sum of all tickets purchased on the same journey.
select id, price,
	CAST(price as numeric)/(sum(price) over(partition by journey_id)) ratio
from ticket
>>>
id  | price |         ratio          |
-----+-------+------------------------+
  23 |    62 | 0.07730673316708229426 |
 110 |   124 | 0.15461346633416458853 |
 145 |    92 | 0.11471321695760598504 |
 


----------
--REVIEW--
----------
'

* OVER(PARTITION BY x) works in a similar way to GROUP BY, defining the window as all the rows in the query result that have the same value in x.
* "x" can be a single column or multiple columns separated by commas.

'












 