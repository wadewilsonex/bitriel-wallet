import 'package:wallet_apps/index.dart';

class AvatarShimmer extends StatelessWidget{

  final String? txt;
  final Widget? child;

  const AvatarShimmer({Key? key, this.txt, this.child}) : super(key: key);

  final avatarSize = 4;

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
          width: avatarSize.sp,
          height: avatarSize.sp,
          margin: EdgeInsets.only(right: 1.sp),
          decoration: BoxDecoration(
            color: isDarkMode
              ? hexaCodeToColor(AppColors.whiteHexaColor)
              : Colors.grey.shade400,
            shape: BoxShape.circle,
          ),
        ),
      ) 
      : Container(
        width: avatarSize.sp,
        height: avatarSize.sp,
        margin: EdgeInsets.only(right: 1.sp),
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
        width: 14.sp,
        height: 1.2.sp,
        margin: EdgeInsets.only(bottom: 0.5.sp),
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
      fontSize: 2.4,
      fontWeight: FontWeight.bold,
      hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor
    ) 
    : Shimmer.fromColors(
      period: const Duration(seconds: 2),
      baseColor: hexaCodeToColor(AppColors.whiteHexaColor).withOpacity(opacity!),
      highlightColor: highlightColor ?? Colors.white,
      child: Container(
        width: width,
        height: 1.sp,
        margin: EdgeInsets.only(bottom: 0.5.sp),
        color: Colors.white,
      ),
    );
  }
}