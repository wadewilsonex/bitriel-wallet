import 'package:bitriel_wallet/index.dart';
import 'package:flutter/cupertino.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white.withOpacity(.94),
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
          child: ListView(
            children: [
              SettingsGroup(
                settingsGroupTitle: "General",
                items: [
                  // SettingsItem(
                  //   onTap: () {},
                  //   icons: CupertinoIcons.pencil_outline,
                  //   iconStyle: IconStyle(),
                  //   title: 'Appearance',
                  //   subtitle: "Make Ziar'App yours",
                  // ),
                  SettingsItem(
                    onTap: () {},
                    icons: Icons.fingerprint,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: hexaCodeToColor(AppColors.primary),
                    ),
                    title: 'Privacy',
                    subtitle: "Manage Your Privacy Settings",
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: Icons.dark_mode_rounded,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.green,
                    ),
                    title: 'Dark mode',
                    subtitle: "Automatic",
                    trailing: Switch.adaptive(
                      value: false,
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
              SettingsGroup(
                items: [
                  SettingsItem(
                    onTap: () {},
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
                    onTap: () {},
                    icons: Iconsax.user,
                    title: "Manage Accounts",
                    iconStyle: IconStyle(
                      backgroundColor: hexaCodeToColor(AppColors.defiMenuItem),
                    ),
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: Iconsax.cloud_change,
                    title: "Backup Account",
                    iconStyle: IconStyle(
                      backgroundColor: hexaCodeToColor(AppColors.midNightBlue),
                    ),
                  ),
                  SettingsItem(
                    onTap: () {},
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