import 'package:wallet_apps/index.dart';
import 'dart:math' as math;

class FullScreenImageViewer extends StatefulWidget {
  
  final String url;
  
  const FullScreenImageViewer(this.url, {Key? key}) : super(key: key);

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {

  void changeImagePosition(){
    
    Timer(Duration(milliseconds: 10), (){

      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
      ]);
    });
  }
  @override
  initState(){
    // changeImagePosition();
    super.initState();
  }

  @override
  void dispose() {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    print("url ${widget.url}");
    return Scaffold(
      backgroundColor: hexaCodeToColor("393939"),
      body: SafeArea(
        child: GestureDetector(
          child: SizedBox(
          // width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Hero(
              tag: widget.url,
              // child: Image.network(url),
              child:Image.network(widget.url)
            ),
          ),
          onTap: () async {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}