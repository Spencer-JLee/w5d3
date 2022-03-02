DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;

PRAGMA foreign_keys = ON;



CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  f_name TEXT NOT NULL, 
  l_name TEXT NOT NULL

);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,  
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,
  FOREIGN KEY (author_id) REFERENCES users(id)
);



CREATE TABLE question_follows ( 
  question_id INTEGER NOT NULL, 
  user_id INTEGER NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)  

);



CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL, 
  question_id INTEGER NOT NULL, 
  parent_reply_id INTEGER, 
  user_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id),  
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id)  

);



CREATE TABLE question_likes(
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
  users (f_name, l_name)
VALUES
  ("Spencer", "Lee"),
  ("Dominic", "Swaby");

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('Test question', 'How can we do this?', (SELECT id FROM users WHERE f_name = 'Spencer')),
  ('Another Test question', 'Did we do this yet?', (SELECT id FROM users WHERE f_name = 'Dominic')),
  ('Another/another Test question', 'We did it?', (SELECT id FROM users WHERE f_name = 'Dominic'));

INSERT INTO
  question_follows (question_id, user_id)
VALUES
  ((SELECT id FROM questions WHERE title='Test question'), (SELECT id FROM users WHERE f_name = 'Spencer'));


INSERT INTO
  replies (body, question_id, user_id, parent_reply_id)
VALUES
  ('Here is the answer', (SELECT id from questions WHERE title = 'Test question'), (SELECT id FROM users WHERE f_name = 'Dominic'), NULL),
  ('Here is another answer', (SELECT id FROM questions WHERE title = 'Test question'),  (SELECT id FROM users WHERE f_name = 'Dominic'), 1);

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE f_name='Spencer'), (SELECT id FROM questions WHERE title='Test question'));