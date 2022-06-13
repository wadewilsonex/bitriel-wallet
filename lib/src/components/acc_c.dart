import 'package:wallet_apps/index.dart';

class ListTileComponent extends StatelessWidget{

  final String? text;
  final Function? action;

  ListTileComponent({this.text, this.action});

  Widget build(BuildContext context){
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return GestureDetector(
      onTap: () async {
        await action!();
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: hexaCodeToColor(AppColors.bluebgColor)
        ),
        height: 8.h,
        child: Padding(
          padding: const EdgeInsets.all(paddingSize),
          child: Row(
            children: [
              MyText(
                text: text,
                color: isDarkTheme
                  ? AppColors.whiteColorHexa
                  : AppColors.textColor,
                fontWeight: FontWeight.bold,
              ),

              Expanded(child: Container()),

              Icon(
                Icons.arrow_forward_ios, 
                size: 18.5.sp,
                color: hexaCodeToColor(isDarkTheme
                ? AppColors.whiteColorHexa
                : AppColors.textColor)
              )
            ],
          ),
        ),
      ),
    );
  }
}