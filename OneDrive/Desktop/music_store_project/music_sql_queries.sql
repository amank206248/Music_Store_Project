
use music_database;
select * from album1
select * from album2
select * from artist
select * from employee
select * from genre
select * from playlist
select * from playlist_track
select * from track
select * from playlist

---Q. Write query to return the email,first name,last name,& Genre of all Rock Music listeners.
select  distinct a.email,a.first_name,a.last_name from employee a join customer b on a.employee_id=b.support_rep_id
join invoice c on b.customer_id=c.customer_id join invoice_line d on c.invoice_id=d.invoice_id join track e
on d.track_id=e.track_id join genre f on e.genre_id=f.genre_id where f.name='Rock' order by a.email 

---Q. Let's invite the artists who have written the most rock music in our dataset.Write a query that returns
--the Artist name and total track count of the top 10 rock bands..

select top 10  a.artist_id, a.name,count(c.track_id) total_songs,rank() over(partition by a.artist_id order by count(c.track_id) desc) rnk from artist
a join album1 b on a.artist_id=b.artist_id join track c on b.album_id=c.album_id join genre d on c.genre_id=d.genre_id
where d.name='rock' group by a.artist_id,a.name order by total_songs desc



select track_id,name,milliseconds from track where milliseconds >(select avg(milliseconds) from track) order by 
milliseconds desc


--Q. We want to find out the most popular music genre for each country.
--we determine the most popular genre as the genre with the highest amount of purchases.Write a query that returns
--each country along with the top genre.for countries where the maximum number of purchases is shared return all Genres.
with popular_genre as 
(  
  select  count(i.invoice_id) total_purchase, c.country,g.genre_id,g.name,row_number() over(partition by c.country order by count(i.invoice_id) desc) rnk  from customer c join invoice i on
c.customer_id=i.customer_id join invoice_line il 
on i.invoice_id=il.invoice_id join track t on
il.track_id=t.track_id join genre g on t.genre_id=g.genre_id group by c.country,g.genre_id,g.name  
 )  
select * from popular_genre  where rnk=1

--Q. write a query that determines the customer that has spent the most on music for each country.write a query that
--returns the country along with the top customer and how much they spent.for cuntries where the top amount spent
--is shared,provide all customers who spent this amount
with top_customer as 
(select c.customer_id,c.first_name,c.last_name,c.country,sum(il.unit_price*il.quantity) total_spent,
rank() over(partition by c.country order by sum(il.unit_price*il.quantity) desc) rnk
from customer c join invoice i on c.customer_id=i.customer_id
join invoice_line il on i.invoice_id=il.invoice_id join
track t on il.track_id=t.track_id group by c.customer_id,c.first_name,c.last_name,c.country
) select * from top_customer where rnk=1 

