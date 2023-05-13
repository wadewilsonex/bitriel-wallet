import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/data/models/import_acc_m.dart';

class DataLoading extends StatefulWidget {

  final ImportAccAnimationModel? importAnimationAccModel;
  final Function? initStateData;

  const DataLoading({
    Key? key, 
    this.importAnimationAccModel,
    this.initStateData,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DataLoadingState();
  }
}

class DataLoadingState extends State<DataLoading> with TickerProviderStateMixin {

  @override
  void initState() {
    
    widget.initStateData!(this, mySetState);

    AppServices.noInternetConnection(context: context);
    
    super.initState();

  }

  void mySetState(){
    setState(() {
      
    });
  }

  @override
  dispose(){
    widget.importAnimationAccModel!.animationController!.dispose();
    super.dispose();
  }

  // Future<bool>? validateJson(String mnemonic) async {
    
  //   dynamic res;
  //   try {
      
  //     res = Provider.of<ApiProvider>(context, listen: false).apiKeyring;
  //     widget.importAnimationAccModel!.enable = res;
      
  //     setState((){});
  //   } catch (e) {

  //     if (kDebugMode) {
  //       debugPrint("Error validateMnemonic $e");
  //     }
  //   }
  //   return res;
  // }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(top: 30, bottom: 30, left: 20, right: 20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
    
                Lottie.asset("${AppConfig.animationPath}data_center_loading.json", width: 70.w, height: 70.h),
    
                AnimatedTextKit(
                  repeatForever: true,
                  pause: const Duration(seconds: 1),
                  animatedTexts: [
      
                    TypewriterAnimatedText(
                      widget.importAnimationAccModel!.loadingMgs!,
                      textAlign: TextAlign.center,
                      textStyle: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
      
                  ],
                ),
    
                Expanded(child: Container()),
    
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  height: 50,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                  child: LiquidLinearProgressIndicator(
                    borderRadius: 16,
                    value: widget.importAnimationAccModel!.animation!.value.toDouble(), // Defaults to 0.5.
                    valueColor: AlwaysStoppedAnimation(hexaCodeToColor(AppColors.primaryColor)), // Defaults to the current Theme's accentColor.
                    backgroundColor: Colors.grey, // Defaults to the current Theme's backgroundColor.
                    borderColor: Colors.white,
                    borderWidth: 5.0,
                    direction: Axis.horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                    center: MyText(
                      fontSize: 15,
                      text: widget.importAnimationAccModel!.average ?? '..',
                      color2: Colors.white,
                    ),
                  ),
                ),
    
              ],
            ),
          ),
        )
      ),
    );
  }
}
