import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/import_acc_m.dart';
import 'package:wallet_apps/src/screen/main/i_acc.dart';
import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:wallet_apps/src/screen/main/json/body_json.dart';

class ImportJson extends StatefulWidget {
  
  const ImportJson({Key? key}) : super(key: key);

  @override
  State<ImportJson> createState() => _ImportJsonState();
}

class _ImportJsonState extends State<ImportJson> with AccountInterface {
  
  final ImportAccModel _accModel = ImportAccModel();
  final ImportAccAnimationModel _animationModel = ImportAccAnimationModel();

  @override
  void initState(){

    _accModel.initImportState(apiPro: Provider.of<ApiProvider>(context, listen: false), keyTp: KeyType.keystore);
    _accModel.setBuildContext = context;

    initAccInterfaceState(_accModel, _animationModel);

    super.initState();
  }

  void onChanged(String? value){
    
    if (value!.isNotEmpty){
      
      if (_accModel.keyNode!.hasFocus){
        if (value.isNotEmpty && value.contains('meta')){
          _accModel.usrName!.text = json.decode(value)['meta']['name'];

          _animationModel.enable = true;
        } else {
          _animationModel.enable = false;
        }
        setState(() {
          
          print("onChanged ${_animationModel.enable}");
        });
      }
    }
  }

  // void onSubmit(String? value) async {
    
  //   if (value!.isNotEmpty){
  //     await importProcess(importAcc);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black,)
        ),
        elevation: 0,
      ),
      body: JsonBody(
        accModel: _accModel,
        onChanged: onChanged,
        onSubmit: onSubmit,
      )
      // Column(
      //   children: [

      //     TextFormField(
      //       controller: _accModel.key,
      //       focusNode: _accModel.keyNode,
      //       onChanged: onChanged,
      //     ),

      //     TextFormField(
      //       controller: _accModel.pwCon,
      //       focusNode: _accModel.pwNode,
      //       onChanged: onChanged,
      //     ),

      //     if (_accModel.key!.text.isNotEmpty && _accModel.key!.text.contains('meta')) MyText(
      //       text: json.decode(_accModel.key!.text)['meta']['name'],
      //     ),

      //     ElevatedButton(
      //       onPressed: () async {
      //         await importAcc(_accModel);
      //       }, 
      //       child: MyText(
      //         text: "Import Json",
      //       )
      //     )
      //   ],
      // )
      // SizedBox(
      //   height: MediaQuery.of(context).size.height,
      //   child: ImportAccBody(
      //     reImport: widget.reimport,
      //     importAccModel: _importAccModel,
      //     onChanged: onChanged,
      //     onSubmit: widget.reimport != null ? onSubmitIm : onSubmit,
      //     clearInput: clearInput,
      //     enable: enable,
      //   ),
      // )
    );
  }
}