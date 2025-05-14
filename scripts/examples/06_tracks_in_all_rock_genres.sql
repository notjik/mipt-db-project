SET search_path TO mipt_project;

SELECT t.title
FROM tracks t
WHERE NOT EXISTS (
    SELECT 1
    FROM genres g
    WHERE name ILIKE '%rock%'
      AND NOT EXISTS (
        SELECT 1
        FROM track_genres tg
        WHERE tg.track_id = t.id AND tg.genre_id = g.id
    )
);
