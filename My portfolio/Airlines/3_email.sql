WITH
cd AS (SELECT ts.contact_data
	  FROM flights AS fl
	  INNER JOIN airports AS ap ON ap.airport_code=fl.arrival_airport
	  INNER JOIN ticket_flights AS tf ON tf.flight_id=fl.flight_id
	  INNER JOIN tickets AS ts ON ts.ticket_no=rf.ricket_no
	  WHERE EXTRACT(MONTH FROM fl.scheduled_departure) IN (6, 7, 8)
	  AND ap.city = 'Москва')
SELECT js.value
FROM cd, jsonb_each(cd.contact_data) AS js
WHERE ls.key = 'email'