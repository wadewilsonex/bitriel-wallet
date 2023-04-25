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
          height: 125,
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
                  fontSize: 18,
                  hexaColor: AppColors.whiteColorHexa,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Spacer(),
                    Flexible(
                      child: Align(
                        heightFactor: 1,
                        widthFactor: 1,
                        alignment: Alignment.topLeft,
                        child: Image.file(File(asset!)),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}