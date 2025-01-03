(lang dune 3.12)

(name metacan)

(generate_opam_files true)

(source
 (github dbp/metacan))

(authors "Daniel Patterson")

(maintainers "Daniel Patterson")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name metacan)
 (synopsis "The Metadata Trashcan")
 (description "Storing all your metadata")
 (depends ocaml dune dream caqti caqti-driver-postgresql ppx_rapper_lwt dotenv ppx_yojson_conv)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
