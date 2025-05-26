-- Индекс для ускорения выборок по прослушанным трекам
CREATE INDEX IF NOT EXISTS idx_listening_history_user
    ON mipt_project.listened_tracks(user_id);

-- Индекс для быстрого поиска пользователя по username
CREATE INDEX IF NOT EXISTS idx_users_username
    ON mipt_project.users(username);

-- Индекс для быстрого JOIN'а в музыкальном приложении
CREATE INDEX IF NOT EXISTS idx_tracks_album_id
    ON mipt_project.tracks(album_id);

-- Индекс для быстрого получения плейлистов пользователя
CREATE INDEX IF NOT EXISTS idx_playlists_user_id
    ON mipt_project.playlists(user_id);

-- Индекс для быстрого получения треков в плейлисте по порядку
CREATE INDEX IF NOT EXISTS idx_playlist_tracks_playlist_position
    ON mipt_project.playlist_tracks(playlist_id, position);

-- Индекс для быстрого поиска трека по названию
CREATE INDEX IF NOT EXISTS idx_tracks_title_gin
    ON mipt_project.tracks USING gin(to_tsvector('russian', title));

-- Индекс для быстрой сортировке по дате релиза
CREATE INDEX idx_albums_release_date ON mipt_project.albums(artist_id, release_date DESC);

-- Индекс по времени изменения в таблице users_history
CREATE INDEX IF NOT EXISTS idx_users_history_changed_at
    ON mipt_project.users_history(changed_at);

-- Индекс по типу операции в таблице tracks_history
CREATE INDEX IF NOT EXISTS idx_tracks_history_operation_type
    ON mipt_project.tracks_history(operation_type);

-- Индекс для ускорения выборок по связке в таблице playlist_tracks_history
CREATE INDEX IF NOT EXISTS idx_playlist_tracks_history_playlist
    ON mipt_project.playlist_tracks_history(playlist_id);