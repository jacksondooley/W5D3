DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;
PRAGMA foreign_keys = ON;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_reply_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO 
  users (id, fname, lname)
VALUES
  (1, 'Jackson', 'Dooley'),
  (2, 'Harry', 'Israel');

INSERT INTO
  questions (id, title, body, author_id)
VALUES
  (1, 'Is the Earth Flat', 'I was wondering if the Earth is Flat', 1),
  (2, 'Is the Earth Flat?', 'Is there a chance that the Earth is 2D?', 2);

INSERT INTO
  question_follows (id, question_id, user_id)
VALUES
  (1, 1, 1),
  (2, 2, 2);

INSERT INTO
  replies (id, question_id, parent_reply_id, user_id, body)
VALUES
  (1, 2, NULL, 1, 'Earth round silly'),
  (2, 2, 1, 2, 'Earth flat silly');

INSERT INTO
  question_likes (id, question_id, user_id)
VALUES
  (1, 1, 1),
  (2, 1, 2);
