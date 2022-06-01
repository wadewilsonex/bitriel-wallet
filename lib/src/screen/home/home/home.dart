import 'package:carousel_slider/carousel_options.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/home/home/body_home.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late PageController _pageController;
  late int activeIndex;

  late final Function(int index, CarouselPageChangedReason reason)? onPageChanged;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8,);
    activeIndex = 0;
    onPageChanged = (int index, CarouselPageChangedReason reason) {
      setState(() {
        this.activeIndex = index;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return HomePageBody(
      controller: _pageController,
      activeIndex: activeIndex,
      onPageChanged: onPageChanged,
    );
  }
}