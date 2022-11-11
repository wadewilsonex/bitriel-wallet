import 'package:wallet_apps/index.dart';

class SelEcoSysMenuItem extends StatelessWidget {
  final String? title;
  final Function? action;
  final Widget? image;
  
  const SelEcoSysMenuItem({
    Key? key, 
    this.title,
    @required this.action,
    this.image,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        action!();
      },
      child: Container(
        height: 15.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: isDarkMode ? Colors.transparent : hexaCodeToColor(AppColors.orangeColor).withOpacity(0.50),
            width: 0.75,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 48.0,
              offset: const Offset(0.0, 2)
            )
          ],
          borderRadius: BorderRadius.circular(8),
          color: isDarkMode ? hexaCodeToColor(AppColors.defiMenuItem) : hexaCodeToColor(AppColors.whiteColorHexa),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: image!,
            ),

            // const Spacer(),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyText(
                text: title,
                // hexaColor: AppColors.whiteColorHexa,
                fontWeight: FontWeight.w700,
              ),
            ),

            // const Spacer(),
            // const Spacer(),
          ],
        ),
      ),
    );
  }
}