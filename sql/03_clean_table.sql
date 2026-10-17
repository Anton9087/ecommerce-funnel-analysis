-- 3. Чистая таблица events: без дублей, с нормальным типом даты, без неверных цен
DROP TABLE IF EXISTS events;
CREATE TABLE events AS
SELECT DISTINCT
       replace(event_time, ' UTC', '')::timestamp AS event_time,  -- время в UTC, без приписки
       event_type, product_id, category_id,
       NULLIF(brand, '') AS brand,                                 -- пустая строка -> NULL
       price, user_id, user_session
FROM events_raw
WHERE price > 0;                                                   -- нулевые и отрицательные цены убираем

-- Индексы ускоряют группировки по пользователю и сессии
CREATE INDEX ON events (user_id);
CREATE INDEX ON events (user_session);
ANALYZE events;
