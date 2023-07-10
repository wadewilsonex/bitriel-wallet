import 'package:bitriel_wallet/index.dart';

PreferredSizeWidget appBar(final BuildContext context, {required final String title}) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    backgroundColor: hexaCodeToColor(AppColors.background),
    title: MyTextConstant(
      text: title,
      fontSize: 26,
      color2: hexaCodeToColor(AppColors.midNightBlue),
      fontWeight: FontWeight.w600,
    ),
    leading: IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Icon(
        Iconsax.arrow_left_2,
        size: 30,
        color: hexaCodeToColor(AppColors.midNightBlue),
      ),
    ),
  );
}
