SELECT bc.book_count,
	   COUNT(*)
FROM (
	SELECT passenger_name, ROW_NUMBER() OVER(PARTITION BY passenger_name ORDER BY passenger_name) AS book_count
	FROM tickets) AS bc
GROUP BY bc.book_count
ORDER BY bc.book_count