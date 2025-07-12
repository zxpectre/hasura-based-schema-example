# Example of a Hasura-based GraphQL schema for testing/dev purposes

This example case is a Hasura-generated schema and the final "wrapped" schema from it that is used on production on a project.

## Files
- `hasura.graphql`            :Hasura-generated schema in graphql format captured using  `gql-sdl`
- `hasura.json`               :Hasura-generated schema in json format captured using  `gql-sdl`
- `wrapped-hasura.graphql`    :final schema wrapping hasura's one, in graphql format captured using  `gql-sdl`
- `wrapped-hasura.json`       :final schema wrapping hasura's one, in json format captured using  `gql-sdl`
- `db.sql`                    :PostgresDB `public` schema feeding Hasura

## Notes
The final production API, namely `wrapped-hasura.*` is in general terms a wrapped Hasura-generated schema with customizations:
- not exposing mutations and subscriptions from `hasura.*` generated schema 
- not exposing most of the query root fields generated upon the db tables on `public` db schema (Snake case)
- exposing the root fields that where generated upon the db views on `public` db schema (Pascal case plus some exceptions like `utxo` view)
- exposing the root field that where generated upon the db table `Asset` on `public`
- exposing the root field that where generated upon the db view `utxo` on `public`
- adding a couple of custom root fields like `Query.PaymentAddresses` and `Mutation.submitTransaction`
- it has **recursive/nested filtering** arguments and **aggregations** exposed as separate root fields with the prefix `_aggregate`