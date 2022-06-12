import 'package:fl_chart/fl_chart.dart';
import 'package:wallet_apps/index.dart';

class LineChartModel {

  int divider;

  int leftLabelsCount;

  List<FlSpot>? values = [];

  double minX;

  double maxX;

  double minY;

  double maxY;

  double leftTitlesInterval;

  String? totalUsd;

  List<Color> gradientColors = [
    hexaCodeToColor(AppColors.secondary),
    hexaCodeToColor("#00ff6b")
  ];

  LineChartModel({
    this.divider = 5,
    this.leftLabelsCount = 6,
    this.values,
    this.minX = 0,
    this.maxX = 0,
    this.minY = 0,
    this.maxY = 0,
    this.leftTitlesInterval = 0,
    this.totalUsd,
  });

  factory LineChartModel.fromJson(Map<String, dynamic> json){
    return LineChartModel(
      divider: json['divider'].toInt() ?? 5,
      leftLabelsCount: json['leftLabelsCount'].toInt() ?? 6,
      values: json['value'] != [] ? AppServices.jsonToFlList(json['value']) : null,
      minX: json['minX'],
      maxX: json['maxX'],
      minY: json['minY'],
      maxY: json['maxY'],
      leftTitlesInterval: json['leftTitlesInterval'].toDouble() ?? 0.0,
      totalUsd: json['totalUsd']
    );
  }

  static Map<String, dynamic>? toJson(LineChartModel line) => {
    'divider': line.divider,
    'leftLabelsCount': line.leftLabelsCount,
    'value': line.values != null ? AppServices.flListToList(line.values!) : [],
    'minX': line.minX,
    'maxX': line.maxX,
    'minY': line.minY,
    'maxY': line.maxY,
    'leftTitlesInterval': line.leftTitlesInterval,
    'totalUsd': line.totalUsd ?? '',    
  };

  LineChartModel prepareGraphChart(SmartContractModel contract) {
    contract.lineChartModel = LineChartModel();
    contract.lineChartModel!.values = [];
    contract.lineChartModel!.divider = 5;
    
    try {

      // To Prevent Null Of Line Chart
      if (contract.lineChartList != null){

        double minY = double.maxFinite;
        double maxY = double.minPositive;

        contract.lineChartModel!.values!.addAll(
          contract.lineChartList!.map((price) {
            if (minY > price.last) minY = price.last;
            if (maxY < price.last) maxY = price.last;

            return FlSpot(price.first, price.last);
          }).toList()
        );

        contract.lineChartModel!.minX = contract.lineChartModel!.values!.first.x;

        contract.lineChartModel!.maxX = contract.lineChartModel!.values!.last.x;

        contract.lineChartModel!.minY = (minY / contract.lineChartModel!.divider) * contract.lineChartModel!.divider;//(minY * (contract.lineChartModel.divider ?? 5)).floorToDouble() * (contract.lineChartModel.divider ?? 5);
 
        contract.lineChartModel!.maxY = (maxY / contract.lineChartModel!.divider) * contract.lineChartModel!.divider;//(maxY / (contract.lineChartModel.divider ?? 5)).ceilToDouble() * (contract.lineChartModel.divider ?? 5);

        contract.lineChartModel!.leftTitlesInterval = ((contract.lineChartModel!.maxY - contract.lineChartModel!.minY) / (contract.lineChartModel!.leftLabelsCount - 1));//((contract.lineChartModel.maxY - contract.lineChartModel.minY) / ( (contract.lineChartModel.leftLabelsCount ?? 6) - 1)).floorToDouble();
      }
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error prepareGraphChart $e");
    }

    return contract.lineChartModel!;
  }
}
