import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/presentation/screen/webview_screen.dart';


class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, title: "About"),
      body: Column(
        children: [
          
          ...[
            _logoApp(),
            _versionApp()
          ],
      
          const Padding(
            padding: EdgeInsets.all(15),
            child: Divider(),
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

  Widget _logoApp() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Image.asset("assets/logo/bitriel-logo.png", width: 75, height: 75,),
      )
    );
  }

  Widget _versionApp() {
    return const MyTextConstant(
      text: "Bitriel: 9.0.0",
      fontSize: 18,
      fontWeight: FontWeight.w600,
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