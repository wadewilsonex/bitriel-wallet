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