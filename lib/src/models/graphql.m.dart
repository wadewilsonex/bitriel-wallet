class ExplorerQueries {
  String fetchAddressInfo(String address){
    return """
      query MyQuery {
        account_by_pk(address: "$address") {
          reserved_balance
          locked_balance
          free_balance
        }
      }
    """;
  }
}