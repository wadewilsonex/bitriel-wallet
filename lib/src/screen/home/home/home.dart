import 'dart:math';
import 'package:carousel_slider/carousel_options.dart';
import 'package:wallet_apps/index.dart';
<<<<<<< HEAD
import 'package:wallet_apps/src/backend/post_request.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/provider/verify_seed_p.dart';
import 'package:wallet_apps/src/screen/home/home/body_home.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
=======
import 'package:wallet_apps/src/backend/get_request.dart';
import 'package:wallet_apps/src/backend/post_request.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/provider/app_p.dart';
import 'package:wallet_apps/src/provider/verify_seed_p.dart';
import 'package:wallet_apps/src/screen/home/home/body_home.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
>>>>>>> daveat

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

<<<<<<< HEAD
=======
  String? dir;

>>>>>>> daveat
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
<<<<<<< HEAD
=======
    
    allAssets();
>>>>>>> daveat

    StorageServices.readSecure(DbKey.privateList)!.then((value) => {
      setState(() {
        Provider.of<VerifySeedsProvider>(context, listen: false).getPrivateList = jsonDecode(value);

        // if (Provider.of<VerifySeedsProvider>(context, listen: false).getPrivateList.where((e) {
        //   if (e['address'] == Provider.of<ApiProvider>(context, listen: false).getKeyring.current.address) return true;
        //   return false;
        // }).toList().isNotEmpty){
        //   Provider.of<VerifySeedsProvider>(context, listen: false).isVerifying = true; 
        // }

      })
    });
<<<<<<< HEAD

    
=======
>>>>>>> daveat
    
    AppServices.noInternetConnection(context: context);
    
    super.initState();
    
  }

  @override
  void dispose(){
    // _videoController!.dispose();
    debugPrint("Why");
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

<<<<<<< HEAD
=======
      AppProvider _appPro = Provider.of<AppProvider>(context, listen: false);

>>>>>>> daveat
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
<<<<<<< HEAD
              image: Image.asset("assets/icons/success.png", width: 18, height: 8),
=======
              image: Image.asset("${_appPro.dirPath}/icons/success.png", width: 18, height: 8),
>>>>>>> daveat
              btn2: Container(),
              btn: null
            );
            
            // Navigator.pop(context);
            // List<int> convert = decode['id'].toString().codeUnits;
            // Uint8List uint8list = Uint8List.fromList(convert);
            // String _credentials = await _signId(decode['id']);
            // debugPrint("_credentials $_credentials");
            // String signedDataHex = EthSigUtil.signMessage(
            //   privateKey: _credentials,
            //   message: uint8list
            // );
            // debugPrint("signedDataHex $signedDataHex");
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
<<<<<<< HEAD
=======

  void allAssets() async {

    await downloadAsset(fileName: 'logo.zip');

    // ignore: use_build_context_synchronously
    AppConfig.initIconPath(context);
    
    // await downloadAsset(fileName: 'icons.zip');

    // // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, use_build_context_synchronously
    // Provider.of<AppProvider>(context, listen: false).notifyListeners();

    await downloadAsset(fileName: 'token_logo.zip');

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, use_build_context_synchronously
    Provider.of<AppProvider>(context, listen: false).notifyListeners();
  }
  
  Future<void> downloadAsset({required String fileName}) async {

    print("downloadAsset $fileName");
    dir ??= (await getApplicationDocumentsDirectory()).path;

    print("$dir/$fileName");

    print(await Directory("$dir/$fileName").exists());

    // ignore: unrelated_type_equality_checks
    if ( await Directory("$dir/$fileName").exists() == false ){

      await downloadAssets(fileName).then((value) async {
        print("downloadAssets ${value.body}");
        
        await Permission.storage.request().then((pm) async {
          if (pm.isGranted){
            await getApplicationDocumentsDirectory().then((dir) async {

              await AppUtils.archiveFile(await File("${dir.path}/$fileName").writeAsBytes(value.bodyBytes)).then((files) async {
                
                // await readFile(fileName);
              });
            });
          }
        });
        
      });

      Provider.of<AppProvider>(context, listen: false).dirPath = dir;
      
      print("Finish download and write");
    } else {
      print("Just read");
      await readFile(fileName);
    }
  }

  Future<void> readFile(String fileName) async{

    String dir = (await getApplicationDocumentsDirectory()).path;

    print("dir $dir");

    print("Provider.of<AppProvider>(context, listen: false).dirPath ${Provider.of<AppProvider>(context, listen: false).dirPath}");

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    Provider.of<AppProvider>(context, listen: false).notifyListeners();

    List<FileSystemEntity> files = Directory("$dir/logo").listSync();
    
    for(FileSystemEntity f in files){
      print("file ${f.path}");
    }
  }
>>>>>>> daveat
  
  @override
  Widget build(BuildContext context) {
    return HomePageBody(
      isTrx: widget.isTrx,
      homePageModel: _model,
      onPageChanged: onPageChanged,
      pushReplacement: pushReplacement,
      getReward: _scanLogin,
<<<<<<< HEAD
=======
      downloadAsset: downloadAsset
>>>>>>> daveat
    );
  }
}