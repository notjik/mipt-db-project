SET search_path TO mipt_project;

SELECT
    g.name AS genre,
    t.title AS track,
    t.duration,
    RANK() OVER (PARTITION BY g.id ORDER BY t.duration DESC) AS rank_within_genre
FROM track_genres tg
         JOIN genres g ON tg.genre_id = g.id
         JOIN tracks t ON tg.track_id = t.id
ORDER BY g.name, rank_within_genre;
