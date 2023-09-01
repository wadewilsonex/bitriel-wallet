import 'package:bitriel_wallet/index.dart';

class NavbarUsecaseImpl implements NavbarUsecase{

  final ValueNotifier<int> currentIndex = ValueNotifier(0);

  PageController pageController = PageController();

  @override
  void changeIndex(int? index) async {
    print("changeIndex $index");

    if (currentIndex.value != index!){

      pageController.jumpToPage(index);
      
      currentIndex.value = index; // THIS IS CRITICAL!! Don't miss it!
    }

    
  }
  
}