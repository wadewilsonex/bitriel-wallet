import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wallet_apps/index.dart';
import 'package:path_provider/path_provider.dart';

class GetWalletMethod {

  Future<void> qrShare(GlobalKey globalKey, String wallet) async {
    try {
      final RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      final image = await boundary.toImage(pixelRatio: 5.0);
      final ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = await File("${tempDir.path}/selendra.png").create();
      await file.writeAsBytes(pngBytes);

      Share.shareXFiles([XFile(file.path)], text: wallet);
    } catch (e) {
      
      if (kDebugMode) {
        print("Error qrShare ${e.toString()}");
      }
    }
  }

  void popScreen(BuildContext context) {
    Navigator.pop(context);
  }

  /* Trigger Snack Bar Function */
  void snackBar(BuildContext context, String contents, GlobalKey<ScaffoldState> globalKey) {
    final snackbar = SnackBar(
      content: Text(contents),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
