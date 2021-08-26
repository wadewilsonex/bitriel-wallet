import 'package:fl_chart/fl_chart.dart';
import 'package:wallet_apps/index.dart';

class LineChartModel {

  final int divider = 5;

  final int leftLabelsCount = 6;

  List<FlSpot> values = [];

  double minX = 0;

  double maxX = 0;

  double minY = 0;

  double maxY = 0;

  double leftTitlesInterval = 0;

  String totalUsd = '';

  List<Color> gradientColors = [
    hexaCodeToColor(AppColors.secondary),
    hexaCodeToColor("#00ff6b")
  ];

  LineChartModel prepareCryptoData(SmartContractModel contract) {

    // print(contract.symbol);
    // if (contract.symbol == 'KGO'){
    //   print(contract.lineChartData);
    // }
    // print(contract.lineChartData);

    double minY = double.maxFinite;
    double maxY = double.minPositive;
    
    contract.lineChartModel.values.clear();

    // To Prevent Null Of Line Chart
    if (contract.lineChartData != null){
      contract.lineChartModel.values.addAll(
        contract.lineChartData.map((price) {
          if (minY > price.last) minY = price.last;
          if (maxY < price.last) maxY = price.last;

          return FlSpot(price.first, price.last);
        }).toList()
      );

      // if (contract.symbol == 'KGO'){
        // print(contract.lineChartModel.values);
      // }

      contract.lineChartModel.minX = contract.lineChartModel.values.first.x;
      contract.lineChartModel.maxX = contract.lineChartModel.values.last.x;
      contract.lineChartModel.minY = (minY / contract.lineChartModel.divider).floorToDouble() * contract.lineChartModel.divider;

      contract.lineChartModel.maxY = (maxY / contract.lineChartModel.divider).ceilToDouble() * contract.lineChartModel.divider;

      contract.lineChartModel.leftTitlesInterval = ((contract.lineChartModel.maxY - contract.lineChartModel.minY) / (contract.lineChartModel.leftLabelsCount - 1)).floorToDouble();

    }

    return contract.lineChartModel;
  }
}