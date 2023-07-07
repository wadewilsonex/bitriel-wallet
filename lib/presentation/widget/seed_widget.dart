import 'package:bitriel_wallet/index.dart';

class SeedContents extends StatelessWidget{

  final String? title;
  final String? subTitle;

  const SeedContents({Key? key, required this.title, required this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 25),
        MyTextConstant(
          text: title,
          fontSize: 21,
          fontWeight: FontWeight.bold,
        ),

        const SizedBox(height: 5),
        MyTextConstant(
          text: subTitle,
          // hexaColor: isDarkMode ? AppColors.lowWhite : AppColors.darkGrey,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.start,
          // fontSize: 16,
        ),
      ],
    );
  }
}