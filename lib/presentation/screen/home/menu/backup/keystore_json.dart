import 'package:wallet_apps/index.dart';

class KeyStoreJson extends StatelessWidget{

  final Map<String, dynamic>? keystore;

  const KeyStoreJson({Key? key, this.keystore}) : super(key: key);

  @override
  Widget build(BuildContext context){
     
    return Scaffold(
      backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Iconsax.arrow_left_2,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 30,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        title: const MyText(text: 'Keystore (Json)', fontSize: 20, fontWeight: FontWeight.bold, hexaColor: AppColors.blackColor,),
      ),
      body: Column(
        children: [
          Card(
            color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.whiteColorHexa),
            margin: const EdgeInsets.all(paddingSize),
            child: Padding(
              padding: const EdgeInsets.all(paddingSize),
              child: MyText(
                text: keystore.toString(),
                hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor
              )
            ),
          ),

          MyGradientButton(
            edgeMargin: const EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 16),
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