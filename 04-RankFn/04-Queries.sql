'
In this part, we are going to use window functions for something very useful – creating rankings. Which "x" is the best? Which "x" is in 3rd place? Which is the worst? These are the questions we are going to answer in this part.

So far, we have learned how to use window functions with aggregate functions that we already knew – SUM(), COUNT(), AVG(), MAX() and MIN(). Now, lets look at different functions that go well with OVER() – RANKING functions. The general syntax is as follows:
<ranking function> OVER (ORDER BY <order by columns>)

OVER (ORDER BY col1, col2...) is the part where we specify the order in which rows should be sorted and therefore ranked.
'

'
What does RANK() do? It returns the rank (a number) of each row with respect to the sorting specified within parentheses.
RANK() OVER (ORDER BY ...)

ORDER BY sorts rows and shows them in a specific order to you. RANK() OVER(ORDER BY ...) is a function that shows the rank(place, position) of each row in a separate column.
'
-- We want to return the rank of each row when we sort them by the column editor_rating
SELECT name, platform, editor_rating,
  RANK() OVER(ORDER BY editor_rating)
FROM game;
>>>
       name         |   platform    | editor_rating | rank |
---------------------+---------------+---------------+------+
 Duck Dash           | Android       |             4 |    1 |
 The Square          | Android       |             4 |    1 |
 Hit Brick           | Android       |             4 |    1 |
 Go Bunny            | iOS           |             5 |    4 |
 Perfect Time        | Windows Phone |             6 |    5 |
 First Finish        | Windows Phone |             7 |    6 |
 
 '
In the above result, we can see that we get the rank of each game in the last column. There are 3 games with the lowest score – 4. All of them got rank 1. The next game, with score 5, got rank 4, not 2. That is how RANK() works. There were three games before the game with score 5, so, being the 4th game, it got rank 4 – regardless of the fact that the other three all got rank 1. RANK() will always leave gaps in numbering when more than 1 row share the same value.
'
 
--For each game, show name, genre, date of update and its rank. The rank should be created with RANK() and take into account the date of update.
select name, genre, updated,
	rank() over(order by updated)
from game
>>>
       name         |   genre   |  updated   | rank |
---------------------+-----------+------------+------+
 Froggy Adventure    | adventure | 2015-07-02 |    1 |
 Go Bunny            | action    | 2015-07-13 |    2 |
 Speed Race          | racing    | 2015-07-25 |    3 |
 Eternal Stone       | adventure | 2015-10-25 |    4 |
 Monsters in Dungeon | adventure | 2015-12-15 |    5 |
 
'
RANK() will always leave gaps in numbering when more than 1 row share the same value. We can change that behavior by using another function: DENSE_RANK():
'

SELECT name, platform, editor_rating,
  DENSE_RANK() OVER(ORDER BY editor_rating)
FROM game;
>>>
        name         |   platform    | editor_rating | dense_rank |
---------------------+---------------+---------------+------------+
 Duck Dash           | Android       |             4 |          1 |
 The Square          | Android       |             4 |          1 |
 Hit Brick           | Android       |             4 |          1 |
 Go Bunny            | iOS           |             5 |          2 |
 Perfect Time        | Windows Phone |             6 |          3 |
 First Finish        | Windows Phone |             7 |          4 |
 
 
'
Use ROW_NUMBER() as next aggregating function. Now, each row gets its own, unique rank number, so even rows with the same value get consecutive numbers.

The only problem is with the order of these consecutive numbers. We could ask – how does my database determine which of the games with editor_rating = 4 gets 1, 2 or 3 as the rank? The answer is – it doesnt, really. The order is nondeterministic. When we execute ROW_NUMBER(), we never really know what the output will be:
'
SELECT name, platform, editor_rating,
  ROW_NUMBER() OVER(ORDER BY editor_rating)
FROM game; 
>>>
        name         |   platform    | editor_rating | row_number |
---------------------+---------------+---------------+------------+
 Duck Dash           | Android       |             4 |          1 |
 The Square          | Android       |             4 |          2 |
 Hit Brick           | Android       |             4 |          3 |
 Go Bunny            | iOS           |             5 |          4 |
 Perfect Time        | Windows Phone |             6 |          5 |
 First Finish        | Windows Phone |             7 |          6 |
 
 
-- For each game, show its name, genre and date of release. In the next three columns, show RANK(), DENSE_RANK() and ROW_NUMBER() sorted by the date of release.
select name, genre, released, 
	rank() over(order by released),
	dense_rank() over(order by released),
	row_number() over(order by released)
from game
>>> 
         name         |   genre   |  released  | rank | dense_rank | row_number |
---------------------+-----------+------------+------+------------+------------+
 Eternal Stone       | adventure | 2015-03-20 |    1 |          1 |          1 |
 Speed Race          | racing    | 2015-03-20 |    1 |          1 |          2 |
 Froggy Adventure    | adventure | 2015-05-01 |    3 |          2 |          3 |
 Hit Brick           | action    | 2015-05-01 |    3 |          2 |          4 |
 Go Bunny            | action    | 2015-05-01 |    3 |          2 |          5 |
 Duck Dash           | shooting  | 2015-07-30 |    6 |          3 |          6 |
 
 
'
Yet another thing we can do is rank by multiple columns, each of them in the ascending or descending order of our choice. Lets pretend that a player has limited space on phone, but wants to install a relatively recent game. 
'
SELECT name, genre, editor_rating,
  RANK() OVER(ORDER BY released DESC, size ASC)
FROM game;
>>>
        name         |   genre   | editor_rating | rank |
---------------------+-----------+---------------+------+
 Monsters in Dungeon | adventure |             9 |    1 |
 Perfect Time        | action    |             6 |    2 |
 The Square          | action    |             4 |    3 |
 Shoot in Time       | shooting  |             9 |    4 |
 First Finish        | racing    |             7 |    5 |
 

-- We want to find games which were both recently released and recently updated. For each game, show name, date of release and last update date, as well as their rank: use ROW_NUMBER(), sort by release date and then by update date, both in the descending order
select name, released, updated,
	row_number() over(order by released desc, updated desc)
from game
>>>
        name         |  released  |  updated   | row_number |
---------------------+------------+------------+------------+
 Shoot in Time       | 2015-12-01 | 2016-03-20 |          1 |
 The Square          | 2015-12-01 | 2016-03-16 |          2 |
 Perfect Time        | 2015-12-01 | 2016-01-07 |          3 |
 Monsters in Dungeon | 2015-12-01 | 2015-12-15 |          4 |
 First Finish        | 2015-10-01 | 2016-02-20 |          5 | 
 

'
The ranking function and the external ORDER BY are independent. The ranking function returns the rank with respect to the order provided within OVER.

The below query returns the name of the game and the rank of the game with respect to editor ranking. The returned rows are ordered by size of the game in descending way.
' 
SELECT name,
  RANK() OVER (ORDER BY editor_rating)
FROM game
ORDER BY size DESC; 


--For each purchase, find the name of the game, the price, and the date of the purchase. Give purchases consecutive numbers by date when the purchase happened, so that the latest purchase gets number 1. Order the result by editor's rating of the game
select g.name, p.price, p.date,
	row_number() over(order by date desc)
from game g, purchase p
where p.game_id=g.id
order by editor_rating;
>>>
     name     | price |    date    | row_number |
--------------+-------+------------+------------+
 The Square   | 14.99 | 2016-07-17 |         22 |
 Hit Brick    |  7.99 | 2016-04-20 |         41 |
 Hit Brick    | 11.99 | 2016-02-27 |         52 |
 The Square   |  2.99 | 2016-03-24 |         49 |
 The Square   |  4.99 | 2016-10-05 |          6 |
 Duck Dash    | 18.99 | 2016-01-05 |         59 |
 
 
'
The last function in this section is NTILE(X). It distributes the rows into a specific number of groups, provided as X. For instance, In the below query, we create three groups with NTILE(3) that are divided based on the values in the column editor_rating. The "best" games will be put in group 1, "average" games in group 2, "worst" games in group 3. Note that if the number of rows is not divisible by the number of groups, some groups will have one more element than other groups, with larger groups coming first.
'
SELECT name, genre, editor_rating,
  NTILE(3) OVER (ORDER BY editor_rating DESC)
FROM game;

 
'
Now, we will learn how to create queries that, for instance, return only the row with rank 1, 5, 10, etc. This cannot be accomplished with a simple query – we will need to create a complex one. For this purpose, we will use Common Table Expressions. An example may look like this. The query returns the name of the game which gets rank number 2 with respect to editor rating:
' 
WITH ranking AS 
	(
	SELECT name,
		RANK() OVER(ORDER BY editor_rating DESC) AS rank
	FROM game
	)
SELECT name FROM ranking WHERE rank = 2; 


-- Find the name, genre and size of the smallest game in our studio.
WITH ranking AS 
	(SELECT name, genre, size, 
		RANK() over(ORDER BY size) as rank
	FROM game)
SELECT name, genre, size FROM ranking WHERE rank=1 

			-- Find the name, genre and size of the smallest game in our studio.
			select name, genre, size 
			from game 
			where size in (select min(size) from game)
 

--Show the name, platform and update date of the second most recently updated game
with ranking as
	(select name, platform, updated,
		Rank() over (order by updated desc) as rank
	from game)
select name, platform, updated from ranking where rank=2 
>>>
   name    | platform |  updated   |
-----------+----------+------------+
 Duck Dash | Android  | 2016-05-23 |
 
 
 
----------
--REVIEW--
----------
' 

* The most basic usage of ranking functions is: RANK() OVER(ORDER BY column1, column2...).
* The ranking functions we have learned:
	RANK() - returns the rank (a number) of each row with respect to the sorting specified within parentheses.
	DENSE_RANK() - returns a "dense" rank, i.e. there are no gaps in numbering.
	ROW_NUMBER() - returns a unique rank number, so even rows with the same value get consecutive numbers.
	NTILE(x) - distributes the rows into a specific number of groups, provided as x.
* To get col1 of the row with rank place1 in a ranking sorted by col2, write:

' 
WITH ranking AS
  (SELECT
    RANK() OVER (ORDER BY col2) AS RANK,
    col1
  FROM table_name)
SELECT col1 FROM ranking WHERE RANK = place1;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 