import 'package:pie_chart/pie_chart.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/presentation/components/portfolio_c.dart';

class PortFolioCus extends StatelessWidget {
  const PortFolioCus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     
    return Container(
      margin: const EdgeInsets.only(bottom: 2.0),
      padding: const EdgeInsets.only(left: 16, right: 20, top: 32, bottom: 32),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: isDarkMode
          ? hexaCodeToColor(AppColors.darkCard)
          : hexaCodeToColor(AppColors.whiteHexaColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          Expanded(
            child: Align(
              child: SizedBox(
                width: 140,
                height: 140,
                child: Consumer<WalletProvider>(
                  builder: (context, value, child) {
                    return value.dataMap.isEmpty
                      ? PieChart(
                        ringStrokeWidth: 15,
                        dataMap: const {'SEL': 100},
                        chartType: ChartType.ring,
                        //colorList: value.pieColorList,
                        centerText: "0%",
                        legendOptions: const LegendOptions(
                          showLegends: false,
                        ),
                        colorList: [
                          isDarkMode ? hexaCodeToColor(AppColors.darkBgd) : Colors.grey.shade400
                        ],
                        chartValuesOptions: ChartValuesOptions(
                          showChartValues: false,
                          showChartValueBackground: false,
                          chartValueStyle: TextStyle(
                            color: hexaCodeToColor(isDarkMode ? "#FFFFFF" : "#000000"),
                            fontSize: 16,
                          ),
                        ),
                      )
                      : PieChart(
                        ringStrokeWidth: 15,
                        dataMap: value.dataMap,
                        chartType: ChartType.ring,
                        colorList: value.pieColorList,
                        centerText: "100%",
                        legendOptions: const LegendOptions(
                          showLegends: false,
                        ),
                        chartValuesOptions: ChartValuesOptions(
                          showChartValues: false,
                          showChartValueBackground: false,
                          chartValueStyle: TextStyle(
                            color: hexaCodeToColor(isDarkMode ? "#FFFFFF" : "#000000"),
                            fontSize: 16,
                          ),
                        ),
                      );
                  },
                ),
              ),
            ),
          ),

          Expanded(
            child: Consumer<WalletProvider>(
              builder: (context, value, child) {
                return value.portfolio.isEmpty
                ? const Center(
                  child: MyText(
                    text: "Market Price...",
                    fontWeight: FontWeight.bold,
                    hexaColor: AppColors.darkSecondaryText,
                  ),
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(value.portfolio.length, (index) {
                    return MyPieChartRow(
                      color: value.portfolio[index].color,
                      centerText: value.portfolio[index].symbol,
                      endText: value.portfolio[index].percentage,
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
