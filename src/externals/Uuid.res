type t

@module("uuid") external make: unit => t = "v4"
@module("uuid") external validate: t => bool = "validate"
@module("uuid") external version: t => int = "version"

external toString: t => string = "%identity"
external unsafeFromString: string => t = "%identity"

let fromString = string =>
  switch string->unsafeFromString {
  | uuid if uuid->validate => Some(uuid)
  | _ => None
  }
