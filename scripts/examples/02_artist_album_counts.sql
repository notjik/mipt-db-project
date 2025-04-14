SET search_path TO mipt_project;

SELECT a.id, a.name, COUNT(al.id) AS album_count
FROM artists a
         LEFT JOIN albums al ON al.artist_id = a.id
GROUP BY a.id, a.name
HAVING COUNT(al.id) >= 1
ORDER BY album_count DESC;
