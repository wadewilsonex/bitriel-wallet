class ExplorerQueries {
  String fetchAddressInfo(String address){
    return """
      query {
        account_by_pk(address: "$address") {
          reserved_balance
          locked_balance
          free_balance
        }
      }
    """;
  }

  String fetchHashInfo(String hash){
    return """
      query {
        extrinsic(where: {hash: {_eq: "$hash"}}) {
          block_id
          hash
          transfers {
            amount
            fee_amount
            from_address
            from_evm_address
            extrinsic_id
            success
            timestamp
            to_address
          }
        }
      }
    """;
  }
}
