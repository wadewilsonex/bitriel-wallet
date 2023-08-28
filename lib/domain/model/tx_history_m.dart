import 'package:bitriel_wallet/index.dart';

class TxHistoryModel {

  String? from;
  String? to;
  String? amt;
  String? networkHash;

  TxHistoryModel({
    this.from,
    this.to,
    this.amt,
    this.networkHash,
  });
  
  static List<Map<String, dynamic>> encode(List<TxHistoryModel> lstTxHistory){
    return lstTxHistory.map<Map<String, dynamic>>((e) => TxHistoryModel.toMap(e)).toList();
  }

  static List<TxHistoryModel> decode(List<dynamic> asset){
    return asset.map<TxHistoryModel>((item) => TxHistoryModel.fromJson(item)).toList();
  }

  static TxHistoryModel fromJson(Map<String, dynamic> json) {
    return TxHistoryModel(
      from : json["from"],
      to: json["to"],
      amt: json["amt"],
      networkHash: json["network_hash"]
    );
  }

  static Map<String, dynamic> toMap(TxHistoryModel txHistory) => {
    "from": txHistory.from,
    "to": txHistory.to,
    "amt": txHistory.amt,
    "network_hash": txHistory.networkHash
  };


}