import 'package:wallet_apps/index.dart';


Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AppString.splashScreenView:
      return RouteAnimation(enterPage: MySplashScreen());
    case AppString.localAuth:
      return RouteAnimation(enterPage: FingerPrint());
    case AppString.accountView:
      return RouteAnimation(enterPage: Account());
    case AppString.contactBookView:
      return RouteAnimation(enterPage: ContactBook());
    case AppString.txActivityView:
      return RouteAnimation(enterPage: TrxActivity());
    case AppString.importAccView:
      return RouteAnimation(enterPage: ImportAcc());
    case AppString.contentBackup:
      return RouteAnimation(enterPage: ContentsBackup());
    case AppString.confirmationTxView:
      return RouteAnimation(enterPage: ConfirmationTx());
    // case AppString.checkinView:
    //   return RouteAnimation(enterPage: const CheckIn());
    //   break;
    case AppString.recieveWalletView:
      return RouteAnimation(enterPage: ReceiveWallet());
    case AppString.claimAirdropView:
      return RouteAnimation(enterPage: ClaimAirDrop());
    case AppString.navigationDrawerView:
      return RouteAnimation(enterPage: NavigationDrawer());
    // case AppString.inviteFriendView:
    //   return RouteAnimation(enterPage: InviteFriend());
    //   break;
    default:
      return RouteAnimation(enterPage: MySplashScreen());
  }
}
