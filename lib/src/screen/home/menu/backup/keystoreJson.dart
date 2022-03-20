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
            size: 36,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        backgroundColor: hexaCodeToColor(isDarkTheme ? AppColors.darkCard : AppColors.whiteHexaColor),
        title: MyText(text: 'Keystore (Json)', color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.blackColor, fontWeight: FontWeight.bold),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            margin: EdgeInsets.all(paddingSize),
            child: Padding(
              padding: EdgeInsets.all(paddingSize),
              child: MyText(
                text: keystore.toString(),
              )
            ),
          ),

          TextButton(
            onPressed: () {
              Clipboard.setData(
                ClipboardData(text: json.encode(keystore)),
              );
              /* Copy Text */
              snackBar(context, 'Copied keystore!');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.content_copy,
                  color: hexaCodeToColor(AppColors.secondary),
                  size: 30,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: const MyText(
                    text: "COPY ADDRESS",
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}