import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/lineChart_m.dart';

class AssetItem extends StatelessWidget {
  final String asset;
  final String tokenSymbol;
  final String org;
  final String balance;
  final String marketPrice;
  final String priceChange24h;
  final Color color;
  final double size;
  final List<List<double>> lineChartData;
  final Function prepareLineData;
  final LineChartModel lineChartModel;

  AssetItem(this.asset, this.tokenSymbol, this.org, this.balance, this.color,
      {this.marketPrice,
      this.priceChange24h,
      this.size,
      this.lineChartData,
      this.prepareLineData,
      this.lineChartModel});

  @override
  Widget build(BuildContext context) {
    // if (balance != AppString.loadingPattern && marketPrice != null) {
    //   var res = double.parse(balance ?? '0') * double.parse(marketPrice ?? '0');
    //   lineChartModel.totalUsd = res.toStringAsFixed(2);
    // }

    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;

    // print("Hello $tokenSymbol");
    // if (tokenSymbol == "BTC") print("Hello ${lineChartModel.values ?? 0}");
    // if (tokenSymbol == "BNB") print("Hello ${lineChartModel.values ?? 0}");
    // if (tokenSymbol == "ETH") print("Hello ${lineChartModel.values.length ?? 0}");

    return rowDecorationStyle(
        color: isDarkTheme
            ? hexaCodeToColor(AppColors.darkCard)
            : hexaCodeToColor(AppColors.whiteHexaColor),
        child: Row(
          children: <Widget>[
            // Asset Logo
            Container(
              width: 65, //size ?? 65,
              height: 65, //size ?? 65,
              padding: const EdgeInsets.all(6),
              margin: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
              ),
              child: Image.asset(
                asset,
                fit: BoxFit.contain,
              ),
            ),

            // Asset Name
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: tokenSymbol,
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme
                        ? AppColors.whiteColorHexa
                        : AppColors.textColor,
                    bottom: 4.0,
                  ),
                  if (marketPrice == null)
                    if (org == '')
                      Container()
                    else
                      MyText(
                        text: org,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDarkTheme
                            ? AppColors.darkSecondaryText
                            : AppColors.darkSecondaryText,
                      )
                  else
                    Row(
                      children: [
                        
                        tokenSymbol == "KGO"
                            ? MyText(
                                text: "\$ $marketPrice",
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isDarkTheme
                                    ? AppColors.darkSecondaryText
                                    : AppColors.darkSecondaryText,
                              )
                            : MyText(
                                text: marketPrice != null ? '\$ $marketPrice' : '',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isDarkTheme
                                    ? AppColors.darkSecondaryText
                                    : AppColors.darkSecondaryText,
                              ),
                        const SizedBox(width: 6.0),
                        MyText(
                          text: priceChange24h != null ? priceChange24h.substring(0, 1) == '-'
                              ?  '$priceChange24h%'
                              : '+$priceChange24h%' 
                            : '',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color:  priceChange24h != null ? priceChange24h.substring(0, 1) == '-'
                              ? '#FF0000'
                              : isDarkTheme
                                  ? '#00FF00'
                                  : '#66CD00' 
                            : '#00FF00',
                        ),
                      ],
                    ),
                ],
              ),
            ),

            // Graph Chart
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.16,
                child: lineChartData == null ||
                        lineChartModel.leftTitlesInterval == 0
                    ? LineChart(avgData(context))
                    : LineChart(mainData(context)),
              ),
            ),

            // Total Amount
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      width: double.infinity,
                      text: balance ?? '0',
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.right,
                      color: isDarkTheme
                          ? AppColors.whiteColorHexa
                          : AppColors.textColor,
                      bottom: 4.0,
                    ),
                    MyText(
                      width: double.infinity,
                      text: balance != AppString.loadingPattern &&
                              marketPrice != null
                          ? '\$${lineChartModel.totalUsd}'
                          : '\$0.00',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      color: isDarkTheme
                          ? AppColors.darkSecondaryText
                          : AppColors.darkSecondaryText,
                    )
                  ],
                ),
              ),

              //
            ),
          ],
        ));
  }

  LineChartData avgData(BuildContext context) {
    final isDarkTheme =
        Provider.of<ThemeProvider>(context, listen: false).isDark;
    // print(lineChartModel.values.length);
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: false,
        drawHorizontalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: false,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: false,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 0),
            FlSpot(2.6, 0),
            FlSpot(4.9, 0),
            FlSpot(6.8, 0),
            FlSpot(8, 0),
            FlSpot(9.5, 0),
            FlSpot(11, 0),
          ],
          // [FlSpot(1629811481263.0, 0.026484468248930006), FlSpot(1629811842425.0, 0.026422088860180763), FlSpot(1629811983743.0, 0.02631041463096356), FlSpot(1629812599911.0, 0.026168574795301252), FlSpot(1629813432880.0, 0.026516562401410378), FlSpot(1629814429291.0, 0.026486367854854594), FlSpot(1629814993266.0, 0.02650664872426699), FlSpot(1629815178661.0, 0.026653976776425933), FlSpot(1629816083867.0, 0.02664838920351283), FlSpot(1629816625020.0, 0.026628883007468206), FlSpot(1629816713634.0, 0.026395592612262327), FlSpot(1629818064856.0, 0.0263684847933232), FlSpot(1629818179633.0, 0.02600024728590415), FlSpot(1629819596667.0, 0.025943447858092307), FlSpot(1629819878829.0, 0.026230464433345372), FlSpot(1629821039758.0, 0.026217641920264118), FlSpot(1629821192721.0, 0.02598537359299723), FlSpot(1629821630972.0, 0.025972471422391424), FlSpot(1629822883278.0, 0.02645391764892207), FlSpot(1629824010701.0, 0.026411414902404937), FlSpot(1629824482981.0, 0.02670095062927337), FlSpot(1629825918788.0, 0.026289222936613624), FlSpot(1629825939655.0, 0.026241869505636003), FlSpot(1629827464073.0, 0.026572815441874117), FlSpot(1629828296517.0, 0.02665112635811219), FlSpot(1629828920167.0, 0.026433769192341465), FlSpot(1629830461123.0, 0.026539281979109913), FlSpot(1629831994895.0, 0.026937038015090155), FlSpot(1629832378482.0, 0.026945819973406844), FlSpot(1629833427790.0, 0.02623385047043594), FlSpot(1629834299231.0, 0.026200740871835434), FlSpot(1629834933486.0, 0.02663481695417656), FlSpot(1629836457996.0, 0.026312020456593685), FlSpot(1629837959128.0, 0.02645576046661702), FlSpot(1629838427945.0, 0.02646143838576137), FlSpot(1629839434843.0, 0.026210464712165073), FlSpot(1629840946525.0, 0.026489605426703727), FlSpot(1629842300906.0, 0.026414448503740674), FlSpot(1629842489191.0, 0.02635218599921919), FlSpot(1629843608890.0, 0.02639193103730508), FlSpot(1629843844197.0, 0.026519727755634683), FlSpot(1629843991941.0, 0.026486284989172066), FlSpot(1629845261656.0, 0.0260220802625338), FlSpot(1629846717096.0, 0.026132195409329977), FlSpot(1629848214899.0, 0.02642156560638123), FlSpot(1629849692423.0, 0.02660793680461462), FlSpot(1629850997381.0, 0.026699968713368966), FlSpot(1629851164069.0, 0.026719655365994167), FlSpot(1629851594464.0, 0.02671947894008174), FlSpot(1629852713723.0, 0.026398884662502748), FlSpot(1629853156785.0, 0.026434365819502804), FlSpot(1629854103284.0, 0.026951353324980148), FlSpot(1629855911659.0, 0.026928185019306442), FlSpot(1629855935473.0, 0.02676781080113987), FlSpot(1629857487537.0, 0.026486442997813463), FlSpot(1629859267710.0, 0.026244776869792357), FlSpot(1629859548998.0, 0.02625045625211884), FlSpot(1629859987913.0, 0.026290243205500004), FlSpot(1629860526362.0, 0.026051440112523673), FlSpot(1629862044579.0, 0.026359510069282537), FlSpot(1629862487346.0, 0.026368902960487096), FlSpot(1629863694696.0, 0.0261105668056504), FlSpot(1629865246598.0, 0.026366547467255235), FlSpot(1629867040421.0, 0.026394874661302244), FlSpot(1629867499569.0, 0.026332633713605186), FlSpot(1629868574115.0, 0.026283665032307803), FlSpot(1629870184457.0, 0.026047041145304806), FlSpot(1629870732456.0, 0.026149169672872095), FlSpot(1629871761480.0, 0.02607214404964798), FlSpot(1629872197049.0, 0.026044823046152403), FlSpot(1629873294713.0, 0.026023219034155592), FlSpot(1629873852058.0, 0.026042331532586532), FlSpot(1629874794706.0, 0.026436842280050558), FlSpot(1629875363542.0, 0.026452247519416345), FlSpot(1629875583780.0, 0.026400385261610423), FlSpot(1629876577860.0, 0.026319900676261183), FlSpot(1629877190663.0, 0.02623048006768842), FlSpot(1629878451166.0, 0.026292619865710565), FlSpot(1629878754954.0, 0.026297943537700093), FlSpot(1629880500779.0, 0.02607429376055169), FlSpot(1629881290610.0, 0.02593961244132093), FlSpot(1629881703598.0, 0.02675170373545028), FlSpot(1629881905560.0, 0.026706292611458193), FlSpot(1629883123614.0, 0.02650011359682021), FlSpot(1629883598619.0, 0.026521962566573225), FlSpot(1629884633571.0, 0.026577282561301485), FlSpot(1629885077881.0, 0.026538724516362123), FlSpot(1629885391762.0, 0.026544217373839208), FlSpot(1629885771649.0, 0.026526880891248446), FlSpot(1629886530685.0, 0.026159497284185533), FlSpot(1629886944567.0, 0.026226920984437827), FlSpot(1629888210231.0, 0.026997806685110634), FlSpot(1629888371926.0, 0.027016879174973866), FlSpot(1629889721948.0, 0.026881720509985354), FlSpot(1629889931866.0, 0.02684485598113673), FlSpot(1629891218944.0, 0.026100642553194053), FlSpot(1629891413178.0, 0.026084553082147847), FlSpot(1629892750305.0, 0.02621160941505941), FlSpot(1629893308621.0, 0.02619112062186873), FlSpot(1629894301661.0, 0.026565810793961444), FlSpot(1629894378415.0, 0.02655827621925915), FlSpot(1629896043000.0, 0.026610959128752238), FlSpot(1629896043991.0, 0.026610959128752238)],

          isCurved: true,
          colors: isDarkTheme
              ? [hexaCodeToColor('#00FF00')]
              : [hexaCodeToColor('#66CD00')],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(show: true, colors: [
            ColorTween(
                    begin: hexaCodeToColor(AppColors.secondary),
                    end: hexaCodeToColor("#00ff6b"))
                .lerp(0.2)
                .withOpacity(0.1),
            ColorTween(
                    begin: hexaCodeToColor(AppColors.secondary),
                    end: hexaCodeToColor("#00ff6b"))
                .lerp(0.2)
                .withOpacity(0.1),
          ]),
        ),
      ],
    );
  }

  LineChartData mainData(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: false,
      ),
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: false,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
            showTitles: false,
            getTextStyles: (value) => const TextStyle(
                  color: Color(0xff67727d),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
            getTitles: (value) {
              switch (value.toInt()) {
                case 1:
                  return '10k';
                case 3:
                  return '30k';
                case 5:
                  return '50k';
              }
              return '';
            },
            reservedSize: 28,
            margin: 12,
            interval: lineChartModel.leftTitlesInterval),
      ),
      borderData: FlBorderData(
          show: false,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: lineChartModel.minX,
      maxX: lineChartModel.maxX,
      minY: lineChartModel.minY,
      maxY: lineChartModel.maxY,
      lineBarsData: [
        LineChartBarData(
          spots: lineChartModel.values,
          isCurved: true,
          colors: priceChange24h.substring(0, 1) == '-'
              ? [hexaCodeToColor('#FF0000')]
              : isDarkTheme
                  ? [hexaCodeToColor('#00FF00')]
                  : [hexaCodeToColor('#66CD00')],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            //gradientColorStops: const [0.25, 0.5, 0.75],
            gradientFrom: const Offset(0.2, 1.2),
            gradientTo: const Offset(0.2, 0),
            colors: priceChange24h.substring(0, 1) == '-'
                ? [
                    Colors.white.withOpacity(0.2),
                    hexaCodeToColor('#FF0000').withOpacity(0.2)
                  ]
                : [
                    Colors.white.withOpacity(0.2),
                    hexaCodeToColor('#00FF00').withOpacity(0.2),
                  ],
            // colors:
            //     _gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  Widget rowDecorationStyle(
      {Widget child, double mTop = 0, double mBottom = 16, Color color}) {
    return Container(
        margin: EdgeInsets.only(top: mTop, bottom: 2),
        padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
        height: 100,
        color: color ?? hexaCodeToColor(AppColors.whiteHexaColor),
        child: child);
  }
}
