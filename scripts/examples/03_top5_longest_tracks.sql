SET search_path TO mipt_project;

SELECT title, duration, track_url
FROM tracks
ORDER BY duration DESC
LIMIT 5;
