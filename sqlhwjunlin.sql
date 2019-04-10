USE sakila;
SELECT * FROM actor;

-- #1a. Display the first and last names of all actors from the table `actor`.
SELECT first_name, last_name from actor;

-- #1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`
SELECT CONCAT(first_name, ' ', last_name) as ACTOR_NAME FROM actor;

-- #2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = 'joe';

-- #2b. Find all actors whose last name contain the letters `GEN`:
SELECT * FROM actor WHERE last_name LIKE '%GEN%';

-- #2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
SELECT last_name, first_name FROM actor WHERE last_name LIKE '%LI%';

-- #2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- #3a. You want to keep a description of each actor. 
-- #You dont think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference betweenit and `VARCHAR` are significant).

ALTER TABLE actor ADD COLUMN description BLOB; 

-- #3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
ALTER TABLE actor DROP COLUMN description; 

-- # 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(last_name) FROM actor GROUP BY last_name; 

-- # 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(last_name) FROM actor GROUP BY last_name HAVING COUNT(last_name)>=2; 

-- # 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
UPDATE actor SET first_name = 'HARPO' WHERE first_name = 'GROUCHO' and last_name = 'WILLIAMS';

-- # 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
-- #i dont understand what the difference is ???

-- # 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE address;
SELECT * FROM address;
SELECT * FROM staff;

-- # 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
SELECT staff.address_id, staff.first_name, staff.last_name, address.address 
 FROM staff 
 LEFT JOIN address ON (staff.address_id = address.address_id);
 
-- # 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`. 
-- SELECT * from payment LIMIT 0,50;
SELECT staff.staff_id, staff.first_name, staff.last_name, SUM(payment.amount)
 FROM staff 
 INNER JOIN payment
 ON staff.staff_id = payment.staff_id
 WHERE payment.payment_date BETWEEN '2005-08-01' AND '2005-09-01'
 GROUP BY staff.staff_id;
 
--  #6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.

-- SELECT * FROM film;
-- SELECT * FROM film_actor;

SELECT film.film_id, film.title, COUNT(film_actor.film_id) as Actor_Nums
FROM film 
INNER JOIN film_actor
ON film.film_id = film_actor.film_id
GROUP BY film_actor.film_id
ORDER BY COUNT(film_actor.film_id) desc;

-- #6d.How many copies of the film `Hunchback Impossible` exist in the inventory system?

SELECT * FROM inventory;
SELECT film.film_id, film.title, COUNT(inventory.film_id) as Inventory_Nums
FROM film
INNER JOIN inventory
on film.film_id = inventory.film_id 
WHERE title = 'Hunchback Impossible'
GROUP BY inventory.film_id;

--  #* 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT * FROM payment; 
SELECT * FROM customer;
SELECT customer.first_name, customer.last_name, SUM(payment.amount) as 'total payment'
FROM payment  
INNER JOIN customer 
ON payment.customer_id = customer.customer_id 
GROUP BY payment.customer_id 
ORDER BY customer.last_name;

-- #* 7a. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT * FROM film;
SELECT * FROM language;	

SELECT film_id, title, language_id 
FROM film 
WHERE title LIKE 'K%' or title LIKE 'Q%' 
AND language_id IN
(
SELECT language_id
FROM language 
WHERE name = 'English'
);


-- #7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT * FROM film_actor;
SELECT * FROM actor;

SELECT actor_id, first_name, last_name
FROM actor 
WHERE actor_id IN ( 
 SELECT actor_id 
    FROM film_actor
    WHERE film_id = (
	SELECT film_id 
        FROM film 
        WHERE title = 'Alone Trip'
	)
);


-- # 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
USE sakila;
SELECT * FROM customer;
SELECT * FROM city;
SELECT * FROM country;
SELECT * FROM address;
-- address.city_id, country.country_id, country.country
SELECT customer.first_name,customer.last_name, customer.email, address.address_id, address.city_id, city.country_id, country.country
FROM customer 
INNER JOIN address on customer.address_id = address.address_id
INNER JOIN city on address.city_id = city.city_id 
INNER JOIN country on city.country_id = country.country_id
WHERE country.country = 'Canada'; 

-- #7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT * FROM film_category;
SELECT * FROM category;
SELECT * FROM film;

SELECT film.film_id, film.title, category.name FROM film
INNER JOIN film_category on film.film_id = film_category.film_id
INNER JOIN category on film_category.category_id = category.category_id
WHERE name = 'Family';

-- #7e. Display the most frequently rented movies in descending order.
SELECT * FROM rental;
SELECT * FROM inventory;
SELECT * FROM film;

SELECT film.title, COUNT(film.title) as 'total'
FROM film 
INNER JOIN inventory ON film.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY total desc;

-- #7g. Write a query to display for each store its store ID, city, and country.

SELECT store.store_id, address.address, city.city,country.country
FROM address 
INNER JOIN store on address.address_id = store.address_id
INNER JOIN city on address.city_id = city.city_id
INNER JOIN country on city.country_id = country.country_id;

-- # 7h. List the top five genres in gross revenue in descending order.  
#(category, film_category, inventory, payment, and rental.)
SELECT * FROM category;
SELECT * FROM inventory;
SELECT * FROM film_category;
SELECT * FROM payment;
SELECT * FROM rental;

SELECT category.name as 'genre', SUM(payment.amount) as 'gross_revenue'
FROM payment 
INNER JOIN rental ON payment.rental_id = rental.rental_id
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film_category ON inventory.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id 
GROUP BY category.name
ORDER BY SUM(payment.amount) desc; 
    
-- #8a create view 
CREATE VIEW top_five_genre3 as (
	SELECT category.name as 'genre', SUM(payment.amount) as 'gross_revenue'
	FROM payment 
	INNER JOIN rental ON payment.rental_id = rental.rental_id
	INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
	INNER JOIN film_category ON inventory.film_id = film_category.film_id
	INNER JOIN category ON film_category.category_id = category.category_id 
	GROUP BY category.name
	ORDER BY SUM(payment.amount) desc 
);

-- #8b. How would you display the view that you created in 8a?
SELECT * FROM top_five_genre2
LIMIT 5;

-- #8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW top_five_genre3;

 


