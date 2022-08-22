import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallet_apps/src/components/marketplace_menu_item_c.dart';
import 'package:wallet_apps/src/components/walletConnect_c.dart';
import 'package:wallet_apps/src/components/walletconnect_button.c.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/screen/home/menu/wallet_connect/detail_walletconnect.dart';

class WalletConnectBody extends StatelessWidget {

  final TextEditingController emailInputController;
  final TextEditingController passwordInputController;
  final bool? isChecked;
  final Function? handleRememberMe;
  final GlobalKey<FormState> formKey;
  final Function? validator;
  final Function? submitLogin;
  // final dynamic wcData;

  const WalletConnectBody({
    Key? key, 
    required this.emailInputController, 
    required this.passwordInputController, 
    this.handleRememberMe, 
    this.isChecked = false,
    required this.formKey,
    this.validator,
    this.submitLogin,
    // this.wcData
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final darkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Consumer<WalletConnectComponent>(
      builder: (context, provider, widget){
        // print("provider.sessionStore! ${provider.sessionStore!.toJson()}");
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: MyText(text: "WalletConnect", color: darkTheme ? AppColors.lowWhite : AppColors.blackColor,),
            actions: [
              TextButton(
                onPressed: () async {
                  await provider.killAllSession();
                  // await Future.delayed(
                  //   const Duration(milliseconds: 1500),
                  //   (){
                  //     // Close Dialog Message
                      // Navigator.pop(context);
                  //     Navigator.pop(context);
                  //   }
                  // );
                }, 
                child: MyText(text: "Disconnect All", color2: Colors.red, fontWeight: FontWeight.bold,)
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(left: paddingSize, right: paddingSize, top: paddingSize),
              child: Consumer<WalletConnectComponent>(
                builder: (context, provider, widget) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GridView.builder(
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 10,
                        ),
                        shrinkWrap: true,
                        itemCount: provider.lsWcClients.length,
                        itemBuilder: (context, index){
                          return WalletConnectMenuItem(
                            image: provider.lsWcClients[index].remotePeerMeta.icons[1],
                            title: provider.lsWcClients[index].remotePeerMeta.name,
                            action: () {
                              Navigator.push(
                                context, 
                                Transition(child: DetailWalletConnect(wcData: provider.lsWcClients[index], index: index), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                              );
                            },
                          );
                        },
                      ),


                      
                      // Padding(
                      //   padding: EdgeInsets.only(bottom: paddingSize),
                      //   child: Image.network(provider.sessionStore!.remotePeerMeta.icons.first.replaceAll("localhost", provider.ip!), width: 80,),
                      // ),

                      // MyText(
                      //   text: provider.sessionStore!.remotePeerMeta.name,
                      //   fontSize: 23,
                      //   fontWeight: FontWeight.bold,
                      //   bottom: paddingSize+paddingSize
                      // ),

                      // Row(
                      //   children: [

                      //     MyText(
                      //       text: "Connected to",
                      //       color: AppColors.lowWhite,
                      //     ),
                      //     Expanded(
                      //       child: MyText(
                      //         color: AppColors.lowWhite,
                      //         textAlign: TextAlign.end,
                      //         text: provider.sessionStore!.remotePeerMeta.url,
                      //         color2: Colors.grey,
                      //         overflow: TextOverflow.ellipsis,
                      //       )
                      //     ),
                      //   ]
                      // ),

                      // Padding(
                      //   padding: EdgeInsets.only(top: paddingSize, bottom: paddingSize),
                      //   child: Divider(
                      //     height: 1,
                      //   )
                      // ),

                      // Consumer<ContractProvider>(
                      //   builder: (context, provider, widget){
                      //     return Row(
                      //       children: [
                      //         MyText(
                      //           text: "Address",
                      //           color: AppColors.lowWhite,
                      //         ),
                      //         Expanded(
                      //           child: MyText(
                      //             color: AppColors.lowWhite,
                      //             textAlign: TextAlign.end,
                      //             text: provider.ethAdd != '' ? provider.ethAdd.replaceRange( 10, provider.ethAdd.length - 10, ".....") : '...',
                      //             color2: Colors.grey,
                      //           )
                      //         ),
                      //       ]
                      //     );
                      //   }
                      // ),

                      // Padding(
                      //   padding: EdgeInsets.only(top: paddingSize, bottom: paddingSize),
                      //   child: Divider(
                      //     height: 1,
                      //   )
                      // ),

                      // Row(
                      //   children: [
                      //     MyText(
                      //       text: "Network",
                      //       color: AppColors.lowWhite,
                      //     ),

                      //     SizedBox(width: 5.w,),
                      //     Expanded(
                      //       child: MyText(
                      //         text: provider.sessionStore!.remotePeerMeta.name.replaceAll("Network", ""),
                      //         color: AppColors.lowWhite,
                      //         overflow: TextOverflow.ellipsis,
                      //         textAlign: TextAlign.end,
                      //       ),
                      //     ),
                          
                      //   ]
                      // ),

                      // Padding(
                      //   padding: EdgeInsets.only(top: paddingSize, bottom: paddingSize),
                      //   child: Divider(
                      //     height: 1,
                      //   )
                      // ),

                      // Row(
                      //   children: [
                      //     MyText(
                      //       text: "Signed Transactions",
                      //       color: AppColors.lowWhite,
                      //     ),
                      //     Expanded(child: Container(),),
                      //     MyText(
                      //       text: "0",
                      //       color: AppColors.lowWhite,
                      //     )
                      //   ]
                      // ),

                      // Padding(
                      //   padding: EdgeInsets.only(top: paddingSize, bottom: paddingSize),
                      //   child: Divider(
                      //     height: 1,
                      //   )
                      // ),

                    ],
                  );
                }
              ),
            )
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async{
              WalletConnectComponent _wConnectC = Provider.of<WalletConnectComponent>(context, listen: false);

              String? value = await Navigator.push(context, MaterialPageRoute(builder: (context) => QrScanner()));
                
              if (value != null){
                
                _wConnectC.qrScanHandler(value);
              }
            },
            child: Icon(Iconsax.add_circle),
          ),
        );
      },
    );
  }
}