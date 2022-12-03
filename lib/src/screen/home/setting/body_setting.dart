import 'package:wallet_apps/src/constants/color.dart';
import 'package:wallet_apps/src/models/card_section_setting.m.dart';

import '../../../../../index.dart';

class BodySettingPage extends StatelessWidget {
  const BodySettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: MyText(
          text: "Settings",
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: paddingSize),
        child: Column(
          children: [
            accountSection(context),

            SizedBox(height: 2.h),

            wcSection(context),

            SizedBox(height: 2.h),

            policySection(context),

            SizedBox(height: 2.h),

            logoutSection(context),
          ],
        ),
      ),
    );
  }

  Widget accountSection(BuildContext context) {
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
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: settingsAccSection(context: context).length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (){
                settingsAccSection(context: context)[index].action!();
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.orangeColor).withOpacity(0.2),
                            shape: BoxShape.circle
                        ),
                        child: Icon(settingsAccSection(context: context)[index].leadingIcon, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.orangeColor), size: 17,),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(text: settingsAccSection(context: context)[index].title),
                          ],
                        ),
                      ),
                    ],
                  ),

                  settingsAccSection(context: context).length - 1 == index ? Container() : Divider(thickness: 1, color: hexaCodeToColor(AppColors.greyColor).withOpacity(0.5),),
                ],
              ),
            );
          }
      ),
    );
  }

  Widget wcSection(BuildContext context) {
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
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: settingsWCSection(context: context).length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (){
                settingsWCSection(context: context)[index].action!();
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.orangeColor).withOpacity(0.2),
                            shape: BoxShape.circle
                        ),
                        child: Icon(settingsWCSection(context: context)[index].leadingIcon, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.orangeColor), size: 17,),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(text: settingsWCSection(context: context)[index].title,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
      ),
    );
  }

  Widget policySection(BuildContext context) {
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
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: settingsPolicySection(context: context).length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (){
                settingsPolicySection(context: context)[index].action!();
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.orangeColor).withOpacity(0.2),
                            shape: BoxShape.circle
                        ),
                        child: Icon(settingsPolicySection(context: context)[index].leadingIcon, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.orangeColor), size: 17,),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(text: settingsPolicySection(context: context)[index].title),
                          ],
                        ),
                      ),
                    ],
                  ),
                  settingsPolicySection(context: context).length - 1 == index ? Container() : Divider(thickness: 1, color: hexaCodeToColor(AppColors.greyColor).withOpacity(0.5),),
                ],
              ),
            );
          }
      ),
    );
  }

  Widget logoutSection(BuildContext context) {
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
        color: isDarkMode ? hexaCodeToColor(AppColors.defiMenuItem) : hexaCodeToColor(AppColors.warningColor).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20)
      ),
      child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: settingsLogoutSection(context: context).length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (){
                settingsLogoutSection(context: context)[index].action!();
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: hexaCodeToColor(AppColors.warningColor),
                          shape: BoxShape.circle
                        ),
                        child: Icon(settingsLogoutSection(context: context)[index].leadingIcon, color: hexaCodeToColor(AppColors.whiteColorHexa), size: 17,),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(text: settingsLogoutSection(context: context)[index].title, hexaColor: AppColors.warningColor),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
      ),
    );
  }

}
