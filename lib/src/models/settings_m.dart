import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/models/account.m.dart';
import 'package:wallet_apps/src/screen/home/ads_webview/adsWebView.dart';
import 'package:wallet_apps/src/screen/home/menu/wallet_connect/wallet_connect.dart';

import '../screen/home/menu/backup/body_backup_key.dart';

class SettingsSection {
  final String? title;
  final IconData? leadingIcon;
  final Function? action;

  SettingsSection({this.title, this.leadingIcon, this.action});
}


List<SettingsSection> settingsAccSection({BuildContext? context}) {
  return [
    SettingsSection(
      title:'Backup Keys',
      leadingIcon: Iconsax.lock_1,
      action: () {
        Navigator.push(
          context!, 
          Transition(
            child: BackUpKeyBody(),
            transitionEffect: TransitionEffect.RIGHT_TO_LEFT
          )
        );
      }
    ),
    SettingsSection(
      title: 'Account',
      leadingIcon: Iconsax.personalcard,
      action: () {
        Navigator.push(
          context!,
          Transition(
            child: Account(),
            transitionEffect: TransitionEffect.RIGHT_TO_LEFT
          )
        );
      }
    ),
  ];
}

List<SettingsSection> settingsWCSection({BuildContext? context}) {
  return [
    SettingsSection(
      title: 'Wallet Connect',
      leadingIcon: Iconsax.bitcoin_convert,
      action: () {
        Navigator.push(
          context!,
          Transition(
            child: WalletConnectPage(),
            transitionEffect: TransitionEffect.RIGHT_TO_LEFT
          )
        );
      }
    ),
  ];
}

List<SettingsSection> settingsPolicySection({BuildContext? context}) {
  return [
    SettingsSection(
      title: 'Terms of Service',
      leadingIcon: Iconsax.archive_book,
      action: () {
        Navigator.push(
          context!, 
          Transition(child: AdsWebView(url: "https://bitriel.com/termofuse", title: "Terms of Service",), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
        );
      }
    ),
    SettingsSection(
      title: 'Privacy policy',
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

List<SettingsSection> settingsLogoutSection({BuildContext? context}) {
  return [
    SettingsSection(
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
        child: MyText(
          text: 'Delete',
          color: AppColors.redColor,
          fontWeight: FontWeight.w700
        ),
      ),
    );
  }

 Future<void> _deleteAccount({BuildContext? context}) async {

    AccountM _accountModel = AccountM();

    dialogLoading(context!);

    final _api = await Provider.of<ApiProvider>(context, listen: false);
    
    try {
      await _api.apiKeyring.deleteAccount(
        _api.getKeyring,
        _accountModel.currentAcc!,
      );

      final mode = await StorageServices.fetchData(DbKey.themeMode);
      // final event = await StorageServices.fetchData(DbKey.event);

      await StorageServices().clearStorage();

      // Re-Save Them Mode
      await StorageServices.storeData(mode, DbKey.themeMode);
      // await StorageServices.storeData(event, DbKey.event);

      await StorageServices().clearSecure();
      
      Provider.of<ContractProvider>(context, listen: false).resetConObject();

      await Future.delayed(Duration(seconds: 2), () {});
      
      Provider.of<WalletProvider>(context, listen: false).clearPortfolio();

      Navigator.pushAndRemoveUntil(context, RouteAnimation(enterPage: Welcome()), ModalRoute.withName('/'));
    } catch (e) {
      if (ApiProvider().isDebug == true) print("_deleteAccount ${e.toString()}");
      // await dialog(context, e.toString(), 'Opps');
    }
  }