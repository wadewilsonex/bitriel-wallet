import 'package:wallet_apps/index.dart';

class MyPieChartRow extends StatelessWidget {
  final Color? color;
  final String? centerText;
  final String? endText;

  const MyPieChartRow({Key? key, this.color, this.centerText, this.endText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              MyText(
                left: 11,
                text: centerText,
                fontSize: 14.0,
                hexaColor: isDarkMode
                  ? AppColors.whiteColorHexa
                  : AppColors.textColor,
              )
            ],
          ),
          Expanded(
            child: Container(),
          ),

          MyText(
            text: "$endText %",
            fontSize: 14.0,
            hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,
          )
        ],
      ),
    );
  }
}

// class MyPercentText extends StatelessWidget {
//   final String value;

//   const MyPercentText({this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           MyText(
//             text: value,
//             fontSize: 25,
//             color: AppColors.textColor,
//           ),
//           const MyText(
//             text: "%",
//             fontSize: 25,
//           )
//         ],
//       ),
//     );
//   }
// }
