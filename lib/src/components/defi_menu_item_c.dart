import 'package:wallet_apps/index.dart';

class DefiMenuItem extends StatelessWidget {
  final String? title;
  final Function? action;
  
  DefiMenuItem({
    this.title,
    @required this.action,
  });


  @override
  Widget build(BuildContext context) {

    return Container(
      width: 200,
      height: 90,
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
                fontSize: 16,
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