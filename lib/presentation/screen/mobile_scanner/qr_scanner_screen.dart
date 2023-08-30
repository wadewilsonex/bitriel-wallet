import 'package:bitriel_wallet/index.dart';
import 'package:scan/scan.dart';

class QrScanner extends StatefulWidget {

  const QrScanner({
    Key? key,
  }) : super(key: key);

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {

  ScanController scanController = ScanController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scanController.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [

              SizedBox(
                child: ScanView(
                  controller: scanController,
                  scanLineColor: hexaCodeToColor(AppColors.primary),
                  onCapture: (data) async {
                  
                    Navigator.pop(context, data);

                    if(data.contains("0x") || data.contains("se")) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TokenPayment(address: data,))
                      );
                    }
                    else{
                      await QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: 'Invalid address format',
                      );
                    }
                  },
                ),
              ),

              Positioned(
                top: 40,
                right: 10,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  iconSize: 40,
                  color: hexaCodeToColor(AppColors.primary)
                ),
              ),

              Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    color: hexaCodeToColor(AppColors.whiteColorHexa)
                  ),
                  child: const Column(
                    children: [
                      ListTile(
                        title: MyTextConstant(text: "Send Funds", fontSize: 18, fontWeight: FontWeight.w600, textAlign: TextAlign.start),
                        subtitle: MyTextConstant(text: "Scan address QR code to send transaction", fontSize: 15, textAlign: TextAlign.start),
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 30,
                              child: Icon(
                                Iconsax.arrow_up_3,
                                color: Colors.black
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
