import 'package:wallet_apps/index.dart';

class SelendraSwap extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? image;
  final Function? action;

  const SelendraSwap({
    Key? key, 
    this.title,
    this.subtitle,
    this.image,
    @required this.action
  }) : super(key: key);

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
              pTop: 2,
              pBottom: 2,
              text: title,
              hexaColor: AppColors.whiteColorHexa,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w600,
          
            ),
            subtitle: MyText(
              pBottom: 2,
              text: subtitle,
              hexaColor: AppColors.whiteColorHexa,
              textAlign: TextAlign.start,
              fontSize: 14,
            ),
            trailing: Container(
              height: 10,
              width: 10,
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