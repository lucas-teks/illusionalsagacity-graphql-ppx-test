// NOTE - Scalars must obey to GraphQL customField PPX pattern:
// > https://graphql-ppx.com/docs/custom-fields

module CKU = {
  exception CannotParseCku
  exception CannotSerializeCku

  type t = string

  let parse = json => {
    switch json
    ->JSON.Decode.string
    ->Option.flatMap(Uuid.fromString)
    ->Option.map(uuid => (uuid->Uuid.version, uuid->Uuid.toString)) {
    | exception _ => throw(CannotParseCku)
    | Some(4, uuidv4) => uuidv4
    | _ => throw(CannotParseCku)
    }
  }
  let serialize = cku => {
    switch cku->Uuid.fromString->Option.map(Uuid.version) {
    | Some(4) => cku->JSON.Encode.string
    | _ => throw(CannotSerializeCku)
    }
  }
}
