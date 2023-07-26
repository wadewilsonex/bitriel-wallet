import 'package:bitriel_wallet/index.dart';

Widget dropDown(List<SmartContractModel> lstCoins, ValueNotifier<int> index) {
  return DropdownButtonHideUnderline(
    child: DropdownButton2<String>(
      isExpanded: true,
      hint: ValueListenableBuilder(
        valueListenable: index,
        builder: (context, value, wg){
          return Text(
            lstCoins[value
            ].symbol!,
            style: const TextStyle(
              fontSize: 14,
            ),
          );
        },
      ),
      items: lstCoins.map((e) {
        return DropdownMenuItem<String>(
          value: lstCoins.indexOf(e).toString(),
            child: Text(
            e.symbol!,
          )
        );
      }).toList(),
      onChanged: (String? value) {
          // selectedValue = value;
        index.value = int.parse(value!);
      },
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: 40,
        width: 140,
      ),
      menuItemStyleData: const MenuItemStyleData(
        height: 40,
      ),
    )
  );
}