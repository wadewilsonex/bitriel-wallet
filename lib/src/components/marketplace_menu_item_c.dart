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
          borderRadius: BorderRadius.circular(15.sp),
          color: isDarkMode ? hexaCodeToColor(AppColors.defiMenuItem) : hexaCodeToColor(AppColors.whiteColorHexa),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Padding(
              padding: EdgeInsets.all(8.0.sp),
              child: image!,
            ),

            // const Spacer(),

            Padding(
              padding: EdgeInsets.all(8.0.sp),
              child: MyText(
                text: title,
                hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.darkGrey,
                fontWeight: FontWeight.w700,
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