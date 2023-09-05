import 'package:bitriel_wallet/index.dart';

LineChartData chart(
  List<FlSpot> spots,
  double minY,
  double maxY,
) {

  return LineChartData(
    borderData: FlBorderData(show: false),
    gridData: const FlGridData(show: false),
    titlesData: const FlTitlesData(show: false),
    lineTouchData: LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        tooltipBgColor: hexaCodeToColor("#00A478"),
        getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
          return touchedBarSpots.map((barSpot) {
            final flSpot = barSpot;
            return LineTooltipItem(
              flSpot.y
                .toStringAsFixed(2)
                .replaceFirst('.', ',')
                .replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.'),
              const TextStyle(
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
        color: Colors.green,
        spots: spots,
        isCurved: true,
        dotData: const FlDotData(show: false,),
      ),
    ],
  );

}
