SET search_path TO mipt_project;

SELECT p.id, p.title
FROM playlists p
         LEFT JOIN playlist_tracks pt ON pt.playlist_id = p.id
WHERE pt.track_id IS NULL;
