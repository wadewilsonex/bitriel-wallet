import 'package:wallet_apps/index.dart';

class SwapTokenListModel {

  bool? isActive = false;
  String? title = '';
  String? subtitle = '';
  String? balance = '';
  String? network = '';
  Widget? image;
  
  SwapTokenListModel({this.image, this.title, this.subtitle, this.balance, this.network, this.isActive});
}