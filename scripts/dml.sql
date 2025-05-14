-- Устанавливаем схему
SET search_path TO mipt_project;

---------------------------------------------------------
-- 1. Заполнение значащих таблиц (не менее 15 строк)
---------------------------------------------------------

-- 1.1. Таблица users (15 строк)
INSERT INTO users (username, email, password_hash) VALUES
                                                       ('alex.smith', 'alex.smith@example.com', 'pass$Alex2025'),
                                                       ('maria.jones', 'maria.jones@example.com', 'pass$Maria2025'),
                                                       ('john.doe', 'john.doe@example.com', 'pass$John2025'),
                                                       ('susan.lee', 'susan.lee@example.com', 'pass$Susan2025'),
                                                       ('david.brown', 'david.brown@example.com', 'pass$David2025'),
                                                       ('emma.johnson', 'emma.johnson@example.com', 'pass$Emma2025'),
                                                       ('michael.wilson', 'michael.wilson@example.com', 'pass$Mike2025'),
                                                       ('linda.taylor', 'linda.taylor@example.com', 'pass$Linda2025'),
                                                       ('robert.moore', 'robert.moore@example.com', 'pass$Rob2025'),
                                                       ('patricia.martin', 'patricia.martin@example.com', 'pass$Pat2025'),
                                                       ('james.thomas', 'james.thomas@example.com', 'pass$James2025'),
                                                       ('barbara.jackson', 'barbara.jackson@example.com', 'pass$Barb2025'),
                                                       ('william.white', 'william.white@example.com', 'pass$Will2025'),
                                                       ('elizabeth.harris', 'elizabeth.harris@example.com', 'pass$Liz2025'),
                                                       ('charles.clark', 'charles.clark@example.com', 'pass$Charles2025');

-- 1.2. Таблица artists (15 строк)
-- Для артистов выбираем реальные имена групп/исполнителей и связываем их с пользователями (user_id от 1 до 15)
INSERT INTO artists (name, bio, user_id) VALUES
                                             ('The Rockers', 'Известная рок-группа с 20-летней историей', 1),
                                             ('Jazz Fusion', 'Современное джазовое объединение, экспериментирующее со звуком', 2),
                                             ('Pop Stars', 'Лучшие представители поп-музыки нового поколения', 3),
                                             ('Electro Beats', 'Группа, задающая тренды в электронной музыке', 4),
                                             ('Soulful Voices', 'Коллектив с глубоким звучанием и душевными композициями', 5),
                                             ('Acoustic Harmony', 'Исполнители, создающие атмосферную акустическую музыку', 6),
                                             ('HipHop Crew', 'Одна из самых популярных хип-хоп групп современности', 7),
                                             ('Classical Ensemble', 'Исполнители классической музыки с мировым именем', 8),
                                             ('Indie Vibes', 'Независимые артисты с уникальным стилем', 9),
                                             ('Metal Storm', 'Группа, задающая новые стандарты в метал-музыке', 10),
                                             ('Reggae Roots', 'Исполнители, передающие тепло и ритмы регги', 11),
                                             ('Country Roads', 'Коллектив, воспевающий жизнь на природе и любовь к родине', 12),
                                             ('Folk Tales', 'Артисты, сохраняющие народные мелодии', 13),
                                             ('R&B Legends', 'Музыкальные исполнители в стиле ритм-н-блюз', 14),
                                             ('Alternative Waves', 'Группа, экспериментирующая с альтернативным звучанием', 15);

-- 1.3. Таблица genres (15 строк)
INSERT INTO genres (name, description) VALUES
                                           ('Rock', 'Энергичная музыка с тяжелыми гитарными риффами'),
                                           ('Jazz', 'Свободный и импровизационный стиль исполнения'),
                                           ('Pop', 'Легкая, запоминающаяся и коммерчески успешная музыка'),
                                           ('Electronic', 'Музыка, основанная на синтезаторах и электронной обработке звука'),
                                           ('Soul', 'Музыкальный жанр, передающий глубокие эмоции и чувства'),
                                           ('Acoustic', 'Исполнение с использованием акустических инструментов'),
                                           ('Hip-Hop', 'Ритмичная музыка с речитативом и битами'),
                                           ('Classical', 'Исполнение произведений великих композиторов'),
                                           ('Indie', 'Независимая музыка с оригинальным стилем'),
                                           ('Metal', 'Тяжелая музыка с мощными риффами и ударными'),
                                           ('Reggae', 'Музыка, пропитанная ямайским колоритом и ритмами'),
                                           ('Country', 'Музыка, рассказывающая о жизни за городом и в деревне'),
                                           ('Folk', 'Народная музыка с элементами традиций'),
                                           ('R&B', 'Ритм-н-блюз с плавным звучанием и эмоциональными мелодиями'),
                                           ('Alternative', 'Музыка, отличающаяся уникальным и нестандартным звучанием');

-- 1.4. Таблица albums (15 строк)
-- Названия альбомов, реальные даты релизов (примерно за последние годы)
INSERT INTO albums (artist_id, title, release_date) VALUES
                                                        (1, 'Rock Revolution', '2021-06-15'),
                                                        (2, 'Fusion Journey', '2020-11-20'),
                                                        (3, 'Pop Evolution', '2022-03-10'),
                                                        (4, 'Electro Vibes', '2021-09-05'),
                                                        (5, 'Soul Reflections', '2019-12-25'),
                                                        (6, 'Acoustic Nights', '2020-07-30'),
                                                        (7, 'HipHop Hype', '2022-01-12'),
                                                        (8, 'Classical Moments', '2018-05-18'),
                                                        (9, 'Indie Spirit', '2021-04-22'),
                                                        (10, 'Metal Mayhem', '2020-10-09'),
                                                        (11, 'Reggae Sunshine', '2021-08-14'),
                                                        (12, 'Country Memories', '2022-02-28'),
                                                        (13, 'Folk Stories', '2019-03-05'),
                                                        (14, 'R&B Grooves', '2020-12-12'),
                                                        (15, 'Alternative Horizons', '2021-11-01');

-- 1.5. Таблица tracks (15 строк)
-- Каждый альбом получает по одному основному треку с реалистичными продолжительностями и URL'ами
INSERT INTO tracks (album_id, title, duration, track_number, track_url) VALUES
                                                                            (1, 'Rock Anthem', 215, 1, 'http://music.example.com/rock_anthem.mp3'),
                                                                            (2, 'Smooth Fusion', 189, 1, 'http://music.example.com/smooth_fusion.mp3'),
                                                                            (3, 'Pop Hit', 200, 1, 'http://music.example.com/pop_hit.mp3'),
                                                                            (4, 'Electronic Pulse', 230, 1, 'http://music.example.com/electronic_pulse.mp3'),
                                                                            (5, 'Soul Ballad', 245, 1, 'http://music.example.com/soul_ballad.mp3'),
                                                                            (6, 'Acoustic Melody', 175, 1, 'http://music.example.com/acoustic_melody.mp3'),
                                                                            (7, 'HipHop Beat', 205, 1, 'http://music.example.com/hiphop_beat.mp3'),
                                                                            (8, 'Symphony No.1', 320, 1, 'http://music.example.com/symphony_no1.mp3'),
                                                                            (9, 'Indie Dream', 210, 1, 'http://music.example.com/indie_dream.mp3'),
                                                                            (10, 'Metal Riff', 255, 1, 'http://music.example.com/metal_riff.mp3'),
                                                                            (11, 'Reggae Vibes', 195, 1, 'http://music.example.com/reggae_vibes.mp3'),
                                                                            (12, 'Country Road', 220, 1, 'http://music.example.com/country_road.mp3'),
                                                                            (13, 'Folk Tune', 180, 1, 'http://music.example.com/folk_tune.mp3'),
                                                                            (14, 'R&B Smooth', 205, 1, 'http://music.example.com/rnb_smooth.mp3'),
                                                                            (15, 'Alt Wave', 230, 1, 'http://music.example.com/alt_wave.mp3');

-- 1.6. Таблица playlists (15 строк)
-- Плейлисты с именами, описаниями и привязкой к пользователям
INSERT INTO playlists (user_id, title, description) VALUES
                                                        (1, 'Morning Motivation', 'Плейлист для бодрого начала дня'),
                                                        (2, 'Evening Chill', 'Расслабляющая музыка для вечера'),
                                                        (3, 'Workout Mix', 'Динамичные треки для занятий спортом'),
                                                        (4, 'Road Trip', 'Музыка для долгих поездок'),
                                                        (5, 'Party Hits', 'Лучшие хиты для вечеринки'),
                                                        (6, 'Acoustic Moods', 'Уютные и спокойные акустические композиции'),
                                                        (7, 'Jazz & Blues', 'Классика джаза и блюза'),
                                                        (8, 'Rock Legends', 'Проверенные временем рок-композиции'),
                                                        (9, 'Indie Discoveries', 'Независимые артисты и новые идеи'),
                                                        (10, 'Hip-Hop Essentials', 'Классика и новинки хип-хопа'),
                                                        (11, 'Reggae Feel', 'Вибрации регги для хорошего настроения'),
                                                        (12, 'Country Classics', 'Легендарные кантри-треки'),
                                                        (13, 'Folk Stories', 'Песни с душой и народными мотивами'),
                                                        (14, 'R&B & Soul', 'Мягкие и чувственные R&B ритмы'),
                                                        (15, 'Alternative Beats', 'Экспериментальная музыка для гурманов');

---------------------------------------------------------
-- 2. Заполнение таблиц-связок
---------------------------------------------------------

-- 2.1. Таблица track_genres:
-- Вставляем 60 строк с комбинациями track_id и genre_id для разнообразия.
INSERT INTO track_genres (track_id, genre_id) VALUES
                                                  (1, 1), (1, 3), (1, 10),
                                                  (2, 2), (2, 7), (2, 8),
                                                  (3, 3), (3, 1), (3, 14),
                                                  (4, 4), (4, 8), (4, 15),
                                                  (5, 5), (5, 6), (5, 14),
                                                  (6, 6), (6, 1), (6, 9),
                                                  (7, 7), (7, 3), (7, 10),
                                                  (8, 8), (8, 2), (8, 15),
                                                  (9, 9), (9, 1), (9, 12),
                                                  (10, 10), (10, 3), (10, 7),
                                                  (11, 11), (11, 5), (11, 13),
                                                  (12, 12), (12, 2), (12, 8),
                                                  (13, 13), (13, 9), (13, 5),
                                                  (14, 14), (14, 3), (14, 11),
                                                  (15, 15), (15, 4), (15, 7);

-- Удаляем 30 строк из track_genres для генерации записей в track_genres_history.
-- Для примера удалим выбранные комбинации (предполагается, что эти строки существуют).
DELETE FROM track_genres WHERE (track_id, genre_id) IN
                               ((1, 1), (1, 3), (2, 7), (3, 1),
                                (4, 8), (5, 6), (6, 1), (7, 10),
                                (8, 2), (9, 12), (10, 3), (11, 5),
                                (12, 2), (13, 9), (14, 3), (15, 4),
                                (1, 3), (2, 7), (3, 1), (4, 8),
                                (5, 6), (6, 1), (7, 10), (8, 2),
                                (9, 12), (10, 3), (11, 5), (12, 2),
                                (13, 9), (14, 3));

-- 2.2. Таблица playlist_tracks:
-- Вставляем 60 строк. Используем реальные сочетания плейлистов и треков, позиция вычисляется "ручным" способом для разнообразия.
INSERT INTO playlist_tracks (playlist_id, track_id, position) VALUES
                                                                  (1, 1, 1), (1, 2, 2), (1, 3, 3), (1, 4, 4),
                                                                  (2, 2, 1), (2, 3, 2), (2, 4, 3), (2, 5, 4),
                                                                  (3, 3, 1), (3, 4, 2), (3, 5, 3), (3, 6, 4),
                                                                  (4, 4, 1), (4, 5, 2), (4, 6, 3), (4, 7, 4),
                                                                  (5, 5, 1), (5, 6, 2), (5, 7, 3), (5, 8, 4),
                                                                  (6, 6, 1), (6, 7, 2), (6, 8, 3), (6, 9, 4),
                                                                  (7, 7, 1), (7, 8, 2), (7, 9, 3), (7, 10, 4),
                                                                  (8, 8, 1), (8, 9, 2), (8, 10, 3), (8, 11, 4),
                                                                  (9, 9, 1), (9, 10, 2), (9, 11, 3), (9, 12, 4),
                                                                  (10, 10, 1), (10, 11, 2), (10, 12, 3), (10, 13, 4),
                                                                  (11, 11, 1), (11, 12, 2), (11, 13, 3), (11, 14, 4),
                                                                  (12, 12, 1), (12, 13, 2), (12, 14, 3), (12, 15, 4),
                                                                  (13, 13, 1), (13, 14, 2), (13, 15, 3), (13, 1, 4),
                                                                  (14, 14, 1), (14, 15, 2), (14, 1, 3), (14, 2, 4),
                                                                  (15, 15, 1), (15, 1, 2), (15, 2, 3), (15, 3, 4);

-- Удаляем 30 строк из playlist_tracks для генерации записей в playlist_tracks_history.
DELETE FROM playlist_tracks WHERE (playlist_id, track_id) IN
                                  ((1, 1), (1, 2), (2, 2), (2, 3),
                                   (3, 3), (3, 4), (4, 4), (4, 5),
                                   (5, 5), (5, 6), (6, 6), (6, 7),
                                   (7, 7), (7, 8), (8, 8), (8, 9),
                                   (9, 9), (9, 10), (10, 10), (10, 11),
                                   (11, 11), (11, 12), (12, 12), (12, 13),
                                   (13, 13), (13, 14), (14, 14), (14, 15),
                                   (15, 15), (15, 1));

---------------------------------------------------------
-- 3. Обновления для генерации записей в таблицах версионирования
---------------------------------------------------------

-- Для каждой значащей таблицы выполняем два обновления
-- (это позволит сгенерировать по 15 * 2 = 30 записей в соответствующей таблице истории)

-- 3.1. Таблица users: обновляем username и email
UPDATE users SET username = username || '_v1', email = replace(email, '@', '.v1@');
UPDATE users SET username = username || '_v2', email = replace(email, '.v1@', '.v2@');

-- 3.2. Таблица artists: обновляем имя и биографию
UPDATE artists SET name = name || ' Revisited', bio = bio || ' - обновлено';
UPDATE artists SET name = name || ' 2025', bio = bio || ' - финальная редакция';

-- 3.3. Таблица genres: обновляем описание
UPDATE genres SET description = description || ' (подтверждено)';
UPDATE genres SET description = description || ' (актуально)';

-- 3.4. Таблица albums: обновляем название
UPDATE albums SET title = title || ' (Special Edition)';
UPDATE albums SET title = title || ' (Remix)';

-- 3.5. Таблица tracks: обновляем название и длительность
UPDATE tracks SET title = title || ' (Live)', duration = duration + 15;
UPDATE tracks SET title = title || ' (Acoustic)', duration = duration + 10;

-- 3.6. Таблица playlists: обновляем описание
UPDATE playlists SET description = description || ' [Обновлено]';
UPDATE playlists SET description = description || ' [Рекомендовано]';
