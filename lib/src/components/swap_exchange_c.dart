import 'package:wallet_apps/index.dart';

class SwapExchange extends StatelessWidget {
  final String? title;
  final Widget? image;
  final Function? action;
  
  const SwapExchange({Key? key, 
    this.title,
    this.image,
    @required this.action
  }) : super(key: key);

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
              padding: const EdgeInsets.symmetric(horizontal: 5),
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
                  hexaColor: AppColors.whiteColorHexa,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            const SizedBox(width: 60),
    
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}