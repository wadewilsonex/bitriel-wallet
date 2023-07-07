import 'dart:math';
import 'package:bitriel_wallet/index.dart';

class AccountManagementImpl extends AccountMangementUC {

  BuildContext? context;

  set setContext(BuildContext ctx) {
    context = ctx;
    sdkProvier = Provider.of<SDKProvier>(ctx, listen: false);
  }

  TextEditingController seedController = TextEditingController();

  /* -----------------------For Create Wallet----------------------- */
  
  List<String> randomThreeEachNumber(){
    // First Number
    String rd1 = Random().nextInt(12).toString();
    while(rd1 == "0"){
      rd1 = Random().nextInt(12).toString();
    }

    // Second Number
    String rd2 = Random().nextInt(12).toString();
    while(rd2 == rd1 || rd2 == "0"){
      rd2 = Random().nextInt(12).toString();
      if (rd2 != rd1) break;
    }

    // Third Number
    String rd3 = Random().nextInt(12).toString();
    while(rd3 == rd1 || rd3 == rd2 || rd3 == "0"){
      rd3 = Random().nextInt(12).toString();
      if (rd3 != rd1 && rd3 != rd2) break;
    }

    return [rd1, rd2, rd3];
  }
  
  /// For Import Wallet
  ValueNotifier<bool> isSeedValid = ValueNotifier(false);

  SDKProvier? sdkProvier;

  void changeState(String seed){
    if (seed.split(" ").toList().length == 12 && seed.split(" ").toList().last != ""){
      isSeedValid.value = true;
    } else if (isSeedValid.value) {
      isSeedValid.value = false;
    }
  }

  void resetState(){
    isSeedValid.value = false;
  }

  @override
  Future<void> importAccount(String pin) async {

    dialogLoading(context!);
    await sdkProvier!.importSeed(seedController.text, pin).then((value) {
      Navigator.pop(context!);

      print("Success");
      // Navigator.push(
      //   context, route
      // );
    });
    
  }
}