import 'package:lottie/lottie.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/walletconnect_c.dart';
import 'package:wallet_apps/src/components/walletconnect_button.c.dart';
import 'package:wallet_apps/src/screen/home/menu/wallet_connect/detail_walletconnect.dart';

class WalletConnectBody extends StatelessWidget {

  final TextEditingController emailInputController;
  final TextEditingController passwordInputController;
  final bool? isChecked;
  final Function? handleRememberMe;
  final GlobalKey<FormState> formKey;

  const WalletConnectBody({
    Key? key, 
    required this.emailInputController, 
    required this.passwordInputController, 
    this.handleRememberMe, 
    this.isChecked = false,
    required this.formKey,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final darkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Consumer<WalletConnectComponent>(
      builder: (context, wcComponent, widget){
        // print("provider.sessionStore! ${provider.sessionStore!.toJson()}");
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: MyText(text: "WalletConnect", color: darkTheme ? AppColors.lowWhite : AppColors.blackColor,),
            actions: [
              wcComponent.lsWcClients.isNotEmpty ? TextButton(
                onPressed: () async {
                  await wcComponent.killAllSession();
                  // await Future.delayed(
                  //   const Duration(milliseconds: 1500),
                  //   (){
                  //     // Close Dialog Message
                      // Navigator.pop(context);
                  //     Navigator.pop(context);
                  //   }
                  // );
                }, 
                child: const MyText(text: "Disconnect All", color2: Colors.red, fontWeight: FontWeight.bold,)
              )
              : Container(),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(left: paddingSize, right: paddingSize, top: paddingSize),
              child: Consumer<WalletConnectComponent>(
                builder: (context, provider, widget) {
                  return wcComponent.lsWcClients.isNotEmpty ? Column(
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

                        const MyText(
                          text: "Active Connections will appear here",
                          color: AppColors.greyColor,
                          fontSize: 16,
                        )


                      ],
                    ),
                  );
                }
              ),
            )
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: hexaCodeToColor(AppColors.defiMenuItem),
            onPressed: () async{
              WalletConnectComponent wConnectC = Provider.of<WalletConnectComponent>(context, listen: false);

              String? value = await Navigator.push(context, MaterialPageRoute(builder: (context) => const QrScanner()));
                
              if (value != null){
                
                wConnectC.qrScanHandler(value);
              }
            },
            child: const Icon(Iconsax.add_circle),
          ),
        );
      },
    );
  }
}