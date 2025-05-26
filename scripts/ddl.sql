-- Пересоздаём схему mipt_project
DROP SCHEMA IF EXISTS mipt_project CASCADE;
CREATE SCHEMA mipt_project;

-- Таблица пользователей
CREATE TABLE IF NOT EXISTS mipt_project.users
(
    id            SERIAL PRIMARY KEY,
    username      VARCHAR(255) UNIQUE NOT NULL,
    email         VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255)        NOT NULL,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица исполнителей
CREATE TABLE IF NOT EXISTS mipt_project.artists
(
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(255) NOT NULL,
    bio        TEXT,
    user_id    INTEGER      REFERENCES mipt_project.users (id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица жанров
CREATE TABLE IF NOT EXISTS mipt_project.genres
(
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100) UNIQUE NOT NULL,
    description TEXT
);

-- Таблица альбомов
CREATE TABLE IF NOT EXISTS mipt_project.albums
(
    id           SERIAL PRIMARY KEY,
    artist_id    INTEGER      NOT NULL REFERENCES mipt_project.artists (id) ON DELETE CASCADE,
    title        VARCHAR(255) NOT NULL,
    release_date DATE DEFAULT CURRENT_DATE,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица плейлистов
CREATE TABLE IF NOT EXISTS mipt_project.playlists
(
    id          SERIAL PRIMARY KEY,
    user_id     INTEGER      NOT NULL REFERENCES mipt_project.users (id) ON DELETE CASCADE,
    title       VARCHAR(255) NOT NULL,
    description TEXT,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица треков
CREATE TABLE IF NOT EXISTS mipt_project.tracks
(
    id           SERIAL PRIMARY KEY,
    album_id     INTEGER      NOT NULL REFERENCES mipt_project.albums (id) ON DELETE CASCADE,
    title        VARCHAR(255) NOT NULL,
    duration     INTEGER NOT NULL CHECK ( duration > 0 ), -- продолжительность в секундах
    track_number INTEGER NOT NULL,
    track_url    TEXT NOT NULL,    -- ссылка на аудиофайл для подгрузки
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_track_number_per_album UNIQUE (album_id, track_number)
);

-- Вспомогательная таблица для связи треков и жанров (многие ко многим)
CREATE TABLE IF NOT EXISTS mipt_project.track_genres
(
    track_id    INTEGER NOT NULL REFERENCES mipt_project.tracks (id) ON DELETE CASCADE,
    genre_id    INTEGER NOT NULL REFERENCES mipt_project.genres (id) ON DELETE CASCADE,
    PRIMARY KEY (track_id, genre_id)
);

-- Вспомогательная таблица для связи плейлистов и треков (многие ко многим)
CREATE TABLE IF NOT EXISTS mipt_project.playlist_tracks
(
    playlist_id INTEGER NOT NULL REFERENCES mipt_project.playlists (id) ON DELETE CASCADE,
    track_id    INTEGER NOT NULL REFERENCES mipt_project.tracks (id) ON DELETE CASCADE,
    position    INTEGER NOT NULL CHECK ( position > 0 ), -- порядок трека в плейлисте
    PRIMARY KEY (playlist_id, track_id),
    CONSTRAINT unique_track_position_per_playlist UNIQUE (playlist_id, position)
);

-- Вспомогательная таблица с историей прослушивания треков (многие-ко-многим)
CREATE TABLE mipt_project.listened_tracks (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES mipt_project.users(id) ON DELETE CASCADE,
    track_id INTEGER NOT NULL REFERENCES mipt_project.tracks(id) ON DELETE CASCADE,
    listened_at TIMESTAMP NOT NULL DEFAULT NOW()
);