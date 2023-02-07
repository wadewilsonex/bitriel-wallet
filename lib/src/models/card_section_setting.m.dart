import 'package:wallet_apps/auth/google_auth_service.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/components/walletconnect_c.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/screen/home/about/about_bitriel.dart';
import 'package:wallet_apps/src/screen/home/menu/backup/keystore_json.dart';
import 'package:wallet_apps/src/screen/home/menu/wallet_connect/wallet_connect.dart';
import 'package:wallet_apps/src/screen/home/security_privacy/security_privacy.dart';

class CardSection {
  final String? title;
  final String? trailingTitle;
  final Widget? leadingIcon;
  final IconData? trailingIcon;
  final Function? action;

  CardSection({this.title, this.trailingTitle, this.leadingIcon, this.trailingIcon, this.action});
}


List<CardSection> settingsAccSection({BuildContext? context, PackageInfo? packageInfo}) {
  return [
    CardSection(
      title:'Account',
      leadingIcon: Icon(Iconsax.user, color: hexaCodeToColor(AppColors.primaryColor)),
      trailingIcon: Iconsax.arrow_right_3,
      action: () {
        Navigator.push(
          context!, 
          Transition(
            child: const Account(),
            transitionEffect: TransitionEffect.RIGHT_TO_LEFT
          )
        );
      }
    ),
    
    CardSection(
      title: 'WalletConnect',
      leadingIcon: SvgPicture.asset("assets/icons/walletconnect.svg", color: hexaCodeToColor(AppColors.primaryColor),),
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

    CardSection(
      title: 'Security & Privacy',
      leadingIcon: Icon(Iconsax.security_user, color: hexaCodeToColor(AppColors.primaryColor)),
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
      title: 'About Bitriel',
      leadingIcon: Icon(Iconsax.info_circle, color: hexaCodeToColor(AppColors.primaryColor)),
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
        // Navigator.push(
        //   context!, 
        //   Transition(
        //     child: const BackUpKey(),
        //     transitionEffect: TransitionEffect.RIGHT_TO_LEFT
        //   )
        // );
      }
    ),

    CardSection(
      title: 'Visit Our Website',
      trailingIcon: Iconsax.arrow_right_3,
      action: () {
        // Navigator.push(
        //   context!,
        //   Transition(
        //     child: const Account(),
        //     transitionEffect: TransitionEffect.RIGHT_TO_LEFT
        //   )
        // );
      }
    ),

    CardSection(
      title: 'Contact us',
      trailingIcon: Iconsax.arrow_right_3,
      action: () {
        // Navigator.push(
        //   context!,
        //   Transition(
        //     child: const Account(),
        //     transitionEffect: TransitionEffect.RIGHT_TO_LEFT
        //   )
        // );
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
          await apiProvider.apiKeyring.getDecryptedSeed(apiProvider.getKeyring, value).then((res) async {
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

      await api.apiKeyring.deleteAccount(
        api.getKeyring,
        api.accountM.currentAcc,
      );

      final mode = await StorageServices.fetchData(DbKey.themeMode);
      final sldNW = await StorageServices.fetchData(DbKey.sldNetwork);
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