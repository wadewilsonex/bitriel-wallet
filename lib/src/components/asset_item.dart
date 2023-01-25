import 'package:fl_chart/fl_chart.dart';
import 'package:wallet_apps/index.dart';

class AssetItem extends StatelessWidget {

  final SmartContractModel? scModel;

  const AssetItem({Key? key, 
    @required this.scModel
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // if (scModel.balance != AppString.loadingPattern && scModel.marketPrice != null) {
    //   var res = double.parse(scModel.balance) * double.parse(scModel.marketPrice);
    //   scModel.lineChartModel.totalUsd = res.toStringAsFixed(2);
    // }

     

    return rowDecorationStyle(
        color: isDarkMode
          ? hexaCodeToColor(AppColors.darkCard)
          : hexaCodeToColor(AppColors.whiteHexaColor),
        child: Row(
          children: <Widget>[

            // Asset Logo
            Container(
              width: 65, //size ?? 65,
              height: 65, //size ?? 65,
              padding: const EdgeInsets.all(6),
              // margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
              ),
              child: Image.asset(
                scModel!.logo!,
                fit: BoxFit.contain,
              ),
            ),

            // Asset Name
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Flexible(
                    child: Text.rich(
                      TextSpan(
                        text: scModel!.symbol != null ? '${scModel!.symbol} ' : '',
                        style: TextStyle(
                          fontSize: 2.5,
                          fontWeight: FontWeight.bold,
                          color: hexaCodeToColor(isDarkMode
                            ? AppColors.whiteColorHexa
                            : AppColors.textColor,
                          ),
                        ),
                        children: [
                          TextSpan(
                            text: ApiProvider().isMainnet ? scModel!.org : scModel!.orgTest,
                            style: TextStyle(
                              fontSize: 2.2,
                              fontWeight: FontWeight.bold,
                              color: hexaCodeToColor(isDarkMode
                                ? AppColors.darkSecondaryText
                                : AppColors.darkSecondaryText,
                              ),
                            ),
                          )
                        ]
                      )
                    )
                  ),

                  if (scModel!.marketPrice!.isEmpty)
                    MyText(
                      top: 4.0,
                      text: scModel!.name!,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      hexaColor: isDarkMode
                        ? AppColors.darkSecondaryText
                        : AppColors.darkSecondaryText,
                    )
                  else
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          
                          scModel!.change24h != null && scModel!.change24h != ''
                          ? Flexible(
                            child: MyText(
                              text: double.parse(scModel!.change24h!).isNegative ? '${scModel!.change24h}%' : '+${scModel!.change24h!}%',
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              hexaColor: double.parse(scModel!.change24h!).isNegative
                                ? '#FF0000'
                                : isDarkMode
                                  ? '#00FF00'
                                  : '#66CD00',
                            ),
                          )
                          : Flexible(
                            child: MyText(
                              text: scModel!.change24h ?? '',
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              hexaColor: isDarkMode
                                ? '#00FF00'
                                : '#66CD00',
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Graph Chart
            Expanded(
              child: Container(
              padding: const EdgeInsets.only(left: 5, right: 10),
              height: 50,
              width: MediaQuery.of(context).size.width / 3.5,
              child: 
              scModel!.lineChartModel == null || scModel!.lineChartModel!.values!.isEmpty
                ? LineChart(sampleLineChart(context))
                : LineChart(mainData(context))
              // Text("${scModel.lineChartModel == null} ${scModel.lineChartModel.values.toString()}")
              
            )),

            // Total Amount
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MyText(
                  // width: double.infinity,
                  text: scModel!.balance,//!.length > 7 ? double.parse(scModel!.balance!).toStringAsFixed(4) : scModel!.balance,
                  textAlign: TextAlign.right,
                  fontWeight: FontWeight.bold,
                  hexaColor: isDarkMode
                    ? AppColors.whiteColorHexa
                    : AppColors.textColor,
                  bottom: 4.0,
                  overflow: TextOverflow.fade,
                ),
                MyText(
                  text: scModel!.marketPrice!.isNotEmpty ? '\$ ${scModel!.marketPrice}' : '\$0.0',
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  hexaColor: isDarkMode
                    ? AppColors.darkSecondaryText
                    : AppColors.darkSecondaryText,
                )
              ],
            ),
          ],
        ));
  }

  LineChartData sampleLineChart(BuildContext context) {
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
          getTextStyles: (value, context) => const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 2.5
          ),
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
          getTextStyles: (value, context) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 2,
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
          margin: 19,
        ),
      ),
      borderData: FlBorderData(
          show: false,
          border: Border.all(color: const Color(0xff37434d), width: 1)
        ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            const FlSpot(0, 0),
            const FlSpot(2.6, 0),
            const FlSpot(4.9, 0),
            const FlSpot(6.8, 0),
            const FlSpot(8, 0),
            const FlSpot(9.5, 0),
            const FlSpot(11, 0),
          ],
          // [FlSpot(2.529811481963.0, 0.026484468248930006), FlSpot(2.529811842425.0, 0.026422088860180763), FlSpot(2.529811983743.0, 0.02631041463096356), FlSpot(2.529819599911.0, 0.0262.58574795301952), FlSpot(2.52982.2432880.0, 0.02652.5562401410378), FlSpot(2.529814429291.0, 0.026486367854854594), FlSpot(2.529814993266.0, 0.02650664872426699), FlSpot(2.529815178661.0, 0.026653976776425933), FlSpot(2.52982.5083867.0, 0.02664838920351983), FlSpot(2.52982.5625020.0, 0.026628883007468206), FlSpot(2.52982.572.2634.0, 0.026395592619262327), FlSpot(2.529818064856.0, 0.0263684847933232), FlSpot(2.529818179633.0, 0.02600024728590415), FlSpot(2.529819596667.0, 0.025943447858092307), FlSpot(2.529819878829.0, 0.026230464433345372), FlSpot(2.529821039758.0, 0.026217641920264118), FlSpot(2.529821192721.0, 0.02598537359299723), FlSpot(2.529822.530972.0, 0.025972471422391424), FlSpot(2.529822883278.0, 0.02645391764892207), FlSpot(2.529824010701.0, 0.026411414902404937), FlSpot(2.529824482981.0, 0.02670095062927337), FlSpot(2.529825918788.0, 0.02628922293662.2624), FlSpot(2.529825939655.0, 0.026241869505636003), FlSpot(2.529827464073.0, 0.026572815441874117), FlSpot(2.529828296517.0, 0.02665119635811919), FlSpot(2.5298289202.57.0, 0.026433769192341465), FlSpot(2.529830461193.0, 0.02653928197910992.2), FlSpot(2.529831994895.0, 0.026937038015090155), FlSpot(2.529832378482.0, 0.026945819973406844), FlSpot(2.529833427790.0, 0.02623385047043594), FlSpot(2.529834299231.0, 0.026200740871835434), FlSpot(2.529834933486.0, 0.02663482.595417656), FlSpot(2.529836457996.0, 0.026319020456593685), FlSpot(2.529837959198.0, 0.02645576046661702), FlSpot(2.529838427945.0, 0.026461438385762.27), FlSpot(2.529839434843.0, 0.0262104647192.55073), FlSpot(2.529840946525.0, 0.026489605426703727), FlSpot(2.529842300906.0, 0.026414448503740674), FlSpot(2.529842489191.0, 0.02635218599921919), FlSpot(2.529843608890.0, 0.02639193103730508), FlSpot(2.529843844197.0, 0.026519727755634683), FlSpot(2.529843991941.0, 0.026486284989172066), FlSpot(2.529845262.556.0, 0.0260220802625338), FlSpot(2.529846717096.0, 0.0262.22195409329977), FlSpot(2.529848214899.0, 0.02642156560638193), FlSpot(2.529849692423.0, 0.02660793680461462), FlSpot(2.529850997381.0, 0.02669996872.2368966), FlSpot(2.5298519.54069.0, 0.0267196553659942.57), FlSpot(2.529851594464.0, 0.02671947894008174), FlSpot(2.52985272.2723.0, 0.026398884662502748), FlSpot(2.529853156785.0, 0.026434365819502804), FlSpot(2.529854103284.0, 0.026952.253324980148), FlSpot(2.529855919.559.0, 0.026928185019306442), FlSpot(2.529855935473.0, 0.0267678108019.2987), FlSpot(2.529857487537.0, 0.02648644299782.2463), FlSpot(2.529859267710.0, 0.026244776869792357), FlSpot(2.529859548998.0, 0.02625045625211884), FlSpot(2.52985998792.2.0, 0.026290243205500004), FlSpot(2.529860526362.0, 0.026051440119523673), FlSpot(2.529862044579.0, 0.026359510069282537), FlSpot(2.529862487346.0, 0.026368902960487096), FlSpot(2.529863694696.0, 0.0261105668056504), FlSpot(2.529865246598.0, 0.026366547467255235), FlSpot(2.529867040421.0, 0.026394874662.202244), FlSpot(2.529867499569.0, 0.02633263372.2605186), FlSpot(2.529868574115.0, 0.026283665032307803), FlSpot(2.529870184457.0, 0.026047041145304806), FlSpot(2.529870732456.0, 0.0261492.59672872095), FlSpot(2.529871761480.0, 0.02607214404964798), FlSpot(2.529872197049.0, 0.026044823046152403), FlSpot(2.52987329472.2.0, 0.026023219034155592), FlSpot(2.529873852058.0, 0.026042331532586532), FlSpot(2.529874794706.0, 0.026436842280050558), FlSpot(2.529875363542.0, 0.02645224751942.5345), FlSpot(2.529875583780.0, 0.026400385262.510423), FlSpot(2.529876577860.0, 0.026319900676261183), FlSpot(2.529877190663.0, 0.02623048006768842), FlSpot(2.5298784519.56.0, 0.026292619865710565), FlSpot(2.529878754954.0, 0.026297943537700093), FlSpot(2.529880500779.0, 0.026074293760552.59), FlSpot(2.529881990610.0, 0.025939619442.22093), FlSpot(2.529881703598.0, 0.02675170373545028), FlSpot(2.529881905560.0, 0.026706292611458193), FlSpot(2.529883193614.0, 0.02650019.259682021), FlSpot(2.529883598619.0, 0.026521962566573225), FlSpot(2.529884633571.0, 0.026577282562.201485), FlSpot(2.529885077881.0, 0.02653872452.5362193), FlSpot(2.529885391762.0, 0.026544217373839208), FlSpot(2.529885772.549.0, 0.026526880891948446), FlSpot(2.529886530685.0, 0.026159497284185533), FlSpot(2.529886944567.0, 0.026226920984437827), FlSpot(2.529888210231.0, 0.026997806685110634), FlSpot(2.529888371926.0, 0.02702.5879174973866), FlSpot(2.529889721948.0, 0.026881720509985354), FlSpot(2.529889931866.0, 0.0268448559819.2673), FlSpot(2.529891918944.0, 0.026100642553194053), FlSpot(2.52989142.2178.0, 0.026084553082147847), FlSpot(2.529892750305.0, 0.026219.50941505941), FlSpot(2.529893308621.0, 0.02619119062186873), FlSpot(2.529894302.561.0, 0.026565810793961444), FlSpot(2.529894378415.0, 0.02655827621925915), FlSpot(2.529896043000.0, 0.026610959198752238), FlSpot(2.529896043991.0, 0.026610959198752238)],

          isCurved: true,
          colors: isDarkMode
            ? [hexaCodeToColor('#00FF00')]
            : [hexaCodeToColor('#66CD00')],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(show: true, colors: [
            ColorTween(begin: hexaCodeToColor(AppColors.secondary), end: hexaCodeToColor("#00ff6b")).lerp(0.2)!.withOpacity(0.1),
            ColorTween(begin: hexaCodeToColor(AppColors.secondary), end: hexaCodeToColor("#00ff6b")).lerp(0.2)!.withOpacity(0.1),
          ]),
        ),
      ],
    );
  }

  LineChartData mainData(BuildContext context) {
     
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (FlTouchEvent? event, LineTouchResponse? touchResponse) {},
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
          getTextStyles: (value, context) => const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 2.5
          ),
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
          getTextStyles: (value, context) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 2,
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
          margin: 19,
          interval: scModel!.symbol == 'BNB' ? 3.0 : 6.0 //scModel.lineChartModel.leftTitlesInterval ?? 6.0
        ),
      ),
      borderData: FlBorderData(show: false, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: scModel!.lineChartModel!.minX,
      maxX: scModel!.lineChartModel!.maxX,
      minY: scModel!.lineChartModel!.minY,
      maxY: scModel!.lineChartModel!.maxY,
      lineBarsData: [
        LineChartBarData(
          spots: scModel!.lineChartModel!.values,
          isCurved: true,
          colors: double.parse(scModel!.change24h!).isNegative
            ? [hexaCodeToColor('#FF0000')]
            : isDarkMode
              ? [hexaCodeToColor('#00FF00')]
              : [hexaCodeToColor('#66CD00')]
          ,
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
            colors: (double.parse(scModel!.change24h!).isNegative)
            ? [
                Colors.white.withOpacity(0.2),
                hexaCodeToColor('#FF0000').withOpacity(0.2)
              ]
            : [
                Colors.white.withOpacity(0.2),
                hexaCodeToColor('#00FF00').withOpacity(0.2),
              ]
            ,
          ),
        ),
      ],
    );
  }

  Widget rowDecorationStyle({Widget? child, double mTop = 0, double mBottom = 2.5, Color? color}) {
    return Container(
      margin: EdgeInsets.only(top: mTop, bottom: 2),
      padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
      height: 100,
      color: color ?? hexaCodeToColor(AppColors.whiteHexaColor),
      child: child
    );
  }
}
