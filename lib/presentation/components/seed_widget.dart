import 'package:bitriel_wallet/standalone/utils/app_utils/global.dart';
import 'package:bitriel_wallet/standalone/utils/themes/colors.dart';
import 'package:bitriel_wallet/presentation/widget/text_widget.dart';
import 'package:flutter/material.dart';

class SeedsCompoent {
  static double _seedHeight = 22.8;

  static List<Widget> getColumn(BuildContext context, String seed, int pos, {double? moreSize = 0}) {
    _seedHeight = (_seedHeight + moreSize!);
    var list = <Widget>[];
    var se = seed.split(' ');
    var colSize = se.length ~/ 3;

    for (var i = 0; i < colSize; i++) {
      if (se[i * 3 + pos] == "") {
        list.add(
            // Display Empty Text
          Container(
            // Minus 34 Size OF Padding Left & Right
            width: MediaQuery.of(context).size.width / 3 - _seedHeight,
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            alignment: Alignment.center,
            margin: const EdgeInsets.all(4),
            color: Colors.transparent,
          )
        );
      } else {
        list.add(Container(
          // Minus 34 Size OF Padding Left & Right
          width: MediaQuery.of(context).size.width / 3 - _seedHeight,
          padding: const EdgeInsets.only(top: 8, bottom: 8,),
          alignment: Alignment.center,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: hexaCodeToColor(AppColors.whiteHexaColor),
            borderRadius: const BorderRadius.all(Radius.circular(50)),
          ),
          // color: grey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              if ((i * 3 + pos + 1) < 10)
                MyText(
                    text: '${i * 3 + pos + 1}. ${se[i * 3 + pos]}',
                    hexaColor: AppColors.textColor,
                    fontSize: 17 * MediaQuery.of(context).textScaleFactor,
                    fontWeight: FontWeight.bold)
              else
                MyText(
                    text: '${i * 3 + pos + 1}. ${se[i * 3 + pos]}',
                    hexaColor: AppColors.textColor,
                    fontSize: 17 * MediaQuery.of(context).textScaleFactor,
                    fontWeight: FontWeight.bold),
            ]),
          ),
        ));
      }
    }
    return list;
  }

  static Widget seedContainer(BuildContext context, String txt, int index, int rmIndex, Function? onTap) {
    return GestureDetector(
      onTap: () {
        onTap!(index, rmIndex);
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 3 - _seedHeight,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: hexaCodeToColor(AppColors.whiteHexaColor),
          borderRadius: const BorderRadius.all(Radius.circular(50)),
        ),
        // color: grey,
        child: MyText(
          text: txt,
          hexaColor: AppColors.textColor,
          fontSize: 17 * MediaQuery.of(context).textScaleFactor,
          fontWeight: FontWeight.bold
        ),
      )
    );
  }
}
