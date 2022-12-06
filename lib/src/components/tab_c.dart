import 'package:wallet_apps/index.dart';

class TabItemComponent extends StatelessWidget{

  final String? label;  
  final int? active;
  final int? index;
  final Function()? onTap;

  TabItemComponent({required this.label , required this.active, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context){
    return InkWell(
      onTap: onTap!,
      child: Container(
        margin: EdgeInsets.only(right: 30),
        height: 30,
        child: Column(
          
          children: [
    
            MyText(
              height: 20,
              text: label,
              fontWeight: active == index ? FontWeight.w700 : FontWeight.w400,
              hexaColor: active == index ? AppColors.primaryColor : "#BCBCBC",
            ),
    
            active != index ? Container() : Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: hexaCodeToColor(AppColors.primaryColor)),
              width: 5,
              height: 5,
            ) 
          ],
        ),
      ),
    );
  }
}