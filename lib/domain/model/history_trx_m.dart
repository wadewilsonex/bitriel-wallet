import 'package:bitriel_wallet/index.dart';

class HistoryTrxModel {
  String chain;
  String name;
  IconData icon;

  HistoryTrxModel(this.chain, this.name, this.icon);
 
}


List<HistoryTrxModel> elements = <HistoryTrxModel>[

  HistoryTrxModel("Native", 'Got to gym', Icons.fitness_center),
  HistoryTrxModel("Native", 'Work', Icons.work),
  HistoryTrxModel("BITCOIN", 'Buy groceries', Icons.shopping_basket),
  HistoryTrxModel("Native", 'Cinema', Icons.movie),
  HistoryTrxModel("Native", 'Eat', Icons.fastfood),
  HistoryTrxModel("BINANCE (BSC)", 'Car wash', Icons.local_car_wash),
  HistoryTrxModel("BINANCE (BSC)", 'Car wash', Icons.local_car_wash),
  HistoryTrxModel("BINANCE (BSC)", 'Car wash', Icons.local_car_wash),
  HistoryTrxModel("ETHEREUM", 'Car wash', Icons.local_car_wash),
  HistoryTrxModel("ETHEREUM", 'Car wash', Icons.local_car_wash),
  HistoryTrxModel("ETHEREUM", 'Car wash', Icons.local_car_wash),
  HistoryTrxModel("ETHEREUM", 'Car wash', Icons.local_car_wash),
];