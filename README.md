# BDAura

BDAura (shorthand for BigDipper Aura) is the [Aura](https://github.com/aura-nw/aura) implementation
for [BigDipper](https://github.com/forbole/big-dipper).

It extends the custom Aura behavior by adding different handlers and custom operations to make it easier for BigDipper
showing the data inside the UI.

All the chains' data that are queried from the RPC and gRPC endpoints are stored inside
a [PostgreSQL](https://www.postgresql.org/) database on top of which [GraphQL](https://graphql.org/) APIs can then be
created using [Hasura](https://hasura.io/).

## Usage
To know how to set up and run BDAura, please refer to
the [docs website](https://docs.bigdipper.live/cosmos-based/parser/overview/).

## Testing
If you want to test the code, you can do so by running

```shell
$ make test-unit
```

**Note**: Requires [Docker](https://docker.com).

This will:
1. Create a Docker container running a PostgreSQL database.
2. Run all the tests using that database as support.