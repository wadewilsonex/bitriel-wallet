import 'package:wallet_apps/index.dart';

class SwapExchange extends StatelessWidget {
  final String? title;
  final Widget? image;
  final Function? action;
  
  SwapExchange({
    this.title,
    this.image,
    @required this.action,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: action == null ? null : (){
        action!();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: hexaCodeToColor(AppColors.bluebgColor)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  image!
                ],
              ),
            ),
    
            Expanded(child: Container()),
    
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText(
                  text: title,
                  fontSize: 18,
                  color: AppColors.whiteColorHexa,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            SizedBox(width: 60),
    
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}