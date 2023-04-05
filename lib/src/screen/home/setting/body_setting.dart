import 'package:wallet_apps/src/models/card_section_setting.m.dart';

import '../../../../../index.dart';

class BodySettingPage extends StatelessWidget {

  final PackageInfo? packageInfo;
  final MenuModel? model;
  final Function? switchBio;

  const BodySettingPage({Key? key, this.packageInfo, this.model, this.switchBio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const MyText(
          text: "Settings",
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: paddingSize),
          child: Column(
            children: [
              
              walletSection(context),

              SizedBox(height: 4.h),

              settingsSection(context),
      
              SizedBox(height: 2.h),
      
              logoutSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget walletSection(BuildContext context, ) {
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
        color: hexaCodeToColor(AppColors.whiteColorHexa),
        borderRadius: BorderRadius.circular(20)
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: settingsAccSection(context: context).length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              settingsWalletSection(context: context, packageInfo: packageInfo)[index].action!();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: hexaCodeToColor(AppColors.primaryColor).withOpacity(0.05),
                        shape: BoxShape.circle
                      ),
                      child: SizedBox(height: 30, width: 30, child: settingsWalletSection(context: context)[index].leadingIcon),
                    ),

                    const SizedBox(width: 10,),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: settingsWalletSection(context: context)[index].title,
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ],
                      ),
                    ),
                    
                    Icon(settingsWalletSection(context: context)[index].trailingIcon, color: hexaCodeToColor(AppColors.primaryColor), size: 30,),

                  ],
                ),

                // MyText(
                //   pTop: 10,
                //   text: settingsWalletSection(context: context)[index].subtittle,
                // ),

                settingsWalletSection(context: context).length - 1 == index ? Container() : Divider(thickness: 1, color: hexaCodeToColor(AppColors.greyColor).withOpacity(0.5),),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget settingsSection(BuildContext context, ) {
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
        color: hexaCodeToColor(AppColors.whiteColorHexa),
        borderRadius: BorderRadius.circular(20)
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: settingsAccSection(context: context).length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              settingsAccSection(
                context: context, 
                packageInfo: packageInfo, 
                model: model, 
                switchBio: switchBio
              )[index].action!();
            },
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: hexaCodeToColor(AppColors.primaryColor).withOpacity(0.05),
                        shape: BoxShape.circle
                      ),
                      child: settingsAccSection(context: context)[index].leadingIcon,
                    ),

                    const SizedBox(width: 10,),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: settingsAccSection(context: context)[index].title,
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ],
                      ),
                    ),
                    
                    Icon(settingsAccSection(context: context)[index].trailingIcon, color: hexaCodeToColor(AppColors.primaryColor), size: 30,),

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

  // Widget wcSection(BuildContext context) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 20),
  //     decoration: BoxDecoration(
  //       boxShadow: <BoxShadow>[
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.04),
  //           blurRadius: 48.0,
  //           offset: const Offset(0.0, 2)
  //         )
  //       ],
  //       color: hexaCodeToColor(isDarkMode ? AppColors.defiMenuItem : AppColors.whiteColorHexa),
  //       borderRadius: BorderRadius.circular(20)
  //     ),
  //     child: ListView.builder(
  //       physics: const NeverScrollableScrollPhysics(),
  //       shrinkWrap: true,
  //       padding: const EdgeInsets.symmetric(vertical: 10),
  //       itemCount: settingsWCSection(context: context).length,
  //       itemBuilder: (context, index) {
  //         return GestureDetector(
  //           onTap: (){
  //             settingsWCSection(context: context)[index].action!();
  //           },
  //           child: Column(
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   Container(
  //                     padding: const EdgeInsets.all(10),
  //                     decoration: BoxDecoration(
  //                         color: hexaCodeToColor(AppColors.primaryColor).withOpacity(0.1),
  //                         shape: BoxShape.circle
  //                     ),
  //                     child: Icon(settingsWCSection(context: context)[index].leadingIcon, color: hexaCodeToColor(AppColors.primaryColor), size: 17,),
  //                   ),
  //                   const SizedBox(width: 10,),
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         MyText(text: settingsWCSection(context: context)[index].title,),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         );
  //       }
  //     ),
  //   );
  // }

  // Widget policySection(BuildContext context) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 20),
  //     decoration: BoxDecoration(
  //       boxShadow: <BoxShadow>[
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.04),
  //           blurRadius: 48.0,
  //           offset: const Offset(0.0, 2)
  //         )
  //       ],
  //       color: hexaCodeToColor(isDarkMode ? AppColors.defiMenuItem : AppColors.whiteColorHexa),
  //       borderRadius: BorderRadius.circular(20)
  //     ),
  //     child: ListView.builder(
  //       physics: const NeverScrollableScrollPhysics(),
  //       shrinkWrap: true,
  //       padding: const EdgeInsets.symmetric(vertical: 10),
  //       itemCount: settingsPolicySection(context: context).length,
  //       itemBuilder: (context, index) {
  //         return GestureDetector(
  //           onTap: (){
  //             settingsPolicySection(context: context)[index].action!();
  //           },
  //           child: Column(
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   Container(
  //                     padding: const EdgeInsets.all(10),
  //                     decoration: BoxDecoration(
  //                         color: hexaCodeToColor(AppColors.primaryColor).withOpacity(0.1),
  //                         shape: BoxShape.circle
  //                     ),
  //                     child: Icon(settingsPolicySection(context: context)[index].leadingIcon, color: hexaCodeToColor(AppColors.primaryColor), size: 17,),
  //                   ),
  //                   const SizedBox(width: 10,),
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         MyText(text: settingsPolicySection(context: context)[index].title),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               settingsPolicySection(context: context).length - 1 == index ? Container() : Divider(thickness: 1, color: hexaCodeToColor(AppColors.greyColor).withOpacity(0.5),),
  //             ],
  //           ),
  //         );
  //       }
  //     ),
  //   );
  // }

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
        color: hexaCodeToColor(AppColors.warningColor).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20)
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: settingsLogoutSection(context: context).length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () async {
              await settingsLogoutSection(context: context)[index].action!();
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
                      child: settingsLogoutSection(context: context)[index].leadingIcon,
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: settingsLogoutSection(context: context)[index].title, 
                            hexaColor: AppColors.warningColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            ),
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
