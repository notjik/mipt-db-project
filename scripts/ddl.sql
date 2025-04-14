-- Пересоздаём схему mipt_project
DROP SCHEMA IF EXISTS mipt_project CASCADE;
CREATE SCHEMA mipt_project;

-- Устанавливаем search_path, чтобы использовать схему project
SET search_path TO mipt_project;

-- Таблица пользователей
CREATE TABLE IF NOT EXISTS users
(
    id            SERIAL PRIMARY KEY,
    username      VARCHAR(255) UNIQUE NOT NULL,
    email         VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255)        NOT NULL,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица исполнителей
CREATE TABLE IF NOT EXISTS artists
(
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(255) NOT NULL,
    bio        TEXT,
    user_id    INTEGER      REFERENCES users (id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица жанров
CREATE TABLE IF NOT EXISTS genres
(
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100) UNIQUE NOT NULL,
    description TEXT
);

-- Таблица альбомов
CREATE TABLE IF NOT EXISTS albums
(
    id           SERIAL PRIMARY KEY,
    artist_id    INTEGER      NOT NULL REFERENCES artists (id) ON DELETE CASCADE,
    title        VARCHAR(255) NOT NULL,
    release_date DATE DEFAULT CURRENT_DATE,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Таблица плейлистов
CREATE TABLE IF NOT EXISTS playlists
(
    id          SERIAL PRIMARY KEY,
    user_id     INTEGER      NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    title       VARCHAR(255) NOT NULL,
    description TEXT,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица треков
CREATE TABLE IF NOT EXISTS tracks
(
    id           SERIAL PRIMARY KEY,
    album_id     INTEGER      NOT NULL REFERENCES albums (id) ON DELETE CASCADE,
    title        VARCHAR(255) NOT NULL,
    duration     INTEGER NOT NULL CHECK ( duration > 0 ), -- продолжительность в секундах
    track_number INTEGER NOT NULL,
    track_url    TEXT NOT NULL,    -- ссылка на аудиофайл для подгрузки
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_track_number_per_album UNIQUE (album_id, track_number)
);

-- Вспомогательная таблица для связи треков и жанров (многие ко многим)
CREATE TABLE IF NOT EXISTS track_genres
(
    track_id    INTEGER NOT NULL REFERENCES tracks (id) ON DELETE CASCADE,
    genre_id    INTEGER NOT NULL REFERENCES genres (id) ON DELETE CASCADE,
    PRIMARY KEY (track_id, genre_id)
);

-- Вспомогательная таблица для связи плейлистов и треков (многие ко многим)
CREATE TABLE IF NOT EXISTS playlist_tracks
(
    playlist_id INTEGER NOT NULL REFERENCES playlists (id) ON DELETE CASCADE,
    track_id    INTEGER NOT NULL REFERENCES tracks (id) ON DELETE CASCADE,
    position    INTEGER NOT NULL CHECK ( position > 0 ), -- порядок трека в плейлисте
    PRIMARY KEY (playlist_id, track_id),
    CONSTRAINT unique_track_position_per_playlist UNIQUE (playlist_id, position)
);

-- Таблица с версионированием Users
CREATE TABLE users_history (
                               history_id SERIAL PRIMARY KEY,
                               user_id INT REFERENCES users(id) ON DELETE SET NULL,
                               username VARCHAR(255),
                               email VARCHAR(255),
                               password_hash VARCHAR(255),
                               created_at TIMESTAMP,
                               operation_type VARCHAR(10) NOT NULL,
                               changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица с версионированием Artists
CREATE TABLE artists_history (
                                 history_id SERIAL PRIMARY KEY,
                                 artist_id INT REFERENCES artists(id) ON DELETE SET NULL,
                                 name VARCHAR(255),
                                 bio TEXT,
                                 user_id INT,
                                 created_at TIMESTAMP,
                                 operation_type VARCHAR(10) NOT NULL,
                                 changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица с версионированием Genres
CREATE TABLE genres_history (
                                history_id SERIAL PRIMARY KEY,
                                genre_id INT REFERENCES genres(id) ON DELETE SET NULL,
                                name VARCHAR(100),
                                description TEXT,
                                operation_type VARCHAR(10) NOT NULL,
                                changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица с версионированием Albums
CREATE TABLE albums_history (
                                history_id SERIAL PRIMARY KEY,
                                album_id INT REFERENCES albums(id) ON DELETE SET NULL,
                                artist_id INT,
                                title VARCHAR(255),
                                release_date DATE,
                                created_at TIMESTAMP,
                                operation_type VARCHAR(10) NOT NULL,
                                changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица с версионированием Tracks
CREATE TABLE tracks_history (
                                history_id SERIAL PRIMARY KEY,
                                track_id INT REFERENCES tracks(id) ON DELETE SET NULL,
                                album_id INT,
                                title VARCHAR(255),
                                duration INT,
                                track_number INT,
                                track_url TEXT,
                                created_at TIMESTAMP,
                                operation_type VARCHAR(10) NOT NULL,
                                changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица с версионированием Playlists
CREATE TABLE playlists_history (
                                   history_id SERIAL PRIMARY KEY,
                                   playlist_id INT REFERENCES playlists(id) ON DELETE SET NULL,
                                   user_id INT,
                                   title VARCHAR(255),
                                   description TEXT,
                                   created_at TIMESTAMP,
                                   operation_type VARCHAR(10) NOT NULL,
                                   changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица с версионированием связи TrackGenres
CREATE TABLE track_genres_history (
                                      history_id SERIAL PRIMARY KEY,
                                      track_id INT,
                                      genre_id INT,
                                      operation_type VARCHAR(10) NOT NULL,
                                      changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица с версионированием связи PlaylistTracks
CREATE TABLE playlist_tracks_history (
                                         history_id SERIAL PRIMARY KEY,
                                         playlist_id INT,
                                         track_id INT,
                                         position INT,
                                         operation_type VARCHAR(10) NOT NULL,
                                         changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Триггеры для основных таблиц
CREATE OR REPLACE FUNCTION log_entity_history() RETURNS TRIGGER AS $$
BEGIN
    IF TG_TABLE_NAME = 'users' THEN
        INSERT INTO users_history (
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
        INSERT INTO artists_history (
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
        INSERT INTO genres_history (
            genre_id, name, description, operation_type
        ) VALUES (
                     CASE TG_OP WHEN 'DELETE' THEN OLD.id ELSE NEW.id END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.name ELSE NEW.name END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.description ELSE NEW.description END,
                     TG_OP
                 );
    ELSIF TG_TABLE_NAME = 'albums' THEN
        INSERT INTO albums_history (
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
        INSERT INTO tracks_history (
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
        INSERT INTO playlists_history (
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
CREATE OR REPLACE FUNCTION log_relation_history() RETURNS TRIGGER AS $$
BEGIN
    IF TG_TABLE_NAME = 'track_genres' THEN
        INSERT INTO track_genres_history (
            track_id, genre_id, operation_type
        ) VALUES (
                     CASE TG_OP WHEN 'DELETE' THEN OLD.track_id ELSE NEW.track_id END,
                     CASE TG_OP WHEN 'DELETE' THEN OLD.genre_id ELSE NEW.genre_id END,
                     TG_OP
                 );
    ELSIF TG_TABLE_NAME = 'playlist_tracks' THEN
        INSERT INTO playlist_tracks_history (
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

-- Активация триггеров для всех страниц
CREATE TRIGGER users_audit AFTER INSERT OR UPDATE OR DELETE ON users
    FOR EACH ROW EXECUTE FUNCTION log_entity_history();

CREATE TRIGGER artists_audit AFTER INSERT OR UPDATE OR DELETE ON artists
    FOR EACH ROW EXECUTE FUNCTION log_entity_history();

CREATE TRIGGER genres_audit AFTER INSERT OR UPDATE OR DELETE ON genres
    FOR EACH ROW EXECUTE FUNCTION log_entity_history();

CREATE TRIGGER albums_audit AFTER INSERT OR UPDATE OR DELETE ON albums
    FOR EACH ROW EXECUTE FUNCTION log_entity_history();

CREATE TRIGGER tracks_audit AFTER INSERT OR UPDATE OR DELETE ON tracks
    FOR EACH ROW EXECUTE FUNCTION log_entity_history();

CREATE TRIGGER playlists_audit AFTER INSERT OR UPDATE OR DELETE ON playlists
    FOR EACH ROW EXECUTE FUNCTION log_entity_history();

CREATE TRIGGER track_genres_audit AFTER INSERT OR DELETE ON track_genres
    FOR EACH ROW EXECUTE FUNCTION log_relation_history();

CREATE TRIGGER playlist_tracks_audit AFTER INSERT OR UPDATE OR DELETE ON playlist_tracks
    FOR EACH ROW EXECUTE FUNCTION log_relation_history();