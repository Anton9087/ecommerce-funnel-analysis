-- 8. Конверсия «товар в корзине -> этот же товар куплен в той же сессии» по ценовым квартилям
WITH carted AS (
    SELECT DISTINCT user_session, product_id, price
    FROM events
    WHERE event_type = 'cart' AND user_session IS NOT NULL
),
bought AS (
    SELECT DISTINCT user_session, product_id
    FROM events
    WHERE event_type = 'purchase' AND user_session IS NOT NULL
),
segmented AS (
    SELECT c.*,
           ntile(4) OVER (ORDER BY c.price) AS price_quartile   -- оконная функция: 4 равные по размеру группы
    FROM carted c
)
SELECT s.price_quartile,
       min(s.price)                                       AS min_price,
       max(s.price)                                       AS max_price,
       count(*)                                           AS carted_items,
       count(b.product_id)                                AS bought_items,
       round(count(b.product_id)::numeric / count(*), 4)  AS cart_to_purchase
FROM segmented s
LEFT JOIN bought b USING (user_session, product_id)
GROUP BY s.price_quartile
ORDER BY s.price_quartile;
