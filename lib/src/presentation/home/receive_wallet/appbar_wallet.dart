import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:wallet_apps/index.dart';

class QrViewTitle extends StatelessWidget {
  final bool? isValue;
  final String? assetInfo;
  final String? initialValue;
  final Function? onChanged;
  final List<Map<String, dynamic>>? listContract;

  const QrViewTitle({Key? key, this.isValue, this.assetInfo, this.initialValue, this.onChanged, required this.listContract}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        canvasColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg)
      ),
      child: Consumer<WalletProvider>(
        builder: (context, value, child) {
          return DropdownButtonHideUnderline(
            child: DropdownButton2(
              value: isValue == true ? initialValue : null,
              isExpanded: true,
              dropdownElevation: 16,
              dropdownPadding: EdgeInsets.symmetric(horizontal: 1.vmax),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.5.vmax),
                border: Border.all(color: hexaCodeToColor(AppColors.primary), width: 0.1.vmax)
              ),
              itemHeight: 6.vmax,
              itemPadding: EdgeInsets.zero,
              icon: Icon(Icons.arrow_drop_down, color: hexaCodeToColor(AppColors.secondary), size: 5.vmax,),
              items: listContract!.map<DropdownMenuItem<String>>((Map<String, dynamic> value) {
                return DropdownMenuItem<String>(
                  value: value['index'].toString(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: Align(
                        alignment: Alignment.center,
                        child: MyText(text: value['symbol'], overflow: TextOverflow.ellipsis,))),
                      Divider(
                        color: hexaCodeToColor(AppColors.primary), 
                        height: 1,
                      )
                    ],
                  )
                );
              }).toList(),
              // value: initialValue,
              onChanged: (String? value){
                onChanged!(value);
              },
            ),
          );
        },
      ),
    );
  }
}