import 'package:wallet_apps/index.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({Key? key}) : super(key: key);

  // final List portList;
  // final WalletSDK sdk;
  // final Keyring keyring;

  // QrScanner({this.portList, this.sdk, this.keyring});

  @override
  State<StatefulWidget> createState() {
    return QrScannerState();
  }
}

class QrScannerState extends State<QrScanner> {

  final GlobalKey qrKey = GlobalKey();

  Future? _onQrViewCreated(QRViewController controller) async {
    controller.resumeCamera();
    try {
      controller.scannedDataStream.listen((event) async {
        controller.pauseCamera();

        Navigator.pop(context, event.code);

      });

    } catch (e) {
      if (kDebugMode) {
        print("qr create $e");
      }
    }

    return controller;
  }

  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? hexaCodeToColor(AppColors.darkBgd) : hexaCodeToColor(AppColors.lightColorBg),
        iconTheme: IconThemeData(
          color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor)
        ),
        title: const MyText(
          text: "Scan QR",
          fontSize: 17,
          fontWeight: FontWeight.w600
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Iconsax.arrow_left_2,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: BodyScaffold(
        physic: const NeverScrollableScrollPhysics(),
        height: MediaQuery.of(context).size.height,
        bottom: 0,
        child: Column(
          children: [
            
            Expanded(
              child: Stack(
                children: [
                  QRView(
                    key: qrKey,
                    onQRViewCreated: (QRViewController qrView) async {
                      await _onQrViewCreated(qrView);
                    },
                    overlay: QrScannerOverlayShape(
                      borderColor: hexaCodeToColor(AppColors.whiteColorHexa),
                      borderRadius: 10,
                      borderWidth: 10,
                    ),
                  ),
                  const Positioned(
                    left: 85,
                    top: 550,
                    child: MyText(
                      text: "Scan QR Code to login, send, pay",
                      // fontSize: 15,
                      hexaColor: AppColors.whiteColorHexa,
                    ),
                  )
                ]
              )
            ),
          ],
        ),
      ),
    );
  }
}
