import 'package:fl_chart/fl_chart.dart';
import 'package:wallet_apps/index.dart';

class PieChartSample1 extends StatefulWidget {
  const PieChartSample1({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChartSample1State();
}

class PieChartSample1State extends State {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Consumer<ContractProvider>(
      builder: (context, provider, widget){
        return AspectRatio(
          aspectRatio: 1.3,
          child: Card(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 28,
                ),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(touchCallback:
                            (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        }),
                        startDegreeOffset: 180,
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 1,
                        centerSpaceRadius: 0,
                        sections: showingSections(provider)
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<PieChartSectionData> showingSections(ContractProvider provider) {
    return List.generate(
      4,
      (i) {
        final isTouched = i == touchedIndex;
        final opacity = isTouched ? 1.0 : 0.6;

        const color0 = Color(0xff0293ee);
        const color1 = Color(0xfff8b250);
        const color2 = Color(0xff845bef);
        const color3 = Color(0xff13d38e);

        switch (i) {
          case 0:
            return PieChartSectionData(
              color: color0.withOpacity(opacity),
              value: double.parse(provider.sortListContract[i].balance!),
              title: provider.sortListContract[i].symbol!,
              radius: 80,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff044d7c)),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? BorderSide(color: color0, width: 6)
                  : BorderSide(color: color0.withOpacity(0)),
            );
          case 1:
            return PieChartSectionData(
              color: color1.withOpacity(opacity),
              value: double.parse(provider.sortListContract[i].balance!),
              title: provider.sortListContract[i].symbol!,
              radius: 65,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff90672d)),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? BorderSide(color: color1, width: 6)
                  : BorderSide(color: color2.withOpacity(0)),
            );
          case 2:
            return PieChartSectionData(
              color: color2.withOpacity(opacity),
              value: double.parse(provider.sortListContract[i].balance!),
              title: provider.sortListContract[i].symbol!,
              radius: 60,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff4c3788)),
              titlePositionPercentageOffset: 0.6,
              borderSide: isTouched
                  ? BorderSide(color: color2, width: 6)
                  : BorderSide(color: color2.withOpacity(0)),
            );
          case 3:
            return PieChartSectionData(
              color: color3.withOpacity(opacity),
              value: double.parse(provider.sortListContract[i].balance!),
              title: provider.sortListContract[i].symbol!,
              radius: 70,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0c7f55)),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? BorderSide(color: color3, width: 6)
                  : BorderSide(color: color2.withOpacity(0)),
            );
          default:
            throw Error();
        }
      },
    );
  }
}

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
      padding: EdgeInsets.symmetric(horizontal: paddingSize*2),
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
             fontWeight: FontWeight.bold, color: AppColors.whiteColorHexa
          )
        ],
      ),
    );
  }
}

class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State {
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
                boxShadow: [
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
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: hexaCodeToColor(AppColors.darkBgd),
                  text: provider.sortListContract[1].symbol!,
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: hexaCodeToColor("#FFC154"),
                  text: provider.sortListContract[2].symbol!,
                  isSquare: true,
                ),
                SizedBox(
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


class PieChartSample3 extends StatefulWidget {
  const PieChartSample3({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChartSample3State();
}

class PieChartSample3State extends State {
  int touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: Colors.white,
        child: AspectRatio(
          aspectRatio: 1,
          child: PieChart(
            PieChartData(
                pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                }),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 0,
                sections: showingSections()),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              'assets/logo/bitriel-logo-v2.svg',
              size: widgetSize,
              borderColor: const Color(0xff0293ee),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              'assets/logo/bitriel-logo-v2.svg',
              size: widgetSize,
              borderColor: const Color(0xfff8b250),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: 16,
            title: '16%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              'assets/logo/bitriel-logo-v2.svg',
              size: widgetSize,
              borderColor: const Color(0xff845bef),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              'assets/logo/bitriel-logo-v2.svg',
              size: widgetSize,
              borderColor: const Color(0xff13d38e),
            ),
            badgePositionPercentageOffset: .98,
          );
        default:
          throw 'Oh no';
      }
    });
  }
}

class _Badge extends StatelessWidget {
  final String svgAsset;
  final double size;
  final Color borderColor;

  const _Badge(
    this.svgAsset, {
    Key? key,
    required this.size,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: SvgPicture.asset(
          svgAsset,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}