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

    return Container(
      width: 200.w,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: hexaCodeToColor(AppColors.defiMenuItem)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: image!,
          ),

          Row(  
            children: [
              MyText(
                text: title,
                fontSize: 16.sp,
                color: AppColors.whiteColorHexa,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ],
      ),
    );
  }
}