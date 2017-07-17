CREATE DATABASE blog;

USE blog;

CREATE TABLE posts (
	id int(11) NOT NULL auto_increment,
	title varchar(100) NOT NULL,
	text TEXT NOT NULL,
	PRIMARY KEY (id)
);

INSERT INTO posts (title, text)
	VALUES  ('Blog-Post #1',  'lorem ipsum dolor...');
INSERT INTO posts (title, text)
	VALUES  ('Blog-Post #2',  'lorem ipsum dolor...');
INSERT INTO posts (title, text)
	VALUES  ('Blog-Post #3',  'lorem ipsum dolor...');
INSERT INTO posts (title, text)
	VALUES  ('Blog-Post #4',  'lorem ipsum dolor...');
INSERT INTO posts (title, text)
	VALUES  ('Blog-Post #5',  'lorem ipsum dolor...');
