-- Instagram project
/*
Tables 
# users are entity of persons
Users -> username, email, created_at
photos -> image_url,user_id,created_at
comments -> comment_text,user_id,photo_id,created_at
likes -> likes,user_id,photo_id,created_at
follows -> followers,following,created_at
hashtags -> two tables tagnames and tag_photos

or else 
ig_clone_data.sql
*/

drop database if exists instagram;

create database instagram;
use instagram;

-- users create usernames
create table users(
	id int primary key auto_increment,
	username varchar(255) unique not null,
	created_at timestamp default current_timestamp() on update now()
);

-- photos added by username
create table photos(
	id int primary key auto_increment,
	image_url varchar(255) not null,
	user_id int not null,
	created_at timestamp default current_timestamp() on update now(),
	foreign key(user_id) references users(id) on delete cascade
);

-- comments by users
create table comments(
	id int primary key auto_increment,
	comment_text varchar(255) not null,
	user_id int not null,
	photo_id int not null,
	created_at timestamp default current_timestamp on update now(),
	foreign key(user_id) references users(id) on delete cascade,
	foreign key(photo_id) references photos(id) on delete cascade
);

-- likes by users of particular photos
create table likes(
	user_id int not null,
	photo_id int not null,
	created_at timestamp default current_timestamp on update now(),
	foreign key(user_id) references users(id),
	foreign key(photo_id) references photos(id),
	primary key(user_id,photo_id)
);

-- followers and followings of particular user
create table follows(
	follower_id int not null,
	followee_id int not null,
	created_at timestamp default current_timestamp on update now(),
	primary key(follower_id,followee_id),
	foreign key(follower_id) references users(id),
	foreign key(followee_id) references users(id)
);

-- tags that assosicated with photos
create table tags(
	id int primary key auto_increment,
	tag_name varchar(255) unique,
	created_at timestamp default current_timestamp on update now()
);

create table photo_tag(
	photo_id int not null,
	tag_id int not null,
	primary key(photo_id,tag_id),
	foreign key(photo_id) references photos(id),
	foreign key(tag_id) references tags(id)
);



-- users create usernames
insert into users(username) values
	('BlueTheCat'),
	('CharlieBrown'),
	('ColtSteele');

-- photos added by username
insert into photos(image_url,user_id) values
	('/asrlifuae',1),
	('/liuaehraf',2),
	('/gseirjddf',2);

alter table photos add column caption varchar(255) default ' ' after image_url;
update photos set caption = 'My cat' where id = 1;
update photos set caption = 'My meal' where id = 2;
update photos set caption = 'A Selfie' where id = 3;

-- comments by users
insert into comments(comment_text,user_id,photo_id) values
	('Meow!',1,2),
	('Amazing Shot!',3,2),
	('I <3 this',2,1);

-- likes by users of particular photos
insert into likes(user_id,photo_id) values
	(1,1),
	(2,1),
	(1,2),
	(1,3),
	(3,3);

-- user likes only once
-- insert into likes(user_id,photo_id) values(1,1);

-- followers and followings of particular user
insert into follows(follower_id,followee_id) values
	(1,2),
	(1,3),
	(3,1),
	(2,3),
	(2,1);

-- tags that assosicated with photos
insert into tags(tag_name) values
	('adorable'),
	('cute'),
	('sunrise');

insert into photo_tag(photo_id,tag_id) values
	(1,1),
	(1,2),
	(2,3),
	(3,2);

-- Questions
/*
We want to reward our users who have been around the longest. Find the 5 oldest users.
code : select * from users order by created_at limit 5;

What day of the week do most users register on? We need to figure out when to schedule an ad campgain. Most Popular Registration Date
code : select dayname(created_at) as dated,count(*) from users group by dated;

We want to target our inactive users with an email campaign. Find the users  who have never posted a photo
code : select username from users left join photos on users.id = photos.user_id where photos.user_id is null;

We're running a new contest to see who can get the most likes on a single photo. Who Won??!!
code : select users.username,photos.image_url,count(*) as total from likes inner join photos on photos.id = likes.photo_id inner join users on users.id = photos.user_id group by photos.id order by total desc limit 1;
# Visualize : select * from likes inner join photos on photos.id = likes.photo_id inner join users on photos.user_id = users.id limit 5;

Our Investors want to know. How many times does the average user post Calculate avg numbers of photos per user
code : select (select count(*) from photos)/(select count(*) from users) as avg;

A brand wants to know which hashtags to use in a post. What are the top 5 most commonly used hashtags?
code : select t.tag_name,count(photo_id) as total from tags as t inner join photo_tags as pt on pt.tag_id = t.id group by t.id order by total desc limit 5;

We have a small problem with bots on our site... Find users who have liked every single photo on the site
-- Bots accounts that likes and comments other accounts but dont post any thing
# own solution experimental use
-- select users and photos which has not posted any photos
select users.id as ids,users.username as users,users.created_at from users left join photos on users.id = photos.user_id where photos.id is null;
-- select users who has liked any photos
select users.id,users.username,users.created_at from users left join photos on users.id = photos.user_id where photos.id is null and users.id in (select likes.user_id from likes);

# preferred one original solution
-- users who liked the photos and their counts based on username
select users.id as ids,users.username,count(likes.photo_id) as total from users inner join likes on likes.user_id = users.id group by users.id order by total desc;

-- users who liked all the photos and previous sub query
select t1.ids,t1.username from (select users.id as ids,users.username,count(likes.photo_id) as total from users inner join likes on likes.user_id = users.id group by users.id order by total desc) as t1 where t1.total = (select count(*) from photos); 

-- users who has not uploaded photos
select users.id,users.username from users left join photos on photos.user_id = users.id where photos.id is null;

-- total query
select t1.ids,
t1.username 
from (select users.id as ids,users.username,count(likes.photo_id) as total from users
	 inner join likes on likes.user_id = users.id group by users.id order by total desc) as t1 
where t1.total = (select count(*) from photos) and
 	  t1.ids in (select users.id from users left join photos on photos.user_id = users.id where photos.id is null); 

-- another query efficient one
select username,count(photo_id) as total 
	from users 
	inner join likes on users.id = likes.user_id 
	group by user_id 
	having total = (select count(*) from photos);

*/
