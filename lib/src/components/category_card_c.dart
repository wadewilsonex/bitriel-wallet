
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
    
    return GestureDetector(
      onTap: () {
        onTap(index);
      },
      child: Card(
        color: index == selectedIndex ?hexaCodeToColor(AppColors.secondary) : Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width /4,
          child: MyText(
            text: title,
          )
        ),
      ),
    );
  }
}