-- 1. Процедура: Добавление жанра к треку по имени жанра
CREATE OR REPLACE PROCEDURE mipt_project.add_genre_to_track(
    p_track_id    INT,
    p_genre_name  VARCHAR
)
LANGUAGE plpgsql AS $$
DECLARE
    v_genre_id INT;
BEGIN
    SELECT id INTO v_genre_id
    FROM mipt_project.genres
    WHERE name = p_genre_name;

    IF v_genre_id IS NULL THEN
        RAISE EXCEPTION 'Жанр "%" не найден', p_genre_name;
    END IF;

    INSERT INTO mipt_project.track_genres(track_id, genre_id)
    VALUES (p_track_id, v_genre_id)
    ON CONFLICT DO NOTHING;
END;
$$;

-- 2. Процедура: Добавления трека в историю прослушивания
CREATE OR REPLACE PROCEDURE mipt_project.listen_track(
    IN p_user_id INTEGER,
    IN p_track_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO mipt_project.listened_tracks (user_id, track_id)
    VALUES (p_user_id, p_track_id);
END;
$$;

-- 3. Функция: Средняя длительность треков артиста
CREATE OR REPLACE FUNCTION mipt_project.get_avg_track_duration_by_artist(
    p_artist_id INT
) RETURNS NUMERIC AS $$
DECLARE
    v_avg NUMERIC;
BEGIN
    SELECT AVG(duration) INTO v_avg
    FROM mipt_project.tracks t
    JOIN mipt_project.albums a ON t.album_id = a.id
    WHERE a.artist_id = p_artist_id;
    RETURN COALESCE(v_avg, 0);
END;
$$ LANGUAGE plpgsql;

-- 4. Табличная функция: Список треков по жанру
CREATE OR REPLACE FUNCTION mipt_project.get_tracks_by_genre(
    p_genre VARCHAR
) RETURNS TABLE(
    track_id   INT,
    track_title VARCHAR,
    album_title VARCHAR,
    artist_name VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.id,
        t.title,
        a.title,
        ar.name
    FROM mipt_project.tracks t
    JOIN mipt_project.track_genres tg ON tg.track_id = t.id
    JOIN mipt_project.genres g ON g.id = tg.genre_id
    JOIN mipt_project.albums a ON a.id = t.album_id
    JOIN mipt_project.artists ar ON ar.id = a.artist_id
    WHERE g.name = p_genre;
END;
$$ LANGUAGE plpgsql;