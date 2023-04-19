import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/get_request.dart';
import 'package:wallet_apps/src/components/progress_timeline_c.dart';
import 'package:wallet_apps/src/models/swap_m.dart';

class SwapStatus extends StatefulWidget {
  const SwapStatus({Key? key}) : super(key: key);

  @override
  State<SwapStatus> createState() => _SwapStatusState();
}

class _SwapStatusState extends State<SwapStatus> {

  final TextEditingController _textController = TextEditingController();

  Future<void> _onSubmit() async {
    try {

      dialogLoading(context);
     
      await queryTrxStatus(_textController.text.toString()).then((value) {

        final _res = SwapStatusResponseObj.fromJson(json.decode(value.body));

        if (value.statusCode == 200){
          // Close Dialog
          Navigator.pop(context);
          Navigator.push(
            context, 
            Transition(
              child: SwapStatusProgress(res: _res, ticks: _res.status == "wait" ? 1 : 2,),
              transitionEffect: TransitionEffect.RIGHT_TO_LEFT
            )
          );
        } else {
          throw Exception(json.decode(value.body)['error']);
        }
        
      });
      
    }
    on Exception catch (ex){
      print("Exception");
      customDialog(context, "Error", "Transaction not found", txtButton: "Close").then((value) {
       Navigator.pop(context);
      });
      // Close Dialog
      
      print(ex);
      
    } 
    catch (e) {
      // Close Dialog
      Navigator.pop(context);
      print("Something wrong $e");
    }

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor)
        ),
        backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
        title: MyText(
          text: "Exchange Status",
          fontSize: 22,
          fontWeight: FontWeight.w600,
          hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Iconsax.arrow_left_2, size: 30),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Padding(
            padding: const EdgeInsets.all(paddingSize),
            child: tfPasswordWidget(_textController, "Exchange ID", obscureText: false),
          ),

          Padding(
            padding: const EdgeInsets.all(paddingSize),
            child: MyGradientButton(
              textButton: "Submit",
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              action: (){
                _onSubmit();
              }
            ),
          )
        ],
      ),
    );
  }
}