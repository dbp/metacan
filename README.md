## Running locally

``` 
dune exec metacan
```

## Setup

Expects a `.env` file with the following:

COOKIE_KEY=SOME SECRET
DATABASE_URL=postgresql://metacan:111@localhost:5432/metacan
SECRET_KEY=111

And for a database named `metacan` to exist, with user `metacan` with password `111`.

There should be a single table in it, create it with command in `init.sql`

## Testing

With the app running locally, run `test.sh`. The first should succeed, the rest
should fail, and it should remove a single row from DB at end. It will erase
development database at end!


## Queries

If you are just looking for the existence of a particular pattern, you can run
SQL queries against the `meta` table. Sometimes, though, you want to look at the
resulting code. In order to do that, you can create an entry in the `query`
table, which you can then view. Note that there is no authentication, so you
should choose a hard to guess `key` for it.

e.g.,:

``` sql
INSERT INTO query(description,metas,key)  (SELECT 'set!' as description, array_agg(id) as metas, gen_random_uuid() :: text as key FROM meta WHERE content LIKE '%set!%') RETURNING key;
```

Then you can take the resulting `key` that was returned (a UUID, in this case) and visit `https://url-of-metacan/query/UUID`

(Currently, the `description` is only viewable in the database, not in the UI).
