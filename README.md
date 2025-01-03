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
