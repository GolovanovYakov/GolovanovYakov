SELECT COUNT(DISTINCT aircraft_code)
FROM flights
WHERE EXTRACT(MONTH FROM scheduled_departure) = 5
AND EXTRACT(YEAR FROM scheduled_departure) = 2017