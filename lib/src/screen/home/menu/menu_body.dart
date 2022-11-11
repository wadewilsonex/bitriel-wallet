import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/walletconnect_c.dart';
import 'package:wallet_apps/src/screen/home/menu/wallet_connect/wallet_connect.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';

class MenuBody extends StatelessWidget {
  
  final Map<String, dynamic>? userInfo;
  final MenuModel? model;
  final Function? enablePassword;
  final Function? switchBio;
  final Function? switchTheme;

  const MenuBody({
    Key? key, 
    this.userInfo,
    this.model,
    this.enablePassword,
    this.switchBio,
    this.switchTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        MenuHeader(userInfo: userInfo),

        // Wallet
        MenuSubTitle(index: 1),
        
        // MyListTile(
        //   icon: Icon(Iconsax.card_coin, color: Colors.white, size: 22.5.sp),
        //   index: 2,
        //   subIndex: 1,
        //   onTap: () {
        //     Navigator.push(context, Transition(child: Swap(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
        //   },
        // ),

        MyListTile(
          icon: Icon(Iconsax.note_2, color: isDarkMode ? Colors.white : hexaCodeToColor(AppColors.darkGrey), size: 22.5.sp),
          index: 1,
          subIndex: 0,
          onTap: () {
            Navigator.push(context, Transition(child: const ReceiveWallet(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
          },
        ),

        MyListTile(
          icon: Icon(Iconsax.wallet_check, color: isDarkMode ? Colors.white : hexaCodeToColor(AppColors.darkGrey), size: 22.5.sp),
          index: 1,
          subIndex: 1,
          onTap: () {
            // underContstuctionAnimationDailog(context: context);
            Navigator.push(context, Transition(child: const AddAsset(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
          },
        ),
        
        MyListTile(
          // icon: Icon(Iconsax.wallet, color: Colors.white, size: 22.5.sp),
          index: 1,
          subIndex: 2,
          onTap: () async {

            // await StorageServices.removeKey(DbKey.wcSession);
            
            WalletConnectComponent wConnectC = Provider.of<WalletConnectComponent>(context, listen: false);
            wConnectC.setBuildContext = context;
            await StorageServices.fetchData(DbKey.wcSession).then((value) async {

              if (value == null){

                String? value = await Navigator.push(context, MaterialPageRoute(builder: (context) => const QrScanner()));
                
                if (value != null){
                  
                  wConnectC.qrScanHandler(value);
                }
              } else {
                Navigator.push(
                  context, 
                  Transition(child: const WalletConnectPage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                );
                // _wConnectC.sessionStore = WCSessionStore.fromJson(value);
                // try {

                //   _wConnectC.wcClient.connectFromSessionStore(_wConnectC.sessionStore!);
                //   // _wConnectC.connectToPreviousSession();
                //   Navigator.push(
                //     context, 
                //     Transition(child: WalletConnectPage(wcData: value,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                //   );
                // } catch (e){
                //   if (ApiProvider().isDebug == true) print("error _wConnectC.wcClient $e");
                // }
              }
            });
            // underContstuctionAnimationDailog(context: context);
          },
        ),

        // Account
        MenuSubTitle(index: 3),

        MyListTile(
          icon: Icon(Iconsax.finger_scan, color: isDarkMode ? Colors.white : hexaCodeToColor(AppColors.darkGrey), size: 22.5.sp),
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

        MenuSubTitle(index: 4),
        MyListTile(
          icon: Icon(Iconsax.moon, color: isDarkMode ? Colors.white : hexaCodeToColor(AppColors.darkGrey), size: 22.5.sp),
          enable: false,
          index: 4,
          subIndex: 0,
          trailing: Switch(
            activeColor: hexaCodeToColor(AppColors.defiMenuItem),
            value: isDarkMode,
            onChanged: (value) {
              switchTheme!(value);
            },
          ),
          onTap: null,
        ),

        MenuSubTitle(index: 5),

        MyListTile(
          icon: Icon(Iconsax.people, color: isDarkMode ? Colors.white : hexaCodeToColor(AppColors.darkGrey), size: 22.5.sp),
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
