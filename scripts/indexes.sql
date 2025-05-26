-- Индекс по времени изменения в таблице users_history
CREATE INDEX IF NOT EXISTS idx_users_history_changed_at
    ON mipt_project.users_history(changed_at);

-- Индекс по типу операции в таблице tracks_history
CREATE INDEX IF NOT EXISTS idx_tracks_history_operation_type
    ON mipt_project.tracks_history(operation_type);

-- Индекс для ускорения выборок по связке в таблице playlist_tracks_history
CREATE INDEX IF NOT EXISTS idx_playlist_tracks_history_playlist
    ON mipt_project.playlist_tracks_history(playlist_id);

-- Индекс для ускорения выборок по связке в таблице playlist_tracks_history
CREATE INDEX IF NOT EXISTS idx_listening_history_user
    ON mipt_project.listened_tracks(user_id);