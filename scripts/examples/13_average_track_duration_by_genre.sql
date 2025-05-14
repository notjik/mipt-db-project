SET search_path TO mipt_project;

SELECT
    g.name AS genre_name,
    ROUND(AVG(t.duration)) AS avg_duration
FROM genres g
         JOIN track_genres tg ON g.id = tg.genre_id
         JOIN tracks t ON t.id = tg.track_id
GROUP BY g.name
ORDER BY avg_duration DESC;
