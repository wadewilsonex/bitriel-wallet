import 'package:fl_chart/fl_chart.dart';
import 'package:wallet_apps/index.dart';

LineChartData chart(
  List<FlSpot> spots,
  double minY,
  double maxY,
) {

  List<Color> gradientColors = [
    hexaCodeToColor(AppColors.primaryColor),
    hexaCodeToColor(AppColors.secondary),
  ];

  return LineChartData(
    borderData: FlBorderData(show: false),
    gridData: FlGridData(show: false),
    titlesData: FlTitlesData(show: false),
    lineTouchData: LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: hexaCodeToColor(AppColors.primaryColor),
        getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
          return touchedBarSpots.map((barSpot) {
            final flSpot = barSpot;
            return LineTooltipItem(
              flSpot.y
                .toStringAsFixed(3)
                .replaceFirst('.', ',')
                .replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.'),
              TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            );
          }).toList();
        }
      ),
    ),
    minX: 0,
    maxX: 6,
    minY: minY,
    maxY: maxY,
    lineBarsData: [
      LineChartBarData(
        spots: spots,
        isCurved: true,
        colors: gradientColors,
        barWidth: 2,
        dotData: FlDotData(show: false,),
        belowBarData: BarAreaData(
          show: true,
          gradientFrom: const Offset(0, 0),
          gradientTo: const Offset(0, 1),
          colors: [
            hexaCodeToColor(AppColors.primaryColor).withOpacity(0.1),
            hexaCodeToColor(AppColors.primaryColor).withOpacity(0),
          ]
        ),
      ),
    ],
  );

}
