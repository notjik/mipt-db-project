SET search_path TO mipt_project;

SELECT
    t.album_id,
    t.title,
    t.duration,
    RANK() OVER (PARTITION BY t.album_id ORDER BY t.duration DESC) AS duration_rank
FROM tracks t;
