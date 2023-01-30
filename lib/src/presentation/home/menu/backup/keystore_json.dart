import 'package:wallet_apps/index.dart';

class KeyStoreJson extends StatelessWidget{

  final Map<String, dynamic>? keystore;

  const KeyStoreJson({Key? key, this.keystore}) : super(key: key);

  @override
  Widget build(BuildContext context){
     
    return Scaffold(
      backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
      appBar: secondaryAppBar(
        context: context, 
        title: const MyText(text: 'Keystore (Json)', fontWeight: FontWeight.bold, fontSize: 2.4,)
      ),
      body: Column(
        children: [
          Card(
            color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.whiteColorHexa),
            margin: EdgeInsets.all(paddingSize),
            child: Padding(
              padding: EdgeInsets.all(paddingSize),
              child: MyText(
                text: keystore.toString(),
                hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor
              )
            ),
          ),

          MyGradientButton(
            edgeMargin: EdgeInsets.only(top: 2.4.sp, left: 2.8.sp, right: 2.8.sp, bottom: 2.4.sp),
            textButton: "Copy",
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            action: () {
              Clipboard.setData(
                ClipboardData(text: json.encode(keystore)),
              );
              /* Copy Text */
              snackBar(context, 'Copied keystore!');
            },
          ),
          
        ],
      ),
    );
  }
}