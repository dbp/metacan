open Ppx_yojson_conv_lib.Yojson_conv.Primitives

type meta = {
  key : string;
  email : string;
  assignment : string;
  time : string;
  content : string;
  results : string;
  other : string
} [@@deriving yojson, eq, show]

let () = Dotenv.export () |> ignore

let key = Sys.getenv "SECRET_KEY"

let () =
  Dream.run ~interface:"0.0.0.0"
  @@ Dream.logger
  @@ Dream.set_secret (Sys.getenv "COOKIE_KEY")
  @@ Dream.flash
  @@ Dream.cookie_sessions
  @@ Dream.sql_pool (Sys.getenv "DATABASE_URL")
  @@ Dream.router [

    Dream.post "/dump"
      (fun request ->
        let%lwt body = Dream.body request in

        match try body
              |> Yojson.Safe.from_string
              |> meta_of_yojson
              |> Option.some
          with _ -> None with
        | None ->
          Dream.log "Error: Missing fields";
          Dream.json "ERROR"
        | Some m ->
          if m.key = key then
            begin
              Dream.log "Storing metadata for %s" m.email;
              match%lwt
                Dream.sql request ([%rapper
                                    execute
                                      {sql|
                                       INSERT INTO meta (email, assignment, time, content, results, other) VALUES (%string{email}, %string{assignment}, %string{time}, %string{content}, %string{results}, %string{other})
      |sql} record_in] m) with
              | Ok _ -> Dream.json "OK"
              | Error err ->
                Dream.log "Error %s" (Caqti_error.show err);
                Dream.json "ERROR"
            end
          else
            begin
              Dream.log "Error: Not authenticated";
              Dream.json "ERROR"
            end)
  ]
