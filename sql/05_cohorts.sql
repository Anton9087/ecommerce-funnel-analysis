-- 5. Недельные когорты: неделя первого визита -> сколько вернулось через N недель
WITH first_week AS (
    SELECT user_id,
           date_trunc('week', min(event_time))::date AS cohort_week
    FROM events
    GROUP BY user_id
),
activity AS (
    SELECT DISTINCT user_id,
           date_trunc('week', event_time)::date AS activity_week
    FROM events
)
SELECT f.cohort_week,
       (a.activity_week - f.cohort_week) / 7 AS week_number,
       count(*)                              AS users
FROM first_week f
JOIN activity a USING (user_id)
GROUP BY f.cohort_week, week_number
ORDER BY f.cohort_week, week_number;
