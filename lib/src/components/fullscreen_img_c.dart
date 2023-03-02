import 'package:wallet_apps/index.dart';

class FullScreenImageViewer extends StatefulWidget {
  
  final String url;
  final bool isLandscape;
  
  const FullScreenImageViewer(this.url, this.isLandscape, {Key? key}) : super(key: key);

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {

  void changeImagePosition(){
    
    Timer(const Duration(milliseconds: 10), (){

      SystemChrome.setPreferredOrientations([
        widget.isLandscape == true ? DeviceOrientation.landscapeLeft
        : DeviceOrientation.portraitUp

      ]);
    });
  }
  @override
  initState(){
    changeImagePosition();
    super.initState();
  }

  @override
  void dispose() {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexaCodeToColor("393939"),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 19,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Iconsax.close_circle,
                color: Colors.black,
                size: 20.sp,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          child: SizedBox(
          // width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Hero(
              tag: widget.url,
              // child: Image.asset(url),
              child: widget.url.contains("https") ? Image.network(widget.url) : Image.asset(widget.url)
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