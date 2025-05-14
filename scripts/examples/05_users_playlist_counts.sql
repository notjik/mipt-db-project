SET search_path TO mipt_project;

SELECT u.username, COUNT(p.id) AS playlist_count
FROM users u
         LEFT JOIN playlists p ON p.user_id = u.id
GROUP BY u.username
ORDER BY playlist_count DESC;
