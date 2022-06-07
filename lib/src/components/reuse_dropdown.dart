import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../index.dart';

class ReuseDropDown extends StatelessWidget {
  
  final ValueChanged<String>? onChanged;
  final Widget? icon;
  final String? initialValue;
  final TextStyle? style;
  final List<Map<String, dynamic>>? itemsList;

  const ReuseDropDown({
    this.onChanged,
    this.initialValue,
    this.icon,
    this.style,
    this.itemsList
  });

  @override
  Widget build(BuildContext context) {

    return Theme(
      data: ThemeData(
        canvasColor: hexaCodeToColor(AppColors.darkBgd)
      ),
      child: DropdownButton<String>(
        value: initialValue,
        underline: Container(
          color: Colors.blue,
        ),
        style: style,
        icon: icon,
        onChanged: (String? value){
          onChanged!(value!);
        },
        items: itemsList!.map<DropdownMenuItem<String>>((Map<String, dynamic> value) {
          return DropdownMenuItem<String>(
            value: value['index'].toString(),
            child: Text(value['symbol'])
          );
        }).toList(),
      ),
    );
  }
}
