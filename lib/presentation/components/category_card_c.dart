
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
    
    return InkWell(
      onTap: () {
        onTap(index, isTap: true);
      },

      child: Row(
        children: [
          const SizedBox(width: 2,),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyText(
                text: title,
                fontSize: 15,
                fontWeight: (index == selectedIndex) ? FontWeight.bold : FontWeight.w400,
                hexaColor: (index == selectedIndex) ? (isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor) : AppColors.greyColor,
              ),
              
              const SizedBox(height: 0.65,),

              (index == selectedIndex) ?
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor)),
                width: 5,
                height: 5,
              ) 
              : Container(),
            ],
          ),

          const SizedBox(width: 7,),
        ],
      ),
    );
  }
}