create schema if not exists blog;

create table if not exists blog.post (
	id serial primary key,
	title text not null,
	content text not null,
	date timestamp default now()
);

-- Safely add author_id if it does not exist (Postgres 9.6+)
alter table blog.post add column if not exists author_id integer;

create table if not exists blog.users (
	id serial primary key,
	name text not null,
	email text not null unique,
	password text not null,
	date timestamp default now()
);

-- Seed Admin User (Password: "password123" hashed)
insert into blog.users (name, email, password) 
values ('Admin', 'admin@ezops.com', '$2b$10$VEBiZoOIVJumMgeM9WYn6uifOyM8QgxOGxvz7siTxYdFK2HT/Mjue') 
on conflict (email) do nothing;

-- Seed Posts (News)
-- Post 1 (Insert or Update if exists to ensure HTML content)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM blog.post WHERE title = 'Stability vs Operational Improvements') THEN
        INSERT INTO blog.post (title, content, author_id)
        SELECT 'Stability vs Operational Improvements', 
               'Most teams postpone operational improvements because stability feels like permission to delay. In reality, stability is the only moment when improvement is affordable. Once incidents start, every fix becomes reactive and expensive.<br><br>At EZOps Cloud, we help teams invest in reliability while systems are still stable.<br><br><img src="https://media.licdn.com/dms/image/v2/D4D22AQFPsJi7UICczQ/feedshare-shrink_1280/B4DZuNhAjgJUAs-/0/1767605799802?e=1770854400&v=beta&t=KbfUOjyWWgWF1HDPQ_0sWSpxY2hDVinHxBe38QBUnn0" style="max-width:100%; border-radius:8px; margin-top:10px;" />', 
               1;
    ELSE
        UPDATE blog.post SET content = 'Most teams postpone operational improvements because stability feels like permission to delay. In reality, stability is the only moment when improvement is affordable. Once incidents start, every fix becomes reactive and expensive.<br><br>At EZOps Cloud, we help teams invest in reliability while systems are still stable.<br><br><img src="https://media.licdn.com/dms/image/v2/D4D22AQFPsJi7UICczQ/feedshare-shrink_1280/B4DZuNhAjgJUAs-/0/1767605799802?e=1770854400&v=beta&t=KbfUOjyWWgWF1HDPQ_0sWSpxY2hDVinHxBe38QBUnn0" style="max-width:100%; border-radius:8px; margin-top:10px;" />' 
        WHERE title = 'Stability vs Operational Improvements';
    END IF;
END $$;

-- Post 2
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM blog.post WHERE title = 'Security added at the end never scales') THEN
        INSERT INTO blog.post (title, content, author_id)
        SELECT 'Security added at the end never scales', 
               'It slows teams, creates friction, and increases risk. DevSecOps integrates security into pipelines, infrastructure, and workflows from day one, shifting it from gatekeeper to enabler.<br><br>At EZOps Cloud, we help teams embed security into Cloud and DevOps practices.<br><br><img src="https://media.licdn.com/dms/image/v2/D4D22AQGydhKdN4jq4g/feedshare-shrink_800/B4DZuNfUbCJUAk-/0/1767605357084?e=1770854400&v=beta&t=qErnkAiiYIe_Z5yBBiqyFdhIIWXsw0ZCixNdcbZZA74" style="max-width:100%; border-radius:8px; margin-top:10px;" />', 
               1;
    ELSE
        UPDATE blog.post SET content = 'It slows teams, creates friction, and increases risk. DevSecOps integrates security into pipelines, infrastructure, and workflows from day one, shifting it from gatekeeper to enabler.<br><br>At EZOps Cloud, we help teams embed security into Cloud and DevOps practices.<br><br><img src="https://media.licdn.com/dms/image/v2/D4D22AQGydhKdN4jq4g/feedshare-shrink_800/B4DZuNfUbCJUAk-/0/1767605357084?e=1770854400&v=beta&t=qErnkAiiYIe_Z5yBBiqyFdhIIWXsw0ZCixNdcbZZA74" style="max-width:100%; border-radius:8px; margin-top:10px;" />'
        WHERE title = 'Security added at the end never scales';
    END IF;
END $$;

-- Post 3
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM blog.post WHERE title = 'Infrastructure reflects leadership decisions') THEN
        INSERT INTO blog.post (title, content, author_id)
        SELECT 'Infrastructure reflects leadership decisions', 
               'Infrastructure is never just technical. Centralized approvals create architectural bottlenecks. Lack of ownership turns systems fragile.<br><br>In our work at EZOps Cloud, infrastructure consistently reflects how leadership distributes trust, ownership, and accountability.<br><br><img src="https://media.licdn.com/dms/image/v2/D4D22AQGjshbu3uSiHw/feedshare-shrink_800/B4DZuNe6B2HwAk-/0/1767605249111?e=1770854400&v=beta&t=NdWXo4fVyViBx31WXl_rrVu6ooh-H0uYFgAwYXhegzI" style="max-width:100%; border-radius:8px; margin-top:10px;" />', 
               1;
    ELSE
         UPDATE blog.post SET content = 'Infrastructure is never just technical. Centralized approvals create architectural bottlenecks. Lack of ownership turns systems fragile.<br><br>In our work at EZOps Cloud, infrastructure consistently reflects how leadership distributes trust, ownership, and accountability.<br><br><img src="https://media.licdn.com/dms/image/v2/D4D22AQGjshbu3uSiHw/feedshare-shrink_800/B4DZuNe6B2HwAk-/0/1767605249111?e=1770854400&v=beta&t=NdWXo4fVyViBx31WXl_rrVu6ooh-H0uYFgAwYXhegzI" style="max-width:100%; border-radius:8px; margin-top:10px;" />'
         WHERE title = 'Infrastructure reflects leadership decisions';
    END IF;
END $$;
