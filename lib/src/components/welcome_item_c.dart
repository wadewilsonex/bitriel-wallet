import 'package:wallet_apps/index.dart';

class WelcomeItem extends StatelessWidget {
  final String? title;
  final String? itemColor;
  final Widget? icon;
  final String? textColor;
  final Widget? image;
  final Function? action;
  
  const WelcomeItem({
    Key? key, 
    this.title,
    this.itemColor,
    this.textColor,
    this.icon,
    this.image,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Consumer<AppProvider>(
      builder: (context, pro, wg) {
        return GestureDetector(
          onTap: (){
            action!();
          },
          child: Container(
            // height: MediaQuery.of(context).size.height,
            // width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: hexaCodeToColor(itemColor!)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      icon!
                    ],
                  ),
                ),

                // const Spacer(),

                SizedBox(
                  height: 150,
                  width: 150,
                  child: image!
                ),

                // const Spacer(),

                Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 10.0),
                  child: Row(
                    children: [
                      MyText(
                        text: title,
                        hexaColor: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}