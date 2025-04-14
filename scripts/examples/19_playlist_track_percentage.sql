SET search_path TO mipt_project;

SELECT
    p.title,
    COUNT(pt.track_id) AS track_count,
    ROUND(100.0 * COUNT(pt.track_id) / SUM(COUNT(pt.track_id)) OVER (), 2) AS percent_of_total
FROM playlists p
         JOIN playlist_tracks pt ON pt.playlist_id = p.id
GROUP BY p.id
ORDER BY percent_of_total DESC;
