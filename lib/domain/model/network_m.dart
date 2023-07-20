enum Network {
  // ignore: constant_identifier_names
  Mainnet,
  // ignore: constant_identifier_names
  Testnet
}

class NetworkModel {

  Network? network;

  List<String>? lstNetwork;

  NetworkModel();
  
  NetworkModel.init(this.network, this.lstNetwork);

  List<NetworkModel> fromJson(Map<String, List<dynamic>> map){
    
    List<NetworkModel> lst = [];
    for (var element in map.entries) {
      lst.add(NetworkModel.init(
        element.key == 'mainnet' ? Network.Mainnet : Network.Testnet, 
        element.value.map((e) => e.toString()).toList()
      ));
    }

    return lst;
  }

}