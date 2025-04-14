SET search_path TO mipt_project;

SELECT t.id, t.title
FROM tracks t
WHERE t.id IN (
    SELECT track_id
    FROM playlist_tracks
    GROUP BY track_id
    HAVING COUNT(DISTINCT playlist_id) >= 2
);
