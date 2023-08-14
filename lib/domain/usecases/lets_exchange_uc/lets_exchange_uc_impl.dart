import 'package:bitriel_wallet/index.dart';

class LetsExchangeUCImpl implements LetsExchangeUseCases {

  final LetsExchangeRepoImpl letsExchangeRepoImpl = LetsExchangeRepoImpl();

  ValueNotifier<List<LetsExchangeCoin>> lstLECoin = ValueNotifier([]);
  
  ValueNotifier<String> inputAmount = ValueNotifier("");

  @override
  Future<void> getLetsExchangeCoin() async {
    
    if(lstLECoin.value.isEmpty){
      lstLECoin.value = await letsExchangeRepoImpl.getLetsExchangeCoin();
    }
  }

  @override 
  void onDeleteTxt() {

    final formattedValue = formatCurrencyText(inputAmount.value);

    inputAmount.value = formattedValue;

    if (inputAmount.value.isNotEmpty) {
      inputAmount.value = inputAmount.value.substring(0, inputAmount.value.length - 1);
    }

  }

  String formatCurrencyText(String value) {
    return value;
  }

  @override
  void formatDouble(String value) {

    // Value Equal Empty & Not Contains "."
    if (value.contains(".") && !(inputAmount.value.contains(".")) && inputAmount.value.isEmpty){

      inputAmount.value = "0.";

    } 
    // Prevent Add "." Multiple Time.
    // Reject Input "." Evertime
    else if ( !(value.contains("."))) {

      inputAmount.value = inputAmount.value + value;

    }
    // Add "." For Only one time.
    else if ( !(inputAmount.value.contains(".")) ){

      inputAmount.value = inputAmount.value + value;
    }

  }

}