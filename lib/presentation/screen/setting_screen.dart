import 'package:bitriel_wallet/index.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Settings",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SettingsGroup(
                settingsGroupTitle: "General",
                items: [

                  SettingsItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PrivacyScreen())
                      );
                    },
                    icons: Icons.fingerprint_sharp,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: hexaCodeToColor(AppColors.primary),
                    ),
                    title: 'Privacy',
                    subtitle: "Manage Your Privacy Settings",
                  ),

                  SettingsItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AboutScreen())
                      );
                    },
                    icons: Icons.info_rounded,
                    iconStyle: IconStyle(
                      backgroundColor: Colors.purple,
                    ),
                    title: 'About',
                    subtitle: "Learn more about Bitriel",
                  ),
                ],
              ),

              // You can add a settings title
              SettingsGroup(
                settingsGroupTitle: "Account",
                items: [
                  SettingsItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings: RouteSettings(name: "/${BitrielRouter.multiAccRoute}"),
                          builder: (context) => const MultiAccountScreen()
                        ) 
                      );
                    },
                    icons: Iconsax.user,
                    title: "Manage Accounts",
                    iconStyle: IconStyle(
                      backgroundColor: hexaCodeToColor(AppColors.defiMenuItem),
                    ),
                  ),
                  
                  SettingsItem(
                    onTap: () async {
                      await QuickAlert.show(
                        context: context,
                        type: QuickAlertType.warning,
                        text: 'Are you sure to delete all your wallets?',
                        confirmBtnText: "Delete",
                        onConfirmBtnTap: () async{
                          await Provider.of<SDKProvider>(context, listen: false).getSdkImpl.deleteAccount(context);
                        },
                        showCancelBtn: true
                      );
                    },
                    icons: Iconsax.trash,
                    title: "Delete Account",
                    subtitle: "Delete all your wallets",
                    iconStyle: IconStyle(
                      backgroundColor: Colors.red,
                    ),
                    titleStyle: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}