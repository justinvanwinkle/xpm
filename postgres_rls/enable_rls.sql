ALTER TABLE projects FORCE ROW LEVEL SECURITY;
ALTER TABLE tasks FORCE ROW LEVEL SECURITY;
ALTER TABLE comments FORCE ROW LEVEL SECURITY;

CREATE POLICY projects_user_policy ON projects
    USING (user_id = current_setting('myvars.current_user_id')::integer)
    WITH CHECK (user_id = current_setting('myvars.current_user_id')::integer);

CREATE POLICY tasks_user_policy ON tasks
    USING ((SELECT user_id FROM projects WHERE projects.id = tasks.project_id) = current_setting('myvars.current_user_id')::integer)
    WITH CHECK ((SELECT user_id FROM projects WHERE projects.id = tasks.project_id) = current_setting('myvars.current_user_id')::integer);

CREATE POLICY comments_user_policy ON comments
    USING (user_id = current_setting('myvars.current_user_id')::integer)
    WITH CHECK (user_id = current_setting('myvars.current_user_id')::integer);

ALTER TABLE projects FORCE ROW LEVEL SECURITY;
ALTER TABLE tasks FORCE ROW LEVEL SECURITY;
ALTER TABLE comments FORCE ROW LEVEL SECURITY;
