SET search_path TO mipt_project;

SELECT track_id, duration, prev_duration
FROM (
         SELECT
             track_id,
             duration,
             LAG(duration) OVER (PARTITION BY track_id ORDER BY changed_at) AS prev_duration
         FROM tracks_history
         WHERE duration IS NOT NULL
     ) t
WHERE prev_duration IS NOT NULL AND duration <> prev_duration
GROUP BY track_id, duration, prev_duration;


