import 'dart:core';

import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/swap_p.dart';

class SwapPageModel {

  bool success = false, enableBtn = false;

  String str = "123456";
  List<String> lsTmp = [];
  int? percentActive = 0;
  int? length;
  int? cursor = -1;
  bool? isCursor = false;
  TextEditingController? myController = TextEditingController();
  FocusNode? focusNode = FocusNode();

  Map<String, dynamic> toJsonSwap(SwapProvider provider, String addr){
    return {
      "coin_from": provider.name1,
      "coin_to": provider.name2,
      "deposit_amount": myController!.text,
      "withdrawal": addr,
      "withdrawal_extra_id": null,
      "affiliate_id": "DCNVjpI0Txr1Sw2w",
      "network_from": provider.networkFrom,
      "network_to": provider.networkTo
    }; 
  }
}

class InfoTwoCoinModel{

  String? from;
  String? to;
  String? networkFrom;
  String? networkTo;
  String? amt;
  String? affiliateId;

  toJson(){
    return json.encode({
      "from": from,
      "to": to,
      "network_from": networkFrom,
      "network_to": networkTo,
      "amount": amt,
      "affiliate_id": affiliateId,
    });
  }
}
class ResInfoTwoCoinModel{
  String? min_amount;
  String? max_amount;
  String? amount;
  String? fee;
  String? rate;
  String? profit;
  String? extra_fee_amount;
  // int? rate_id;
  String? rate_id_expired_at;
  // String? applied_promo_code_id;
  double? deposit_amount_usdt;
  double? withdrawal_amount_usdt;
  List<dynamic>? networks_from;
  List<dynamic>? networks_to;

  fromJson(Map<String, dynamic> jsn){
    min_amount = jsn["min_amount"].toString();
    max_amount = jsn["max_amount"].toString();
    amount = jsn["amount"].toString();
    fee = jsn["fee"].toString();
    rate = jsn["rate"].toString();
    profit = jsn["profit"].toString();
    extra_fee_amount = jsn["extra_fee_amount"].toString();
    // rate_id = jsn["rate_id"];
    rate_id_expired_at = jsn["rate_id_expired_at"].toString();
    // applied_promo_code_id = jsn["applied_promo_code_id"];
    deposit_amount_usdt = jsn["deposit_amount_usdt"];
    withdrawal_amount_usdt = jsn["withdrawal_amount_usdt"];
    networks_from = jsn["networks_from"];
    networks_to = jsn["networks_to"];
  }
}

class SwapResponseObj {

  bool? is_float;
  String? status;
  String? coin_from;
  String? coin_to;
  String? deposit_amount;
  String? withdrawal;
  String? withdrawal_extra_id;
  String? _return;
  String? return_extra_id;
  String? final_amount;
  int? extra_fee_from;
  int? extra_fee_to;
  String? coin_from_network;
  String? coin_to_network;
  String? deposit;
  String? deposit_extra_id;
  String? withdrawal_amount;
  String? rate;
  String? fee;
  bool? revert;
  String? transaction_id;
  int? expired_at;
  String? created_at;
  String? execution_time;
  bool? is_available;
  String? coin_from_explorer_url;
  String? coin_to_explorer_url;
  String? coin_from_icon;
  String? coin_from_extra_name;
  String? coin_to_icon;
  String? coin_to_extra_name;
  String? coin_from_name;
  String? coin_to_name;
  int? need_confirmations;
  int? confirmations;
  String? email;
  List<dynamic>? aml_error_signals;

  SwapResponseObj.fromJson(Map<String, dynamic> jsn){
    is_float = jsn['is_float'];
    status = jsn['status'];
    coin_from = jsn['coin_from'];
    coin_to = jsn['coin_to'];
    deposit_amount = jsn['deposit_amount'];
    withdrawal = jsn['withdrawal'];
    withdrawal_extra_id = jsn['withdrawal_extra_id'];
    final_amount = jsn['final_amount'];
    _return = jsn['return'];
    return_extra_id = jsn['return_extra_id'];
    extra_fee_from = jsn['extra_fee_from'];
    extra_fee_to = jsn['extra_fee_to'];
    coin_from_network = jsn['coin_from_network'];
    coin_to_network = jsn['coin_to_network'];
    deposit = jsn['deposit'];
    deposit_extra_id = jsn['deposit_extra_id'];
    withdrawal_amount = jsn['withdrawal_amount'];
    rate = jsn['rate'];
    fee = jsn['fee'];
    revert = jsn['revert'];
    transaction_id = jsn['transaction_id'];
    expired_at = jsn['expired_at'];
    created_at = jsn['created_at'];
    execution_time = jsn['execution_time'];
    is_available = jsn['is_available'];
    coin_from_explorer_url = jsn['coin_from_explorer_url'];
    coin_to_explorer_url = jsn['coin_to_explorer_url'];
    coin_from_icon = jsn['coin_from_icon'];
    coin_from_extra_name = jsn['coin_from_extra_name'];
    coin_to_icon = jsn['coin_to_icon'];
    coin_to_extra_name = jsn['coin_to_extra_name'];
    coin_from_name = jsn['coin_from_name'];
    coin_to_name = jsn['coin_to_name'];
    need_confirmations = jsn['need_confirmations'];
    confirmations = jsn['confirmations'];
    email = jsn['email'];
    aml_error_signals = jsn['aml_error_signals'];
  }
}

class SwapStatusResponseObj {

  String? createdAt;
  String? status;
  String? transactionId;
  String? coinFrom;
  String? coinTo;
  String? depositAmount;
  String? withdrawalAmount;
  String? rate;
  String? fee;
  String? deposit;
  String? depositExtraId;
  String? withdrawal;
  String? withdrawalExtraId;
  String? welcomeReturn;
  String? returnExtraId;
  String? finalAmount;
  String? hashIn;
  String? hashOut;
  String? rating;
  String? realDepositAmount;
  String? realWithdrawalAmount;
  String? startedAt;
  String? finishedAt;
  String? coinFromNetwork;
  String? coinToNetwork;
  String? extraFeeFrom;
  String? extraFeeTo;
  String? returnAmount;
  String? returnHash;
  String? returnCoin;
  String? returnNetwork;
  bool? isAvailable;
  String? coinFromExplorerUrl;
  String? coinToExplorerUrl;
  String? coinFromIcon;
  String? coinFromExtraName;
  String? coinToIcon;
  String? coinToExtraName;
  String? coinFromName;
  String? coinToName;
  String? email;
  bool? internalTransaferRefund;
  String? returnNetworkCode;
  String? returnExplorerUrl;
  String? profit;

  SwapStatusResponseObj.fromJson(Map<String, dynamic> jsn){
    createdAt = jsn['created_at'];
    status = jsn['status'];
    transactionId = jsn['transaction_id'];
    coinFrom = jsn['coin_from'];
    coinTo = jsn['coin_to'];
    depositAmount = jsn['deposit_amount'];
    withdrawalAmount = jsn['withdrawal_amount'];
    rate = jsn['rate'];
    fee = jsn['fee'];
    deposit = jsn['deposit'];
    depositExtraId = jsn['deposit_extra_id'];
    withdrawal = jsn['withdrawal'];
    withdrawalExtraId = jsn['withdrawal_extra_id'];
    welcomeReturn = jsn['return'];
    returnExtraId = jsn['return_extra_id'];
    finalAmount = jsn['final_amount'];
    hashIn = jsn['hash_in'];
    hashOut = jsn['hash_out'];
    rating = jsn['rating'];
    realDepositAmount = jsn['real_deposit_amount'];
    realWithdrawalAmount = jsn['real_withdrawal_amount'];
    startedAt = jsn['startedAt'];
    finishedAt = jsn['finishedAt'];
    coinFromNetwork = jsn['coin_from_network'];
    coinToNetwork = jsn['coin_to_network'];
    extraFeeFrom = jsn['extra_fee_from'];
    extraFeeTo = jsn['extra_fee_to'];
    returnAmount = jsn['return_amount'];
    returnHash = jsn['return_hash'];
    returnCoin = jsn['return_coin'];
    returnNetwork = jsn['return_network'];
    isAvailable = jsn['is_available'];
    coinFromExplorerUrl = jsn['coin_from_explorer_url'];
    coinToExplorerUrl = jsn['coin_to_explorer_url'];
    coinFromIcon = jsn['coin_from_icon'];
    coinFromExtraName = jsn['coin_from_extra_name'];
    coinToIcon = jsn['coin_to_icon'];
    coinToExtraName = jsn['coin_to_extra_name'];
    coinFromName = jsn['coin_from_name'];
    coinToName = jsn['coin_to_name'];
    email = jsn['email'];
    internalTransaferRefund = jsn['internal_transafer_refund'];
    returnNetworkCode = jsn['return_network_code'];
    returnExplorerUrl = jsn['return_explorer_url'];
    profit = jsn['profit'];
  }
}

class SwapTrxInfo {

  String? created_at;
  String? status;
  String? transaction_id;
  String? coin_from;
  String? coin_to;
  String? deposit_amount;
  String? withdrawal_amount;
  String? rate;
  String? fee;
  String? deposit;
  String? deposit_extra_id;
  String? withdrawal;
  String? withdrawal_extra_id;
  String? _return;
  String? return_extra_id;
  String? final_amount;
  String? hash_in;
  String? hash_out;
  String? rating;
  String? real_deposit_amount;
  String? real_withdrawal_amount;
  String? startedAt;
  String? finishedAt;
  int? is_float;
  String? coin_from_network;
  String? coin_to_network;
  int? revert;
  String? extra_fee_from;
  String? extra_fee_to;
  String? return_amount;
  String? return_hash;
  String? return_coin;
  String? return_network;
  int? confirmations;
  int? expired_at;
  List<dynamic>? aml_error_signals;
  String? execution_time;
  bool? is_available;
  String? coin_from_explorer_url;
  String? coin_to_explorer_url;
  String? coin_from_icon;
  String? coin_from_extra_name;
  String? coin_to_icon;
  String? coin_to_extra_name;
  String? coin_from_name;
  String? coin_to_name;
  int? need_confirmations;
  String? email;
  bool? internal_transafer_refund;
  String? return_network_code;
  String? return_explorer_url;
  String? profit;

  SwapTrxInfo.fromJson(Map<String, dynamic> jsn){
    created_at = jsn["created_at"];
    status = jsn["status"];
    transaction_id = jsn["transaction_id"];
    coin_from = jsn["coin_from"];
    coin_to = jsn["coin_to"];
    deposit_amount = jsn["deposit_amount"];
    withdrawal_amount = jsn["withdrawal_amount"];
    rate = jsn["rate"];
    fee = jsn["fee"];
    deposit = jsn["deposit"];
    deposit_extra_id = jsn["deposit_extra_id"];
    withdrawal = jsn["withdrawal"];
    withdrawal_extra_id = jsn["withdrawal_extra_id"];
    _return = jsn["return"];
    return_extra_id = jsn["return_extra_id"];
    final_amount = jsn["final_amount"];
    hash_in = jsn["hash_in"];
    hash_out = jsn["hash_out"];
    rating = jsn["rating"];
    real_deposit_amount = jsn["real_deposit_amount"];
    real_withdrawal_amount = jsn["real_withdrawal_amount"];
    startedAt = jsn["startedAt"];
    finishedAt = jsn["finishedAt"];
    is_float = jsn["is_float"];
    coin_from_network = jsn["coin_from_network"];
    coin_to_network = jsn["coin_to_network"];
    revert = jsn["revert"];
    extra_fee_from = jsn["extra_fee_from"];
    extra_fee_to = jsn["extra_fee_to"];
    return_amount = jsn["return_amount"];
    return_hash = jsn["return_hash"];
    return_coin = jsn["return_coin"];
    return_network = jsn["return_network"];
    confirmations = jsn["confirmations"];
    expired_at = jsn["expired_at"];
    aml_error_signals = jsn["aml_error_signals"];
    execution_time = jsn["execution_time"];
    is_available = jsn["is_available"];
    coin_from_explorer_url = jsn["coin_from_explorer_url"];
    coin_to_explorer_url = jsn["coin_to_explorer_url"];
    coin_from_icon = jsn["coin_from_icon"];
    coin_from_extra_name = jsn["coin_from_extra_name"];
    coin_to_icon = jsn["coin_to_icon"];
    coin_to_extra_name = jsn["coin_to_extra_name"];
    coin_from_name = jsn["coin_from_name"];
    coin_to_name = jsn["coin_to_name"];
    need_confirmations = jsn["need_confirmations"];
    email = jsn["email"];
    internal_transafer_refund = jsn["internal_transafer_refund"];
    return_network_code = jsn["return_network_code"];
    return_explorer_url = jsn["return_explorer_url"];
    profit = jsn["profit"];
  }

}

class ConvertCoinModel{
  String? status;
  String? fromCoinAmount;
  String? toCoinAmount;

  fromJson(Map<String, dynamic> jsn, fromAmount, toAmount){
    status = jsn["min_amount"];
    fromCoinAmount = jsn["fromAmount"];
    toCoinAmount = jsn["toAmount"];
  }

}
