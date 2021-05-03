import 'package:flutter/material.dart';
import 'package:wallet_apps/index.dart';

class AssetItem extends StatelessWidget {
  final String asset;
  final String tokenSymbol;
  final String org;
  final String balance;
  final Color color;
  final double size;

  const AssetItem(
      this.asset, this.tokenSymbol, this.org, this.balance, this.color,
      {this.size});
  @override
  Widget build(BuildContext context) {
    return rowDecorationStyle(
        child: Row(
      children: <Widget>[
        Container(
          width: 65, //size ?? 65,
          height: 65, //size ?? 65,
          padding: const EdgeInsets.all(6),
          margin: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Image.asset(
            asset,
            fit: BoxFit.contain,
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: tokenSymbol,
                  color: "#FFFFFF",
                ),
                if (org == '') Container() else MyText(text: org, fontSize: 15),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                    width: double.infinity,
                    text: balance ?? '0',
                    color: "#FFFFFF",
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Widget rowDecorationStyle(
      {Widget child, double mTop = 0, double mBottom = 16}) {
    return Container(
        margin: EdgeInsets.only(top: mTop, bottom: 2),
        padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
        height: 100,
        color: hexaCodeToColor(AppColors.cardColor),
        child: child);
  }
}
