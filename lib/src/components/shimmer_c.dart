import 'package:shimmer/shimmer.dart';
import 'package:wallet_apps/index.dart';

class AvatarShimmer extends StatelessWidget{

  final String? txt;
  final Widget? child;

  AvatarShimmer({this.txt, this.child});

  Widget build (BuildContext context){
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Align(
      alignment: Alignment.centerLeft,
      child: txt == null 
      ? Shimmer.fromColors(
        child: Container(
          width: 10.w,
          height: 10.w,
          margin: const EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
            color: isDarkTheme
              ? hexaCodeToColor(AppColors.whiteHexaColor)
              : Colors.grey.shade400,
            shape: BoxShape.circle,
          ),
        ), 
        period: const Duration(seconds: 2),
        baseColor: isDarkTheme
          ? Colors.white.withOpacity(0.06)
          : Colors.grey[300]!,
        highlightColor: isDarkTheme
          ? Colors.white.withOpacity(0.5)
          : Colors.grey[100]!,
      ) 
      : Container(
        width: 10.w,
        height: 10.w,
        margin: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          color: isDarkTheme
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
  
  WidgetShimmer({this.txt, this.child});

  Widget build(BuildContext context){
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return txt != null 
    ? child!
    : 
    Shimmer.fromColors(
      child: Container(
        width: 100,
        height: 8.0,
        margin: EdgeInsets.only(bottom: 3),
        color: Colors.white,
      ), 
      period: const Duration(seconds: 2),
      baseColor: isDarkTheme
        ? Colors.white.withOpacity(0.06)
        : Colors.grey[300]!,
      highlightColor: isDarkTheme
        ? Colors.white.withOpacity(0.5)
        : Colors.grey[100]!,
    );
  }
}

class TextShimmer extends StatelessWidget{

  final String? txt;
  final double? width;
  final Color? highlightColor;
  final double? opacity;
  
  TextShimmer({this.txt, this.width = 100, this.opacity = 0.06, this.highlightColor});

  Widget build(BuildContext context){
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return txt != null 
    ? MyText(
      bottom: 3,
      text: txt ?? '',
      fontSize: 16,
      color: isDarkTheme
        ? AppColors.whiteColorHexa
        : AppColors.textColor,
    ) 
    : Shimmer.fromColors(
      child: Container(
        width: width,
        height: 8.0,
        margin: EdgeInsets.only(bottom: 3),
        color: Colors.white,
      ), 
      period: const Duration(seconds: 2),
      baseColor: hexaCodeToColor(AppColors.whiteHexaColor).withOpacity(opacity!),
      highlightColor: highlightColor ?? Colors.white,
    );
  }
}