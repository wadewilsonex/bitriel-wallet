import 'package:wallet_apps/index.dart';

class SwapTokenList extends StatelessWidget {

  final bool? isActive;
  final String? title;
  final String? subtitle;
  final Widget? image;
  final Function? action;
  
  SwapTokenList({
    this.isActive = false,
    this.title,
    this.subtitle,
    this.image,
    @required this.action,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: action == null ? null : (){
        if (isActive == false) action!();
      },
      child: Container(
        color: hexaCodeToColor(AppColors.darkBgd),
        child: Row(
          children: [
      
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: image
              ),
            ),
          
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                MyText(
                  text: title,
                  // fontSize: 18,
                  color2: isActive == false ? hexaCodeToColor(AppColors.whiteColorHexa) : Colors.white.withOpacity(0.5),
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.start,
                ),
                MyText(
                  text: subtitle,
                  fontSize: 13,
                  color2: isActive == false ? hexaCodeToColor(AppColors.whiteColorHexa) : Colors.white.withOpacity(0.5),
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}