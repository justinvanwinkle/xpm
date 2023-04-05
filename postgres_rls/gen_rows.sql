INSERT INTO users (username, email, password_hash)
SELECT
    'user_' || i,
    'user_' || i || '@example.com',
    md5(random()::text)
FROM generate_series(1, 1000000) AS s(i);

-- Insert a million projects, assigning each project to a random user
INSERT INTO projects (name, description, user_id)
SELECT
    'project_' || i,
    'project_description_' || i,
    ceil(random() * 1000000)::integer
FROM generate_series(1, 1000000) AS s(i);

-- Insert a million tasks, assigning each task to a random project
INSERT INTO tasks (title, description, status, project_id)
SELECT
    'task_' || i,
    'task_description_' || i,
    (random() > 0.5),
    ceil(random() * 1000000)::integer
FROM generate_series(1, 1000000) AS s(i);

-- Insert a million comments, assigning each comment to a random user and a random task
INSERT INTO comments (content, user_id, task_id)
SELECT
    'comment_' || i,
    ceil(random() * 1000000)::integer,
    ceil(random() * 1000000)::integer
FROM generate_series(1, 1000000) AS s(i);

-- Insert a million attachments, assigning each attachment to a random task
INSERT INTO attachments (file_name, file_path, task_id)
SELECT
    'file_' || i || '.txt',
    'path/to/file_' || i || '.txt',
    ceil(random() * 1000000)::integer
FROM generate_series(1, 1000000) AS s(i);
