SELECT DISTINCT 
    ts.contact_data->>'email' AS email
FROM flights AS fl
INNER JOIN airports_data AS ap ON ap.airport_code = fl.arrival_airport
INNER JOIN ticket_flights AS tf ON tf.flight_id = fl.flight_id
INNER JOIN tickets AS ts ON ts.ticket_no = tf.ticket_no
WHERE EXTRACT(MONTH FROM fl.scheduled_departure) IN (6, 7, 8)
  AND ap.city->>'ru' = 'Москва'
  AND ts.contact_data->>'email' IS NOT NULL;
