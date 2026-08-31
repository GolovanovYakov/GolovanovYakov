# ✈️ Исследование базы данных авиаперевозок

### 📊 Описание проекта
В данном проекте проводится анализ демонстрационной базы данных авиакомпании от [PostgresPro](https://postgrespro.ru). Цель проекта — решить комплекс бизнес-задач по оценке загруженности аэропортов, анализу маркетинговых активностей и поведению клиентов с помощью продвинутого SQL.

### 🛠️ Технологический стек
* **СУБД:** PostgreSQL
* **Язык запросов:** SQL (Оконные функции `ROW_NUMBER() OVER()`, обобщенные табличные выражения `WITH / CTE`, извлечение данных из JSONB-полей через `->>`)

---

### 📈 Задачи и решения

#### 1️⃣ Количество активных самолётов
**Задача:** Вывести количество уникальных самолётов, совершивших рейсы в мае 2017 года.

```sql
SELECT COUNT(DISTINCT aircraft_code) AS unique_aircrafts_count
FROM flights
WHERE EXTRACT(MONTH FROM scheduled_departure) = 5
  AND EXTRACT(YEAR FROM scheduled_departure) = 2017;
```

#### 2️⃣ Популярность туристических направлений
**Задача:** Вывести название города и количество совершённых в этот город перелётов за весь 2017 год. Результат отсортировать от самых популярных.

```sql
SELECT 
    ap.city->>'ru' AS city_name,
    COUNT(fl.flight_id) AS flights_count
FROM flights AS fl
INNER JOIN airports_data AS ap ON ap.airport_code = fl.arrival_airport
WHERE EXTRACT(YEAR FROM fl.scheduled_departure) = 2017	
GROUP BY ap.city->>'ru'
ORDER BY COUNT(fl.flight_id) DESC;
```

#### 3️⃣ Сбор контактов для маркетинговой кампании
**Задача:** Вывести уникальные e-mail почты пассажиров, купивших билеты на любой летний рейс (даже не состоявшийся) в Москву для проведения рассылки.

```sql
SELECT DISTINCT 
    ts.contact_data->>'email' AS email
FROM flights AS fl
INNER JOIN airports_data AS ap ON ap.airport_code = fl.arrival_airport
INNER JOIN ticket_flights AS tf ON tf.flight_id = fl.flight_id
INNER JOIN tickets AS ts ON ts.ticket_no = tf.ticket_no
WHERE EXTRACT(MONTH FROM fl.scheduled_departure) IN (6, 7, 8)
  AND ap.city->>'ru' = 'Москва'
  AND ts.contact_data->>'email' IS NOT NULL;
```

#### 4️⃣ Воронка повторных бронирований
**Задача:** Подсчитать количество первых, вторых, третьих и последующих бронирований пользователей. Представить результаты в виде воронки удержания (Retention).

```sql
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
```

---

### 💡 Ключевые выводы аналитика
* **Гео-аналитика:** Вторая задача наглядно показывает ключевые хабы авиакомпании по объёму входящего трафика за 2017 год. Это позволяет оптимизировать расписание рейсов и прогнозировать нагрузку на персонал наземных служб в популярных городах.
* **Маркетинг:** Третий запрос формирует чистую, сегментированную базу email-адресов клиентов (без дубликатов и пустых строк). Её можно сразу передавать в CRM-систему для запуска персонализированных летних промо-кампаний по московскому направлению.
* **Продуктовые метрики:** Четвёртый запрос строит классическую воронку повторных продаж (User Retention). Сравнение количества пользователей между 1-м и последующими шагами позволяет оценить LTV (жизненный цикл клиента) и эффективность программ лояльности авиакомпании.
