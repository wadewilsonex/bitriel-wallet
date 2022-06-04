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
      height: 8.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: hexaCodeToColor(AppColors.defiMenuItem)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(  
            children: [
              MyText(
                text: title,
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