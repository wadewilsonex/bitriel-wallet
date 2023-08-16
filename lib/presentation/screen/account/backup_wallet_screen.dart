import 'package:bitriel_wallet/index.dart';

class BackUpWalletScreen extends StatelessWidget{

  const BackUpWalletScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
     
    return Scaffold(
      appBar: appBar(context, title: "Export Mnemonic"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: paddingSize),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

          ]
        ),
      )
    );
  }
  
}