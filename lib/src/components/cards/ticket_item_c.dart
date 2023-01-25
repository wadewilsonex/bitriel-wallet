import 'package:wallet_apps/index.dart';

class TicketItemComponent extends StatelessWidget{

  final String? label;
  final String? value;
  final Widget? icon;
  final Widget? child;
  final String? valueColor;
  final double? valueFontSize;
  final Function? onTap;

  const TicketItemComponent({
    Key? key,  
    required this.label, 
    this.value,
    this.icon,
    this.child,
    this.valueColor = "#49595F",
    this.valueFontSize = 16,
    this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return InkWell(
      onTap: (){
        
        if (onTap != null) onTap!();
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
    
              MyText(
                textAlign: TextAlign.start,
                bottom: 1.5.vmax,
                fontSize: 2,
                text: label ?? '',
                hexaColor: "#BCBCBC",
              ),
            
              child ?? Row(
                children: [
                  
                  icon != null ? Container(margin: EdgeInsets.only(right: 1.5.vmax), child: icon!,) : Container(), 
                  Flexible(
                    child: MyText(
                      textAlign: TextAlign.start,
                      text: value ?? '',
                      hexaColor: valueColor,
                      fontSize: valueFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
