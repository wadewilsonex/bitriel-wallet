import 'package:wallet_apps/index.dart';

class SelEcoSysMenuItem extends StatelessWidget {
  final String? title;
  final Function? action;
  final Widget? image;
  
  const SelEcoSysMenuItem({
    Key? key, 
    this.title,
    @required this.action,
    this.image,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        action!();
      },
      child: Container(
        height: 15.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isDarkMode ? hexaCodeToColor(AppColors.defiMenuItem) : hexaCodeToColor("#FFBF86"),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: image!,
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyText(
                text: title,
                // hexaColor: AppColors.whiteColorHexa,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}