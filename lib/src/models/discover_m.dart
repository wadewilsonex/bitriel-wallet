import 'package:wallet_apps/src/components/selendra_swap_c.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/swap_exchange_c.dart';

class DiscoverContent {

  static BuildContext? _context;

  static List<SelendraSwap>? lsSelendraSwap = [];

  static List<SwapExchange> lsSwapExchange = [];

<<<<<<< HEAD
  static void initContext({required BuildContext? context}){
    _context = context;
=======
  static AppProvider? _appPro;

  static void initContext({required BuildContext? context}){
    _context = context;

    _appPro ??= Provider.of<AppProvider>(_context!, listen: false);
>>>>>>> daveat
    
    lsSwapExchange =  [
      SwapExchange(
        title: "Pancake Swap",
<<<<<<< HEAD
        image: Image.asset("assets/logo/pancake.png", width: 10, height: 10),
=======
        image: Image.asset("${_appPro!.dirPath}/logo/pancake.png", width: 10, height: 10),
>>>>>>> daveat
        action: () {
          underContstuctionAnimationDailog(context: _context);
        },
      ),

      SwapExchange(
        title: "Sushi Swap",
<<<<<<< HEAD
        image: Image.asset("assets/logo/sushi.png", width: 10, height: 10),
=======
        image: Image.asset("${_appPro!.dirPath}/logo/sushi.png", width: 10, height: 10),
>>>>>>> daveat
        action: () {
          underContstuctionAnimationDailog(context: _context);
        },
      ),

    ];

    lsSelendraSwap =  [
      SelendraSwap(
        title: "Claim Free SEL Tokens",
        subtitle: "Your chance to get SEL tokens via our Airdrops. It's just a few clicks away.",
<<<<<<< HEAD
        image: SvgPicture.asset("assets/icons/gift.svg",),
=======
        image: SvgPicture.asset("${_appPro!.dirPath}/icons/gift.svg",),
>>>>>>> daveat
        action: () {
          underContstuctionAnimationDailog(context: _context);
        },
      ),

      SelendraSwap(
        title: "SEL Token Sale",
        subtitle: "We are doing limited time Presale for SEL token. Get discounted price before IDO and Exchange listings.",
<<<<<<< HEAD
        image: SvgPicture.asset("assets/icons/sale.svg",),
=======
        image: SvgPicture.asset("${_appPro!.dirPath}/icons/sale.svg",),
>>>>>>> daveat
        action: () {
          underContstuctionAnimationDailog(context: _context);
          // Navigator.push(_context!, Transition(child: Presale(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
        },
      ),

      // SelendraSwap(
      //   title: "Swap SEL from V1 to V2",
      //   subtitle: "If you have SEL v1, now it’s a good time to swap it to v2",
<<<<<<< HEAD
      //   image: Image.asset("assets/SelendraCircle-White.png",), 
=======
      //   image: Image.asset("${_appPro!.dirPath}/SelendraCircle-White.png",), 
>>>>>>> daveat
      //   action: () {
      //     Navigator.push(_context!, Transition(child: Swap(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
      //   },
      // ),

      SelendraSwap(
        title: "Stacking SEL Token",
        subtitle: "Earn passive income SEL token",
<<<<<<< HEAD
        image: SvgPicture.asset("assets/icons/coin_stack.svg",),
=======
        image: SvgPicture.asset("${_appPro!.dirPath}/icons/coin_stack.svg",),
>>>>>>> daveat
        action: () {
          underContstuctionAnimationDailog(context: _context);
        },
      ),
      
    ];
    
  }
}