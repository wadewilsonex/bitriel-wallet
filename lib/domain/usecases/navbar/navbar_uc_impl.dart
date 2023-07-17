
import 'package:bitriel_wallet/index.dart';

class NavbarUsecaseImpl implements NavbarUsecase{

  NavbarModel navbarModel = NavbarModel();

  @override
  void changeIndex({int? index}) async {

    navbarModel.controller?.index = index!; // THIS IS CRITICAL!! Don't miss it!

    if (index == 1) {}
    
  }
  
}