import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/walletconnect_c.dart';
import 'package:wallet_connect/models/ethereum/wc_ethereum_transaction.dart';

class ConfirmTrx extends StatefulWidget {
  
  final int? id;
  final WCEthereumTransaction? ethereumTransaction;
  final String? title;
  final VoidCallback? onConfirm;
  final VoidCallback? onReject;
  final WCClient? wcClient;

  const ConfirmTrx({
    Key? key,
    required this.id,
    required this.ethereumTransaction,
    required this.title,
    required this.onConfirm,
    required this.onReject,
    required this.wcClient

  }) : super(key: key);

  @override
  State<ConfirmTrx> createState() => _ConfirmTrxState();
}

class _ConfirmTrxState extends State<ConfirmTrx> {

  @override
  initState(){
    print("id: ${widget.id}");
    print("ethereumTransaction: ${widget.ethereumTransaction!.toJson()}");
    print("title: ${widget.title}");
    print("onConfirm: ${widget.onConfirm}");
    print("onReject: ${widget.onReject}");
    print("wcClien: ${widget.wcClient!.chainId}");
    super.initState();  
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black,),
          onPressed: () => Navigator.pop(context),
        ),
        title: const MyText(text: "Confirm Transaction"),
      ),
      body: Consumer<WalletConnectProvider>(
        builder: (context, walletConProvider, wg) {
          return Column(
            children: [
              Row(
                children: [

                  Expanded(
                    child: MyGradientButton(
                      edgeMargin: const EdgeInsets.all(paddingSize),
                      textButton: "Reject",
                      fontWeight: FontWeight.w400,
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      action: () async {
                        
                        widget.onReject!();
                      },
                    ),
                  ),
              
                  Expanded(
                    child: MyGradientButton(
                      edgeMargin: const EdgeInsets.all(paddingSize),
                      textButton: "Approve",
                      fontWeight: FontWeight.w400,
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      action: () async {

                        widget.onConfirm!();

                      },
                    ),
                  )
                ],
              )
            ],
          );
        }
      ),
    );
  }
}