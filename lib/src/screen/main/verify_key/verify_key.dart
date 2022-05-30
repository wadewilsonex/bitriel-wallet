import 'dart:convert';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
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

    widget.createKeyModel!.missingSeeds = widget.createKeyModel!.lsSeeds!;

    // Replace match index with Empty
    widget.createKeyModel!.missingSeeds[int.parse(widget.createKeyModel!.threeNum![0])] = "";
    widget.createKeyModel!.missingSeeds[int.parse(widget.createKeyModel!.threeNum![1])] = "";
    widget.createKeyModel!.missingSeeds[int.parse(widget.createKeyModel!.threeNum![2])] = "";

    widget.createKeyModel!.tmpSeed = widget.createKeyModel!.missingSeeds.join(" ");
    setState(() { });
  }

  @override
  void initState() {
    remove3Seeds();
    super.initState();
  }
  
  Future<void> verifySeeds() async {

  }

  @override
  Widget build(BuildContext context) {
    return VerifyPassphraseBody(
      createKeyModel: widget.createKeyModel,
      verify: verifySeeds,
    );
  }
}
