import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/screen/home/about/about_bitriel.dart';
import 'package:wallet_apps/src/screen/home/menu/backup/keystore_json.dart';
import 'package:wallet_apps/src/screen/home/menu/wallet_connect/wallet_connect.dart';
import 'package:wallet_apps/src/screen/home/security_privacy/security_privacy.dart';
import 'package:wallet_apps/src/screen/home/webview/ads_webview.dart';
import 'package:wallet_apps/src/screen/home/webview/marketplace_webview.dart';

class CardSection {
  final String? title;
  final String? subtittle;
  final String? trailingTitle;
  final Widget? leadingIcon;
  final IconData? trailingIcon;
  final Function? action;

  CardSection({this.title, this.subtittle, this.trailingTitle, this.leadingIcon, this.trailingIcon, this.action});
}


List<CardSection> settingsWalletSection({BuildContext? context, PackageInfo? packageInfo}) {
  return [

    CardSection(
      title:'Multiple Wallets',
      subtittle: "Create, Import and Manage Wallets",
      leadingIcon: Icon(Iconsax.user, color: hexaCodeToColor(AppColors.primaryColor), size: 30),
      trailingIcon: Iconsax.arrow_right_3,
      action: () {
        
        Navigator.push(
          context!, 
          MaterialPageRoute(
            settings: const RouteSettings(name: "/multipleWallets"),
            builder: (context) => const Account()
          )
        );


          // Transition(
          //   arguments: "/multipleWallets",
          //   child: const MultipleWallets(),
          //   transitionEffect: TransitionEffect.RIGHT_TO_LEFT
          // )
      }
    ),
    
    CardSection(
      title: 'WalletConnect',
      subtittle: "Manage you DApp connections",
      leadingIcon: SvgPicture.asset(
        "assets/icons/walletconnect.svg", 
        color: hexaCodeToColor(AppColors.primaryColor),
      ),
      trailingIcon: Iconsax.arrow_right_3,
      action: () {
        Navigator.push(
          context!,
          Transition(
            child: const WalletConnectPage(),
            transitionEffect: TransitionEffect.RIGHT_TO_LEFT
          )
        );
      }
    ),

  ];
}

List<CardSection> settingsAccSection({BuildContext? context, PackageInfo? packageInfo}) {
  return [

    CardSection(
      title: 'Security & Privacy',
      subtittle: "Change PIN number, Auto lock, Biometric",
      leadingIcon: Icon(Iconsax.security_user, color: hexaCodeToColor(AppColors.primaryColor), size: 30,),
      trailingIcon: Iconsax.arrow_right_3,
      action: () {
        Navigator.push(
          context!,
          Transition(
            child: const SecurityPrivacy(),
            transitionEffect: TransitionEffect.RIGHT_TO_LEFT
          )
        );
      }
    ),

    CardSection(
      title: 'About Us',
      subtittle: "Term of Use, Contact Us",
      leadingIcon: Icon(Iconsax.info_circle, color: hexaCodeToColor(AppColors.primaryColor), size: 30,),
      trailingIcon: Iconsax.arrow_right_3,
      action: () {
        Navigator.push(
          context!,
          Transition(
            child: AboutBitriel(packageInfo: packageInfo),
            transitionEffect: TransitionEffect.RIGHT_TO_LEFT
          )
        );
      }
    ),

  ];
}

List<CardSection> infoSection({BuildContext? context}) {
  return [
    CardSection(
      title: 'Privacy Policy (Terms of Use)',
      trailingIcon: Iconsax.arrow_right_3,
      action: () {
        Navigator.push(
          context!, 
          Transition(
            child: const AdsWebView(url: "https://bitriel.com/legal/privacy-policy", title: "Privacy Policy",),
            transitionEffect: TransitionEffect.RIGHT_TO_LEFT
          )
        );
      }
    ),

    CardSection(
      title: 'Visit Our Website',
      trailingIcon: Iconsax.arrow_right_3,
      action: () {
        Navigator.push(
          context!, 
          Transition(
            child: const MarketPlaceWebView(url: "https://bitriel.com/", title: "BITRIEL",),
            transitionEffect: TransitionEffect.RIGHT_TO_LEFT
          )
        );
      }
    ),
    
  ];
}

List<CardSection> backupSection({BuildContext? context}) {
  return [
    CardSection(
      title: 'Keystore (json)',
      trailingIcon: Iconsax.arrow_right_3,
      action: () {
        ApiProvider apiProvider = Provider.of<ApiProvider>(context!, listen: false);
        Map<String, dynamic> jsons = {
          "address": Provider.of<ContractProvider>(context, listen: false).listContract[apiProvider.selNativeIndex].address,
          "encoded": apiProvider.getKeyring.current.encoded,
          "encoding": apiProvider.getKeyring.current.encoding,
          "pubKey": apiProvider.getKeyring.current.pubKey,
          "meta": apiProvider.getKeyring.current.meta,
          "memo": apiProvider.getKeyring.current.memo,
          "observation": apiProvider.getKeyring.current.observation,
          "indexInfo": apiProvider.getKeyring.current.indexInfo
        };

        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => KeyStoreJson(keystore: jsons,))
        );
      }
    ),

    CardSection(
      title: 'Mnemonic',
      trailingIcon: Iconsax.arrow_right_3,
      action: () async {
        await Navigator.push(context!, MaterialPageRoute(builder: (context) => const Passcode(label: PassCodeLabel.fromBackUp))).then((value) async {
          ApiProvider apiProvider = Provider.of<ApiProvider>(context, listen: false);
          await apiProvider.getSdk.api.keyring.getDecryptedSeed(apiProvider.getKeyring, value).then((res) async {
            if (res!.seed != null){
              await DialogComponents().seedDialog(context: context, contents: res.seed.toString());
            } else {
              await DialogComponents().dialogCustom(context: context, titles: "Oops", contents: "Invalid PIN");
            }
          });
        });
      }
    ),

  ];
}

List<CardSection> settingsLogoutSection({BuildContext? context}) {
  return [
    CardSection(
      title: 'Delete Wallet',
      leadingIcon: Icon(Iconsax.logout, color: hexaCodeToColor(AppColors.whiteColorHexa)),
      action: () async {
        await deleteAccout(context: context!);
      }
    ),
  ];
}

  Future<void> deleteAccout({BuildContext? context}) async {
    await customDialog(
      context!, 
      'Delete account', 
      'Are you sure to delete your account?',
      btn2: TextButton(
        onPressed: () async => await _deleteAccount(context: context),
        child: const MyText(
          text: 'Delete',
          hexaColor: AppColors.redColor,
          fontWeight: FontWeight.w700
        ),
      ),
    );
  }
  
  Future<void> _deleteAccount({BuildContext? context}) async {

    dialogLoading(context!);

    final api = Provider.of<ApiProvider>(context, listen: false);
    
    try {

      await api.getSdk.api.keyring.deleteAccount(
        api.getKeyring,
        api.getKeyring.current,
      );

      final mode = await StorageServices.fetchData(DbKey.themeMode);
      final sldNW = await StorageServices.fetchData(DbKey.sldNetwork);

      print(mode);
      print(sldNW);
      // final event = await StorageServices.fetchData(DbKey.event);

      await StorageServices().clearStorage();

      // Re-Save Them Mode
      await StorageServices.storeData(mode, DbKey.themeMode);
      await StorageServices.storeData(sldNW, DbKey.sldNetwork);
      // await StorageServices.storeData(event, DbKey.event);

      await StorageServices().clearSecure();
      
      Provider.of<ContractProvider>(context, listen: false).resetConObject();
      
      await Future.delayed(const Duration(seconds: 2), () {});
      
      Provider.of<WalletProvider>(context, listen: false).clearPortfolio();

      Navigator.pushAndRemoveUntil(context, RouteAnimation(enterPage: const Onboarding()), ModalRoute.withName('/'));
    } catch (e) {

      if (kDebugMode) {
        print("_deleteAccount ${e.toString()}");
      }
      // await dialog(context, e.toString(), 'Opps');
    }
  }