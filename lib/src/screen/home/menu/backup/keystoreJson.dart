import 'package:wallet_apps/index.dart';

class KeyStoreJson extends StatelessWidget{

  final Map<String, dynamic>? keystore;

  KeyStoreJson({this.keystore});

  Widget build(BuildContext context){
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          /* Menu Icon */

          padding: const EdgeInsets.only(left: 16, right: 8),
          iconSize: 40.0,
          icon: Icon(
            Platform.isAndroid ? LineAwesomeIcons.arrow_left : LineAwesomeIcons.angle_left,
            color: isDarkTheme ? Colors.white : Colors.black,
            size: 22.5.sp,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: hexaCodeToColor(isDarkTheme ? AppColors.darkCard : AppColors.whiteHexaColor).withOpacity(0),
        title: MyText(text: 'Keystore (Json)', color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.blackColor, fontWeight: FontWeight.bold),
      ),
      body: Column(
        children: [
          Card(
            color: Colors.white.withOpacity(0.06),
            margin: EdgeInsets.all(paddingSize),
            child: Padding(
              padding: EdgeInsets.all(paddingSize),
              child: MyText(
                text: keystore.toString(),
                color2: Colors.white
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