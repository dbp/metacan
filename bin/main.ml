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

    Dream.get "/query/:key"
      (fun request ->
        match%lwt
          Dream.sql request ([%rapper get_many {sql|
               SELECT @string{key}, @string{email}, @string{assignment}, @string{time}, @string{content}, @string{results}, @string{other} FROM meta JOIN query ON meta.id = ANY (query.metas) WHERE query.key = %string{key} |sql} record_out] ~key:(Dream.param request "key")) with
        | Ok courses ->
          let open Dream_html in
          let open HTML in
          Dream_html.respond (html [lang "en"] [
            head [] [
              link [rel "stylesheet"; href "https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css"];
              style [type_ "text/css"] "table td, table td * {vertical-align: top;}";
            ];
            body [] [
              main [class_ "container-fluid"] [
                table [class_ "striped"] [
                  thead [] [tr [] [th [] [txt "Email"];
                                   th [] [txt "Content"]]];
                  tbody [] (courses |> List.map (fun c -> tr [] [td [] [span [string_attr "data-tooltip" "%s - %s" c.assignment c.time] [txt "%s" c.email]];
                                                              td [] [pre [] [txt "%s" (c.content)]]]))
                ]
              ]
            ]
          ])
        | Error err ->
          Dream.log "Error %s" (Caqti_error.show err);
          Dream.html "");
    Dream.post "/dump"
      (fun request ->
        let%lwt body = Dream.body request in

        match try body
              |> Yojson.Safe.from_string
              |> meta_of_yojson
              |> Option.some
          with _ -> None with
        | None ->
          Dream.log "Error: Missing or invalid fields -- %s" body;
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
