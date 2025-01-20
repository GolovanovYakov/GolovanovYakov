SELECT ap.city AS city,
	COUNT(fl.flight_id)
FROM flights AS dl
INNER JOIN airports AS ap ON ap.airport_code=fl.arrival_airport
GROUP BY city
ORDER BY COUNT(fl.flight_id) DESC