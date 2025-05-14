-- Два представления для аналитики

-- View 1: Количество плейлистов на пользователя
CREATE OR REPLACE VIEW mipt_project.user_playlists_count AS
SELECT
    u.id        AS user_id,
    u.username,
    COUNT(p.id) AS playlists_count
FROM mipt_project.users u
LEFT JOIN mipt_project.playlists p
  ON p.user_id = u.id
GROUP BY u.id, u.username;

-- View 2: Топ треков по количеству включений в плейлисты
CREATE OR REPLACE VIEW mipt_project.popular_tracks AS
SELECT
    t.id        AS track_id,
    t.title     AS track_title,
    COUNT(pt.playlist_id) AS included_in_playlists
FROM mipt_project.tracks t
LEFT JOIN mipt_project.playlist_tracks pt
  ON pt.track_id = t.id
GROUP BY t.id, t.title
ORDER BY included_in_playlists DESC;