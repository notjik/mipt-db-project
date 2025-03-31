-- Создаём схему project
CREATE SCHEMA IF NOT EXISTS mipt_project;

-- Устанавливаем search_path, чтобы использовать схему project
SET search_path TO mipt_project;

-- Удаляем таблицы, если они уже существуют
DROP TABLE IF EXISTS playlist_tracks;
DROP TABLE IF EXISTS playlists;
DROP TABLE IF EXISTS tracks;
DROP TABLE IF EXISTS albums;
DROP TABLE IF EXISTS artists;
DROP TABLE IF EXISTS genres;
DROP TABLE IF EXISTS users;

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
    release_date DATE,
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
    genre_id     INTEGER      REFERENCES genres (id) ON DELETE SET NULL,
    title        VARCHAR(255) NOT NULL,
    duration     INTEGER, -- продолжительность в секундах
    track_number INTEGER,
    track_url    TEXT,    -- ссылка на аудиофайл для подгрузки
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_track_number_per_album UNIQUE (album_id, track_number)
);

-- Вспомогательная таблица для связи плейлистов и треков (многие ко многим)
CREATE TABLE IF NOT EXISTS playlist_tracks
(
    playlist_id INTEGER NOT NULL REFERENCES playlists (id) ON DELETE CASCADE,
    track_id    INTEGER NOT NULL REFERENCES tracks (id) ON DELETE CASCADE,
    position    INTEGER, -- порядок трека в плейлисте
    PRIMARY KEY (playlist_id, track_id),
    CONSTRAINT unique_track_position_per_playlist UNIQUE (playlist_id, position)
);
