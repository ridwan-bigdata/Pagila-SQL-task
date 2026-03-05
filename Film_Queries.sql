--1. Display the number of films in each category, sort in descending order. 
--Solution.

/*

SELECT 
    c.name AS category,
    COUNT(fc.film_id) AS film_count
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.name
ORDER BY film_count DESC;

*/

---2. Display the top 10 actors whose films were rented the most, sorted in descending order. 
-- Solution.

/* 
SELECT 
    a.actor_id,
    a.first_name,
    a.last_name,
    COUNT(r.rental_id) AS total_rentals
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN inventory i ON fa.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY total_rentals DESC
LIMIT 10;
*/

--3. Display the category of films on which the most money was spent. 
 --Solution.
/*

SELECT 
    c.name AS category,
    SUM(p.amount) AS total_revenue
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY total_revenue DESC
LIMIT 1;

*/

-- 4. Display movie titles not in inventory. Write the query without the IN operator.
-- Solution.

/*
SELECT f.title
FROM film f
LEFT JOIN inventory i 
ON f.film_id = i.film_id
WHERE i.film_id IS NULL;
*/


--5. Display the top 3 actors with the most film appearances in the "Children" category. If multiple actors have the same number of film appearances, display them all. 

--Solution.
/*
WITH children_actor_counts AS (
    SELECT 
        a.actor_id,
        a.first_name,
        a.last_name,
        COUNT(*) AS film_count
    FROM actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    JOIN film_category fc ON fa.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Children'
    GROUP BY a.actor_id, a.first_name, a.last_name
),
ranked AS (
    SELECT *,
           DENSE_RANK() OVER (ORDER BY film_count DESC) AS rnk
    FROM children_actor_counts
)
SELECT actor_id, first_name, last_name, film_count
FROM ranked
WHERE rnk <= 3
ORDER BY film_count DESC;
*/

--6. Display cities with the number of active and inactive customers (active = customer.active = 1). Sort by the number of inactive customers in descending order. 

--Solution.
-- active = customer.active = 1
-- Inactive = customer.inactive = 0
-- This means if customer is active, count 1, Else count 0. Then sum everything
/*

SELECT 
    ci.city,
    SUM(CASE WHEN c.active = 1 THEN 1 ELSE 0 END) AS active_customers,
    SUM(CASE WHEN c.active = 0 THEN 1 ELSE 0 END) AS inactive_customers
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
GROUP BY ci.city
ORDER BY inactive_customers DESC;

*/

-- 7. Display the movie category with the highest total rental hours in cities (customer.address_id in this city) and that begin with the letter "a." Do the same for cities that contain the "-" symbol. Write everything in one query.

-- Important note: PostgreSQL use the time function EXTRACT(EPOCH)
					-- SQLite uses julianday()
					--  MySQL uses TIMESTAMPDIFF()

/* SELECT
    c.name AS category,
    SUM((julianday(r.return_date) - julianday(r.rental_date)) * 24) AS total_rental_hours
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category fc ON i.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN customer cu ON r.customer_id = cu.customer_id
JOIN address a ON cu.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
WHERE
    ci.city LIKE 'a%'
    AND ci.city LIKE '%-%'
GROUP BY c.name
ORDER BY total_rental_hours DESC
LIMIT 1;

*/