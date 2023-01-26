import 'package:lottie/lottie.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/walletconnect_c.dart';
import 'package:wallet_apps/src/components/walletconnect_button.c.dart';

class WalletConnectBody extends StatelessWidget {

  final bool? isChecked;
  final Function? handleRememberMe;
  final GlobalKey<FormState> formKey;
  final Function? killSession;

  const WalletConnectBody({
    Key? key, 
    this.handleRememberMe, 
    this.isChecked = false,
    required this.formKey,
    this.killSession,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Consumer<WalletConnectComponent>(
      builder: (context, wcComponent, widget){
        return Scaffold(
          backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Iconsax.arrow_left_2,
                color: isDarkMode ? Colors.white : Colors.black,
                size: 22.5.sp,
              ),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            // actions: [
            //   wcComponent.lsWcClients.isNotEmpty ? TextButton(
            //     onPressed: () async {
            //       await wcComponent.killAllSession();
            //     }, 
            //     child: const MyText(text: "Disconnect All", color2: Colors.red, fontWeight: FontWeight.bold,)
            //   )
            //   : Container(),
            // ],
            elevation: 0,
            backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkCard : AppColors.whiteHexaColor).withOpacity(0),
            title: MyText(text: 'WalletConnect', fontSize: 16, hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor, fontWeight: FontWeight.bold,),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(paddingSize),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MyText(
                    text: "Link your wallet with Decentralized Apps (DApps) that support WalletConnect to make transactions:",
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.start,
                  ),

                  SizedBox(height: 2.5.h),

                  InkWell(
                    onTap: () async{
                      WalletConnectComponent wConnectC = Provider.of<WalletConnectComponent>(context, listen: false);

                      String? value = await Navigator.push(context, MaterialPageRoute(builder: (context) => const QrScanner()));
                        
                      if (value != null){
                        wConnectC.qrScanHandler(value);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(paddingSize),
                      decoration: BoxDecoration(
                        color: hexaCodeToColor(AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [

                          const Icon(Iconsax.scan_barcode, color: Colors.white),

                          SizedBox(width: 2.w,),

                          const MyText(text: "Connect", hexaColor: AppColors.whiteColorHexa,)

                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h,),

                  const MyText(text: "Active connections", hexaColor: AppColors.textColor, fontSize: 17, fontWeight: FontWeight.w700,),

                  SizedBox(height: 2.h,),
                  
                  Consumer<WalletConnectComponent>(
                    builder: (context, provider, widget) {
                      return wcComponent.lsWcClients.isNotEmpty ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: provider.lsWcClients.length,
                            itemBuilder: (context, index){
                              return WalletConnectMenuItem(
                                image: provider.lsWcClients[index].remotePeerMeta.icons[1],
                                title: provider.lsWcClients[index].remotePeerMeta.name,
                                action: () {
                                  killSession!(index);
                                  // Navigator.push(
                                  //   context, 
                                  //   Transition(child: DetailWalletConnect(wcData: provider.lsWcClients[index], index: index), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                                  // );
                                },
                              );
                            },
                          ),

                        ],
                      )
                      :
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              "assets/animation/no-results.json",
                              repeat: false,
                              height: 30.h,
                            ),

                            MyText(
                              text: "Active Connections will appear here",
                              hexaColor: isDarkMode ? AppColors.greyColor : AppColors.lightGreyColor,
                              fontSize: 16,
                            )


                          ],
                        ),
                      );
                    }
                  ),
                ],
              ),
            ),
            // child: Container(
            //   height: MediaQuery.of(context).size.height,
            //   padding: const EdgeInsets.only(left: paddingSize, right: paddingSize, top: paddingSize),
            //   child: Consumer<WalletConnectComponent>(
            //     builder: (context, provider, widget) {
            //       return wcComponent.lsWcClients.isNotEmpty ? Column(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: <Widget>[
            //           GridView.builder(
            //             gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            //               maxCrossAxisExtent: 200,
            //               childAspectRatio: 3 / 2,
            //               crossAxisSpacing: 10,
            //             ),
            //             shrinkWrap: true,
            //             itemCount: provider.lsWcClients.length,
            //             itemBuilder: (context, index){
            //               return WalletConnectMenuItem(
            //                 image: provider.lsWcClients[index].remotePeerMeta.icons[1],
            //                 title: provider.lsWcClients[index].remotePeerMeta.name,
            //                 action: () {
            //                   Navigator.push(
            //                     context, 
            //                     Transition(child: DetailWalletConnect(wcData: provider.lsWcClients[index], index: index), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
            //                   );
            //                 },
            //               );
            //             },
            //           ),

            //         ],
            //       )
            //       :
            //       Center(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //             Lottie.asset(
            //               "assets/animation/no-results.json",
            //               repeat: false,
            //               height: 30.h,
            //             ),

            //             MyText(
            //               text: "Active Connections will appear here",
            //               hexaColor: isDarkMode ? AppColors.greyColor : AppColors.lightGreyColor,
            //               fontSize: 16,
            //             )


            //           ],
            //         ),
            //       );
            //     }
            //   ),
            // )
          ),
          // floatingActionButton: FloatingActionButton(
          //   backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.defiMenuItem : AppColors.orangeColor),
          //   onPressed: () async{
          //     WalletConnectComponent wConnectC = Provider.of<WalletConnectComponent>(context, listen: false);

          //     String? value = await Navigator.push(context, MaterialPageRoute(builder: (context) => const QrScanner()));
                
          //     if (value != null){
                
          //       wConnectC.qrScanHandler(value);
          //     }
          //   },
          //   child: const Icon(Iconsax.add_circle),
          // ),
        );
      },
    );
  }
}