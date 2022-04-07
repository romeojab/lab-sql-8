-- Lab | SQL Join (Part II)

-- 1. Write a query to display for each store its store ID, city, and country.
SELECT	s.store_id
		, ci.city AS City
        , c.country AS Country
FROM sakila.store s
	JOIN sakila.address a
		USING (address_id)
	JOIN sakila.city ci
		USING (city_id)
	JOIN sakila.country c
		USING (country_id)
;

-- 2. Write a query to display how much business, in dollars, each store brought in.
SELECT	sto.store_id
		, SUM(p.amount) AS 'Total Revenue'
FROM sakila.store sto
	JOIN sakila.staff sta
		USING (store_id)
	JOIN sakila.payment p
		USING (staff_id)
GROUP BY sto.store_id
;

-- 3. Which film categories are longest?
SELECT	c.name AS Category
        , ROUND(AVG(f.length)) 'Mean Duration'
FROM sakila.category c
	JOIN sakila.film_category fc
		USING (category_id)
	JOIN sakila.film f
		USING (film_id)
GROUP BY Category
ORDER BY `Mean Duration` DESC
;

-- 4. Display the most frequently rented movies in descending order.
SELECT	f.title
		, COUNT(f.film_id) AS 'Number Rented'
FROM sakila.rental r
	JOIN sakila.inventory i
		USING (inventory_id)
	JOIN sakila.film f
		USING (film_id)
GROUP BY f.title
ORDER BY `Number Rented` DESC
;

-- 5. List the top five genres in gross revenue in descending order.
SELECT	c.name AS 'Genre'
		, SUM(p.amount) AS 'Gross Revenue'
FROM sakila.film f
	JOIN sakila.inventory i
		USING (film_id)
	JOIN sakila.rental r
		USING (inventory_id)
	JOIN sakila.payment p
		USING (customer_id)
	JOIN sakila.film_category fc
		ON  (f.film_id = fc.film_id)
	JOIN sakila.category c
		USING (category_id)
GROUP BY `Genre`
ORDER BY `Gross Revenue` DESC
LIMIT 5
;

-- 6. Is "Academy Dinosaur" available for rent from Store 1?
SELECT	s.store_id AS 'Store 1'
		, f.title AS Film
        , COUNT(s.store_id) AS Available
FROM sakila.film f
	JOIN sakila.inventory i
		USING (film_id)
	JOIN sakila.store s
		USING (store_id)
WHERE f.title = 'ACADEMY DINOSAUR'
;

-- 7. Get all pairs of actors that worked together.
SELECT	CONCAT(act1.first_name,' ',act1.last_name) AS 'ACTOR 1'
		, CONCAT(act2.first_name,' ',act2.last_name) AS 'ACTOR 2'
        , f.title AS 'FILM'
FROM sakila.film_actor a
	JOIN sakila.film_actor b
		ON  (a.actor_id <> b.actor_id) AND (a.film_id = b.film_id) 
	JOIN sakila.actor act1
		ON act1.actor_id = a.actor_id
	JOIN sakila.actor act2
		ON act2.actor_id = b.actor_id
	JOIN sakila.film f
		ON a.film_id = f.film_id    
GROUP BY a.film_id
ORDER BY `Film`
;

-- 8. Get all pairs of customers that have rented the same film more than 3 times.
SELECT	r1.inventory_id
		, r1.customer_id AS Customer_1
		, r2.customer_id AS Customer_2
		, COUNT(CONCAT(r1.customer_id, ' ',r2.customer_id)) AS n
FROM sakila.rental r1
	JOIN sakila.rental r2
		ON  (r1.customer_id <> r2.customer_id) AND (r1.inventory_id = r2.inventory_id) 
GROUP BY Customer_1
        , Customer_2		
HAVING n > 3
ORDER BY n DESC
;

-- 9. For each film, list actor that has acted in more films.
SELECT	fa.actor_id
		, fa.film_id
        , f_list.`# Of Films`
FROM sakila.film_actor fa
JOIN (	SELECT	actor_id
				, film_id
				, COUNT(film_id) AS '# Of Films'
		FROM sakila.film_actor
		GROUP BY actor_id
        HAVING `# Of Films` > 1
		ORDER BY `# Of Films`
	 ) f_list
	ON f_list.actor_id= fa.actor_id
		AND f_list.film_id = fa.film_id
;