import 'package:bitriel_wallet/index.dart';

class NavbarUsecaseImpl implements NavbarUsecase{

  final ValueNotifier<int> currentIndex = ValueNotifier(0);

  @override
  void changeIndex({required int index}) async {

    currentIndex.value = index; // THIS IS CRITICAL!! Don't miss it!
    
  }
  
}