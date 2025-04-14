SET search_path TO mipt_project;

SELECT u.id, u.username, COUNT(DISTINCT uh.email) AS email_versions
FROM users u
         JOIN users_history uh ON uh.user_id = u.id
GROUP BY u.id, u.username
HAVING COUNT(DISTINCT uh.email) > 1;
