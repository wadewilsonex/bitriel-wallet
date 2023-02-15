import 'package:wallet_apps/index.dart';

class MyMenuItem extends StatelessWidget {
  final String? title;
  final String? asset;
  final Widget? icon;
  final Function? action;
  final String colorHex;
  
  const MyMenuItem({
    Key? key, 
    this.title,
    this.asset,
    this.icon,
    required this.colorHex,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        action!();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: hexaCodeToColor(colorHex),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10, top: 5),
                child: MyText(
                  text: title,
                  hexaColor: AppColors.whiteColorHexa,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),

              Row(
                children: [
                  const Spacer(),
                  Flexible(
                    child: Align(
                      heightFactor: 0.77,
                      widthFactor: 0.77,
                      alignment: Alignment.topLeft,
                      child: Image.asset(asset!, height: 100,),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),

    );
  }
}