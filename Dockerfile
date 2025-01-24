FROM debian:stable-slim as build

RUN apt-get update
RUN apt-get install -y git libpq-dev m4 unzip opam libev-dev libpcre3-dev pkg-config libgmp-dev  libffi-dev

RUN opam init --disable-sandboxing
RUN eval $(opam env)

WORKDIR /build

RUN opam switch create 5.1.1
RUN opam install --yes dune dream dream-html dotenv ppx_deriving ppx_sexp_conv ppx_rapper ppx_rapper_lwt ppx_yojson_conv caqti-driver-postgresql

# Build project.
ADD . .

RUN eval $(opam env) && dune build


FROM debian:stable-slim as run

RUN apt-get update
RUN apt-get install -y libev4 libpcre3-dev libpq5 curl

COPY --from=build /build/_build/default/bin/main.exe /bin/app

RUN mkdir /app

WORKDIR /app

ENTRYPOINT /bin/app
