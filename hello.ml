open Ordered

module type Heap = sig
  module Elt : Comparable

  type elt = Elt.t
  type t

  exception Empty

  val empty : t
  val is_empty : t -> bool
  val insert : elt -> t -> t
  val merge : t -> t -> t
  val find_min : t -> elt
  val delete_min : t -> t
end(* press '%' doesn't trigger any action *)

(* press '%' here, cursor is expected to jump to ')', but it jump to the end of 'module' *)
(*> LeftistHeaps <*)
module LeftistHeaps (Elt : Comparable) = struct
  module Elt = ExtendCompare (Elt)

  type elt = Elt.t

  type t =
    | E
    | T of int * elt * t * t

  exception Empty

  let rank = function
    | E -> 0
    | T (r, _, _, _) -> r
  ;;

  let rec merge a b =
    let makeT x a b =
      if rank a >= rank b then T (rank b + 1, x, a, b) else T (rank a + 1, x, b, a)
    in
    match a, b with
    | h, E -> h
    | E, h -> h
    | (T (_, x, l1, r1) as h1), (T (_, y, l2, r2) as h2) ->
      if Elt.leq x y then makeT x l1 (merge r1 h2) else makeT y l2 (merge r2 h1)
  ;;

  let is_empty = function
    | E -> true
    | T _ -> false
  ;;

  let empty = E
  let insert x h = merge (T (1, x, E, E)) h

  let find_min = function
    | E -> raise Empty
    | T (_, x, _, _) -> x
  ;;

  let delete_min = function
    | E -> raise Empty
    | T (_, _, a, b) -> merge a b
  ;;
end