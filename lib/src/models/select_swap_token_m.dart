
import 'package:wallet_apps/src/components/select_swap_token_c.dart';
import 'package:wallet_apps/index.dart';

class SwapTokenListModel {

  bool? isActive = false;
  String? title = '';
  String? subtitle = '';
  String? balance = '';
  Image? image;
  
  
  SwapTokenListModel({this.image, this.title, this.subtitle, this.balance, this.isActive});
}