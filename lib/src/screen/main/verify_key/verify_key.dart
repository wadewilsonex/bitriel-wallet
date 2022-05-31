import 'dart:convert';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/models/createKey_m.dart';
import 'package:wallet_apps/src/screen/main/verify_key/body_verify_key.dart';


class VerifyPassphrase extends StatefulWidget {

  final CreateKeyModel? createKeyModel;
  
  VerifyPassphrase({this.createKeyModel});

  @override
  State<VerifyPassphrase> createState() => _VerifyPassphraseState();
}

class _VerifyPassphraseState extends State<VerifyPassphrase> {

  void remove3Seeds() {

    widget.createKeyModel!.missingSeeds = [];

    // Add Origin Three Number To tmpThreeNum
    widget.createKeyModel!.threeNum!.forEach((element) {
      widget.createKeyModel!.tmpThreeNum!.addAll({element});
    });


    // Add Origin lsSeeds To tmpThreeNum
    widget.createKeyModel!.lsSeeds!.forEach((element) {
      widget.createKeyModel!.missingSeeds.add(element);
    });

    print("widget.createKeyModel!.lsSeeds! ${widget.createKeyModel!.lsSeeds!}");

    // Replace match index with Empty
    widget.createKeyModel!.missingSeeds[int.parse(widget.createKeyModel!.tmpThreeNum![0])] = "";
    widget.createKeyModel!.missingSeeds[int.parse(widget.createKeyModel!.tmpThreeNum![1])] = "";
    widget.createKeyModel!.missingSeeds[int.parse(widget.createKeyModel!.tmpThreeNum![2])] = "";

    widget.createKeyModel!.tmpSeed = widget.createKeyModel!.missingSeeds.join(" ");
    setState(() { });
  }

  @override
  void initState() {
    remove3Seeds();
    super.initState();
  }

  void onTap(index, rmIndex){
    print("index $index");
    for(int i = 0; i < widget.createKeyModel!.missingSeeds.length; i++){
      if (widget.createKeyModel!.missingSeeds[i] == ""){
        widget.createKeyModel!.missingSeeds[i] = widget.createKeyModel!.lsSeeds![index];
        break;
      }
    }
    print("widget.createKeyModel!.missingSeeds[index] ${widget.createKeyModel!.missingSeeds[index]}");
    widget.createKeyModel!.tmpSeed = widget.createKeyModel!.missingSeeds.join(" ");
    widget.createKeyModel!.tmpThreeNum!.removeAt(rmIndex);
    setState(() { });
  }
  
  Future<void> verifySeeds() async {
    dynamic res;
    try {
      res = await Provider.of<ApiProvider>(context, listen: false).validateMnemonic(widget.createKeyModel!.missingSeeds.join(" "));
      
      if (res == true){
        DialogComponents().dialogCustom(
          context: context,
          contents: "You have successfully create your account.",
          textButton: "Completed",
          image: Image.asset("assets/icons/success.png")
        );
      }
    } catch (e) {
      if (ApiProvider().isDebug == false) print("Error validateMnemonic $e");
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return VerifyPassphraseBody(
      createKeyModel: widget.createKeyModel,
      verify: verifySeeds,
      onTap: onTap,
      remove3Seeds: remove3Seeds
    );
  }
}
