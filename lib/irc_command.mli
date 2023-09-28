module type S = sig
  type t

  val name : string

  val show : t -> string

  val from_string' : string -> t
  val from_string : string -> (t, 'exn) result
end

module type Impl = sig
  type t

  val name : string

  val show : t -> string

  val parse_string : string -> t
end

module Make (Impl : Impl) : S with type t = Impl.t

module Ping : S
module Pong : S

type t
  = Ping
  | Pong

val parse_string : string -> t

val show : t -> string
