DROP TABLE IF EXISTS attachments;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS tasks;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL
);

CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    user_id INTEGER REFERENCES users (id)
      ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE tasks (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    status BOOLEAN NOT NULL DEFAULT FALSE,
    project_id INTEGER REFERENCES projects (id)
      ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    user_id INTEGER REFERENCES users (id)
      ON DELETE CASCADE ON UPDATE CASCADE,
    task_id INTEGER REFERENCES tasks (id)
      ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE attachments (
    id SERIAL PRIMARY KEY,
    file_name TEXT NOT NULL,
    file_path TEXT NOT NULL,
    task_id INTEGER REFERENCES tasks (id)
      ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX projects_projects_user_id_fkey_ix ON projects (user_id);
CREATE INDEX tasks_tasks_project_id_fkey_ix ON tasks (project_id);
CREATE INDEX comments_comments_user_id_fkey_ix ON comments (user_id);
CREATE INDEX comments_comments_task_id_fkey_ix ON comments (task_id);
CREATE INDEX attachments_attachments_task_id_fkey_ix ON attachments (task_id);
