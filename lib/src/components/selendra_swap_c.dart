import 'package:wallet_apps/index.dart';

class SelendraSwap extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? image;
  final Function? action;

  SelendraSwap({
    this.title,
    this.subtitle,
    this.image,
    @required this.action
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: hexaCodeToColor(AppColors.bluebgColor)
          ),
          child: ListTile(
            title: MyText(
              pTop: 2.h,
              pBottom: 2.h,
              text: title,
              color: AppColors.whiteColorHexa,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w600,
          
            ),
            subtitle: MyText(
              pBottom: 2.h,
              text: subtitle,
              color: AppColors.whiteColorHexa,
              textAlign: TextAlign.start,
              fontSize: 14,
            ),
            trailing: Container(
              height: 10.h,
              width: 10.w,
              color: Colors.transparent,
              child: image
            ),
            onTap: action == null ? null : (){
              action!();
            },
          ),
        ),
      ],
    );
  }
}