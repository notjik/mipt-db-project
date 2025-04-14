SET search_path TO mipt_project;

SELECT playlist_id, title, changed_at
FROM playlists_history
WHERE operation_type = 'DELETE';
