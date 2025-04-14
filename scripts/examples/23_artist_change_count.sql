SET search_path TO mipt_project;

SELECT artist_id, COUNT(*) AS change_count
FROM artists_history
GROUP BY artist_id
ORDER BY change_count DESC;