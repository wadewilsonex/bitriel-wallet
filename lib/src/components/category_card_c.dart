
import 'package:wallet_apps/index.dart';

class CategoryCard extends StatelessWidget {

  // Index Of Category
  final int index;
  final String title;
  final int selectedIndex;
  final Function onTap;

  const CategoryCard({
    Key? key,
    required this.index,
    required this.title,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    
    return MyFlatButton(
      edgeMargin: const EdgeInsets.symmetric(vertical: 8),
      textColor: (index == selectedIndex) ? (isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor) : AppColors.greyColor,
      width: 25.w,  
      textButton: title,
      // subChild: Container(
      //   margin: EdgeInsets.only(top: 10.sp),
      //   width: 2.w, height: 2.w, decoration: (index == selectedIndex) ? BoxDecoration(
      //   borderRadius: BorderRadius.circular(100),
      //   color: hexaCodeToColor(AppColors.primaryColor)
      // ) : BoxDecoration(),),
      buttonColor: (index == selectedIndex) ? (isDarkMode ? AppColors.primaryColor : "#fcf2e1") : AppColors.whiteHexaColor,
      opacity: 1.0,
      isBorder: false,
      isTransparent: index == selectedIndex ? false : true,
      action: () {
        onTap(index, isTap: true);
      },
    );
  }
}