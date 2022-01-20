import 'package:wallet_apps/index.dart';

class SendComponent extends StatelessWidget{

  final String? label;
  final Widget? txtFormField;
  final Widget? trailing1;
  final Widget? trailing2;
  final EdgeInsetsGeometry? margin;
  final Function? onPressedTrailing1;
  final Function? onPressedTrailing2;

  SendComponent({this.label, this.txtFormField, this.trailing1, this.trailing2, this.margin, this.onPressedTrailing1, this.onPressedTrailing2});

  final double textSize = 15;
  
  Widget build(BuildContext context){
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: label!,
            color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.blackColor,
            fontSize: textSize,
            bottom: 10,
          ),
          
          Container(
            // padding: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: hexaCodeToColor(AppColors.lowGrey)
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: txtFormField!),
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: InkWell(
                    onTap: (){
                      onPressedTrailing1!();
                    }, 
                    child: trailing1
                  )
                ),

                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: InkWell(
                    onTap: (){
                      onPressedTrailing2!();
                    }, 
                    child: trailing2
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }
}