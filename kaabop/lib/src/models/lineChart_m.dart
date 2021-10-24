import 'package:fl_chart/fl_chart.dart';
import 'package:wallet_apps/index.dart';

class LineChartModel {

  int divider = 5;

  int leftLabelsCount = 6;

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

  LineChartModel({
    this.divider,
    this.leftLabelsCount,
    this.values,
    this.minX,
    this.maxX,
    this.minY,
    this.maxY,
    this.leftTitlesInterval,
    this.totalUsd,
  });

  factory LineChartModel.fromJson(Map<String, dynamic> json){
    // print("json $json");
    // AppServices.jsonToFlList(json['value']);
    print("json['value'] ${json['value']}");
    // print("json['leftTitlesInterval'] ${json['leftTitlesInterval'].runtimeType}");
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

  static Map<String, dynamic> toJson(LineChartModel line) => {
    'divider': line.divider ?? 5.0,
    'leftLabelsCount': line.leftLabelsCount ?? 6.0,
    'value': line.values != null ? AppServices.flListToList(line.values) : [],
    'minX': line.minX,
    'maxX': line.maxX,
    'minY': line.minY,
    'maxY': line.maxY,
    'leftTitlesInterval': line.leftTitlesInterval ?? 0.0,
    'totalUsd': line.totalUsd ?? '',    
  };

  LineChartModel prepareGraphChart(SmartContractModel contract) {

    contract.lineChartModel = LineChartModel();
    contract.lineChartModel.values = [];
    try {

      // To Prevent Null Of Line Chart
      if (contract.lineChartList != null){

        double minY = double.maxFinite;
        double maxY = double.minPositive;

        contract.lineChartModel.values.addAll(
          contract.lineChartList.map((price) {
            if (minY > price.last) minY = price.last;
            if (maxY < price.last) maxY = price.last;

            return FlSpot(price.first, price.last);
          }).toList()
        );

        contract.lineChartModel.minX = contract.lineChartModel.values.first.x;

        contract.lineChartModel.maxX = contract.lineChartModel.values.last.x; 

        contract.lineChartModel.minY = (minY * (contract.lineChartModel.divider ?? 5)).floorToDouble() * (contract.lineChartModel.divider ?? 5);
 
        contract.lineChartModel.maxY = (maxY / (contract.lineChartModel.divider ?? 5)).ceilToDouble() * (contract.lineChartModel.divider ?? 5);

        contract.lineChartModel.leftTitlesInterval = ((contract.lineChartModel.maxY - contract.lineChartModel.minY) / ( (contract.lineChartModel.leftLabelsCount ?? 6) - 1)).floorToDouble();
      }
      print("prepareGraphChart ${contract.lineChartModel.leftTitlesInterval}");
    } catch (e) {
      print("Error prepareGraphChart $e");
    }

    return contract.lineChartModel;
  }
}
