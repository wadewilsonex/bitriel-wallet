import 'package:wallet_apps/index.dart';

class ActivityItem extends StatelessWidget {
  final TransactionInfo? _trxInfo;
  const ActivityItem(this._trxInfo, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
     
    final addr = AppUtils.addrFmt('0x899D45A8AE71160b85d414E48544204dec8A99B0');

    return rowDecorationStyle(
      color: isDarkMode
        ? hexaCodeToColor(AppColors.darkCard)
        : hexaCodeToColor(AppColors.whiteHexaColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                //size ?? 65,
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.only(right: 4.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: myIconButton(
                  context,
                  icon: 'wall_clock.svg',
                  iconSize: 36,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 8.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: _trxInfo!.status == null
                        ? 'Pending Transaction'
                        : _trxInfo!.status!
                            ? 'Transfer'
                            : 'Failed',
                    bottom: 16.0,
                    fontWeight: FontWeight.bold,
                    hexaColor: isDarkMode
                        ? AppColors.whiteColorHexa
                        : AppColors.textColor,
                  ),
                  MyText(
                    text: 'To: $addr',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    hexaColor: AppColors.darkSecondaryText,
                  ),
                ],
              ),
            ],
          ),
          MyText(
            text: '${_trxInfo!.amount} ${_trxInfo!.coinSymbol}',
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
            hexaColor:
                isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,
          ),
        ],
      )
    );
  }

  Widget rowDecorationStyle({Widget? child, double mTop = 0, double mBottom = 16, Color? color}) {
    return Container(
      margin: EdgeInsets.only(top: mTop, bottom: 2),
      padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
      height: 100,
      color: color ?? hexaCodeToColor(AppColors.whiteHexaColor),
      child: child,
    );
  }
}
