import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/provider/auth/google_auth_service.dart';
import 'package:wallet_apps/src/screen/home/ads_webview/ads_webview.dart';
import 'package:wallet_apps/src/screen/home/menu/wallet_connect/wallet_connect.dart';
import '../components/walletconnect_c.dart';
import '../screen/home/menu/backup/backup_key.dart';

class CardSection {
  final String? title;
  final String? trailingTitle;
  final IconData? leadingIcon;
  final Function? action;

  CardSection({this.title, this.trailingTitle, this.leadingIcon, this.action});
}


List<CardSection> settingsAccSection({BuildContext? context}) {
  return [
    CardSection(
      title:'Backup Keys',
      leadingIcon: Iconsax.lock_1,
      action: () {
        Navigator.push(
          context!, 
          Transition(
            child: const BackUpKey(),
            transitionEffect: TransitionEffect.RIGHT_TO_LEFT
          )
        );
      }
    ),
    CardSection(
      title: 'Account',
      leadingIcon: Iconsax.personalcard,
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
  ];
}

List<CardSection> settingsWCSection({BuildContext? context}) {
  return [
    CardSection(
      title: 'Wallet Connect',
      leadingIcon: Iconsax.bitcoin_convert,
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

List<CardSection> settingsPolicySection({BuildContext? context}) {
  return [
    CardSection(
      title: 'Terms of Service',
      leadingIcon: Iconsax.archive_book,
      action: () {
        Navigator.push(
          context!, 
          Transition(child: AdsWebView(url: "https://bitriel.com/termofuse", title: "Terms of Service",), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
        );
      }
    ),
    CardSection(
      title: 'Privacy Policy',
      leadingIcon: Iconsax.document,
      action: () {
        Navigator.push(
          context!, 
          Transition(child: AdsWebView(url: "https://bitriel.com/privacy", title: "Privacy policy",), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
        );
      }
    ),
  ];
}

List<CardSection> settingsLogoutSection({BuildContext? context}) {
  return [
    CardSection(
      title: 'Logout',
      leadingIcon: Iconsax.logout,
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

    final wcComponent = Provider.of<WalletConnectComponent>(context, listen: false);
    
    try {
      
      try {
        await api.apiKeyring.deleteAccount(
          api.getKeyring,
          api.getKeyring.keyPairs[0],
        );
      } catch(e){
        print("Error deleteAccount $e");
      }

      final mode = await StorageServices.fetchData(DbKey.themeMode);
      // final event = await StorageServices.fetchData(DbKey.event);

      await StorageServices().clearStorage();

      final pref = await SharedPreferences.getInstance();
      String? value = pref.getString("session");

      // Re-Save Them Mode
      await StorageServices.storeData(mode, DbKey.themeMode);
      // await StorageServices.storeData(event, DbKey.event);

      await StorageServices().clearSecure();
      
      Provider.of<ContractProvider>(context, listen: false).resetConObject();

      await Future.delayed(const Duration(seconds: 2), () {});
      
      Provider.of<WalletProvider>(context, listen: false).clearPortfolio();

      await wcComponent.killAllSession();

      print("google signOut");

      await Provider.of<GoogleAuthService>(context, listen: false).signOut();

      Navigator.pushAndRemoveUntil(context, RouteAnimation(enterPage: const Welcome()), ModalRoute.withName('/'));
    } catch (e) {

      // Close Dialog Loading
      Navigator.pop(context);
      if (kDebugMode) {
        print("_deleteAccount ${e.toString()}");
      }
      // await dialog(context, e.toString(), 'Opps');
    }
  }