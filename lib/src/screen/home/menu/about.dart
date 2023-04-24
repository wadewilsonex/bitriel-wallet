import '../../../../index.dart';

class About extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  About({Key? key}) : super(key: key);
  Future<void> _launchInBrowser(String url) async {
    // try {
    //   if (await canLaunch(url)) {
    //     await launch(
    //       url,
    //       forceSafariVC: false,
    //       forceWebView: false,
    //       headers: <String, String>{'my_header_key': 'my_header_value'},
    //     );
    //   } else {
    //     throw 'Could not launch $url';
    //   }
    // } on PlatformException catch (e) {
    //   debugPrint("Error My PlatformException $e");
    // } catch (e) {
    //   debugPrint("Error _launchInBrowser $e");
    // }
  }

  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      key: _scaffoldKey,
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            MyAppBar(
              title: "About",
              color: isDarkMode
                  ? hexaCodeToColor(AppColors.darkCard)
                  : hexaCodeToColor(AppColors.whiteHexaColor),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
<<<<<<< HEAD
            SizedBox(
=======
            const SizedBox(
>>>>>>> daveat
              height: 5,
            ),
            InkWell(
              onTap: () {
                _launchInBrowser('https://bitriel.com/privacy');
              },
              child: Container(
                height: 10,
                margin: const EdgeInsets.symmetric(horizontal: paddingSize),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: 'Privacy Policy',
                      fontSize: 17,
                      hexaColor: isDarkMode
                          ? AppColors.whiteColorHexa
                          : AppColors.textColor,
                      textAlign: TextAlign.left,
                    ),
                    MyText(
                      top: 4.0,
                      text: 'Read our full Privacy Policy',
                      textAlign: TextAlign.left,
                      hexaColor: isDarkMode
                          ? AppColors.darkSecondaryText
                          : AppColors.textColor,
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _launchInBrowser('https://bitriel.com/termofuse');
              },
              child: Container(
                height: 10,
                margin: const EdgeInsets.symmetric(horizontal: paddingSize),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: 'Terms of Use',
                      fontSize: 17,
                      textAlign: TextAlign.left,
                      hexaColor: isDarkMode
                          ? AppColors.whiteColorHexa
                          : AppColors.textColor,
                    ),
                    MyText(
                      top: 4.0,
                      text: 'Read our term of use for Bitriel app',
                      textAlign: TextAlign.left,
                      hexaColor: isDarkMode
                          ? AppColors.darkSecondaryText
                          : AppColors.textColor,
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: paddingSize),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: 'Contact',
                      fontSize: 17,
                      textAlign: TextAlign.left,
                      hexaColor: isDarkMode
                          ? AppColors.whiteColorHexa
                          : AppColors.textColor,
                    ),
                    MyText(
                      top: 4.0,
                      text:
                          'For questions, concerns, or comments can be address to: ',
                      textAlign: TextAlign.left,
                      hexaColor: isDarkMode
                          ? AppColors.darkSecondaryText
                          : AppColors.textColor,
                    ),
                    Row(
                      children: [
                        MyText(
                          top: 4.0,
                          text: 'info@bitriel.com',
                          textAlign: TextAlign.left,
                          hexaColor: isDarkMode
                              ? AppColors.whiteColorHexa
                              : AppColors.textColor,
                        ),
                        IconButton(
                          onPressed: () {
                            Clipboard.setData(
                              const ClipboardData(text: 'info@bitriel.com'),
                            ).then(
                              (value) => {
                                snackBar(context, "Copied to Clipboard")
                              },
                            );
                          },
                          icon: Icon(
                            Iconsax.copy,
                            color: isDarkMode ? Colors.white : Colors.black,
                            size: 18,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: paddingSize),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: 'About',
                      fontSize: 17,
                      textAlign: TextAlign.left,
                      hexaColor: isDarkMode
                          ? AppColors.whiteColorHexa
                          : AppColors.textColor,
                    ),
                    MyText(
                      top: 6.0,
                      text:
                          'Bitriel is used to store and transact SEL tokens and multiple other cryptocoins. Wallets can be integrated into any application where a use case exists, connecting the application to the Selendra main chain.',
                      textAlign: TextAlign.left,
                      hexaColor: isDarkMode
                          ? AppColors.darkSecondaryText
                          : AppColors.textColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
