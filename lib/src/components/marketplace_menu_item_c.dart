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
        height: 125,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isDarkMode ? hexaCodeToColor(AppColors.defiMenuItem) : hexaCodeToColor(AppColors.whiteColorHexa),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: image!,
            ),

            // const Spacer(),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyText(
                text: title,
                hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.darkGrey,
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),

            // const Spacer(),
            // const Spacer(),
          ],
        ),
      ),
    );
  }
}