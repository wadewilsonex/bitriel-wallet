
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
      textColor: index == selectedIndex ? AppColors.whiteColorHexa : AppColors.greyColor,
      width: 25.w,
      textButton: title,
      buttonColor: index == selectedIndex ? isDarkMode ? AppColors.primaryColor : "#98A8F8" : AppColors.whiteHexaColor,
      isTransparent: index == selectedIndex ? false : true,
      action: () {
        onTap(index, isTap: true);
      },
    );
  }
}