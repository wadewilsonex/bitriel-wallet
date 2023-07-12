import 'package:bitriel_wallet/index.dart';

class SettingScreen extends StatelessWidget {

  const SettingScreen({super.key});
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [

          InkWell(
            onTap: (){

              Navigator.push(
                context, 
                MaterialPageRoute(
                  settings: const RouteSettings(name: "/multipleWallets"),
                  builder: (context) => const MultiAccountScreen()
                )
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: hexaCodeToColor(AppColors.primaryColor).withOpacity(0.05),
                    shape: BoxShape.circle
                  ),
                  child: const SizedBox(height: 30, width: 30, child: Icon(Icons.account_circle_outlined)),
                ),
          
                const SizedBox(width: 10,),
          
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyTextConstant(
                        text: "Account",
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                    ],
                  ),
                ),
                
                // Icon(settingsWalletSection(context: context)[index].trailingIcon, color: hexaCodeToColor(AppColors.primaryColor), size: 30,),
          
              ],
            ),
          ),

        ]
      )
    );
  }

}

class CardSection {
  final String? title;
  final String? subtittle;
  final String? trailingTitle;
  final Widget? leadingIcon;
  final IconData? trailingIcon;
  final Function? action;

  CardSection({this.title, this.subtittle, this.trailingTitle, this.leadingIcon, this.trailingIcon, this.action});
}