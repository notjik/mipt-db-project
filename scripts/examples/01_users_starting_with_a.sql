SET search_path TO mipt_project;

SELECT id, username, email
FROM users
WHERE username ILIKE 'a%';