import 'package:cached_network_image/cached_network_image.dart';
import 'package:wallet_apps/index.dart';

class ExplorerItem extends StatelessWidget {
  final String? title;
  final Function? action;
  final String? image;
  
  const ExplorerItem({
    Key? key, 
    this.title,
    @required this.action,
    this.image,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        action!();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.2.vmax),
        child: Container(
          // width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 48.0,
                offset: const Offset(0.0, 2)
              )
            ],
            borderRadius: BorderRadius.circular(1.2.vmax),
            color: hexaCodeToColor(isDarkMode ? AppColors.defiMenuItem : AppColors.whiteColorHexa)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Padding(
                padding: EdgeInsets.all(1.2.vmax),
                child: Container(
                  width: 4.4.vmax,
                  height: 4.4.vmax,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: image!,
                    progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(0.3.vmax),
                child: MyText(
                  text: title,
                  // hexaColor: AppColors.whiteColorHexa,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}