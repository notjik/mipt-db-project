SET search_path TO mipt_project;

SELECT title, created_at
FROM tracks
ORDER BY created_at DESC
LIMIT 5;
