import 'dart:ui';

import 'package:wallet_apps/index.dart';

class SwapTokenList extends StatelessWidget {

  final bool? isActive;
  final String? title;
  final String? subtitle;
  final Widget? image;
  final Function? action;
  
  const SwapTokenList({
    Key? key, 
    this.isActive = false,
    this.title,
    this.subtitle,
    this.image,
    @required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: action == null ? null : (){
        if (isActive == false) action!();
      },
      child: Container(
        color: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
        child: Row(
          children: [
      
            SizedBox(
              height: 65,
              width: 65,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: isActive == false 
                  ? image 
                  : ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                    child: image,
                  ),
                ),
              ),
            ),
          
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                MyText(
                  text: title,
                  fontSize: 22,
                  color2: isActive == false ? hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor) : hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.lightGreyColor).withOpacity(0.5),
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.start,
                ),
                MyText(
                  text: subtitle,
                  fontSize: 16,
                  color2: isActive == false ? hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor) : hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.greyColor).withOpacity(0.5),
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