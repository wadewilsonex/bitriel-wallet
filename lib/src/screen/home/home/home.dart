import 'dart:math';
import 'package:carousel_slider/carousel_options.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/post_request.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/screen/home/home/body_home.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';

class HomePage extends StatefulWidget {

  static const String route = AppString.homeView;
  final int activePage;
  final bool? isTrx;

  const HomePage({ Key? key, this.activePage = 2, this.isTrx}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final HomePageModel _model = HomePageModel();

  final Random _random = Random();

  int? randomNum;

  final bool? pushReplacement = true;

  @override
  void initState() {


    _model.pageController!.addListener(() {
      if(_model.activeIndex != _model.pageController!.initialPage){
        setState(() {
          _model.activeIndex = _model.pageController!.page!.toInt();
        });
      }
    });

    // For PageView
    _model.activeIndex = widget.activePage;
    _model.pageController = PageController(initialPage: widget.activePage);

    // For CarouselPage
    _model.adsCarouselActiveIndex = 0;
    _model.globalKey = GlobalKey<ScaffoldState>();
    _model.onAdsCarouselChanged = (int index, CarouselPageChangedReason reason) {
      setState(() {
        _model.adsCarouselActiveIndex = index;
      });
    };

    StorageServices().readSecure(DbKey.privateList)!.then((value) => {
      print("initState read list secure $value"),
    });
    
    
    AppServices.noInternetConnection(context: context);
    
    super.initState();
    
  }

  @override
  void dispose(){
    // _videoController!.dispose();
    super.dispose();
  }

  void onPageChanged(int index){
    
    // if (index == 3){

    //   if (Provider.of<EventProvider>(context, listen: false).getIsAdmin == true ){

    //     Navigator.push(
    //       context, 
    //       Transition(
    //         child: Organization(title: 'ISI DSC Crew', logo: "https://dangkorsenchey.com/images/isi-dsc-logo.png",),
    //         transitionEffect: TransitionEffect.RIGHT_TO_LEFT
    //       )
    //     );
    //   } else {

    //     setState(() {

    //       _model.activeIndex = index;
    //       _model.pageController!.jumpToPage(index);
    //     });
    //   }
    // } else {

    //   setState(() {

    //     _model.activeIndex = index;
    //     _model.pageController!.jumpToPage(index);
    //   });
    // }

    setState(() {

        _model.activeIndex = index;
        _model.pageController!.jumpToPage(index);
      });
    // _model.pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  Future<void> _scanLogin(String url) async {

    dialogLoading(
      context,
      content: "Requesting SEL"
    );

    while (true){

      randomNum = _random.nextInt(7);
      if (randomNum != 0) break;
    }

    await Future.delayed(Duration(seconds: randomNum!), () async {

      try {
        await PostRequest().requestReward(url, Provider.of<ApiProvider>(context, listen: false).getKeyring.current.address!).then((value) async {
        
          // Close Dialog
          Navigator.pop(context);
        
          if (json.decode(value.body)['success'] == true){

            await DialogComponents().dialogCustom(
              context: context,
              contentsFontSize: 17,
              titlesFontSize: 17,
              contents: "500 SEL\nOn the way!",
              textButton: "Complete",
              image: Image.asset("assets/icons/success.png", width: 18, height: 8),
              btn2: Container(),
              btn: null
            );
            
            // Navigator.pop(context);
            // List<int> convert = decode['id'].toString().codeUnits;
            // Uint8List uint8list = Uint8List.fromList(convert);
            // String _credentials = await _signId(decode['id']);
            // print("_credentials $_credentials");
            // String signedDataHex = EthSigUtil.signMessage(
            //   privateKey: _credentials,
            //   message: uint8list
            // );
            // print("signedDataHex $signedDataHex");
            // Navigator.pop(context);

          } else {
            await DialogComponents().dialogCustom(
              contentsFontSize: 17,
              titlesFontSize: 17,
              context: context,
              contents: "${json.decode(value.body)['data']}",
              titles: "Oops",
              btn2: Container(),
              btn: null
            );
          }
        });
      } catch (e) {
        
        // Close Dialog
        Navigator.pop(context);
        
        await DialogComponents().dialogCustom(
          context: context,
          contents: e.toString(),
          titles: "Oops",
          btn2: Container(),
          btn: null
        );

      }
    });

  }


  // Future<String> _signId(String id) async {

  //   return await Provider.of<ApiProvider>(context, listen: false).getPrivateKey("august midnight obvious fragile pretty begin useless collect elder ability enhance series");

  // }
  
  @override
  Widget build(BuildContext context) {
    return HomePageBody(
      isTrx: widget.isTrx,
      homePageModel: _model,
      onPageChanged: onPageChanged,
      pushReplacement: pushReplacement,
      getReward: _scanLogin,
    );
  }
}