import '../../index.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final NavbarUsecaseImpl navbarUsecaseImpl = NavbarUsecaseImpl();

    final pages = [
      const HomeScreen(),
      const WalletScreen(),
      const SettingScreen()
    ];

    return ValueListenableBuilder(
      valueListenable: navbarUsecaseImpl.currentIndex,
      builder: (context, value, wg) {
        return Scaffold(
          body: pages[value],
          bottomNavigationBar: _buildBottomBar(index: value, navbarUsecaseImpl: navbarUsecaseImpl)
        );
      }
    );
  }

  Widget _buildBottomBar({required int index, required NavbarUsecaseImpl navbarUsecaseImpl}){
    return NavigationBar(
      height: 70,
      selectedIndex: index,
      onDestinationSelected: (index) => navbarUsecaseImpl.changeIndex(index: index),
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