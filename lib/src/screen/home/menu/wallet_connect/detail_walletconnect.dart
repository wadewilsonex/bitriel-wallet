import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/walletconnect_c.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_connect/wc_session_store.dart';

class DetailWalletConnect extends StatefulWidget {
  final WCSessionStore? wcData;
  final int? index;
  const DetailWalletConnect({Key? key, this.wcData, this.index}) : super(key: key);

  @override
  State<DetailWalletConnect> createState() => _DetailWalletConnectState();
}

class _DetailWalletConnectState extends State<DetailWalletConnect> {

  WalletConnectComponent? _wConnectC;

  @override
  void initState() {
    _wConnectC = Provider.of<WalletConnectComponent>(context, listen: false);
    initConnectWC();
    super.initState();
  }
  
  void initConnectWC(){
    _wConnectC!.connectToPreviousSession(widget.wcData!);
  }

  void killSession() async {
    _wConnectC!.wcClient.killSession();
    if (kDebugMode) {
      print("widget.index! ${widget.index!}");
    }
    _wConnectC!.lsWcClients.removeAt(widget.index!);
    if (kDebugMode) {
      print("_wConnectC!.lsWcClients ${_wConnectC!.lsWcClients}");
    }
    List<Map<String, dynamic>> tmpWcSession = [];

    for (var element in _wConnectC!.lsWcClients) {
      tmpWcSession.add(element.toJson());
    }

    await StorageServices.storeData(tmpWcSession, DbKey.wcSession);
    _wConnectC!.afterKill();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor)
        ),
        backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Iconsax.arrow_left_2),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              
              Center(
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(widget.wcData!.remotePeerMeta.icons[1])
                    )
                  )
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyText(
                  text: widget.wcData!.remotePeerMeta.name,
                  // hexaColor: AppColors.lowWhite,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 48.0,
                        offset: const Offset(0.0, 2)
                      )
                    ],
                    border: Border.all(
                      color: isDarkMode ? Colors.transparent : hexaCodeToColor(AppColors.orangeColor).withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const MyText(
                          text: "Connected to",
                          // hexaColor: AppColors.lowWhite,
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),

                        Expanded(
                          child: MyText(
                            // hexaColor: AppColors.lowWhite,
                            textAlign: TextAlign.end,
                            text: widget.wcData!.remotePeerMeta.url,
                            color2: Colors.grey,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 17,
                          )
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 48.0,
                        offset: const Offset(0.0, 2)
                      )
                    ],
                    border: Border.all(
                      color: isDarkMode ? Colors.transparent : hexaCodeToColor(AppColors.orangeColor).withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const MyText(
                          text: "Chain ID",
                          // hexaColor: AppColors.lowWhite,
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),

                        Expanded(
                          child: MyText(
                            // hexaColor: AppColors.lowWhite,
                            textAlign: TextAlign.end,
                            text: widget.wcData!.chainId.toString(),
                            color2: Colors.grey,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 17,
                          )
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Consumer<ContractProvider>(
                builder: (context, provider, widget){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 48.0,
                            offset: const Offset(0.0, 2)
                          )
                        ],
                        border: Border.all(
                          color: isDarkMode ? Colors.transparent : hexaCodeToColor(AppColors.orangeColor).withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const MyText(
                              text: "Address",
                              // hexaColor: AppColors.lowWhite,
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                            ),
                            Expanded(
                              child: MyText(
                                // hexaColor: AppColors.lowWhite,
                                textAlign: TextAlign.end,
                                text: provider.ethAdd != '' ? provider.ethAdd.replaceRange( 10, provider.ethAdd.length - 10, ".....") : '...',
                                color2: Colors.grey,
                                fontSize: 17,
                              )
                            ),
                          ]
                        ),
                      ),
                    ),
                  );
                }
              ),

              Padding(
                padding: const EdgeInsets.all(18.0),
                child: MyFlatButton(
                  isTransparent: true,
                  textButton: "Disconnect",
                  textColor: AppColors.redColor,
                  action: () {
                    killSession();
                  },
                ),
              )
              
            ],
          ),
        ),
      ),
    );
  }
}