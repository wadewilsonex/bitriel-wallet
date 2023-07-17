import '../../index.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final navbarImpl = NavbarUsecaseImpl();

    return Scaffold(
      body: PersistentTabView(
        context,
        controller: navbarImpl.navbarModel.controller,
        navBarHeight: kSizeBottomNavigationBarHeight,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: kColorBNBBackground,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        popAllScreensOnTapOfSelectedTab: false,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          animateTabTransition: false,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        // decoration: const NavBarDecoration(
        //   borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))
        // ),
        navBarStyle: NavBarStyle.style3,
        onItemSelected: (final index) {
          navbarImpl.changeIndex(index: index);
        },
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      const HomeScreen(),
      const WalletScreen(),
      const HomeScreen(),
      // const WalletScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [

      PersistentBottomNavBarItem(
        icon: Column(
          children: [
            SizedBox(
              height: kSizeBottomNavigationBarIconHeight,
              child: Image.asset(
                kIconPathBottomNavigationBarHome,
              ),
            ),
          ],
        ),
        inactiveIcon: Column(
          children: [
            SizedBox(
              height: kSizeBottomNavigationBarIconHeight,
              child: Image.asset(
                kIconPathBottomNavigationBarHomeDeactive,
              ),
            ),
          ],
        ),
        title: ('Home'),
        activeColorPrimary: kColorBNBActiveTitleColor,
        inactiveColorPrimary: kColorBNBDeactiveTitleColor,
      ),

      PersistentBottomNavBarItem(
        icon: Column(
          children: [
            SizedBox(
              height: kSizeBottomNavigationBarIconHeight,
              child: Image.asset(
                kIconPathBottomNavigationBarWallet,
              ),
            ),
          ],
        ),
        inactiveIcon: Column(
          children: [
            SizedBox(
              height: kSizeBottomNavigationBarIconHeight,
              child: Image.asset(
                kIconPathBottomNavigationBarWalletDeactive,
              ),
            ),
          ],
        ),
        title: ('Wallet'),
        activeColorPrimary: kColorBNBActiveTitleColor,
        inactiveColorPrimary: kColorBNBDeactiveTitleColor,
      ),

      PersistentBottomNavBarItem(
        icon: Column(
          children: [
            SizedBox(
              height: kSizeBottomNavigationBarIconHeight,
              child: Image.asset(
                kIconPathBottomNavigationBarSetting,
              ),
            ),
          ],
        ),
        inactiveIcon: Column(
          children: [
            SizedBox(
              height: kSizeBottomNavigationBarIconHeight,
              child: Image.asset(
                kIconPathBottomNavigationBarSettingDeactive,
              ),
            ),
          ],
        ),
        title: ('Setting'),
        activeColorPrimary: kColorBNBActiveTitleColor,
        inactiveColorPrimary: kColorBNBDeactiveTitleColor,
      ),
      
    ];
  }
}
