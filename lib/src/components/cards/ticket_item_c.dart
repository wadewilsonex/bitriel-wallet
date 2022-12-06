import 'package:wallet_apps/index.dart';

class TicketItemComponent extends StatelessWidget{

  final String? label;
  final String? value;
  final Widget? child;
  final String? valueColor;
  final double? valueFontSize;
  final Function()? onTap;

  TicketItemComponent({ 
    required this.label, 
    this.value,
    this.child,
    this.valueColor = "#49595F",
    this.valueFontSize = 16,
    this.onTap
  });

  @override
  Widget build(BuildContext context){
    return InkWell(
      onTap: onTap,
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
                bottom: 10,
                fontSize: 14,
                text: label ?? '',
                hexaColor: "#BCBCBC",
              ),
            
              child ?? MyText(
                textAlign: TextAlign.start,
                text: value ?? '',
                hexaColor: valueColor,
                fontSize: valueFontSize,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
