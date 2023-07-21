import 'package:bitriel_wallet/index.dart';

class AssetsModel {
  String chain;
  String name;
  IconData icon;

  AssetsModel(this.chain, this.name, this.icon);
 
}


List<AssetsModel> elements = <AssetsModel>[

  AssetsModel("Native", 'Got to gym', Icons.fitness_center),
  AssetsModel("Native", 'Work', Icons.work),
  AssetsModel("BITCOIN", 'Buy groceries', Icons.shopping_basket),
  AssetsModel("Native", 'Cinema', Icons.movie),
  AssetsModel("Native", 'Eat', Icons.fastfood),
  AssetsModel("BINANCE (BSC)", 'Car wash', Icons.local_car_wash),
  AssetsModel("BINANCE (BSC)", 'Car wash', Icons.local_car_wash),
  AssetsModel("BINANCE (BSC)", 'Car wash', Icons.local_car_wash),
  AssetsModel("ETHEREUM", 'Car wash', Icons.local_car_wash),
  AssetsModel("ETHEREUM", 'Car wash', Icons.local_car_wash),
  AssetsModel("ETHEREUM", 'Car wash', Icons.local_car_wash),
  AssetsModel("ETHEREUM", 'Car wash', Icons.local_car_wash),
];