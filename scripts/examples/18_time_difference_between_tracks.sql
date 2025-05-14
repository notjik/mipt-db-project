SET search_path TO mipt_project;

SELECT
    title,
    created_at,
    LAG(created_at) OVER (ORDER BY created_at) AS previous_track_time,
    created_at - LAG(created_at) OVER (ORDER BY created_at) AS time_diff
FROM tracks
ORDER BY created_at;
