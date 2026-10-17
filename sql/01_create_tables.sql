-- 1. Таблица для «сырых» данных: всё как в CSV
DROP TABLE IF EXISTS events_raw;
CREATE TABLE events_raw (
    event_time    text,           -- дата в виде текста: '2019-10-01 00:00:00 UTC'
    event_type    text,           -- view / cart / remove_from_cart / purchase
    product_id    bigint,
    category_id   bigint,
    category_code text,
    brand         text,
    price         numeric(10, 2),
    user_id       bigint,
    user_session  text
);
