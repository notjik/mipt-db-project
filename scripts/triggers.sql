-- Триггеры для основных таблиц
CREATE OR REPLACE FUNCTION mipt_project.log_entity_history() RETURNS TRIGGER AS $$
BEGIN
    IF TG_TABLE_NAME = 'users' THEN
        INSERT INTO mipt_project.users_history (
            user_id, username, email, password_hash, created_at, operation_type
        ) VALUES (
                     CASE TG_OP WHEN 'DELETE' THEN OLD.id ELSE NEW.id END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.username ELSE NEW.username END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.email ELSE NEW.email END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.password_hash ELSE NEW.password_hash END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.created_at ELSE NEW.created_at END,
                     TG_OP
                 );
    ELSIF TG_TABLE_NAME = 'artists' THEN
        INSERT INTO mipt_project.artists_history (
            artist_id, name, bio, user_id, created_at, operation_type
        ) VALUES (
                     CASE TG_OP WHEN 'DELETE' THEN OLD.id ELSE NEW.id END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.name ELSE NEW.name END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.bio ELSE NEW.bio END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.user_id ELSE NEW.user_id END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.created_at ELSE NEW.created_at END,
                     TG_OP
                 );
    ELSIF TG_TABLE_NAME = 'genres' THEN
        INSERT INTO mipt_project.genres_history (
            genre_id, name, description, operation_type
        ) VALUES (
                     CASE TG_OP WHEN 'DELETE' THEN OLD.id ELSE NEW.id END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.name ELSE NEW.name END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.description ELSE NEW.description END,
                     TG_OP
                 );
    ELSIF TG_TABLE_NAME = 'albums' THEN
        INSERT INTO mipt_project.albums_history (
            album_id, artist_id, title, release_date, created_at, operation_type
        ) VALUES (
                     CASE TG_OP WHEN 'DELETE' THEN OLD.id ELSE NEW.id END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.artist_id ELSE NEW.artist_id END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.title ELSE NEW.title END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.release_date ELSE NEW.release_date END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.created_at ELSE NEW.created_at END,
                     TG_OP
                 );
    ELSIF TG_TABLE_NAME = 'tracks' THEN
        INSERT INTO mipt_project.tracks_history (
            track_id, album_id, title, duration, track_number, track_url, created_at, operation_type
        ) VALUES (
                     CASE TG_OP WHEN 'DELETE' THEN OLD.id ELSE NEW.id END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.album_id ELSE NEW.album_id END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.title ELSE NEW.title END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.duration ELSE NEW.duration END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.track_number ELSE NEW.track_number END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.track_url ELSE NEW.track_url END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.created_at ELSE NEW.created_at END,
                     TG_OP
                 );
    ELSIF TG_TABLE_NAME = 'playlists' THEN
        INSERT INTO mipt_project.playlists_history (
            playlist_id, user_id, title, description, created_at, operation_type
        ) VALUES (
                     CASE TG_OP WHEN 'DELETE' THEN OLD.id ELSE NEW.id END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.user_id ELSE NEW.user_id END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.title ELSE NEW.title END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.description ELSE NEW.description END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.created_at ELSE NEW.created_at END,
                     TG_OP
                 );
    END IF;

    RETURN CASE TG_OP WHEN 'DELETE' THEN OLD ELSE NEW END;
END;
$$ LANGUAGE plpgsql;

-- Триггеры для связующих таблиц
CREATE OR REPLACE FUNCTION mipt_project.log_relation_history() RETURNS TRIGGER AS $$
BEGIN
    IF TG_TABLE_NAME = 'track_genres' THEN
        INSERT INTO mipt_project.track_genres_history (
            track_id, genre_id, operation_type
        ) VALUES (
                     CASE TG_OP WHEN 'DELETE' THEN OLD.track_id ELSE NEW.track_id END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.genre_id ELSE NEW.genre_id END,
                     TG_OP
                 );
    ELSIF TG_TABLE_NAME = 'playlist_tracks' THEN
        INSERT INTO mipt_project.playlist_tracks_history (
            playlist_id, track_id, position, operation_type
        ) VALUES (
                     CASE TG_OP WHEN 'DELETE' THEN OLD.playlist_id ELSE NEW.playlist_id END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.track_id ELSE NEW.track_id END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.position ELSE NEW.position END,
                     TG_OP
                 );
    END IF;

    RETURN CASE TG_OP WHEN 'DELETE' THEN OLD ELSE NEW END;
END;
$$ LANGUAGE plpgsql;

-- Функция-триггер для автоматического создания плейлиста "Любимые треки" при добавлении нового пользователя
CREATE OR REPLACE FUNCTION mipt_project.create_default_favorites_playlist() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO mipt_project.playlists (
        user_id,
        title,
        description,
        created_at
    )
    VALUES (
               NEW.id,
               'Любимые треки',
               'Автоматически созданный плейлист по умолчанию',
               CURRENT_TIMESTAMP
           );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Активация триггеров для всех основных таблиц и связей

-- users
DROP TRIGGER IF EXISTS users_audit ON mipt_project.users;
CREATE TRIGGER users_audit
    AFTER INSERT OR UPDATE OR DELETE ON mipt_project.users
    FOR EACH ROW EXECUTE FUNCTION mipt_project.log_entity_history();

-- artists
DROP TRIGGER IF EXISTS artists_audit ON mipt_project.artists;
CREATE TRIGGER artists_audit
    AFTER INSERT OR UPDATE OR DELETE ON mipt_project.artists
    FOR EACH ROW EXECUTE FUNCTION mipt_project.log_entity_history();

-- genres
DROP TRIGGER IF EXISTS genres_audit ON mipt_project.genres;
CREATE TRIGGER genres_audit
    AFTER INSERT OR UPDATE OR DELETE ON mipt_project.genres
    FOR EACH ROW EXECUTE FUNCTION mipt_project.log_entity_history();

-- albums
DROP TRIGGER IF EXISTS albums_audit ON mipt_project.albums;
CREATE TRIGGER albums_audit
    AFTER INSERT OR UPDATE OR DELETE ON mipt_project.albums
    FOR EACH ROW EXECUTE FUNCTION mipt_project.log_entity_history();

-- tracks
DROP TRIGGER IF EXISTS tracks_audit ON mipt_project.tracks;
CREATE TRIGGER tracks_audit
    AFTER INSERT OR UPDATE OR DELETE ON mipt_project.tracks
    FOR EACH ROW EXECUTE FUNCTION mipt_project.log_entity_history();

-- playlists
DROP TRIGGER IF EXISTS playlists_audit ON mipt_project.playlists;
CREATE TRIGGER playlists_audit
    AFTER INSERT OR UPDATE OR DELETE ON mipt_project.playlists
    FOR EACH ROW EXECUTE FUNCTION mipt_project.log_entity_history();

-- track_genres
DROP TRIGGER IF EXISTS track_genres_audit ON mipt_project.track_genres;
CREATE TRIGGER track_genres_audit
    AFTER INSERT OR DELETE ON mipt_project.track_genres
    FOR EACH ROW EXECUTE FUNCTION mipt_project.log_relation_history();

-- playlist_tracks
DROP TRIGGER IF EXISTS playlist_tracks_audit ON mipt_project.playlist_tracks;
CREATE TRIGGER playlist_tracks_audit
    AFTER INSERT OR UPDATE OR DELETE ON mipt_project.playlist_tracks
    FOR EACH ROW EXECUTE FUNCTION mipt_project.log_relation_history();

-- Триггер, который вызывает функцию после вставки новой записи в users
DROP TRIGGER IF EXISTS trg_users_create_favorites ON mipt_project.users;
CREATE TRIGGER trg_users_create_favorites
    AFTER INSERT ON mipt_project.users
    FOR EACH ROW
EXECUTE FUNCTION mipt_project.create_default_favorites_playlist();