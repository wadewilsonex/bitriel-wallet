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
  String? minAmount;
  String? maxAmount;
  String? amount;
  String? fee;
  String? rate;
  String? profit;
  String? extraFeeAmount;
  // int? rate_id;
  String? rateIdExpiredAt;
  // String? applied_promo_code_id;
  double? depositAmountUsdt;
  double? withdrawalAmountUsdt;
  List<dynamic>? networksFrom;
  List<dynamic>? networksTo;

  fromJson(Map<String, dynamic> jsn){
    minAmount = jsn["min_amount"].toString();
    maxAmount = jsn["max_amount"].toString();
    amount = jsn["amount"].toString();
    fee = jsn["fee"].toString();
    rate = jsn["rate"].toString();
    profit = jsn["profit"].toString();
    extraFeeAmount = jsn["extra_fee_amount"].toString();
    // rate_id = jsn["rate_id"];
    rateIdExpiredAt = jsn["rate_id_expired_at"].toString();
    // applied_promo_code_id = jsn["applied_promo_code_id"];
    depositAmountUsdt = jsn["deposit_amount_usdt"];
    withdrawalAmountUsdt = jsn["withdrawal_amount_usdt"];
    networksFrom = jsn["networks_from"];
    networksTo = jsn["networks_to"];
  }
}

class SwapResponseObj {

  bool? isFloat;
  String? status;
  String? coinFrom;
  String? coinTo;
  String? depositAmount;
  String? withdrawal;
  String? withdrawalExtraId;
  String? returnAddress;
  String? returnExtraId;
  String? finalAmount;
  int? extraFeeFrom;
  int? extraFeeTo;
  String? coinFromNetwork;
  String? coinToNetwork;
  String? deposit;
  String? depositExtraId;
  String? withdrawalAmount;
  String? rate;
  String? fee;
  bool? revert;
  String? transactionId;
  int? expiredAt;
  String? createdAt;
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
  int? needConfirmations;
  int? confirmations;
  String? email;
  List<dynamic>? amlErrorSignals;

  SwapResponseObj.fromJson(Map<String, dynamic> jsn){
    isFloat = jsn['is_float'];
    status = jsn['status'];
    coinFrom = jsn['coin_from'];
    coinTo = jsn['coin_to'];
    depositAmount = jsn['deposit_amount'];
    withdrawal = jsn['withdrawal'];
    withdrawalExtraId = jsn['withdrawal_extra_id'];
    finalAmount = jsn['final_amount'];
    returnAddress = jsn['return'];
    returnExtraId = jsn['return_extra_id'];
    extraFeeFrom = jsn['extra_fee_from'];
    extraFeeTo = jsn['extra_fee_to'];
    coinFromNetwork = jsn['coin_from_network'];
    coinToNetwork = jsn['coin_to_network'];
    deposit = jsn['deposit'];
    depositExtraId = jsn['deposit_extra_id'];
    withdrawalAmount = jsn['withdrawal_amount'];
    rate = jsn['rate'];
    fee = jsn['fee'];
    revert = jsn['revert'];
    transactionId = jsn['transaction_id'];
    expiredAt = jsn['expired_at'];
    createdAt = jsn['created_at'];
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
    needConfirmations = jsn['need_confirmations'];
    confirmations = jsn['confirmations'];
    email = jsn['email'];
    amlErrorSignals = jsn['aml_error_signals'];
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
  String? returnAddress;
  String? returnExtraId;
  String? finalAmount;
  String? hashIn;
  String? hashOut;
  String? rating;
  String? realDepositAmount;
  String? realWithdrawalAmount;
  String? startedAt;
  String? finishedAt;
  int? isFloat;
  String? coinFromNetwork;
  String? coinToNetwork;
  int? revert;
  String? extraFeeFrom;
  String? extraFeeTo;
  String? returnAmount;
  String? returnHash;
  String? returnCoin;
  String? returnNetwork;
  int? confirmations;
  int? expiredAt;
  List<dynamic>? amlErrorSignals;
  String? executionTime;
  bool? isAvailable;
  String? coinFromExplorerUrl;
  String? coinToExploreruUrl;
  String? coinFromIcon;
  String? coinFromExtraName;
  String? coinToIcon;
  String? coinToExtraName;
  String? coinFromName;
  String? coinToName;
  int? needConfirmations;
  String? email;
  bool? internalTransaferRefund;
  String? returnNetworkCode;
  String? returnExplorerUrl;
  String? profit;

  SwapTrxInfo.fromJson(Map<String, dynamic> jsn){
    createdAt = jsn["created_at"];
    status = jsn["status"];
    transactionId = jsn["transaction_id"];
    coinFrom = jsn["coin_from"];
    coinTo = jsn["coin_to"];
    depositAmount = jsn["deposit_amount"];
    withdrawalAmount = jsn["withdrawal_amount"];
    rate = jsn["rate"];
    fee = jsn["fee"];
    deposit = jsn["deposit"];
    depositExtraId = jsn["deposit_extra_id"];
    withdrawal = jsn["withdrawal"];
    withdrawalExtraId = jsn["withdrawal_extra_id"];
    returnAddress = jsn["return"];
    returnExtraId = jsn["return_extra_id"];
    finalAmount = jsn["final_amount"];
    hashIn = jsn["hash_in"];
    hashOut = jsn["hash_out"];
    rating = jsn["rating"];
    realDepositAmount = jsn["real_deposit_amount"];
    realWithdrawalAmount = jsn["real_withdrawal_amount"];
    startedAt = jsn["startedAt"];
    finishedAt = jsn["finishedAt"];
    isFloat = jsn["is_float"];
    coinFromNetwork = jsn["coin_from_network"];
    coinToNetwork = jsn["coin_to_network"];
    revert = jsn["revert"];
    extraFeeFrom = jsn["extra_fee_from"];
    extraFeeTo = jsn["extra_fee_to"];
    returnAmount = jsn["return_amount"];
    returnHash = jsn["return_hash"];
    returnCoin = jsn["return_coin"];
    returnNetwork = jsn["return_network"];
    confirmations = jsn["confirmations"];
    expiredAt = jsn["expired_at"];
    amlErrorSignals = jsn["aml_error_signals"];
    executionTime = jsn["execution_time"];
    isAvailable = jsn["is_available"];
    coinFromExplorerUrl = jsn["coin_from_explorer_url"];
    coinToExploreruUrl = jsn["coin_to_explorer_url"];
    coinFromIcon = jsn["coin_from_icon"];
    coinFromExtraName = jsn["coin_from_extra_name"];
    coinToIcon = jsn["coin_to_icon"];
    coinToExtraName = jsn["coin_to_extra_name"];
    coinFromName = jsn["coin_from_name"];
    coinToName = jsn["coin_to_name"];
    needConfirmations = jsn["need_confirmations"];
    email = jsn["email"];
    internalTransaferRefund = jsn["internal_transafer_refund"];
    returnNetworkCode = jsn["return_network_code"];
    returnExplorerUrl = jsn["return_explorer_url"];
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
