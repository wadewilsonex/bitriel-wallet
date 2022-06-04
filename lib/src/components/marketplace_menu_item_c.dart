import 'package:wallet_apps/index.dart';

class MarketPlaceMenuItem extends StatelessWidget {
  final String? title;
  final Function? action;
  
  MarketPlaceMenuItem({
    this.title,
    @required this.action,
  });


  @override
  Widget build(BuildContext context) {

    return Container(
      width: 200.w,
      height: 90.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: hexaCodeToColor(AppColors.bluebgColor)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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