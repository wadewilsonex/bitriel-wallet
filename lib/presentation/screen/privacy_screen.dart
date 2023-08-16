import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/presentation/screen/webview_screen.dart';


class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, title: "About"),
      body: Column(
        children: [
          SettingsItem(
            onTap: () {},
            icons: Icons.fingerprint_sharp,
            iconStyle: IconStyle(
              iconsColor: Colors.white,
              withBackground: true,
              backgroundColor: Colors.green,
            ),
            title: 'Unlock with Biometric',
            trailing: Switch.adaptive(
              value: false,
              onChanged: (value) {},
            ),
          ),

          ...[
            _aboutItems(
              name: "Terms & Conditions",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdsWebView(
                    title: "Terms & Conditions",
                    url: "https://www.bitriel.com/legal/terms-conditions",
                  ))
                );
              }
            ),

            _aboutItems(
              name: "Privacy Policy (Terms of Use)",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdsWebView(
                    title: "Privacy Policy",
                    url: "https://www.bitriel.com/legal/privacy-policy",
                  ))
                );
              }
            ),

            _aboutItems(
              name: "Visit Our Website",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdsWebView(
                    title: "Bitriel",
                    url: "https://www.bitriel.com/",
                  ))
                );
              }
            ),

            _aboutItems(
              name: "Telegram Community",
              onTap: () async{
                await launchUrl(
                  Uri.parse("https://t.me/selendra"),
                  mode: LaunchMode.externalApplication,
                );
              }
            ),
          ],

      
        ],
      ),
    );
  }

  Widget _aboutItems({required String name, required void Function() onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Card(
        color: hexaCodeToColor(AppColors.cardColor),
        child: ListTile(
          title: MyTextConstant(
            text: name,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.start,
          ),
          trailing: Icon(Iconsax.arrow_right_3, color: hexaCodeToColor(AppColors.primary),),
          onTap: onTap
        )
      ),
    );
  }

}