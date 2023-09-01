import 'package:bitriel_wallet/index.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final NavbarUsecaseImpl navbarUsecaseImpl = NavbarUsecaseImpl();

    final MultiAccountImpl multiAccountImpl = MultiAccountImpl();

    return ValueListenableBuilder(
      valueListenable: navbarUsecaseImpl.currentIndex,
      builder: (context, currentIndex, wg) {
        return Scaffold(
          appBar: currentIndex != 2 ? defaultAppBar(context: context, multiAccountImpl: multiAccountImpl) : null,
          body: PageView(
            onPageChanged: navbarUsecaseImpl.changeIndex,
            controller: navbarUsecaseImpl.pageController,
            children: const [
              HomeScreen(),
              WalletScreen(),
              SettingScreen()
            ],
          ),
          bottomNavigationBar: ValueListenableBuilder(
            valueListenable: navbarUsecaseImpl.currentIndex,
            builder: (context, currentIndex, wg) {
              return BottomNavigationBar(
                selectedItemColor: hexaCodeToColor(AppColors.primaryBtn),
                unselectedItemColor: Colors.black,
                onTap: navbarUsecaseImpl.changeIndex,
                currentIndex: currentIndex,
                
                items: const [
                  BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home_outlined,)),
                  BottomNavigationBarItem(label: "Wallet", icon: Icon(Icons.account_balance_wallet_outlined)),
                  BottomNavigationBarItem(label: "Setting", icon: Icon(Icons.settings_outlined))
                ],
              );
            }
          ),
        );
      }
    );
    // ValueListenableBuilder(
    //   valueListenable: navbarUsecaseImpl.currentIndex,
    //   builder: (context, value, wg) {
    //     return Scaffold(
    //       body: pages[value],
    //       bottomNavigationBar: _buildBottomBar(index: value, navbarUsecaseImpl: navbarUsecaseImpl)
    //     );
    //   }
    // );
  }

  Widget _buildBottomBar({required int index, required NavbarUsecaseImpl navbarUsecaseImpl}){
    return NavigationBar(
      height: 70,
      selectedIndex: index,
      onDestinationSelected: (index) => navbarUsecaseImpl.changeIndex(index),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined,),
          selectedIcon: Icon(Icons.home),
          label: "Home",
        ),

        NavigationDestination(
          icon: Icon(Icons.account_balance_wallet_outlined),
          selectedIcon: Icon(Icons.account_balance_wallet),
          label: "Wallet",
        ),

        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: "Setting",
        ),
      ],
    );
  }

}