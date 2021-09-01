import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/home/contact_book/contact_book.dart';
import 'package:wallet_apps/src/screen/home/transaction/confirmation/confimation_tx.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AppString.splashScreenView:
      return RouteAnimation(enterPage: MySplashScreen());
      break;
    case AppString.accountView:
      return RouteAnimation(enterPage: Account());
      break;
    case AppString.contactBookView:
      return RouteAnimation(enterPage: ContactBook());
      break;
    case AppString.txActivityView:
      return RouteAnimation(enterPage: TrxActivity());
      break;
    case AppString.importAccView:
      return RouteAnimation(enterPage: const ImportAcc());
      break;
    case AppString.contentBackup:
      return RouteAnimation(enterPage: ContentsBackup());
      break;
    case AppString.passcodeView:
      return RouteAnimation(enterPage: const Passcode());
      break;
    case AppString.confirmationTxView:
      return RouteAnimation(enterPage: const ConfirmationTx());
      break;
    case AppString.checkinView:
      return RouteAnimation(enterPage: const CheckIn());
      break;
    case AppString.recieveWalletView:
      return RouteAnimation(enterPage: ReceiveWallet());
      break;
    case AppString.claimAirdropView:
      return RouteAnimation(enterPage: ClaimAirDrop());
      break;
    case AppString.navigationDrawerView:
      return RouteAnimation(enterPage: NavigationDrawer());
      break;
    case AppString.inviteFriendView:
      return RouteAnimation(enterPage: InviteFriend());
      break;
    default:
      return RouteAnimation(enterPage: MySplashScreen());
  }
}
