import 'package:wallet_apps/index.dart';

class PortraitCardItem extends StatelessWidget {
  final String? title;
  final Function action;
  final Widget? image;
  final String hexColor;
  final Widget icon;
  
  const PortraitCardItem({
    Key? key, 
    this.title,
    required this.action,
    this.image,
    required this.hexColor,
    required this.icon,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        action();
      },
      child: Container(
        // height: 30.h,
        // width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: hexaCodeToColor(hexColor)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: icon
            ),

            // const Spacer(),
            // Center(
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: image!,
            //   ),
            // ),

            // const Spacer(),
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyText(
                text: title,
                hexaColor: AppColors.whiteColorHexa,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}