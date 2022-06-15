import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallet_apps/src/components/walletConnect_c.dart';

class WalletConnectBody extends StatelessWidget {

  final TextEditingController emailInputController;
  final TextEditingController passwordInputController;
  final bool? isChecked;
  final Function? handleRememberMe;
  final GlobalKey<FormState> formKey;
  final Function? validator;
  final Function? submitLogin;

  const WalletConnectBody({
    Key? key, 
    required this.emailInputController, 
    required this.passwordInputController, 
    this.handleRememberMe, 
    this.isChecked = false,
    required this.formKey,
    this.validator,
    this.submitLogin
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
                  
                  // await StorageServices().clearKeySecure("session");
                  provider.wcClient.killSession();
                  // await Future.delayed(
                  //   const Duration(milliseconds: 1500),
                  //   (){
                  //     // Close Dialog Message
                      // Navigator.pop(context);
                  //     Navigator.pop(context);
                  //   }
                  // );
                }, 
                child: MyText(text: "Disconnect", color2: Colors.red, fontWeight: FontWeight.bold,)
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(left: paddingSize, right: paddingSize, top: paddingSize),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

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

                  Row(
                    children: [

                      MyText(
                        text: "Connected to",
                        color: AppColors.lowWhite,
                      ),
                      Expanded(
                        child: MyText(
                          color: AppColors.lowWhite,
                          textAlign: TextAlign.end,
                          text: provider.sessionStore!.remotePeerMeta.url,
                          color2: Colors.grey,
                          overflow: TextOverflow.ellipsis,
                        )
                      ),
                    ]
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: paddingSize, bottom: paddingSize),
                    child: Divider(
                      height: 1,
                    )
                  ),

                  Consumer<ContractProvider>(
                    builder: (context, provider, widget){
                      return Row(
                        children: [
                          MyText(
                            text: "Address",
                            color: AppColors.lowWhite,
                          ),
                          Expanded(
                            child: MyText(
                              color: AppColors.lowWhite,
                              textAlign: TextAlign.end,
                              text: provider.ethAdd != '' ? provider.ethAdd.replaceRange( 10, provider.ethAdd.length - 10, ".....") : '...',
                              color2: Colors.grey,
                            )
                          ),
                        ]
                      );
                    }
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: paddingSize, bottom: paddingSize),
                    child: Divider(
                      height: 1,
                    )
                  ),

                  Row(
                    children: [
                      MyText(
                        text: "Network",
                        color: AppColors.lowWhite,
                      ),

                      SizedBox(width: 5.w,),
                      Expanded(
                        child: MyText(
                          text: provider.sessionStore!.remotePeerMeta.name.replaceAll("Network", ""),
                          color: AppColors.lowWhite,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                      ),
                      
                    ]
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: paddingSize, bottom: paddingSize),
                    child: Divider(
                      height: 1,
                    )
                  ),

                  Row(
                    children: [
                      MyText(
                        text: "Signed Transactions",
                        color: AppColors.lowWhite,
                      ),
                      Expanded(child: Container(),),
                      MyText(
                        text: "0",
                        color: AppColors.lowWhite,
                      )
                    ]
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: paddingSize, bottom: paddingSize),
                    child: Divider(
                      height: 1,
                    )
                  ),

                ],
              ),
            )
          ),
        );
      },
    );
  }
}