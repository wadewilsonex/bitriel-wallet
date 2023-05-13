import 'package:url_launcher/url_launcher.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/presentation/components/dialog_c.dart';
import 'package:wallet_apps/constants/db_key_con.dart';
import 'package:wallet_apps/presentation/screen/home/about/about_bitriel.dart';
import 'package:wallet_apps/presentation/screen/home/menu/backup/keystore_json.dart';
import 'package:wallet_apps/presentation/screen/home/menu/wallet_connect/wallet_connect.dart';
import 'package:wallet_apps/presentation/screen/home/setting/security_privacy/security_privacy.dart';
import 'package:wallet_apps/presentation/screen/home/webview/ads_webview.dart';
import 'package:wallet_apps/presentation/screen/home/webview/marketplace_webview.dart';

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

  AppProvider _appPro = Provider.of<AppProvider>(context!, listen: false);
  return [

    CardSection(
      title:'Multiple Wallets',
      subtittle: "Create, Import and Manage Wallets",
      leadingIcon: Icon(Iconsax.user, color: hexaCodeToColor(AppColors.primaryColor), size: 30),
      trailingIcon: Iconsax.arrow_right_3,
      action: () {
        
        Navigator.push(
          context, 
          MaterialPageRoute(
            settings: const RouteSettings(name: "/multipleWallets"),
            builder: (context) => const Account()
          )
        );
        
      }
    ),
    
    CardSection(
      title: 'WalletConnect',
      subtittle: "Manage you DApp connections",
      leadingIcon: SvgPicture.file(
        File("${_appPro.dirPath}/icons/walletconnect.svg"), 
        color: hexaCodeToColor(AppColors.primaryColor),
      ),
      trailingIcon: Iconsax.arrow_right_3,
      action: () {
        
        Navigator.push(
          context,
          Transition(
            child: const WalletConnectPage(),
            transitionEffect: TransitionEffect.RIGHT_TO_LEFT
          )
        );
      }
    )

  ];
}

List<CardSection> settingsAccSection({BuildContext? context, PackageInfo? packageInfo, MenuModel? model, Function? switchBio}) {
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
            child: SecurityPrivacy(model: model, switchBio: switchBio,),
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
      title: 'Terms & Conditions',
      trailingIcon: Iconsax.arrow_right_3,
      action: () {
        Navigator.push(
          context!, 
          Transition(
            child: const AdsWebView(url: "https://www.bitriel.com/legal/terms-conditions", title: "Terms & Conditions",),
            transitionEffect: TransitionEffect.RIGHT_TO_LEFT
          )
        );
      }
    ),

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
    
    CardSection(
      title: 'Community',
      trailingIcon: Iconsax.arrow_right_3,
      action: () async {
        await launchUrl(
          Uri.parse("https://t.me/s/selendrachainofficial"),
          mode: LaunchMode.externalApplication,
        );
      }
    ),
  ];
}

List<CardSection> backupSection({BuildContext? context, required KeyPairData acc}) {
  return [

    CardSection(
      title: 'Keystore (json)',
      trailingIcon: Iconsax.arrow_right_3,
      action: () {
        
        // ApiProvider apiProvider = Provider.of<ApiProvider>(context!, listen: false);
        Map<String, dynamic> jsons = {
          "address": acc.address,
          "encoded": acc.encoded,
          "encoding": acc.encoding,
          "pubKey": acc.pubKey,
          "meta": acc.meta,
          "memo": acc.memo,
          "observation": acc.observation,
          "indexInfo": acc.indexInfo
        };

        Navigator.push(
          context!, 
          MaterialPageRoute(builder: (context) => KeyStoreJson(keystore: jsons,))
        );

      }
    ),

    CardSection(
      title: 'Mnemonic',
      trailingIcon: Iconsax.arrow_right_3,
      action: () async {

        await Navigator.push(context!, MaterialPageRoute(builder: (context) => const Pincode(label: PinCodeLabel.fromBackUp))).then((value) async {
          
          ApiProvider apiProvider = Provider.of<ApiProvider>(context, listen: false);
          await apiProvider.getSdk.api.keyring.getDecryptedSeed(apiProvider.getKeyring, acc, value).then((res) async {
            if (res!.seed != null){
              await DialogComponents().seedDialog(context: context, contents: res.seed.toString());
            } else {
              await DialogComponents().customDialog(context, "Oops", "Invalid PIN", txtButton: "Close");
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
      title: 'Delete All Wallets',
      leadingIcon: Icon(Iconsax.logout, color: hexaCodeToColor(AppColors.whiteColorHexa)),
      action: () async {
        await _deleteAccoutDialog(context: context!);
      }
    ),
  ];
}

  Future<void> _deleteAccoutDialog({BuildContext? context}) async {
    await DialogComponents().customDialog(
      context!, 
      'Are you sure to delete all wallets?', 
      'Your current wallets, and assets will be removed from this app permanently\n\n You can Only recover all wallets with all your Secret Recovery Seed Phrases',
      txtButton: "Cancel",
      btn2: MyFlatButton(
        height: 60,
        edgeMargin: const EdgeInsets.symmetric(horizontal: paddingSize),
        isTransparent: false,
        buttonColor: AppColors.whiteHexaColor,
        textColor: AppColors.redColor,
        textButton: "Confirm",
        isBorder: true,
        action: () async => await _deleteAccount(context: context),
      )
    );
  }
  
  Future<void> _deleteAccount({BuildContext? context}) async {

    dialogLoading(context!);

    final api = Provider.of<ApiProvider>(context, listen: false);
    
    try {

      for( KeyPairData e in api.getKeyring.allAccounts){
        await api.getSdk.api.keyring.deleteAccount(
          api.getKeyring,
          e,
        );
      }

      final mode = await StorageServices.fetchData(DbKey.themeMode);
      final sldNW = await StorageServices.fetchData(DbKey.sldNetwork);

      await StorageServices.clearStorage();

      // Re-Save Them Mode
      await StorageServices.storeData(mode, DbKey.themeMode);
      await StorageServices.storeData(sldNW, DbKey.sldNetwork);

      await StorageServices.clearSecure();
      
      Provider.of<ContractProvider>(context, listen: false).resetConObject();
      
      await Future.delayed(const Duration(seconds: 2), () {});
      
      Provider.of<WalletProvider>(context, listen: false).clearPortfolio();

      Navigator.pushAndRemoveUntil(context, RouteAnimation(enterPage: const Onboarding()), ModalRoute.withName('/'));
    } catch (e) {

      if (kDebugMode) {
      }
      // await dialog(context, e.toString(), 'Opps');
    }
  }