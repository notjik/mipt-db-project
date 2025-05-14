SET search_path TO mipt_project;

SELECT p.title AS playlist_title, t.title AS track_title, pt.position
FROM playlists p
         JOIN playlist_tracks pt ON pt.playlist_id = p.id
         JOIN tracks t ON t.id = pt.track_id
ORDER BY p.title, pt.position;
