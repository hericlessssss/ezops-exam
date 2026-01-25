create schema if not exists blog;

create table if not exists blog.post (
	id serial primary key,
	title text not null,
	content text not null,
	date timestamp default now()
);

create table if not exists blog.users (
	id serial primary key,
	name text not null,
	email text not null unique,
	password text not null,
	date timestamp default now()
);

-- Seed Admin User (Password: "password123" hashed)
-- Hash generated via bcryptjs.hash("password123", 10)
insert into blog.users (name, email, password) 
values ('Admin', 'admin@ezops.com', '$2b$10$VEBiZoOIVJumMgeM9WYn6uifOyM8QgxOGxvz7siTxYdFK2HT/Mjue') 
on conflict (email) do nothing;
