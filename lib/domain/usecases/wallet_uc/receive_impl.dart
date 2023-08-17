import 'package:bitriel_wallet/index.dart';
import 'dart:ui';


class ReceiveUcImpl implements ReceiveUc {

  GlobalKey globalKey = GlobalKey();

  BuildContext? _context;

  set setBuildContext(BuildContext ctx){
    _context = ctx;
  }

  @override
  Future<void> copyAddress(String addr) async {
    await Clipboard.setData(
      ClipboardData(text: addr),
    );
    /* Copy Text */
    // provider.method.snackBar(context, 'Copied', provider.globalKey!);
    _snackBar(_context!, "Copied", addr);
  }

  void _snackBar(BuildContext context, String contents, String addr) {
    final snackbar = SnackBar(
      content: Text("$contents address ""$addr"""),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  Future<void> shareAddress(String addr) async {
    try {
      
      final RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      final image = await boundary.toImage(pixelRatio: 5.0);
      final ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = await File("${tempDir.path}/selendra.png").create();
      await file.writeAsBytes(pngBytes);

      Share.shareXFiles([XFile(file.path)], text: addr);
    } catch (e) {
      
      if (kDebugMode) {
        debugPrint("Error qrShare ${e.toString()}");
      }
    }
  }

}