import 'package:bitriel_wallet/index.dart';


class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final AppUsecasesImpl appUsecasesImpl = AppUsecasesImpl();

    appUsecasesImpl.setBuildContext = context;

    appUsecasesImpl.readBio(isPrivacy: true);

    return Scaffold(
      appBar: appBar(context, title: "Privacy"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          ValueListenableBuilder(
            valueListenable: appUsecasesImpl.isAuthenticated,
            builder: (context, value, wg) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                child: SettingsItem(
                  onTap: () {},
                  icons: Icons.fingerprint_sharp,
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: Colors.green,
                  ),
                  title: 'Unlock with Biometric',
                  trailing: Switch.adaptive(
                    value: value,
                    onChanged: (enabledValue) {

                      appUsecasesImpl.enableBiometric(enabledValue);

                    },
                  ),
                ),
              );
            }
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8),
            child: MyTextConstant(
              text: "PIN-Code",
              textAlign: TextAlign.start,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(14.0, 0.0, 14.0, 0.0),
            child: MyTextConstant(
              text: "Choose a string PIN to unlock Bitriel app on your device. If you lose this PIN, you will need your Mnemonic Phrase Key to re-import your wallet",
              textAlign: TextAlign.start,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14.0),
            child: MyButton(
              textButton: "Change PIN",
              fontWeight: FontWeight.w600,
              textColor: AppColors.primaryBtn,
              borderWidth: 1,
              isTransparent: true,
              isTransparentOpacity: 0,
              action: () async {
          
              },
            ),
          ),

          

      
        ],
      ),
    );
  }

}