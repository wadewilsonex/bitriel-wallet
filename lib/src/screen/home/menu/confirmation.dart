import 'package:wallet_apps/src/components/appbar_c.dart';

import '../../../../index.dart';

class Confirmation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            MyAppBar(
              title: "Account",
              color: isDarkTheme
                  ? hexaCodeToColor(AppColors.darkCard)
                  : hexaCodeToColor(AppColors.whiteColorHexa),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
