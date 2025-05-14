SET search_path TO mipt_project;

SELECT
    title,
    duration,
    ROUND(AVG(duration) OVER (ORDER BY created_at ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS rolling_avg_duration
FROM tracks
ORDER BY created_at;
