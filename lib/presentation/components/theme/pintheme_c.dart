import 'package:pinput/pinput.dart';
import 'package:wallet_apps/index.dart';

PinTheme? pinTheme = PinTheme(
  width: 56,
  height: 56,
  textStyle: TextStyle(
    fontSize: 50,
    color: hexaCodeToColor(AppColors.primaryColor),
  ),
  decoration: const BoxDecoration(),
);

Widget prefillWidget(BuildContext context){
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: 3,
        decoration: BoxDecoration(
          color: hexaCodeToColor(AppColors.primaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ],
  );
}