import 'package:wallet_apps/index.dart';

class WelcomeItem extends StatelessWidget {
  final String? title;
  final String? itemColor;
  final Widget? icon;
  final String? textColor;
  final Widget? image;
  final Function? action;
  
  const WelcomeItem({
    Key? key, 
    this.title,
    this.itemColor,
    this.textColor,
    this.icon,
    this.image,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        action!();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: hexaCodeToColor(itemColor!)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: icon!,
            ),

            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 20.h,
              child: image!,
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10.0),
              child: MyText(
                text: title,
                hexaColor: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}