[@@@landmark "random string"];;

module M = struct
  [@@@landmark "random string"];;
end;;

[@@@landmark "auto" "no auto"];;

let () = (print_endline "hello")[@landmark "too"][@landmark "many"][@landmark "landmarks"];;

let[@landmark] () = print_endline "hello";;

let () =
  let[@landmark] _ = 2+2 in ();;

(* Errors for unhandled code *)

(* setup *)
module type S = sig
  type 'a t
  val a : int
  val return : 'a -> 'a t
  val ( let* ) : 'a t -> ('a -> 'b t) -> 'b t
end

(* Module arguments must be unpacked in case they are for modular explicits,
  and hence we must keep around all type annotations. But annotations on
  optionals arguments may refer to the previous arguments, which are lost
  in eta-expansion. Hence, we have an error message. *)
let[@landmark] optM (module X : S) ?m:((module M) : (module S) = (module X)) x =
  x;;

(* This similarly will not work, but it only makes sense on OCaml 5.5+,
  and this library does not yet enforce 5.5. *)
(* let[@landmark] optM' (module X : S) ?m:((module M : S) = (module X : S)) x =
  x;; *)

(* Since module names are kept during unpacking, shadowing is an error. *)
let[@landmark] shadow ((module M) : (module S)) ((module M) : (module S)) =
  M.a;;

(* This code is only valid after 5.5. *)
(* let[@landmark] shadow_poly (module M : S)
    (f : 'a. 'a -> 'a M.t) (module M : S) =
  f 0, M.return (f true);; *)

