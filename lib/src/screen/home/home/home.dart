import 'dart:math';
import 'dart:ui';
import 'package:carousel_slider/carousel_options.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/post_request.dart';
import 'package:wallet_apps/src/constants/ui_helper.dart';
import 'package:wallet_apps/src/provider/mdw_p.dart';
import 'package:wallet_apps/src/provider/receive_wallet_p.dart';
import 'package:wallet_apps/src/screen/home/home/body_home.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';

class HomePage extends StatefulWidget {

  static const String route = "/home";
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

    await Future.delayed(Duration(seconds: randomNum!), () async {

      try {
        await PostRequest().requestReward(url, Provider.of<ApiProvider>(context, listen: false).accountM.address!).then((value) async {
        
          // Close Dialog
          Navigator.pop(context);
        
          if (json.decode(value.body)['success'] == true){

            await DialogComponents().dialogCustom(
              context: context,
              contentsFontSize: 17,
              titlesFontSize: 17,
              contents: "500 SEL\nOn the way!",
              textButton: "Complete",
              image: Image.asset("assets/icons/success.png", width: 18.w, height: 8.h),
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

  Future _qrProfileDialog() async {
    return await showDialog(
      context: context, 
      builder: (BuildContext context){
        return Consumer<ApiProvider>(
          builder: (context, value, child) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Stack(
                children: [

                  AlertDialog(
                    contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    backgroundColor: hexaCodeToColor(AppColors.whiteColorHexa),
                    content: Container(
                      width: 250,
                      child: Consumer<ReceiveWalletProvider>(
                        builder: (context, provider, widget){
                          return RepaintBoundary(
                            key: provider.keyQrShare,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                MyText(
                                  top: 50,
                                  text: value.accountM.name,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  hexaColor: AppColors.blackColor,
                                ),

                                SizedBox(height: 2.h),
                                
                                qrCodeProfile(
                                  value.contractProvider!.ethAdd.isNotEmpty ? value.contractProvider!.ethAdd : '',
                                  "assets/logo/bitirel-logo-circle.png",
                                  provider.keyQrShare,
                                ),
                              ],
                            ),
                          ); 
                        }
                      ),
                    )
                  ),
          
                  Positioned(
                    left: Constants.padding,
                    right: Constants.padding,
                    bottom: (MediaQuery.of(context).size.height / 2) + 120,
                    // top: -50,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: Constants.avatarRadius,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                          child: randomAvatar(value.accountM.addressIcon ?? '')
                      ),
                    ),
                  ),
                ],
          
              ),
            );
          }
        );
      }
    );
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
      qrProfileDialog: _qrProfileDialog
    );
  }
}