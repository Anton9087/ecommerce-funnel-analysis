-- 2. Проверки качества данных (запускать по одному запросу)

-- 2.1 Сколько строк и пользователей, какой период
SELECT count(*)                 AS rows_total,
       count(DISTINCT user_id)  AS users,
       min(event_time)          AS first_event,
       max(event_time)          AS last_event
FROM events_raw;

-- 2.2 Сколько событий каждого типа
SELECT event_type, count(*) AS events
FROM events_raw
GROUP BY event_type
ORDER BY events DESC;

-- 2.3 Полные дубли строк
SELECT count(*) - (SELECT count(*) FROM (SELECT DISTINCT * FROM events_raw) t) AS duplicate_rows
FROM events_raw;

-- 2.4 Пропуски и странные цены
SELECT count(*) FILTER (WHERE brand IS NULL OR brand = '')  AS no_brand,
       count(*) FILTER (WHERE user_session IS NULL)          AS no_session,
       count(*) FILTER (WHERE price <= 0)                    AS bad_price
FROM events_raw;
