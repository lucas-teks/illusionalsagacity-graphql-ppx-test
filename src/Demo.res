module VariantsByCkuQuery = %graphql(`
  query VariantsByCkuQuery($cku: CKU!, $filterBy: InputVariantsByCkuQueryFilter) {
    variantsByCku(cku: $cku, filterBy: $filterBy) {
      edges {
        node {
          id
          stock {
            # ISSUE: generate raise() calls
            state @ppxOmitFutureValue
          }
        }
      }
    }
  }
`)

let with_inline_record__getVariantByCkuAndShopId = (client: ApolloClient.t, ~cku, ~shopId) =>
  client.query(
    {
      cku: cku->Scalar.CKU.serialize,
      filterBy: Some({
        shopIds: Some({_in: [shopId]}),
        archived: None, // ISSUE: must be defined
        active: None, // ISSUE: must be defined
      }),
    },
    ~query=module(VariantsByCkuQuery),
  )

// ISSUE: "It only accepts 3 arguments; here, it's called with more."
let with_factory_helpers__getVariantByCkuAndShopId = (client: ApolloClient.t, ~cku, ~shopId) =>
  client.query(
    VariantsByCkuQuery.makeVariables(
      ~cku=cku->Scalar.CKU.serialize,
      ~filterBy=VariantsByCkuQuery.makeInputObjectInputVariantsByCkuQueryFilter(
        ~shopIds=VariantsByCkuQuery.makeInputObjectInFilter(~_in=[shopId]),
      ),
    ),
    ~query=module(VariantsByCkuQuery),
  )
