import 'package:wallet_apps/index.dart';

class DefiMenuItem extends StatelessWidget {
  final String? title;
  final Function? action;
  final Widget? image;

  DefiMenuItem({
    this.title,
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
        height: 8.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: hexaCodeToColor(AppColors.defiMenuItem)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: image!,
            ),
    
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: MyText(
                text: title,
                color: AppColors.whiteColorHexa,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}