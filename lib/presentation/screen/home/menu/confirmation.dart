import '../../../../index.dart';

class Confirmation extends StatelessWidget {
  const Confirmation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      body: bodyScaffold(
        context,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            
            myAppBar(
              context,
              title: "Account",
              color: isDarkMode
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
