
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
      edgeMargin: EdgeInsets.symmetric(vertical: 8),
      textColor: AppColors.blackColor,
      width: 25.w,
      textButton: title,
      buttonColor: index == selectedIndex ? AppColors.secondary : AppColors.whiteColorHexa,
      action: () {
        onTap(index, isTap: true);
      },
    );
  }
}