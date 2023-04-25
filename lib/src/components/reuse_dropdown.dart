import '../../index.dart';

class ReuseDropDown extends StatelessWidget {
  
  final ValueChanged<String>? onChanged;
  final Widget? icon;
  final String? initialValue;
  final TextStyle? style;
  final List<Map<String, dynamic>>? itemsList;

  const ReuseDropDown({Key? key, 
    this.onChanged,
    this.initialValue,
    this.icon,
    this.style,
    this.itemsList
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Theme(
      data: ThemeData(
        canvasColor: hexaCodeToColor(AppColors.whiteColorHexa)
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
            value: value['index'].runtimeType.toString() == "int" ? value['index'].toString() : value['index'],
            child: Text(value['symbol'])
          );
        }).toList(),
      ),
    );
  }
}
