import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wallet_apps/index.dart';

class RadioComponent extends StatelessWidget {

  final Map<String, dynamic>? data;
  final String? label;
  final dynamic groupValue;
  final dynamic title;
  final int? value;
  final Function? onChangeSession;
  final int? index;

  RadioComponent({
    Key? key, 
    required this.data,
    required this.groupValue, 
    required this.label, 
    required this.title, 
    required this.value,
    required this.onChangeSession,
    /// TicketType Index
    required this.index
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

        Radio(
          fillColor: MaterialStateProperty.all(hexaCodeToColor("#49595F")),
          value: value!, 
          groupValue: groupValue, 
          onChanged: (value){
            /// onValueChange!('session', value);
            onChangeSession!(index, value, data);
          }
        ),
        
        MyText(
          textAlign: TextAlign.start,
          text: title,
          fontWeight: FontWeight.w600,
        )

      ],
    );
  }
}