SET search_path TO mipt_project;

SELECT DISTINCT p.id, p.title
FROM playlists p
WHERE EXISTS (
    SELECT 1
    FROM playlist_tracks pt
             JOIN track_genres tg ON pt.track_id = tg.track_id
             JOIN genres g ON tg.genre_id = g.id
    WHERE pt.playlist_id = p.id AND g.name = 'Rock'
);
