import 'package:wallet_apps/index.dart';
import 'package:fl_chart/fl_chart.dart';

const fontSizePort = 17.0;
const fontColorPort = Colors.white;

List<Color> _gradientColors = [
  hexaCodeToColor(AppColors.secondary),
  hexaCodeToColor("#00ff6b")
];

final portfolioChart = LineChartData(
  borderData: FlBorderData(show: false),
  gridData: FlGridData(
    show: false,
    drawVerticalLine: false,
    getDrawingHorizontalLine: (value) {
      return FlLine(
        color: const Color(0xff37434d),
        strokeWidth: 0.3,
      );
    },
    getDrawingVerticalLine: (value) {
      return FlLine(
        color: const Color(0xff37434d),
        strokeWidth: 0.3,
      );
    },
  ),
  titlesData: FlTitlesData(
    show: true,
    bottomTitles: SideTitles(
      reservedSize: 6,
      getTitles: (value) {
        switch (value.toInt()) {
          case 0:
            return '';
          case 1:
            return '2h';
          case 2:
            return '4h';
          case 3:
            return '6h';
          case 4:
            return '8h';
          case 5:
            return '10h';
        }
        return '12h';
      },
      margin: 0,
    ),
    leftTitles: SideTitles(
      getTitles: (value) {
        switch (value.toInt()) {
          case 0:
            return '';
          case 1:
            return '50';
          case 2:
            return '100';
          case 3:
            return '150';
        }
        return '200';
      },
      reservedSize: 3,
      margin: 0,
    ),
  ),
  minX: 0,
  maxX: 6,
  minY: 0,
  maxY: 4,
  lineBarsData: [
    LineChartBarData(
      spots: [
        const FlSpot(0, 0),
        const FlSpot(0.5, 0.5),
        const FlSpot(1, 1),
        const FlSpot(1.5, 2),
        const FlSpot(2, 2.5),
        const FlSpot(2.5, 3),
        const FlSpot(3, 3),
        const FlSpot(3.5, 3),
        const FlSpot(4, 4),
        const FlSpot(4.5, 3.5),
        const FlSpot(5, 2),
        const FlSpot(5.5, 2),
        const FlSpot(6, 1),
      ],
      isCurved: true,
      colors: _gradientColors,
      barWidth: 2.5,
      // isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
        colors: _gradientColors.map((color) => color.withOpacity(0.3)).toList(),
      ),
    ),
  ],
);

Widget cardToken(
  /* Card Token Display */
  String title,
  String tokenAmount,
  String rateColor,
  String greenColor,
  String rate,
  IconData rateIcon,
  double paddingeBottom6,
) {
  return Container(
    decoration: BoxDecoration(
        border: Border.all(color: hexaCodeToColor(AppColors.borderColor)),
        borderRadius: BorderRadius.circular(size5)),
    child: Padding(
      padding: const EdgeInsets.all(19.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: paddingeBottom6),
            child: const Text("Most Active Token"),
          ),
          Container(
            margin: EdgeInsets.only(bottom: paddingeBottom6),
            child: Row(
              children: <Widget>[
                Container(
                  height: 38.0,
                  alignment: Alignment.center,
                  child: textDisplay(
                      /* Token number */
                      tokenAmount,
                      TextStyle(
                          color: hexaCodeToColor(AppColors.lightBlueSky),
                          fontWeight: FontWeight.bold,
                          fontSize: 28.0)),
                ),
                Container(
                  margin: EdgeInsets.only(
                      bottom: paddingeBottom6, left: paddingeBottom6),
                  child: Text(
                    "Token",
                    style: TextStyle(color: hexaCodeToColor(greenColor)),
                  ),
                )
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Icon(
                rateIcon,
                color: hexaCodeToColor(rateColor),
                size: 17.0,
              ),
              Text(
                rate,
                style: TextStyle(color: hexaCodeToColor(rateColor)),
              )
            ],
          )
        ],
      ),
    ),
  );
}

class AddAssetRowButton extends StatelessWidget {
  const AddAssetRowButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Navigator.pushNamed(context, AddAsset.route);
      },
      child: rowDecorationStyle(
        child: Row(
          children: [
            Container(
              width: 40.0,
              height: 40.0,
              margin: const EdgeInsets.only(right: 10.0),
              decoration: BoxDecoration(
                color: hexaCodeToColor(AppColors.secondary),
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(40.0),
              ),
              alignment: Alignment.center,
              child: const Icon(
                LineAwesomeIcons.plus,
                color: Colors.white,
              ),
            ),
            const Text(
              "Add asset",
              style: TextStyle(
                color: fontColorPort,
                fontSize: fontSizePort,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Portfolow Row Decoration
Widget rowDecorationStyle({Widget? child, double mTop = 0, double mBottom = 16}) {
  return Container(
    margin: EdgeInsets.only(top: mTop, left: 16, right: 16, bottom: 16),
    padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
    height: 90,
    decoration: BoxDecoration(
      boxShadow: const [
        BoxShadow(
            color: Colors.black12, blurRadius: 2.0, offset: Offset(1.0, 1.0))
      ],
      color: hexaCodeToColor(AppColors.whiteHexaColor),
      borderRadius: BorderRadius.circular(8),
    ),
    child: child,
  );
}

Widget myBottomAppBar(
  BuildContext context,
  {
    final int? index,
    final bool? apiStatus,
    final HomeModel? homeM,
    final Function? scanReceipt,
    final Function? toReceiveToken,
    final Function? fillAddress,
    final Function? contactPiker,
    final void Function()? openDrawer,
    final void Function(int index)? onIndexChanged,
    final double iconSize = 24,
  }
) {
    
  return Padding(
    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
    child: ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      child: BottomAppBar(
        height: 80,
        color: isDarkMode ? hexaCodeToColor(AppColors.darkBgd) : hexaCodeToColor(AppColors.whiteHexaColor),
        // isDarkMode
        //   ? hexaCodeToColor(AppColors.darkBgd)
        //   : hexaCodeToColor(AppColors.whiteHexaColor),
        // shape: const CircularNotchedRectangle(),
        // notchMargin: 8.0,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: hexaCodeToColor("#E6E6E6")),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: Colors.white//hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.whiteColorHexa),
          ),
          height: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
    
              Expanded(
                child: myIconButton(
                  context,
                  title: "Discover",
                  txtColor: index == 0 ? isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor : isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor,
                  isActive: index == 0 ? true : false,
                  onPressed: () {
                    onIndexChanged!(0);
                  },
                  child: Icon(Iconsax.discover_1, size: iconSize, color: index == 0 ? hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor) : hexaCodeToColor(isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor))
                ),
              ),
              Expanded(
                child: myIconButton(
                  context,
                  title: "Wallet",
                  txtColor: index == 1 ? isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor : isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor,
                  isActive: index == 1 ? true : false,
                  onPressed: () {
                    onIndexChanged!(1);
                    // Navigator.push(context, RouteAnimation(enterPage: AssetsPage()));
                  },
                  child: Icon(Iconsax.wallet_check, size: iconSize, color: index == 1 ? hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor) : hexaCodeToColor(isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor))
                ),
              ),
              Expanded(
                child: myIconButton(
                  context,
                  title: "Home",
                  txtColor: index == 2 ? isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor : isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor,
                  isActive: index == 2 ? true : false,
                  onPressed: () {
                    // Navigator.push(context, RouteAnimation(enterPage: HomePage()));
                    onIndexChanged!(2);
                  },
                  child: Icon(Iconsax.home, size: iconSize, color: index == 2 ? hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor) : hexaCodeToColor(isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor))
                ),
              ),
              Expanded(
                child: myIconButton(
                  context,
                  title: "Event",
                  txtColor: index == 3 ? isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor : isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor,
                  onPressed: () {
                    onIndexChanged!(3);
                  },
                  child: Icon(Iconsax.calendar_1, size: iconSize, color: index == 3 ? hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor) : hexaCodeToColor(isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor))
                ),
              ),

              Expanded(
                child: myIconButton(
                  context,
                  title: "Settings",
                  txtColor: index == 4 ? isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor : isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor,
                  isActive: index == 4 ? true : false,
                  onPressed: () {
                    onIndexChanged!(4);
                  },
                  child: Icon(Iconsax.setting, size: iconSize, color: index == 4 ? hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor) : hexaCodeToColor(isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor))
                  // child: SvgPicture.asset("${AppConfig.iconsPath}nft_icon.svg", width: iconSize, color: index == 4 ? hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor) : hexaCodeToColor(isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor))//Icon(Iconsax.setting, size: iconSize, color: index == 4 ? hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor) : hexaCodeToColor(isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor))
                ),
              ),
    
            ],
          ),

        ),
      ),
    ),
  );
}
