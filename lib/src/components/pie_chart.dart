import 'package:fl_chart/fl_chart.dart';
import 'package:wallet_apps/index.dart';

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 5,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: paddingSize*2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: size.w,
            height: size.w,
            decoration: BoxDecoration(
              shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
              color: color,
            ),
          ),
          SizedBox(
            width: 2.w,
          ),
          MyText(
            text: text,
            fontWeight: FontWeight.bold, hexaColor: AppColors.whiteColorHexa
          )
        ],
      ),
    );
  }
}

class ChartData extends StatefulWidget {
  const ChartData({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChartDataState();
}

class ChartDataState extends State {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Consumer<ContractProvider>(
      builder: (context, provider, widget){
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            Container(
              height: 10.h,
              decoration: BoxDecoration(
                color: hexaCodeToColor(AppColors.bluebgColor),
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(color: Colors.white, blurRadius: 20.0),
                ],
              ),
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  }),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 20,
                  sections: showingSections(provider)
                ),
              ),
            ),

            SizedBox(
              height: 5.h,
            ),
      
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Indicator(
                  color: hexaCodeToColor(AppColors.orangeColor),
                  text: provider.sortListContract[0].symbol!,
                  isSquare: true,
                ),
                const SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: hexaCodeToColor(AppColors.darkBgd),
                  text: provider.sortListContract[1].symbol!,
                  isSquare: true,
                ),
                const SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: hexaCodeToColor("#FFC154"),
                  text: provider.sortListContract[2].symbol!,
                  isSquare: true,
                ),
                const SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: hexaCodeToColor("#47B39C"),
                  text: provider.sortListContract[3].symbol!,
                  isSquare: true,
                ),
              ],
            ),
          ],
        );
      }
    );
  }

  List<PieChartSectionData> showingSections(ContractProvider provider) {

    return List.generate(4, (i) {
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: hexaCodeToColor(AppColors.orangeColor),
            // value: 100,
            value: double.parse(provider.sortListContract[0].balance!.replaceAll(",", "")),
            showTitle: false,
          );
        case 1:
          return PieChartSectionData(
            color: hexaCodeToColor(AppColors.darkBgd),
            value: double.parse(provider.sortListContract[1].balance!.replaceAll(",", "")),
            showTitle: false,
          );
        case 2:
          return PieChartSectionData(
            color: hexaCodeToColor("#FFC154"),
            value: double.parse(provider.sortListContract[2].balance!.replaceAll(",", "")),
            showTitle: false,
          );
        case 3:
          return PieChartSectionData(
            color: hexaCodeToColor("#47B39C"),
            value: double.parse(provider.sortListContract[3].balance!.replaceAll(",", "")),
            showTitle: false,
          );
        default:
          throw Error();
      }
    });
  }
}