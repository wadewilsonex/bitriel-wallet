import 'package:wallet_apps/index.dart';

class SwapTokenList extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? image;
  final Function? action;
  
  SwapTokenList({
    this.title,
    this.subtitle,
    this.image,
    @required this.action,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: action == null ? null : (){
        action!();
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                image!
              ],
            ),
          ),
    
    
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: title,
                fontSize: 18,
                color: AppColors.whiteColorHexa,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.start,
              ),
              MyText(
                text: subtitle,
                fontSize: 10,
                color: AppColors.whiteColorHexa,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          SizedBox(width: 60),
    
          Expanded(child: Container()),
        ],
      ),
    );
  }
}