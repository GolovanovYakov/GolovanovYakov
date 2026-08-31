WITH unique_user_bookings AS (
    -- Шаг 1: Находим только уникальные бронирования для каждого пассажира по его ID
    SELECT DISTINCT passenger_id, book_ref
    FROM tickets
),
booked_sequences AS (
    -- Шаг 2: Нумеруем бронирования по порядку для каждого уникального пользователя
    SELECT 
        passenger_id,
        ROW_NUMBER() OVER(PARTITION BY passenger_id ORDER BY book_ref) AS booking_order
    FROM unique_user_bookings
)
-- Шаг 3: Считаем пользователей на каждом шаге для построения воронки удержания
SELECT 
    booking_order AS "Порядковый номер бронирования",
    COUNT(*) AS "Количество пользователей"
FROM booked_sequences
GROUP BY booking_order
ORDER BY booking_order;
