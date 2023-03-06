import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/card_section_setting.m.dart';

class AboutBitriel extends StatelessWidget {

  final PackageInfo? packageInfo;

  const AboutBitriel({Key? key, this.packageInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? hexaCodeToColor(AppColors.darkBgd) : hexaCodeToColor(AppColors.lightColorBg),
        iconTheme: IconThemeData(
          color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor)
        ),
        elevation: 0,
        bottomOpacity: 0,
        title: const MyText(
          text: "About Us",
          hexaColor: AppColors.blackColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Iconsax.arrow_left_2,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 30,
          ),
        ),
      ),
      body: Column(
        children: [
          _bitrielVersion(),

          Padding(
            padding: const EdgeInsets.all(paddingSize),
            child: Divider(
              thickness: 0.2,
              color: hexaCodeToColor(AppColors.darkGrey),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(paddingSize),
            child: _infoSection(context),
          ),
        ],
      ),
    );
  }

  Widget _bitrielVersion(){
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(paddingSize),
            child: Image.asset("assets/logo/bitriel-logo-v2.png", height: 40.sp, width: 40.sp,),
          ),
          MyText(
            text: "${packageInfo!.appName}: ${packageInfo!.version}",
            fontWeight: FontWeight.bold,
            fontSize: 20,
          )
        ],
      ),
    );
  }

  Widget _infoSection(BuildContext context, ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 48.0,
            offset: const Offset(0.0, 2)
          )
        ],
        color: hexaCodeToColor(isDarkMode ? AppColors.defiMenuItem : AppColors.whiteColorHexa),
        borderRadius: BorderRadius.circular(20)
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: infoSection(context: context).length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              infoSection(context: context)[index].action!();
            },
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: paddingSize / 2),
                            child: MyText(
                              text: infoSection(context: context)[index].title,
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    Icon(infoSection(context: context)[index].trailingIcon, color: hexaCodeToColor(AppColors.primaryColor), size: 30),

                  ],
                ),

                infoSection(context: context).length - 1 == index ? Container() : Divider(thickness: 1, color: hexaCodeToColor(AppColors.greyColor).withOpacity(0.5),),
              ],
            ),
          );
        }
      ),
    );
  }

}