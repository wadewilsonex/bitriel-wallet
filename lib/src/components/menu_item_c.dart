import 'package:wallet_apps/index.dart';

class MyMenuItem extends StatelessWidget {
  final String? title;
  final Widget? icon;
  final Function? action;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  
  MyMenuItem({
    this.title,
    this.icon,
    required this.begin,
    required this.end,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        action!();
      },
      child: Container(
        width: 200,
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
                    color: AppColors.whiteColorHexa,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}