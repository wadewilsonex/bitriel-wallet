import 'package:flutter/material.dart';

class AssetsModel {
  String chain;
  String name;
  IconData icon;

  AssetsModel(this.chain, this.name, this.icon);

}


  List<AssetsModel> elements = <AssetsModel>[
    AssetsModel("SELENDRA", 'Got to gym', Icons.fitness_center),
    AssetsModel("SELENDRA", 'Work', Icons.work),
    AssetsModel("BITCOIN", 'Buy groceries', Icons.shopping_basket),
    AssetsModel("SELENDRA", 'Cinema', Icons.movie),
    AssetsModel("SELENDRA", 'Eat', Icons.fastfood),
    AssetsModel("BINANCE (BSC)", 'Car wash', Icons.local_car_wash),
    AssetsModel("BINANCE (BSC)", 'Car wash', Icons.local_car_wash),
    AssetsModel("BINANCE (BSC)", 'Car wash', Icons.local_car_wash),
    AssetsModel("SELENDRA", 'Car wash', Icons.local_car_wash),
    AssetsModel("SELENDRA", 'Car wash', Icons.local_car_wash),
    AssetsModel("ETHEREUM", 'Car wash', Icons.local_car_wash),
    AssetsModel("ETHEREUM", 'Car wash', Icons.local_car_wash),
    AssetsModel("ETHEREUM", 'Car wash', Icons.local_car_wash),
    AssetsModel("ETHEREUM", 'Car wash', Icons.local_car_wash),
  ];