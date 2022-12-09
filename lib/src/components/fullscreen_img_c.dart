import 'package:wallet_apps/index.dart';

class FullScreenImageViewer extends StatelessWidget {
  
  const FullScreenImageViewer(this.url,{Key? key}) : super(key: key);
  final String url;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexaCodeToColor("393939"),
      body: SafeArea(
        child: GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Hero(
                tag: 'imageHero',
                // child: Image.network(url),
                child: Image.asset(url),
              ),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}