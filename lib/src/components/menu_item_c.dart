import 'package:wallet_apps/index.dart';

class MenuItem extends StatelessWidget {
  final String? title;
  final Widget? icon;
  final Function? action;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  
  MenuItem({
    this.title,
    this.icon,
    required this.begin,
    required this.end,
    @required this.action,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 200.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [hexaCodeToColor("#0D6BA6"), hexaCodeToColor("#2EF9C8")],
          begin: begin,
          end: end, 
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                icon!
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 10.0),
            child: Row(  
              children: [
                MyText(
                  text: title,
                  fontSize: 16.sp,
                  color: AppColors.whiteColorHexa,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}