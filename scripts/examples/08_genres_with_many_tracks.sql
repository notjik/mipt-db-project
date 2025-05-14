SET search_path TO mipt_project;

SELECT g.name AS genre_name, COUNT(tg.track_id) AS track_count
FROM genres g
         JOIN track_genres tg ON g.id = tg.genre_id
GROUP BY g.name
HAVING COUNT(tg.track_id) > 2;
