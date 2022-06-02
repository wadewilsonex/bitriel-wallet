import 'package:wallet_apps/index.dart';

class MenuBody extends StatelessWidget {
  final Map<String, dynamic>? userInfo;
  final MenuModel? model;
  final Function? enablePassword;
  final Function? switchBio;
  final Function? switchTheme;

  const MenuBody({
    this.userInfo,
    this.model,
    this.enablePassword,
    this.switchBio,
    this.switchTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        MenuHeader(userInfo: userInfo),

        // Wallet
        const MenuSubTitle(index: 1),
        
        MyListTile(
          index: 2,
          subIndex: 1,
          onTap: () {
            Navigator.push(context, Transition(child: Swap(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
          },
        ),

        MyListTile(
          index: 1,
          subIndex: 0,
          onTap: () {
            Navigator.push(context, Transition(child: ReceiveWallet(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
          },
        ),

        MyListTile(
          index: 1,
          subIndex: 1,
          onTap: () {
            Navigator.push(context, Transition(child: AddAsset(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
          },
        ),

        // Account
        const MenuSubTitle(index: 3),

        MyListTile(
          enable: false,
          index: 3,
          subIndex: 0,
          trailing: Switch(
            value: model!.switchPasscode,
            onChanged: (value) async {
              // Navigator.pushNamed(context, AppText.passcodeView);
              final res = await Navigator.push(
                context,
                Transition(child: Passcode(isAppBar: true, label: 'fromHome',), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
              );
              if (res == true) {
                enablePassword!(true);
              } else if (res == false) {
                enablePassword!(false);
              }
            },
          ),
          onTap: null,
        ),

        MyListTile(
          enable: false,
          index: 3,
          subIndex: 1,
          trailing: Switch(
            value: model!.switchBio,
            onChanged: (value) {
              switchBio!(context, value);
            },
          ),
          onTap: null,
        ),
        const MenuSubTitle(index: 4),

        MyListTile(
          index: 4,
          subIndex: 0,
          onTap: null,
          trailing: Consumer<ThemeProvider>(
            builder: (context, value, child) => Switch(
              value: value.isDark,
              onChanged: (value) async {
                await Provider.of<ThemeProvider>(context, listen: false).changeMode();
              },
            ),
          ),
        ),

        const MenuSubTitle(index: 5),

        MyListTile(
          index: 5,
          subIndex: 0,
          onTap: () async {
            Navigator.push(context, Transition(child: About(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
            //_launchInBrowser('https://selendra.com/privacy');
          },
        ),
      ],
    );
  }
}
