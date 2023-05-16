import 'package:wallet_apps/index.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WelcomeItem extends StatelessWidget {
  final String? title;
  final String? itemColor;
  final Widget? icon;
  final String? textColor;
  final int? iconIndex;
  final int? imageIndex;
  final Function? action;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final String? img;
  
  const WelcomeItem({
    Key? key, 
    this.title,
    this.itemColor,
    this.textColor,
    this.icon,
    this.iconIndex,
    this.imageIndex,
    required this.action,
    this.height = 150,
    this.width = 150,
    this.margin,
    this.img
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // final imgs = Provider.of<AppProvider>(context, listen: false).onBoardingImg;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: hexaCodeToColor(itemColor!)
      ),
      child: GestureDetector(
        onTap: (){
          action!();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [

            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10.0),
              child: icon!
              // ValueListenableBuilder(
              //   valueListenable: imgs!,
              //   builder: (context, value, wg) {

              //     return CachedNetworkImage(
              //       imageUrl: "https://raw.githubusercontent.com/BITRIEL-DATA/BITRIEL-DATA.github.io/main/icons/setup-1.png", 
              //       width: 35, height: 35,
              //       // placeholder: (context, url) => const CircularProgressIndicator(),
              //       errorWidget: (context, url, error) => const Icon(Icons.error),
              //     );
              //     // return value[iconIndex!].path.isEmpty ? const Text("...") : SvgPicture.file(value[iconIndex!], width: 35, height: 35,);
              //     // return imageIndex!;
              //   }
              // ),
            ),

            // const Spacer(),

            Center(
              child: SizedBox(
                height: height,
                width: width,
                child: Image.asset(img!, 
                  width: 35, height: 35,
                )
                // ValueListenableBuilder(
                //   valueListenable: imgs!,
                //   builder: (context, value, wg) {
                //     return value[imageIndex!].path.isEmpty ? const Text("...") : Image.file(value[imageIndex!], width: 70, height: 70,);
                //     // return imageIndex!;
                //   }
                // )
              ),
            ),

            // const Spacer(),

            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10.0),
              child: MyTextConstant(
                text: title,
                color2: Color(AppUtils.convertHexaColor(textColor!)),
                fontWeight: FontWeight.w600,
                // fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget circularWidget(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SizedBox(height: 30, width: 30, child: CircularProgressIndicator())
      ],
    );
  }
}