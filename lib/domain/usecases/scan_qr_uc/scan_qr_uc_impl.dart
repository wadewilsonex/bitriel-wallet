import 'package:bitriel_wallet/index.dart';

class ScanQrUcImpl implements ScanQrUc {
  
  final GlobalKey qrKey = GlobalKey();

  BuildContext? context;

  QRViewController? qrViewController;

  set setContext(BuildContext ctx) {
    context = ctx;
  }

  Future? onQrViewCreated(QRViewController controller) async {

    qrViewController ??= controller;
    qrViewController!.resumeCamera();

    try {

      qrViewController!.scannedDataStream.listen((event) async {
        qrViewController!.pauseCamera();

        await getData(event.code!);

      });

    } catch (e) {
    }

    return qrViewController!;
  }

  @override
  Future<void> getData(String data) async {
    
    qrViewController!.pauseCamera();
  
    // Navigator.pop(context, data);

      if(data.contains("0x") || data.contains("se")) {
        Navigator.pushReplacement(
          context!,
          MaterialPageRoute(builder: (context) => TokenPayment(address: data,))
        );
      }
      else{

        await QuickAlert.show(
          context: context!,
          type: QuickAlertType.error,
          text: 'Invalid address format',
        );

        qrViewController!.resumeCamera();
      }
  }
}