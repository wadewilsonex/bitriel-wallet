

// import 'package:graphql_flutter/graphql_flutter.dart';

// class GraphQlHelper {

//   GraphQLClient? client;

//   QueryResult? result;

//   GraphQlHelper(){
//     client = clientToQuery();
//   }

//   Future<QueryResult> mutation({String? schema, Map<String, dynamic>? variable}) async {
//     result = await client!.mutate(
//       MutationOptions(
//         document: gql(schema!),
//         variables: variable!
//       )
//     );
//     return result!;
//   }

//   Future<QueryResult> query({String? schema, Map<String, dynamic>? variable}) async {
//     result = await client!.query(
//       QueryOptions(
//         document: gql(schema!),
//         variables: variable ?? {}
//       )
//     );

//     print("Query result $result");
//     return result!;
//   }

// }

// GraphQLClient clientToQuery() {
//   //   AuthLink authLink = AuthLink(
//   //    getToken: () async => 'Bearer $token',
//   //  );

//   //  final Link link = authLink.concat(httpLink);
//    return GraphQLClient(
//      cache: GraphQLCache(store: HiveStore(),),
//      link: HttpLink("https://airdropv2-api.selendra.org")
//    );
//  }