SET search_path TO mipt_project;

SELECT *
FROM tracks_history
WHERE track_id = 5
ORDER BY changed_at ASC;
