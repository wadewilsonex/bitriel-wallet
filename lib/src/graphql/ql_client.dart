import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
class GQLClient{

  static HttpLink httpLink = HttpLink(
    dotenv.get("EXPLORERKEY_URL"),
    defaultHeaders: {
      "x-hasura-admin-secret": dotenv.get("EXPLORERKEY")
    }
  );

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      // The default store is the InMemoryStore, which does NOT persist to disk
      cache: GraphQLCache(store: InMemoryStore()),
    ),
  );
}