import 'package:bitriel_wallet/index.dart';
import 'package:scan/scan.dart';

class QrScanner extends StatefulWidget {

  const QrScanner({
    Key? key,
  }) : super(key: key);

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> with SingleTickerProviderStateMixin {
  final BorderRadius _borderRadius = const BorderRadius.vertical(
    top: Radius.circular(20),
  );

  late AnimationController controller;
  late Animation<double> scaleAnimation;
  ScanController scanController = ScanController();

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  void dispose() {
    scanController.pause();
    controller.stop();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Scaffold(
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
                    onCapture: (data) => {
                      Navigator.pop(context, data),
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
                      borderRadius: _borderRadius,
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
      ),
    );
  }
}
