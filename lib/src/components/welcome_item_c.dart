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
        height: 35.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.sp),
          color: hexaCodeToColor(itemColor!)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Padding(
              padding: EdgeInsets.only(top: 15.sp, left: 15.sp),
              child: icon!,
            ),

            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: image!,
              ),
            ),

            Padding(
              padding: EdgeInsets.only(bottom: 15.sp, left: 15.sp),
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