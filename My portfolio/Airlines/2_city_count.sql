SELECT 
    ap.city->>'ru' AS city_name,
    COUNT(fl.flight_id) AS flights_count
FROM flights AS fl
INNER JOIN airports_data AS ap ON ap.airport_code = fl.arrival_airport
WHERE EXTRACT(YEAR FROM fl.scheduled_departure) = 2017	
GROUP BY ap.city->>'ru'
ORDER BY COUNT(fl.flight_id) DESC;
