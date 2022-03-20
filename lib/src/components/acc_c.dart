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
        margin: const EdgeInsets.only(left: 16,right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        height: 70,
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
              color: hexaCodeToColor(isDarkTheme
              ? AppColors.whiteColorHexa
              : AppColors.textColor)
            )
          ],
        ),
      ),
    );
  }
}