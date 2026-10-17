-- 7. Ежедневные метрики: активные пользователи, покупатели, заказы, выручка, средний чек
-- «Заказ» = сессия, в которой была хотя бы одна покупка (в данных нет номера заказа)
WITH daily AS (
    SELECT event_time::date                                                   AS day,
           count(DISTINCT user_id)                                            AS dau,
           count(DISTINCT user_id)      FILTER (WHERE event_type = 'purchase') AS buyers,
           count(DISTINCT user_session) FILTER (WHERE event_type = 'purchase') AS orders,
           coalesce(sum(price)          FILTER (WHERE event_type = 'purchase'), 0) AS revenue
    FROM events
    GROUP BY day
)
SELECT day, dau, buyers, orders, revenue,
       round(revenue / NULLIF(orders, 0), 2)   AS avg_order_value,   -- средний чек
       round(buyers::numeric / dau, 4)         AS buyer_share        -- доля покупателей среди активных
FROM daily
ORDER BY day;
