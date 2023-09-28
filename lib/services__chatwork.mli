type 'a value
  = Int : int -> int value
  | Float : float -> float value
  | String : string -> string value
  | Bool : bool -> bool value

type method_t
  = Get
  | Post
  | Put
  | Patch
  | Delete
  | Options

module type Endpoint = sig
  type 'a params = (string * 'a value) list
  type 'a query = (string * 'a value) list

  type ('a, 'b) t =
    { name : string
    ; params : 'a params
    ; query : 'b query
    }

  val name : string

  val make
     : ?params:('a params)
    -> ?query:('b query)
    -> string
    -> ('a, 'b) t

  val to_string : ('a, 'b) t -> string
end

type endpoints = (module Endpoint) list

type content_type
  = Application_json

module type Response = sig
  type header =
    { content_type : content_type list
    ; method_t : method_t
    ; url : string
    }

  type t =
    { header : header
    }

  val make : header:header -> unit -> t
end

type response = (module Response)

module type SendData = sig
  type t
  type key = string

  val empty : unit -> t
  val append : key -> 'a value -> t -> t
  val remove : key -> t -> t
end

type data = (module SendData)

(*
 * Services.Chatwork.Requests.request Get [rooms]
 * Services.Chatwork.Requests.get [rooms]
 * Services.Chatwork.Requests.get [rooms ~room_id:01234567; messages ~force:true]
 *)
module Requests : sig
  val request : method_t -> endpoints -> response

  val get : endpoints -> response
  val post : ?data:data -> endpoints -> response
  val put : ?data:data -> endpoints -> response
  val patch : ?data:data -> endpoints -> response
  val delete : ?data:data -> endpoints -> response
  val options : endpoints -> response
end

