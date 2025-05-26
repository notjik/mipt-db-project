-- View 1: Представление с музыкальными предпочтениями пользователя
CREATE OR REPLACE VIEW mipt_project.user_music_profile AS
SELECT
    u.id as user_id,
    u.username,
    -- Статистика прослушиваний
    COUNT(DISTINCT lt.track_id) as unique_tracks_listened,
    COUNT(lt.id) as total_listens,
    -- Любимый жанр (самый прослушиваемый)
    (
        SELECT g.name
        FROM mipt_project.listened_tracks lt2
        JOIN mipt_project.tracks t2 ON lt2.track_id = t2.id
        JOIN mipt_project.track_genres tg2 ON t2.id = tg2.track_id
        JOIN mipt_project.genres g ON tg2.genre_id = g.id
        WHERE lt2.user_id = u.id
        GROUP BY g.name
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) as favorite_genre,
    -- Любимый артист
    (
        SELECT ar.name
        FROM mipt_project.listened_tracks lt3
        JOIN mipt_project.tracks t3 ON lt3.track_id = t3.id
        JOIN mipt_project.albums al3 ON t3.album_id = al3.id
        JOIN mipt_project.artists ar ON al3.artist_id = ar.id
        WHERE lt3.user_id = u.id
        GROUP BY ar.name
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) as favorite_artist,
    -- Активность за последние 30 дней
    (
        SELECT COUNT(*)
        FROM mipt_project.listened_tracks lt4
        WHERE lt4.user_id = u.id
          AND lt4.listened_at >= CURRENT_DATE - INTERVAL '30 days'
    ) as listens_last_30_days,
    -- Средняя длительность прослушиваемых треков
    (
        SELECT ROUND(AVG(t5.duration)::numeric, 0)
        FROM mipt_project.listened_tracks lt5
        JOIN mipt_project.tracks t5 ON lt5.track_id = t5.id
        WHERE lt5.user_id = u.id
    ) as avg_track_duration_seconds
FROM mipt_project.users u
LEFT JOIN mipt_project.listened_tracks lt ON u.id = lt.user_id
GROUP BY u.id, u.username;

-- View 2: -- Подробная статистика по артистам
CREATE OR REPLACE VIEW mipt_project.artist_analytics AS
SELECT
    ar.id as artist_id,
    ar.name as artist_name,
    ar.created_at as artist_since,
    -- Количество альбомов и треков
    COUNT(DISTINCT al.id) as albums_count,
    COUNT(DISTINCT t.id) as tracks_count,
    -- Статистика прослушиваний
    COUNT(lt.id) as total_listens,
    COUNT(DISTINCT lt.user_id) as unique_listeners,
    -- Популярность по времени
    COUNT(CASE WHEN lt.listened_at >= CURRENT_DATE - INTERVAL '7 days' THEN 1 END) as listens_last_week,
    COUNT(CASE WHEN lt.listened_at >= CURRENT_DATE - INTERVAL '30 days' THEN 1 END) as listens_last_month,
    -- Самый популярный трек
    (
        SELECT t2.title
        FROM mipt_project.tracks t2
        JOIN mipt_project.albums al2 ON t2.album_id = al2.id
        LEFT JOIN mipt_project.listened_tracks lt2 ON t2.id = lt2.track_id
        WHERE al2.artist_id = ar.id
        GROUP BY t2.id, t2.title
        ORDER BY COUNT(lt2.id) DESC
        LIMIT 1
    ) as most_popular_track,
    -- Средняя длительность треков
    ROUND(AVG(t.duration)::numeric, 0) as avg_track_duration,
    -- Жанры артиста
    STRING_AGG(DISTINCT g.name, ', ') as genres,
    -- Рейтинг среди всех артистов
    DENSE_RANK() OVER (ORDER BY COUNT(lt.id) DESC) as popularity_rank
FROM mipt_project.artists ar
LEFT JOIN mipt_project.albums al ON ar.id = al.artist_id
LEFT JOIN mipt_project.tracks t ON al.id = t.album_id
LEFT JOIN mipt_project.listened_tracks lt ON t.id = lt.track_id
LEFT JOIN mipt_project.track_genres tg ON t.id = tg.track_id
LEFT JOIN mipt_project.genres g ON tg.genre_id = g.id
GROUP BY ar.id, ar.name, ar.created_at
ORDER BY total_listens DESC NULLS LAST;