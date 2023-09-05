import 'package:bitriel_wallet/index.dart';

class QrScanner extends StatelessWidget {

  const QrScanner({
    Key? key,
  }) : super(key: key);

  // @override
  @override
  Widget build(BuildContext context) {

    final ScanQrUcImpl scanQrUcImpl = ScanQrUcImpl();

    scanQrUcImpl.setContext = context;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [

              SizedBox(
                // child: ScanView(
                //   controller: scanQrUcImpl.scanController,
                //   scanLineColor: hexaCodeToColor(AppColors.primary),
                //   onCapture: scanQrUcImpl.scanQr,
                // ),
                child: QRView(
                  key: scanQrUcImpl.qrKey,
                    onQRViewCreated: scanQrUcImpl.onQrViewCreated,
                    //  (QRViewController qrView) async {
                    //   await onQrViewCreated(qrView);
                    // },
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.white,
                      borderRadius: 10,
                      borderWidth: 5,
                      borderLength: 50,
                    )
                )
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
