-- 4. Воронка на уровне пользователей (строгая: каждый шаг включает предыдущий)
WITH user_steps AS (
    SELECT user_id,
           bool_or(event_type = 'view')     AS viewed,
           bool_or(event_type = 'cart')     AS carted,
           bool_or(event_type = 'purchase') AS purchased
    FROM events
    GROUP BY user_id
)
SELECT count(*) FILTER (WHERE viewed)                         AS step1_view,
       count(*) FILTER (WHERE viewed AND carted)              AS step2_cart,
       count(*) FILTER (WHERE viewed AND carted AND purchased) AS step3_purchase
FROM user_steps;
