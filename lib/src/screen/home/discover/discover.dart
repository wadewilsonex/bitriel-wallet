import 'package:provider/provider.dart';
import 'package:wallet_apps/core/service/contract.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/discover_c.dart';
import 'package:wallet_apps/src/provider/api_provider.dart';
import 'package:wallet_apps/src/screen/home/menu/presale/presale.dart';

class Discover extends StatefulWidget {
  //static const route = '/recievewallet';

  @override
  State<StatefulWidget> createState() {
    return DiscoerState();
  }
}

class DiscoerState extends State<Discover> {
  
  GlobalKey<ScaffoldState>? _globalKey;

  @override
  void initState() {
    _globalKey = GlobalKey<ScaffoldState>();

    AppServices.noInternetConnection(_globalKey!);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      key: _globalKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: "SELENDRA",
                  color: isDarkTheme ? AppColors.whiteHexaColor : AppColors.blackColor,
                  bottom: 20,
                ),

                DiscoverItem(
                  title: "Claim Free SEL Tokens",
                  subTitle: "Your chance to get SEL tokens via our Airdrops. It’s just a few clicks away.",
                  icon: 'gift.svg',
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ClaimAirDrop()));
                  },
                ),
                DiscoverItem(
                  icon: 'sale.svg',
                  title: "SEL Token Sale",
                  subTitle: "We are doing limited time Presale for SEL token. Get discounted price before IDO and Exchange listings.",
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Presale()));
                  },
                ),
                DiscoverItem(
                  icon: 'swap.svg',
                  title: "Swap SEL from V1 to V2",
                  subTitle: "If you have SEL v1, now it’s a good time to swap it to v2",
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Swap()));
                  },
                ),

                MyText(
                  text: "DeFi",
                  color: isDarkTheme ? AppColors.whiteHexaColor : AppColors.blackColor,
                  bottom: 20,
                  top: 50,
                ),

                DiscoverDefiItem(logo: 'earth.svg', title: 'WEB3 Browser', subTitle: 'Access WEB3 through this browser',),
                DiscoverDefiItem(logo: 'kabob.svg', title: 'Bitriel Swap',),
                DiscoverDefiItem(logo: 'sushi_swap.svg', title: 'Sushi Swap',),
                DiscoverDefiItem(logo: 'pancake_swap.svg', title: 'Pancake Swap',),
              ],
            ),
          )
        ),
      ) 
    );
  }
}
  