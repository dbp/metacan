CREATE TABLE meta (
id serial primary key,
created_at timestamp not null default now(),
email text not null,
assignment text not null,
time timestamp not null,
content text not null,
results text not null,
other text
);

CREATE TABLE query (
id serial primary key,
created_at timestamp not null default now(),
description text not null,
key text not null,
metas int[] not null
);
