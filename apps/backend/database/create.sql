create schema if not exists blog;

create table if not exists blog.post (
	id serial primary key,
	title text not null,
	content text not null,
	date timestamp default now()
);
