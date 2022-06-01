
import 'package:wallet_apps/src/components/selendra_swap_c.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/swap_exchange_c.dart';

class DiscoverContent {

  List<SelendraSwap> lsSelendraSwap = [
    SelendraSwap(
      title: "Claim Free SEL Tokens",
      subtitle: "Your chance to get SEL tokens via our Airdrops. It's just a few clicks away.",
      image: SvgPicture.asset("assets/icons/gift.svg",),
      action: () {
        
      },
    ),

    SelendraSwap(
      title: "SEL Token Sale",
      subtitle: "We are doing limited time Presale for SEL token. Get discounted price before IDO and Exchange listings.",
      image: SvgPicture.asset("assets/icons/sale.svg",),
      action: () {
        
      },
    ),

    SelendraSwap(
      title: "Swap SEL from V1 to V2",
      subtitle: "If you have SEL v1, now it’s a good time to swap it to v2",
      image: Image.asset("assets/SelendraCircle-White.png",), 
      action: () {

      },
    ),

    SelendraSwap(
      title: "Stacking SEL Token",
      subtitle: "Earn passive income SEL token",
      image: SvgPicture.asset("assets/icons/coin_stack.svg",),
      action: () {
        
      },
    ),
    
  ];

  List<SwapExchange> lsSwapExchange = [
    SwapExchange(
      title: "Sushi Swap",
      image: Image.asset("assets/logo/pancake.png", width: 50, height: 50),
      action: () {

      },
    ),

    SwapExchange(
      title: "Pancake Swap",
      image: Image.asset("assets/logo/sushi.png", width: 50, height: 50),
      action: () {
        
      },
    ),
        SwapExchange(
      title: "Sushi Swap",
      image: Image.asset("assets/logo/pancake.png", width: 50, height: 50),
      action: () {

      },
    ),

    SwapExchange(
      title: "Pancake Swap",
      image: Image.asset("assets/logo/sushi.png", width: 50, height: 50),
      action: () {
        
      },
    ),
    SwapExchange(
      title: "Sushi Swap",
      image: Image.asset("assets/logo/pancake.png", width: 50, height: 50),
      action: () {

      },
    ),

    SwapExchange(
      title: "Pancake Swap",
      image: Image.asset("assets/logo/sushi.png", width: 50, height: 50),
      action: () {
        
      },
    ),
  ];
}