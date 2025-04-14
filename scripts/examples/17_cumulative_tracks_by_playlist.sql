SET search_path TO mipt_project;

SELECT
    p.title AS playlist,
    COUNT(pt.track_id) AS track_count,
    SUM(COUNT(pt.track_id)) OVER (ORDER BY p.title) AS cumulative_tracks
FROM playlists p
         LEFT JOIN playlist_tracks pt ON pt.playlist_id = p.id
GROUP BY p.id
ORDER BY p.title;
