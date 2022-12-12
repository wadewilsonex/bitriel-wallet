import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/indecator_c.dart';
import 'package:wallet_apps/src/screen/main/social_login/phonenumber/login/login_phonenumber.dart';
import 'package:wallet_apps/src/screen/main/social_login/phonenumber/register/create_phonenumber.dart';

class PhoneMainScreen extends StatefulWidget {
  const PhoneMainScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PhoneMainScreen> createState() => _PhoneMainScreenState();
}

class _PhoneMainScreenState extends State<PhoneMainScreen> with SingleTickerProviderStateMixin{

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    AppServices.noInternetConnection(context: context);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginSeedPhoneNumber()
      // SafeArea(
      //   child: SizedBox(
      //     height: MediaQuery.of(context).size.height,
      //     child: Column(
      //       children: [
              
      //         TabBar(
      //           labelColor: isDarkMode ? hexaCodeToColor(AppColors.whiteColorHexa) : hexaCodeToColor(AppColors.textColor),
      //           unselectedLabelColor: hexaCodeToColor(AppColors.greyColor),
      //           tabs: const [
      //             Tab(
      //               child: MyText(
      //                 text: "Login",
      //                 fontWeight: FontWeight.w600,
      //               ),
      //             ),
      //             Tab(
      //               child: MyText(
      //                 text: "Register",
      //                 fontWeight: FontWeight.w600,
      //               ),
      //             ),
      //           ],
      //           controller: _tabController,
      //           indicatorSize: TabBarIndicatorSize.tab,
      //           indicatorWeight: 0.5,
      //           indicator: CustomTabIndicator(
      //             color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.orangeColor),
      //           )
      //         ),
      
      //         Expanded(
      //           child: TabBarView(
      //             controller: _tabController,
      //             children: const [
      //               LoginSeedPhoneNumber(),
      //               CreateSeedPhoneNumber(),
      //             ],
      //           ),
      //         ),
      //       ]
      //     ),
      //   ),
      // ),
    );
  }
}