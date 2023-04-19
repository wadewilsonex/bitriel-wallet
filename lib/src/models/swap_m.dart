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
      "network_from": "BEP20",
      "network_to": "BEP20"
    }; 
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
  String? executionTime;
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
    executionTime = jsn['execution_time'];
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