SET search_path TO mipt_project;

SELECT t.title, p.title AS playlist_title, pt.position
FROM playlist_tracks pt
         JOIN tracks t ON pt.track_id = t.id
         JOIN playlists p ON pt.playlist_id = p.id
WHERE t.created_at > p.created_at;
