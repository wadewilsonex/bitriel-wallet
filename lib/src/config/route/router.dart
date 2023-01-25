import 'package:wallet_apps/index.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AppString.splashScreenView:
      return RouteAnimation(enterPage: const MySplashScreen());
    case AppString.localAuth:
      return RouteAnimation(enterPage: const FingerPrint());
    case AppString.accountView:
      return RouteAnimation(enterPage: const Account());
    // case AppString.contactBookView:
    //   return RouteAnimation(enterPage: ContactBook());
    case AppString.txActivityView:
      return RouteAnimation(enterPage: const TrxActivity());
    case AppString.importAccView:
      return RouteAnimation(enterPage: const ImportAcc());
    // case AppString.checkinView:
    //   return RouteAnimation(enterPage: const CheckIn());
    //   break;
    case AppString.recieveWalletView:
      return RouteAnimation(enterPage: const ReceiveWallet());
    case AppString.claimAirdropView:
      return RouteAnimation(enterPage: const ClaimAirDrop());
    case AppString.navigationDrawerView:
      return RouteAnimation(enterPage: const NavigationDrawer());
    // case AppString.inviteFriendView:
    //   return RouteAnimation(enterPage: InviteFriend());
    //   break;
    default:
      return RouteAnimation(enterPage: const MySplashScreen());
  }
}
