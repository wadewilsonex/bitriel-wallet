import 'dart:math';

import 'package:carousel_slider/carousel_options.dart';
import 'package:eth_sig_util/eth_sig_util.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/post_request.dart';
import 'package:wallet_apps/src/screen/home/ads_webview/adsWebView.dart';
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

  PostRequest _postRequest = PostRequest();

  Random _random = Random();

  int? randomNum;

  final bool? pushReplacement = true;

  @override
  void initState() {
    
    _model.pageController!.addListener(() {
      if(_model.activeIndex != _model.pageController){
        setState(() {
          _model.activeIndex = _model.pageController!.page!.toInt();
        });
      }
    });

    // For PageView
    _model.activeIndex = widget.activePage;
    _model.pageController = PageController(initialPage: widget.activePage);

    // For CarouselPage
    _model.carouActiveIndex = 0;
    _model.globalKey = GlobalKey<ScaffoldState>();
    _model.onCarouselChanged = (int index, CarouselPageChangedReason reason) {
      setState(() {
        this._model.carouActiveIndex = index;
      });
    };
    AppServices.noInternetConnection(context: context);
    super.initState();
    
  }

  void onPageChanged(int index){
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

    print("randomNum $randomNum");

    // print("Provider.of<ApiProvider>(context, listen: false).accountM.pubKey! ${Provider.of<ApiProvider>(context, listen: false).accountM.pubKey!}");

    await Future.delayed(Duration(seconds: randomNum!), () async {

      try {
        await PostRequest().requestReward(url, Provider.of<ApiProvider>(context, listen: false).accountM.address!).then((value) async {
        
          print("value ${value.body}");
          // Close Dialog
          Navigator.pop(context);
        
          if (json.decode(value.body)['success'] == true){

            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: MyText(text: "500 SEL", fontWeight: FontWeight.bold, fontSize: 17,),
                content: MyText(text: "On the way!", fontSize: 17),
                actions: [

                  MyGradientButton(
                    textButton: "Close",
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    action: () async {

                      Navigator.pop(context);
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
                    },
                  )
                ],
              ),
            );

          } else {
            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: MyText(text: "Oops", fontWeight: FontWeight.bold, fontSize: 17),
                content: MyText(text: "${json.decode(value.body)['data']}", fontSize: 17),
                actions: [

                  MyGradientButton(
                    textButton: "Close",
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    action: () async {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            );
          }
        });
      } catch (e) {
        
        // Close Dialog
        Navigator.pop(context);

        print("Error $e");
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: MyText(text: "Oops", fontWeight: FontWeight.bold, fontSize: 17),
            content: MyText(text: "${e.toString()}", fontSize: 17),
            actions: [

              MyGradientButton(
                textButton: "Close",
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                action: () async {
                  Navigator.pop(context);
                },
              )
            ],
          ),
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
      getReward: _scanLogin
    );
  }
}