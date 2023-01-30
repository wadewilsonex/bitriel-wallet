import 'package:wallet_apps/index.dart';

class DefiMenuItem extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Function? action;
  final Widget? image;

  const DefiMenuItem({
    Key? key, 
    this.title,
    this.subtitle,
    @required this.action,
    this.image
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        action!();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.sp),
          color: isDarkMode ? hexaCodeToColor(AppColors.defiMenuItem) : hexaCodeToColor(AppColors.whiteColorHexa),
        ),
        // padding: EdgeInsets.symmetric(vertical: 1.vmax),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.vmax),
              child: image!,
            ),

            Flexible(
              child: Padding(
                padding: EdgeInsets.all(1.vmax),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
            
                    MyText(
                      text: title,
                      hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.darkGrey,
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
            
                    MyText(
                      text: subtitle,
                      textAlign: TextAlign.start,
                      hexaColor: isDarkMode ? AppColors.lowWhite : AppColors.greyColor,
                      fontSize: 2.2,
                      overflow: TextOverflow.ellipsis,
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