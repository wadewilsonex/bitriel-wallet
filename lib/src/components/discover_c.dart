import 'package:wallet_apps/index.dart';

class DiscoverItem extends StatelessWidget{

  final String? icon;
  final String? title;
  final String? subTitle;
  final Function? onPressed;

  DiscoverItem({this.icon, this.title, this.subTitle, this.onPressed});

  Widget build(BuildContext context){
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return InkWell(
      onTap: (){
        onPressed!();
      }, 
      child: Card(
        color: isDarkTheme ? hexaCodeToColor(AppColors.grey).withOpacity(0.4) : Colors.white,
        margin: EdgeInsets.only(bottom: 20),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [

              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        textAlign: TextAlign.left,
                        fontWeight: FontWeight.w800,
                        text: title,
                        bottom: 5,
                        color: isDarkTheme ? AppColors.whiteHexaColor : AppColors.blackColor,
                      ),
                      MyText(
                        textAlign: TextAlign.left,
                        color: isDarkTheme ? AppColors.whiteHexaColor : AppColors.blackColor,
                        text: subTitle,
                      ),
                    ],
                  )
                ),
              ),
              
              SizedBox(
                width: 50,
                height: 50,
                child: SvgPicture.asset(
                  'assets/$icon',
                  width: 50,
                  height: 50,
                ),
              )
              
            ],
          ),
        ),
      ),
    );
  }
}

class DiscoverDefiItem extends StatelessWidget{

  final String? logo;
  final String? title;
  final String? subTitle;

  DiscoverDefiItem({@required this.logo, @required this.title, this.subTitle});

  Widget build(BuildContext context){
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return InkWell(
      onTap: (){

      }, 
      child: Card(
        color: isDarkTheme ? hexaCodeToColor(AppColors.grey).withOpacity(0.4) : Colors.white,
        margin: EdgeInsets.only(bottom: 20),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              
              SizedBox(
                width: 50,
                height: 50,
                child: SvgPicture.asset(
                  'assets/logo/$logo',
                  width: 50,
                  height: 50,
                ),
              ),

              SizedBox(width: 15,),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      textAlign: TextAlign.left,
                      fontWeight: FontWeight.w800,
                      text: "$title",
                      color: isDarkTheme ? AppColors.whiteHexaColor : AppColors.blackColor,
                      fontSize: 20,
                    ),
                    subTitle != null ? MyText(
                      textAlign: TextAlign.left,
                      text: "$subTitle",
                      color: isDarkTheme ? AppColors.whiteHexaColor : AppColors.blackColor,
                    ) : Container(),
                  ],
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}