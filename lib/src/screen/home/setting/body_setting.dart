import '../../../../index.dart';
import '../../../models/settings_m.dart';

class BodySettingPage extends StatelessWidget {
  const BodySettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          color: hexaCodeToColor(AppColors.defiMenuItem),
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
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle
                        ),
                        child: Icon(settingsAccSection(context: context)[index].leadingIcon, color: Colors.white, size: 17,),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(text: settingsAccSection(context: context)[index].title, color: AppColors.whiteColorHexa),
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
          color: hexaCodeToColor(AppColors.defiMenuItem),
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
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle
                        ),
                        child: Icon(settingsWCSection(context: context)[index].leadingIcon, color: Colors.white, size: 17,),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(text: settingsWCSection(context: context)[index].title, color: AppColors.whiteColorHexa),
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
          color: hexaCodeToColor(AppColors.defiMenuItem),
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
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle
                        ),
                        child: Icon(settingsPolicySection(context: context)[index].leadingIcon, color: Colors.white, size: 17,),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(text: settingsPolicySection(context: context)[index].title, color: AppColors.whiteColorHexa),
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
          color: hexaCodeToColor(AppColors.defiMenuItem),
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
                            MyText(text: settingsLogoutSection(context: context)[index].title, color: AppColors.warningColor),
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
