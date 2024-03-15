
-- This challenge consists of three exercises that will test your ability to use the SQL RANK() function. You will use it to rank films by their length, their length within the rating category, and by the actor or actress who has acted in the greatest number of films.
-- Rank films by their length and create an output table that includes the title, length, and rank columns only. Filter out any rows with null or zero values in the length column.


select customerNumber, checkNumber, paymentDate, amount
, row_number() over ( order by paymentDate) as "row_number"
, rank() over (order by paymentDate) as "rank"
, dense_rank() over (order by paymentDate) as "dense_rank"
from payments
order by paymentDate;

select title, length,
dense_rank () over (order by length desc) as "rank"
from film 
where length is not null and length > 0
order by length desc;

-- Rank films by length within the rating category and create an output table that includes the title, length, rating and rank columns only. Filter out any rows with null or zero values in the length column.

select title, rating, length
,dense_rank () over (partition by rating order by -length) as "rank"
from film 
;

-- Produce a list that shows for each film in the Sakila database, the actor or actress who has acted in the greatest number of films, as well as the total number of films in which they have acted. Hint: Use temporary tables, CTEs, or Views when appropiate to simplify your queries.


with film_count_per_actor as (
select title, film_id, actor_id, count(film_id) over (partition by actor_id) as film_count
from film_actor
join film
using (film_id)),
film_count_ranking as (select *, row_number() over (partition by film_id 
order by film_count desc) as row_num
from film_count_per_actor)
select title, first_name, last_name, actor_id, film_count from film_count_ranking
join actor
using(actor_id)
where row_num = 1;







;
