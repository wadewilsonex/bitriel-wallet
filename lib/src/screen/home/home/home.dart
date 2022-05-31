import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/home/home/body_home.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late PageController _pageController;
  late int index;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8,);
    index = 0;
  }

  @override
  Widget build(BuildContext context) {
    return HomePageBody(
      controller: _pageController,
      activeIndex: index,
    );
  }
}