-- Таблица с версионированием Users
CREATE TABLE mipt_project.users_history
(
    history_id     SERIAL PRIMARY KEY,
    user_id        INT,
    username       VARCHAR(255),
    email          VARCHAR(255),
    password_hash  VARCHAR(255),
    created_at     TIMESTAMP,
    operation_type VARCHAR(10) NOT NULL,
    changed_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица с версионированием Artists
CREATE TABLE mipt_project.artists_history
(
    history_id     SERIAL PRIMARY KEY,
    artist_id      INT,
    name           VARCHAR(255),
    bio            TEXT,
    user_id        INT,
    created_at     TIMESTAMP,
    operation_type VARCHAR(10) NOT NULL,
    changed_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица с версионированием Genres
CREATE TABLE mipt_project.genres_history
(
    history_id     SERIAL PRIMARY KEY,
    genre_id       INT,
    name           VARCHAR(100),
    description    TEXT,
    operation_type VARCHAR(10) NOT NULL,
    changed_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица с версионированием Albums
CREATE TABLE mipt_project.albums_history
(
    history_id     SERIAL PRIMARY KEY,
    album_id       INT,
    artist_id      INT,
    title          VARCHAR(255),
    release_date   DATE,
    created_at     TIMESTAMP,
    operation_type VARCHAR(10) NOT NULL,
    changed_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица с версионированием Tracks
CREATE TABLE mipt_project.tracks_history
(
    history_id     SERIAL PRIMARY KEY,
    track_id       INT,
    album_id       INT,
    title          VARCHAR(255),
    duration       INT,
    track_number   INT,
    track_url      TEXT,
    created_at     TIMESTAMP,
    operation_type VARCHAR(10) NOT NULL,
    changed_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица с версионированием Playlists
CREATE TABLE mipt_project.playlists_history
(
    history_id     SERIAL PRIMARY KEY,
    playlist_id    INT,
    user_id        INT,
    title          VARCHAR(255),
    description    TEXT,
    created_at     TIMESTAMP,
    operation_type VARCHAR(10) NOT NULL,
    changed_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица с версионированием связи TrackGenres
CREATE TABLE mipt_project.track_genres_history
(
    history_id     SERIAL PRIMARY KEY,
    track_id       INT,
    genre_id       INT,
    operation_type VARCHAR(10) NOT NULL,
    changed_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица с версионированием связи PlaylistTracks
CREATE TABLE mipt_project.playlist_tracks_history
(
    history_id     SERIAL PRIMARY KEY,
    playlist_id    INT,
    track_id       INT,
    position       INT,
    operation_type VARCHAR(10) NOT NULL,
    changed_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);