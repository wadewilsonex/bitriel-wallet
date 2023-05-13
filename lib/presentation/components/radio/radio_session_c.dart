import 'package:wallet_apps/index.dart';

class RadioComponent extends StatelessWidget {

  final Map<String, dynamic>? data;
  final String? label;
  final dynamic groupValue;
  final dynamic title;
  final int? value;
  final Function? onChangeSession;

  const RadioComponent({
    Key? key, 
    required this.data,
    required this.groupValue, 
    required this.label, 
    required this.title, 
    required this.value,
    required this.onChangeSession,
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
            /// Value Is Start From 0
            /// 
            /// Data = {'from': '', 'to': ''}
            onChangeSession!(value, data);
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