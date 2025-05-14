SET search_path TO mipt_project;

SELECT t.title AS track_title, g.name AS genre_name
FROM tracks t
         JOIN track_genres tg ON tg.track_id = t.id
         JOIN genres g ON g.id = tg.genre_id
ORDER BY track_title;
