--1)Who is the senior most employee based on job title?

Select TOP 1 * from music.dbo.employee order by levels desc 

--2)Which countries have the most Invoices?

Select billing_country, count(billing_country) as highest_invoices from music.dbo.invoice group by billing_country,total
order by highest_invoices desc

--3)What are top 3 values of total invoice

Select total from music.dbo.invoice order by total desc

/*--3)Which city has the best customers? We would like to throw a promotional Music 
Festival in the city we made the most money. Write a query that returns one city that 
has the highest sum of invoice totals. Return both the city name & sum of all invoice 
totals*/Select billing_city,total,sum(total) from music.dbo.invoice group by billing_city, total order by sum(total) desc/*--4)Who is the best customer? The customer who has spent the most money will be 
declared the best customer. Write a query that returns the person who has spent the 
most money*/
Select customer_id, billing_city,total,sum(total) from music.dbo.invoice group by customer_id,billing_city, total 
order by sum(total) desc

/*--5)Write query to return the email, first name, last name, & Genre of all Rock Music 
listeners. Return your list ordered alphabetically by email starting with A */

Select distinct email,first_name,last_name from music.dbo.album a join
music.dbo.track b on a.album_id=b.album_id join music.dbo.invoice_line c on b.unit_price=c.unit_price join
music.dbo.invoice d on c.invoice_id=d.invoice_id join music.dbo.customer e on d.customer_id=e.customer_id where genre_id=1 
order by email asc

/*--6)Let's invite the artists who have written the most rock music in our dataset. Write a 
query that returns the Artist name and total track count of the top 10 rock bands*/

Select top 10 count(artist_id) as total_track_count,composer from music.dbo.track a join
music.dbo.album b on a.album_id=b.album_id 
where genre_id=1 group by composer order by total_track_count desc


/*--7)Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the 
longest songs listed first*/

SELECT name,milliseconds
FROM music.dbo.track
WHERE milliseconds > (
	SELECT AVG(milliseconds) AS avg_track_length
	FROM music.dbo.track )
ORDER BY milliseconds DESC;


/*--8)Find how much amount spent by each customer on artists? Write a query to return
customer name, artist name and total spent*/

WITH best_selling_artist AS(
	SELECT TOP 1 r.artist_id, r.name, SUM(i.unit_price*i.quantity)total_sales
	FROM music.dbo.invoice_line i
	JOIN music.dbo.track t ON t.track_id = i.track_id
	JOIN music.dbo.album a ON a.album_id = t.album_id
	JOIN music.dbo.artist r ON r.artist_id = a.artist_id
	ORDER BY 3 DESC
)


SELECT c.customer_id, c.first_name, c.last_name, bsa.name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM music.dbo.invoice i
JOIN music.dbo.customer c ON c.customer_id = i.customer_id
JOIN music.dbo.invoice_line il ON il.invoice_id = i.invoice_id
JOIN music.dbo.track t ON t.track_id = il.track_id
JOIN music.dbo.album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;


/*--9) Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

WITH CTE AS(
SELECT (I.billing_country)country,CONCAT_WS(' ',C.first_name, C.last_name)cust_name , 
SUM(I.total)total_spendings, DENSE_RANK() OVER(PARTITION BY I.billing_country ORDER BY SUM(I.total) DESC)ran
FROM music.dbo.customer C
INNER JOIN music.dbo.invoice I
ON C.customer_id = I.customer_id
GROUP BY I.billing_country, C.first_name, C.last_name)

SELECT country, cust_name, total_spendings
FROM CTE
WHERE ran = 1;




Select * from music.dbo.track




