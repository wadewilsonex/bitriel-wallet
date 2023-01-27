import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lottie/lottie.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/import_acc_m.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class ImportJson extends StatefulWidget {

  final ImportAccountModel? importAccountModel;
  final Function? initStateData;

  const ImportJson({
    Key? key, 
    this.importAccountModel,
    this.initStateData,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ImportJsonState();
  }
}

class ImportJsonState extends State<ImportJson> with TickerProviderStateMixin {

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
    widget.importAccountModel!.animationController!.dispose();
    super.dispose();
  }

  Future<bool>? validateJson(String mnemonic) async {
    
    dynamic res;
    try {
      
      res = Provider.of<ApiProvider>(context, listen: false).apiKeyring;
      widget.importAccountModel!.enable = res;
      
      setState((){});
    } catch (e) {

      if (kDebugMode) {
        print("Error validateMnemonic $e");
      }
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4.28.vmax, horizontal: 2.85.vmax),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
    
                Lottie.asset("${AppConfig.animationPath}data_center_loading.json", width: 70.vmax, height: 70.vmax),
    
                AnimatedTextKit(
                  repeatForever: true,
                  pause: const Duration(seconds: 1),
                  animatedTexts: [
      
                    TypewriterAnimatedText(
                      widget.importAccountModel!.loadingMgs!,
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(
                        fontSize: 3.2.vmax,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
      
                  ],
                ),
    
                Expanded(child: Container()),
    
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  height: 7.14.vmax,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(0.71.vmax)),
                  child: LiquidLinearProgressIndicator(
                    borderRadius: 2.28.vmax,
                    value: widget.importAccountModel!.animation!.value.toDouble(), // Defaults to 0.5.
                    valueColor: AlwaysStoppedAnimation(hexaCodeToColor(AppColors.primaryColor)), // Defaults to the current Theme's accentColor.
                    backgroundColor: Colors.grey, // Defaults to the current Theme's backgroundColor.
                    borderColor: Colors.white,
                    borderWidth: 0.71.vmax,
                    direction: Axis.horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                    center: MyText(
                      fontSize: 1.2,
                      text: widget.importAccountModel!.average ?? '..',
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
