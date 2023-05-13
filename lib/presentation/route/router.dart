import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/presentation/screen/home/events/events.dart';
import 'package:wallet_apps/presentation/screen/home/home/home.dart';


Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppString.splashScreenView:
      return MaterialPageRoute(builder: (context) => const MySplashScreen());
      // return RouteAnimation(enterPage: const MySplashScreen());
    case AppString.localAuth:
      return RouteAnimation(enterPage: const Authentication());
    case AppString.accountView:
      // return RouteAnimation(enterPage: const Account());
      return MaterialPageRoute(
        builder: (_) => const Account(),
        settings: settings
      );
    // case AppString.contactBookView:
    //   return RouteAnimation(enterPage: ContactBook());
    case AppString.txActivityView:
      return RouteAnimation(enterPage: const TrxActivity());
    case AppString.importAccView:
      return RouteAnimation(enterPage: const ImportAcc());
    case AppString.eventView:
      return RouteAnimation(enterPage: const FindEvent());
    // case AppString.checkinView:
    //   return RouteAnimation(enterPage: const CheckIn());
    //   break;
    case AppString.recieveWalletView:
      return RouteAnimation(enterPage: const ReceiveWallet());
    case AppString.claimAirdropView:
      return RouteAnimation(enterPage: const ClaimAirDrop());
    // case AppString.navigationDrawerView:
    //   return RouteAnimation(enterPage: const NavigationDrawer());
    // case AppString.inviteFriendView:
    //   return RouteAnimation(enterPage: InviteFriend());
    //   break;
    case AppString.homeView: 
      return MaterialPageRoute(builder: (context) => const HomePage());
      // return RouteAnimation(enterPage: );
    default:
      return RouteAnimation(enterPage: const MySplashScreen());
  }
}
