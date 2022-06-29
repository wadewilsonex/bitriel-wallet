import 'package:carousel_slider/carousel_options.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/home/home/body_home.dart';

class HomePage extends StatefulWidget {

  static final String route = "/home";
  final int activePage;
  final bool? isTrx;

  const HomePage({ Key? key, this.activePage = 2, this.isTrx}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  HomePageModel _model = HomePageModel();

  @override
  void initState() {
    super.initState();
    
    _model.pageController.addListener(() {
      if(_model.activeIndex != _model.pageController){
        setState(() {
          _model.activeIndex = _model.pageController.page!.toInt();
        });
      }
    });

    _model.activeIndex = widget.activePage;
    _model.pageController = PageController(initialPage: widget.activePage);
    _model.carouActiveIndex = 0;
    _model.globalKey = GlobalKey<ScaffoldState>();
    _model.onCarouselChanged = (int index, CarouselPageChangedReason reason) {
      setState(() {
        this._model.carouActiveIndex = index;
      });
    };
  }

  void onPageChanged(int index){
    setState(() {
      _model.activeIndex = index;
      _model.pageController.jumpToPage(index);
    });
    // _model.pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  final bool? pushReplacement = true;
  
  @override
  Widget build(BuildContext context) {
    return HomePageBody(
      isTrx: widget.isTrx,
      homePageModel: _model,
      onPageChanged: onPageChanged,
      pushReplacement: pushReplacement,
    );
  }
}