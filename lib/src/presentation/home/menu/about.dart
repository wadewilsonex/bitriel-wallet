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
    //   print("Error My PlatformException $e");
    // } catch (e) {
    //   print("Error _launchInBrowser $e");
    // }
  }

  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      key: _scaffoldKey,
      appBar: secondaryAppBar(
        context: context, 
        title: MyText(text: 'About', fontSize: 2.4, hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor, fontWeight: FontWeight.bold,)
      ),
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            
            SizedBox(
              height: 3.sp,
            ),

            InkWell(
              onTap: () {
                _launchInBrowser('https://bitriel.com/privacy');
              },
              child: Container(
                height: 10.sp,
                margin: EdgeInsets.symmetric(horizontal: paddingSize),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: 'Privacy Policy',
                      fontSize: 2.5,
                      hexaColor: isDarkMode
                          ? AppColors.whiteColorHexa
                          : AppColors.textColor,
                      textAlign: TextAlign.left,
                    ),
                    MyText(
                      top: 0.57.sp,
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
                height: 10.sp,
                margin: EdgeInsets.symmetric(horizontal: paddingSize),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: 'Terms of Use',
                      fontSize: 2.5,
                      textAlign: TextAlign.left,
                      hexaColor: isDarkMode
                          ? AppColors.whiteColorHexa
                          : AppColors.textColor,
                    ),
                    MyText(
                      top: 0.57,
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
                margin: EdgeInsets.symmetric(horizontal: paddingSize),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    MyText(
                      text: 'Contact',
                      fontSize: 2.5,
                      textAlign: TextAlign.left,
                      hexaColor: isDarkMode
                          ? AppColors.whiteColorHexa
                          : AppColors.textColor,
                    ),
                    MyText(
                      top: 0.57.sp,
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
                          top: 0.57.sp,
                          text: 'info@bitriel.com',
                          textAlign: TextAlign.left,
                          hexaColor: isDarkMode
                              ? AppColors.whiteColorHexa
                              : AppColors.textColor,
                        ),

                        IconButton(
                          constraints: BoxConstraints.expand(width: 6.sp, height: 6.sp),
                          padding: EdgeInsets.all(1.2.sp),
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
                            size: 2.7.sp,
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
                margin: EdgeInsets.symmetric(horizontal: paddingSize, vertical: paddingSize),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: 'About',
                      fontSize: 2.5,
                      textAlign: TextAlign.left,
                      hexaColor: isDarkMode
                          ? AppColors.whiteColorHexa
                          : AppColors.textColor,
                    ),
                    MyText(
                      top: 0.9.sp,
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
