import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/appbar_c.dart';
import 'package:wallet_apps/src/screen/main/create_seeds/create_seeds.dart';

class ContentsBackup extends StatefulWidget {
  //static const route = '/contentsBackup';

  @override
  _ContentsBackupState createState() => _ContentsBackupState();
}

class _ContentsBackupState extends State<ContentsBackup> {
  final double bpSize = 16.0;
  String _passPhrase = '';
  List _passPhraseList = [];

  Future<void> _generateMnemonic() async {
    print("_generateMnemonic");
    try {
      _passPhrase = await Provider.of<ApiProvider>(context, listen: false).generateMnemonic();
      _passPhraseList = _passPhrase.split(' ');

      print("_passPhraseList ${_passPhraseList}");

      // setState(() {});
    } on PlatformException catch (p) {
      if (ApiProvider().isDebug == true) print("Platform $p");
    } catch (e) {
      if (ApiProvider().isDebug == true) print("error $e");
    }
  }

  @override
  void initState() {
    _generateMnemonic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            MyAppBar(
              title: AppString.createAccTitle,
              color: isDarkTheme
                  ? hexaCodeToColor(AppColors.darkCard)
                  : hexaCodeToColor(AppColors.whiteHexaColor),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: MyText(
                        text: AppString.backup,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: isDarkTheme
                            ? AppColors.whiteColorHexa
                            : AppColors.textColor,
                        bottom: bpSize,
                      )),
                  MyText(
                    textAlign: TextAlign.left,
                    text: AppString.getMnemonic,
                    fontWeight: FontWeight.w500,
                    color: isDarkTheme
                        ? AppColors.whiteColorHexa
                        : AppColors.textColor,
                    bottom: bpSize,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: MyText(
                      text: AppString.backupPassphrase,
                      textAlign: TextAlign.left,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: isDarkTheme
                        ? AppColors.whiteColorHexa
                        : AppColors.textColor,
                      bottom: bpSize,
                    )
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: MyText(
                      textAlign: TextAlign.left,
                      text: AppString.keepMnemonic,
                      fontWeight: FontWeight.w500,
                      color: isDarkTheme
                        ? AppColors.whiteColorHexa
                        : AppColors.textColor,
                      bottom: bpSize,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: MyText(
                      text: AppString.offlineStorage,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: isDarkTheme
                        ? AppColors.whiteColorHexa
                        : AppColors.textColor,
                      bottom: bpSize,
                    )
                  ),
                  MyText(
                    textAlign: TextAlign.left,
                    text: AppString.mnemonicAdvise,
                    fontWeight: FontWeight.w500,
                    color: isDarkTheme
                      ? AppColors.whiteColorHexa
                      : AppColors.textColor,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(),
            ),
            MyFlatButton(
              edgeMargin: const EdgeInsets.only(left: 66, right: 66, bottom: 16),
              hasShadow: true,
              textButton: AppString.next,
              action: () async {
                await _generateMnemonic();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => 
                    CreateSeeds()
                    // CreateMnemonic(
                    //   _passPhrase,
                    //   _passPhraseList,
                    // ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
