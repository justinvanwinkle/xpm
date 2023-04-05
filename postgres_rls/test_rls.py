import psycopg2
import pytest

@pytest.fixture(scope='module')
def connection():
    conn = psycopg2.connect(dbname="rls_test")
    yield conn
    conn.close()


def test_projects_row_level_security(connection):
    with connection.cursor() as cursor:
        cursor.execute("INSERT INTO users (username, email, password_hash) VALUES ('test_user', 'test_user@example.com', 'password_hash')")
        connection.commit()

        cursor.execute("SELECT id FROM users WHERE username = 'test_user'")
        user_id = cursor.fetchone()[0]

        cursor.execute("SET myvars.current_user_id = %s", (user_id,))

        cursor.execute("INSERT INTO projects (name, description, user_id) VALUES ('Test Project', 'Test Project Description', %s)", (user_id,))
        connection.commit()

        cursor.execute("SELECT * FROM projects")
        assert len(cursor.fetchall()) == 1

        cursor.execute("SET myvars.current_user_id = 0")

        cursor.execute("SELECT * FROM projects")
        assert len(cursor.fetchall()) == 0


def test_tasks_row_level_security(connection):
    with connection.cursor() as cursor:
        cursor.execute("INSERT INTO users (username, email, password_hash) VALUES ('test_user_2', 'test_user_2@example.com', 'password_hash')")
        connection.commit()

        cursor.execute("SELECT id FROM users WHERE username = 'test_user_2'")
        user_id = cursor.fetchone()[0]

        cursor.execute("INSERT INTO projects (name, description, user_id) VALUES ('Test Project 2', 'Test Project 2 Description', %s)", (user_id,))
        connection.commit()

        cursor.execute("SELECT id FROM projects WHERE name = 'Test Project 2'")
        project_id = cursor.fetchone()[0]

        cursor.execute("SET myvars.current_user_id = %s", (user_id,))

        cursor.execute("INSERT INTO tasks (title, description, status, project_id) VALUES ('Test Task', 'Test Task Description', FALSE, %s)", (project_id,))
        connection.commit()

        cursor.execute("SELECT * FROM tasks")
        assert len(cursor.fetchall()) == 1

        cursor.execute("SET myvars.current_user_id = 0")

        cursor.execute("SELECT * FROM tasks")
        assert len(cursor.fetchall()) == 0


def test_comments_row_level_security(connection):
    with connection.cursor() as cursor:
        cursor.execute("INSERT INTO users (username, email, password_hash) VALUES ('test_user_3', 'test_user_3@example.com', 'password_hash')")
        connection.commit()

        cursor.execute("SELECT id FROM users WHERE username = 'test_user_3'")
        user_id = cursor.fetchone()[0]

        cursor.execute("INSERT INTO projects (name, description, user_id) VALUES ('Test Project 3', 'Test Project 3 Description', %s)", (user_id,))
        connection.commit()

        cursor.execute("SELECT id FROM projects WHERE name = 'Test Project 3'")
        project_id = cursor.fetchone()[0]

        cursor.execute("INSERT INTO tasks (title, description, status, project_id) VALUES ('Test Task 2', 'Test Task 2 Description', FALSE, %s)", (project_id,))
        connection.commit()

        cursor.execute("SELECT id FROM tasks WHERE title = 'Test Task 2'")
        task_id = cursor.fetchone()[0]

        cursor.execute("SET myvars.current_user_id = %s", (user_id,))

        cursor.execute("INSERT INTO comments (content, user_id, task_id) VALUES ('Test Comment', %s, %s)", (user_id, task_id))
        connection.commit()

        cursor.execute("SELECT * FROM comments")
        assert len(cursor.fetchall()) == 1

        cursor.execute("SET myvars.current_user_id = 0")

        cursor.execute("SELECT * FROM comments")
        assert len(cursor.fetchall()) == 0


if __name__ == "__main__":
    pytest.main()
