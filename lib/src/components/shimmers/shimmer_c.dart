import 'package:wallet_apps/index.dart';

class AvatarShimmer extends StatelessWidget{

  final String? txt;
  final Widget? child;
  final double? width;
  final double? height;

  const AvatarShimmer({Key? key, this.txt, this.child, this.width = 50, this.height = 50}) : super(key: key);

  @override
  Widget build (BuildContext context){
     
    return Align(
      alignment: Alignment.centerLeft,
      child: txt == null 
      ? Shimmer.fromColors(
        period: const Duration(seconds: 2),
        baseColor: isDarkMode
          ? Colors.white.withOpacity(0.06)
          : Colors.grey[300]!,
        highlightColor: isDarkMode
          ? Colors.white.withOpacity(0.5)
          : Colors.grey[100]!,
        child: Container(
          width: width,
          height: height,
          margin: const EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
            color: isDarkMode
              ? hexaCodeToColor(AppColors.whiteHexaColor)
              : Colors.grey.shade400,
            shape: BoxShape.circle,
          ),
        ),
      ) 
      : Container(
        width: width,
        height: height,
        margin: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          color: isDarkMode
            ? hexaCodeToColor(AppColors.whiteHexaColor)
            : Colors.grey.shade400,
          shape: BoxShape.circle,
        ),
        child: child,
      ),
    );
  }
}

class WidgetShimmer extends StatelessWidget{

  final String? txt;
  final Widget? child;
  
  const WidgetShimmer({Key? key, this.txt, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context){
     
    return txt != null 
    ? child!
    : 
    Shimmer.fromColors(
      period: const Duration(seconds: 2),
      baseColor: isDarkMode
        ? Colors.white.withOpacity(0.06)
        : Colors.grey[300]!,
      highlightColor: isDarkMode
        ? Colors.white.withOpacity(0.5)
        : Colors.grey[100]!,
      child: Container(
        width: 100,
        height: 8.0,
        margin: const EdgeInsets.only(bottom: 3),
        color: Colors.white,
      ),
    );
  }
}

class TextShimmer extends StatelessWidget{

  final String? txt;
  final double? width;
  final Color? highlightColor;
  final double? opacity;
  
  const TextShimmer({Key? key, this.txt, this.width = 100, this.opacity = 0.06, this.highlightColor}) : super(key: key);

  @override
  Widget build(BuildContext context){
     
    return txt != null 
    ? MyText(
      text: txt ?? '',
      fontSize: 16,
      fontWeight: FontWeight.bold,
      hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor
    ) 
    : Shimmer.fromColors(
      period: const Duration(seconds: 2),
      baseColor: hexaCodeToColor(AppColors.whiteHexaColor).withOpacity(opacity!),
      highlightColor: highlightColor ?? Colors.white,
      child: Container(
        width: width,
        height: 8.0,
        margin: const EdgeInsets.only(bottom: 3),
        color: Colors.white,
      ),
    );
  }
}