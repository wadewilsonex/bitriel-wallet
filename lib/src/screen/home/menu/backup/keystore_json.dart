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
            size: 22.5.sp,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        title: const MyText(text: 'Keystore (Json)', fontWeight: FontWeight.bold),
      ),
      body: Column(
        children: [
          Card(
            color: isDarkMode ? Colors.white.withOpacity(0.06) : Colors.white,
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
          
          // TextButton(
          //   onPressed: () {
          //     Clipboard.setData(
          //       ClipboardData(text: json.encode(keystore)),
          //     );
          //     /* Copy Text */
          //     snackBar(context, 'Copied keystore!');
          //   },
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       Icon(
          //         Iconsax.copy,
          //         color: hexaCodeToColor(AppColors.whiteHexaColor),
          //         size: 22.5.sp,
          //       ),
          //       Container(
          //         padding: const EdgeInsets.only(left: 10.0),
          //         child: MyText(
          //           text: "COPY ADDRESS",
          //           color: AppColors.whiteHexaColor,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}