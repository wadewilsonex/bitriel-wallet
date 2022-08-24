import 'package:wallet_apps/index.dart';

class DefiMenuItem extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Function? action;
  final Widget? image;

  DefiMenuItem({
    this.title,
    this.subtitle,
    @required this.action,
    this.image
  });


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        action!();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: hexaCodeToColor(AppColors.defiMenuItem)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: image!,
            ),

            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
            
                    MyText(
                      text: title,
                      color: AppColors.whiteColorHexa,
                      fontWeight: FontWeight.w700,
                    ),
            
                    MyText(
                      text: subtitle,
                      color: AppColors.greyColor,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}