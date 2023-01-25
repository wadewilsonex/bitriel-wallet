import 'package:wallet_apps/index.dart';

class ListTileComponent extends StatelessWidget{

  final String? text;
  final Function? action;

  const ListTileComponent({Key? key, this.text, this.action}) : super(key: key);

  @override
  Widget build(BuildContext context){
     
    return GestureDetector(
      onTap: () async {
        await action!();
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.whiteColorHexa),
        ),
        height: 8.h,
        child: Padding(
          padding: EdgeInsets.all(paddingSize),
          child: Row(
            children: [
              MyText(
                text: text,
              ),

              Expanded(child: Container()),

              Icon(
                Icons.arrow_forward_ios, 
                size: 18.5.sp,
                color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor)
              )
            ],
          ),
        ),
      ),
    );
  }
}