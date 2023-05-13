import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/presentation/components/walletconnect_c.dart';
import 'package:wallet_connect/models/ethereum/wc_ethereum_transaction.dart';

class ConfirmTrx extends StatefulWidget {
  
  final int? id;
  final WCEthereumTransaction? ethereumTransaction;
  final String? title;
  final VoidCallback? onConfirm;
  final VoidCallback? onReject;
  final WCClient? wcClient;
  // final WCPeerMeta? peerMeta;

  const ConfirmTrx({
    Key? key,
    required this.id,
    required this.ethereumTransaction,
    required this.title,
    required this.onConfirm,
    required this.onReject,
    required this.wcClient,
    // required this.peerMeta,

  }) : super(key: key);

  @override
  State<ConfirmTrx> createState() => _ConfirmTrxState();
}

class _ConfirmTrxState extends State<ConfirmTrx> {

  @override
  initState(){
    super.initState();  
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const MyText(
          text: "Confirm Transaction",
          fontSize: 18,
          color2: Colors.black,
          fontWeight: FontWeight.w600
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Iconsax.arrow_left_2,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 30,
          ),
        ),
      ),
      body: Consumer<WalletConnectProvider>(
        builder: (context, walletConProvider, wg) {
          return Column(
            children: [
              
              _bodyInfoTrx(),

              const Spacer(),

              Row(
                children: [

                  Expanded(
                    child: MyFlatButton(
                      height: 60,
                      edgeMargin: const EdgeInsets.all(paddingSize),
                      isTransparent: false,
                      buttonColor: AppColors.whiteHexaColor,
                      textColor: AppColors.redColor,
                      textButton: "Reject",
                      isBorder: true,
                      action: () async {
                        
                        widget.onReject!();
                      },
                    ),
                  ),
              
                  Expanded(
                    child: MyGradientButton(
                      edgeMargin: const EdgeInsets.all(paddingSize),
                      textButton: "Approve",
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

  Widget _bodyInfoTrx() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(paddingSize),
          decoration: BoxDecoration(
            color: hexaCodeToColor(AppColors.whiteColorHexa),
            borderRadius: const BorderRadius.all(Radius.circular(18),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(paddingSize),
            child: Column(
              children: [
                Row(
                  children: const [
                    MyText(
                      pTop: 5,
                      pBottom: 5,
                      text: "Asset",
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.blackColor,
                    ),
          
                    Spacer(),
          
                    MyText(
                      pTop: 5,
                      pBottom: 5,
                      text: "Token Symbol",
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.greyCode,
                    )
                  ],
                ),

                const Divider(),
          
                Row(
                  children: [
                    const MyText(
                      pTop: 5,
                      pBottom: 5,
                      text: "From",
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.blackColor,
                    ),
          
                    const Spacer(),
          
                    MyText(
                      pTop: 5,
                      pBottom: 5,
                      text: widget.ethereumTransaction!.from.replaceRange(6, widget.ethereumTransaction!.from.length - 6, "......."),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.greyCode,
                    )
                  ],
                ),

                const Divider(),
          
                Row(
                  children: const [
                    MyText(
                      pTop: 5,
                      pBottom: 5,
                      text: "DApp",
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.blackColor,
                    ),
          
                    Spacer(),
          
                    MyText(
                      pTop: 5,
                      pBottom: 5,
                      text: "DApp",
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.greyCode,
                    )
                  ],
                )
              ],
            ),
          ),
        ),

        Container(
          margin: const EdgeInsets.only(right: paddingSize, left: paddingSize, top: paddingSize / 2),
          decoration: BoxDecoration(
            color: hexaCodeToColor(AppColors.whiteColorHexa),
            borderRadius: const BorderRadius.all(Radius.circular(18),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(paddingSize),
            child: Column(
              children: [
                Row(
                  children: const [
                    MyText(
                      pTop: 5,
                      pBottom: 5,
                      text: "Network Fee",
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.blackColor,
                    ),
          
                    Spacer(),
          
                    MyText(
                      pTop: 5,
                      pBottom: 5,
                      text: "Network Fee",
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.greyCode,
                    )
                  ],
                ),

                const Divider(),
          
                Row(
                  children: const [
                    MyText(
                      pTop: 5,
                      pBottom: 5,
                      text: "Max Total",
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.blackColor,
                    ),
          
                    Spacer(),
          
                    MyText(
                      pTop: 5,
                      pBottom: 5,
                      text: "Max Total",
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.greyCode,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}