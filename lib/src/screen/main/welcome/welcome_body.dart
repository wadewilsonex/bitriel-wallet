import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';

class WelcomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Column(
      children: [
        const SizedBox(
          height: 50,
        ),
        Container(
          padding: const EdgeInsets.only(
            left: 42,
            right: 16,
            bottom: 16,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: MyText(
                  text: AppString.welcome,
                  fontSize: 22,
                  color: isDarkTheme
                      ? AppColors.whiteColorHexa
                      : AppColors.textColor,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: MyText(
                    text: AppString.appName,
                    fontSize: 38,
                    fontWeight: FontWeight.w500,
                    color: isDarkTheme
                        ? AppColors.whiteColorHexa
                        : AppColors.textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
        ),
        SvgPicture.asset(
          'assets/undraw_bear_market_ania.svg',
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 0.2,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
        ),
        Column(
          children: [
            MyFlatButton(
              hasShadow: true,
              edgeMargin: const EdgeInsets.only(left: 42, right: 42, bottom: 16),
              textButton: AppString.createAccTitle,
              action: () {
                Navigator.pushNamed(context, AppString.contentBackup);
                // Navigator.push(context,MaterialPageRoute(builder: (context) => ContentsBackup()));
                // Navigator.push(context, MaterialPageRoute(builder: (context) => MyUserInfo("error shallow spin vault lumber destroy tattoo steel rose toilet school speed")));
              },
            ),
            MyFlatButton(
              hasShadow: true,
              edgeMargin:
                  const EdgeInsets.only(left: 42, right: 42, bottom: 16),
              textButton: AppString.importAccTitle,
              action: () {
                Navigator.pushNamed(context, AppString.importAccView);
              },
            )
          ],
        ),
      ],
    );
  }
}
