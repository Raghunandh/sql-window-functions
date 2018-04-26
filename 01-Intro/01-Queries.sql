-- For each owner, show their id AS dog_owner_id and the number of dogs they have.
select p.id as dog_owner_id, count(d.owner_id) as Count 
from dog d, person p
where d.owner_id = p.id
group by p.id

			-- For each owner, show their id AS dog_owner_id and the number of dogs they have (Same question with Window Functions).
			select distinct(p.id) as dog_owner_id, 
				count(*) over(partition by d.owner_id)  
			from person p, dog d 
			where p.id = d.owner_id;

'
These functions are called window functions precisely because the set of rows is called a window or a window frame. The syntax is:
<window_function> OVER (...)

<window_function> can be an aggregate function that we already know (COUNT(), SUM(), AVG() etc.), or another function, such as a ranking or an analytical function that we will get to know in this course.
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
































































































































