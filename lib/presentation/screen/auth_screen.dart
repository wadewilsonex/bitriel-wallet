import 'package:bitriel_wallet/index.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final AppUsecasesImpl appImpl = AppUsecasesImpl();

    appImpl.setBuildContext = context;

    appImpl.authPopup();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: MyTextConstant(
                text: "Authenticate Required",
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Icon(Iconsax.finger_scan, size: MediaQuery.of(context).size.width / 3,),
            ),

            Container(
              margin: const EdgeInsets.symmetric(vertical: 50.0),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15.0),
                    child: const MyTextConstant(
                      text: "Authenticate using your fingerprint.",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  MyButton(
                    textButton: "Authenticate",
                    action: () async{
                      await appImpl.authPopup();
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}