import 'package:wallet_apps/index.dart';

class HeaderTitle extends StatelessWidget {

  final String? title;
  final String? subTitle;

  const HeaderTitle({Key? key, required this.title, required this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        MyText(
          text: title!,
          fontSize: 2.9,
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.start,
          top: 30,
          bottom: 10,
        ),

        MyText(
          text: subTitle,
          textAlign: TextAlign.start,
          bottom: 30,
        )
      ],
    );
  }
}