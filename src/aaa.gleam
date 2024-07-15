import adjectives
import animals
import gleam/bytes_builder
import gleam/erlang/process
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/string
import mist.{type Connection, type ResponseData}

pub fn main() {
  let assert Ok(_) =
    router
    |> mist.new
    |> mist.port(3000)
    |> mist.start_http

  process.sleep_forever()
}

pub fn router(req: Request(Connection)) -> Response(ResponseData) {
  case request.path_segments(req) {
    [] -> aaa(req)
    _ -> not_found(req)
  }
}

pub fn aaa(_: Request(Connection)) -> Response(ResponseData) {
  response.new(200)
  |> response.set_body(
    mist.Bytes(bytes_builder.from_string(
      string.lowercase(adjectives.random())
      <> "-"
      <> string.lowercase(adjectives.random())
      <> "-"
      <> string.lowercase(animals.random()),
    )),
  )
  |> response.set_header("Content-Type", "text/plain")
}

pub fn not_found(_: Request(Connection)) -> Response(ResponseData) {
  response.new(404)
  |> response.set_body(mist.Bytes(bytes_builder.from_string("Not found")))
  |> response.set_header("Content-Type", "text/plain")
}
