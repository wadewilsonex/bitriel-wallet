import 'package:pinput/pinput.dart';
import 'package:wallet_apps/index.dart';

PinTheme? pinTheme = const PinTheme(
  width: 56,
  padding: EdgeInsets.only(bottom: 15),
  textStyle: TextStyle(
    fontSize: 50,
    color: Color(0xFFF29F05),
    // color: hexaCodeToColor(AppColors.primaryColor),
  ),
  decoration: null,
);

class PrefillWidget extends StatelessWidget {

  const PrefillWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      decoration: BoxDecoration(
        color: const Color(0xFFF29F05),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

// Widget prefillWidget(){
//   return Container(
//     height: 3,
//     decoration: BoxDecoration(
//       color: const Color(0xFFF29F05),
//       borderRadius: BorderRadius.circular(8),
//     ),
//   );
// }