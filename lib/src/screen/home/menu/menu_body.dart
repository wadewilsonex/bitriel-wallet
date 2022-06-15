import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/components/walletConnect_c.dart';
import 'package:wallet_apps/src/screen/home/menu/wallet_connect/wallet_connect.dart';
import 'package:wallet_connect/wc_session_store.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';

class MenuBody extends StatelessWidget {
  
  final Map<String, dynamic>? userInfo;
  final MenuModel? model;
  final Function? enablePassword;
  final Function? switchBio;
  final Function? switchTheme;

  const MenuBody({
    this.userInfo,
    this.model,
    this.enablePassword,
    this.switchBio,
    this.switchTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        MenuHeader(userInfo: userInfo),

        // Wallet
        const MenuSubTitle(index: 1),
        
        MyListTile(
          icon: Icon(Iconsax.card_coin, color: Colors.white, size: 22.5.sp),
          index: 2,
          subIndex: 1,
          onTap: () {
            Navigator.push(context, Transition(child: Swap(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
          },
        ),

        MyListTile(
          icon: Icon(Iconsax.note_2, color: Colors.white, size: 22.5.sp),
          index: 1,
          subIndex: 0,
          onTap: () {
            Navigator.push(context, Transition(child: ReceiveWallet(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
          },
        ),

        MyListTile(
          icon: Icon(Iconsax.wallet_check, color: Colors.white, size: 22.5.sp),
          index: 1,
          subIndex: 1,
          onTap: () {
            // underContstuctionAnimationDailog(context: context);
            Navigator.push(context, Transition(child: AddAsset(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
          },
        ),
        
        MyListTile(
          // icon: Icon(Iconsax.wallet, color: Colors.white, size: 22.5.sp),
          index: 1,
          subIndex: 2,
          onTap: () async {
            WalletConnectComponent _wConnectC = Provider.of<WalletConnectComponent>(context, listen: false);
            _wConnectC.setBuildContext = context;
            await StorageServices.fetchData('session').then((value) async {
              if (value == null){

                String? value = await Navigator.push(context, MaterialPageRoute(builder: (context) => QrScanner()));
                
                if (value != null){
                  
                  _wConnectC.qrScanHandler(value);
                }
              } else {
                _wConnectC.sessionStore = WCSessionStore.fromJson(value);
                try {

                  _wConnectC.wcClient.connectFromSessionStore(_wConnectC.sessionStore!);
                } catch (e){
                  if (ApiProvider().isDebug == true) print("error _wConnectC.wcClient $e");
                }
              }
            });
            // underContstuctionAnimationDailog(context: context);
          },
        ),

        // Account
        const MenuSubTitle(index: 3),

        // MyListTile(
        //   icon: Icon(Iconsax.lock, color: Colors.white, size: 22.5.sp),
        //   enable: false,
        //   index: 3,
        //   subIndex: 0,
        //   trailing: Switch(
        //     value: model!.switchPasscode,
        //     onChanged: (value) async {
        //       // Navigator.pushNamed(context, AppText.passcodeView);
        //       final res = await Navigator.push(
        //         context,
        //         Transition(child: Passcode(isAppBar: true, label: PassCodeLabel.fromMenu,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
        //       );
        //       print("res $res");
        //       if (res != null) {
        //         enablePassword!(!model!.switchPasscode, data: res);
        //       }
        //     },
        //   ),
        //   onTap: null,
        // ),

        MyListTile(
          icon: Icon(Iconsax.finger_scan, color: Colors.white, size: 22.5.sp),
          enable: false,
          index: 3,
          subIndex: 1,
          trailing: Switch(
            value: model!.switchBio,
            onChanged: (value) {
              switchBio!(context, value);
            },
          ),
          onTap: null,
        ),

        const MenuSubTitle(index: 5),

        MyListTile(
          icon: Icon(Iconsax.people, color: Colors.white, size: 22.5.sp),
          index: 5,
          subIndex: 0,
          onTap: () async {
            Navigator.push(context, Transition(child: About(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
            //_launchInBrowser('https://selendra.com/privacy');
          },
        ),
      ],
    );
  }
}
