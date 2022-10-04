import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/main/create_seeds/create_seeds.dart';

class ContentsBackup extends StatefulWidget {
  const ContentsBackup({Key? key}) : super(key: key);

  //static const route = '/contentsBackup';

  @override
  ContentsBackupState createState() => ContentsBackupState();
}

class ContentsBackupState extends State<ContentsBackup> {
  final double bpSize = 16.0;
  String _passPhrase = '';
  List passPhraseList = [];

  Future<void> _generateMnemonic() async {
    try {
      _passPhrase = await Provider.of<ApiProvider>(context, listen: false).generateMnemonic();
      passPhraseList = _passPhrase.split(' ');

      // setState(() {});
    } on PlatformException catch (p) {
      if (ApiProvider().isDebug == true) {
        if (kDebugMode) {
          print("Platform $p");
        }
      }
    } catch (e) {
      if (ApiProvider().isDebug == true) {
        if (kDebugMode) {
          print("error $e");
        }
    }
      }
  }

  @override
  void initState() {
    _generateMnemonic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            MyAppBar(
              title: AppString.createAccTitle,
              color: isDarkMode
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
                        hexaColor: isDarkMode
                            ? AppColors.whiteColorHexa
                            : AppColors.textColor,
                        bottom: bpSize,
                      )),
                  MyText(
                    textAlign: TextAlign.left,
                    text: AppString.getMnemonic,
                    fontWeight: FontWeight.w500,
                    hexaColor: isDarkMode
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
                      hexaColor: isDarkMode
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
                      hexaColor: isDarkMode
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
                      hexaColor: isDarkMode
                        ? AppColors.whiteColorHexa
                        : AppColors.textColor,
                      bottom: bpSize,
                    )
                  ),
                  MyText(
                    textAlign: TextAlign.left,
                    text: AppString.mnemonicAdvise,
                    fontWeight: FontWeight.w500,
                    hexaColor: isDarkMode
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

                if(!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => 
                    const CreateSeeds()
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
