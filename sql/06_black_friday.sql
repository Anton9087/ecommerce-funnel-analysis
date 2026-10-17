-- 6. Конверсия «корзина -> покупка» по сессиям: неделя Чёрной пятницы vs обычные дни ноября
WITH sessions AS (
    SELECT user_session,
           min(event_time)::date            AS session_date,
           bool_or(event_type = 'cart')     AS carted,
           bool_or(event_type = 'purchase') AS purchased
    FROM events
    WHERE event_time >= '2019-11-01'
      AND user_session IS NOT NULL
    GROUP BY user_session
)
SELECT CASE WHEN session_date BETWEEN '2019-11-25' AND '2019-11-30'
            THEN 'black_friday_week' ELSE 'regular' END    AS period,
       count(DISTINCT session_date)                       AS days,
       count(*) FILTER (WHERE carted)                     AS sessions_with_cart,
       count(*) FILTER (WHERE carted AND purchased)       AS sessions_with_purchase
FROM sessions
GROUP BY period;
