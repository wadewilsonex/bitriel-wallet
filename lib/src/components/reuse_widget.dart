import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/pie_chart.dart';
import 'package:wallet_apps/src/constants/ui_helper.dart';
import 'package:wallet_apps/src/provider/receive_wallet_p.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
import 'dialog_c.dart';

/* -----------------------------------Variable--------------------------------------------------- */
/* Size */
const double size1 = 1.0;
const double size2 = 2.0;
const double size4 = 4.0;
const double size5 = 5.0;
const double size8 = 8.0;
const double size10 = 10.0;
const double size17 = 17.0;
const double size34 = 34.0;
const double size15 = 15.0;
const double size18 = 18.0;
const double size28 = 28.0;
const double size50 = 50.0;
const double size80 = 80.0;

/* Background Left & Right Size */
const double leftRight40 = 40.0;

/* -----------------------------------Box Border and Shadow Style--------------------------------------------------- */
Color hexaCodeToColor(String hexaCode) {
  return Color(AppUtils.convertHexaColor(hexaCode));
}

/* Transition Animation Fade Up And Down */
Route transitionRoute(
  Widget child,
  // ignore: type_annotate_public_apis
  {
  // ignore: type_annotate_public_apis
  offsetLeft = 0.0,
  // ignore: type_annotate_public_apis
  offsetRight = 0.25,
  // ignore: type_annotate_public_apis
  sigmaX = 10.0,
  // ignore: type_annotate_public_apis
  sigmaY = 10.0,
}) {
  return PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin = Offset(
          double.parse(offsetLeft.toString()),
          double.parse(offsetRight.toString())
        );
        const end = Offset.zero;
        const curve = Curves.fastOutSlowIn;
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(
              opacity: animation,
              child: Material(
                color: Colors.white.withOpacity(0.1),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(
                    sigmaX: double.parse(sigmaX.toString()),
                    sigmaY: double.parse(sigmaY.toString()),
                  ),
                  child: child,
                ),
              ),
            ));
      });
}

/* User Input Text */
TextField userTextField(
    TextEditingController inputEditor,
    FocusNode node,
    void Function(String) sink,
    AsyncSnapshot snapshot,
    // ignore: avoid_positional_boolean_parameters
    bool showInput,
    TextInputType inputType,
    TextInputAction inputAction) {
  return TextField(
    controller: inputEditor,
    style: const TextStyle(color: Colors.white),
    focusNode: node,
    obscureText: showInput,
    onChanged: sink,
    keyboardType: inputType,
    textInputAction: inputAction,
    decoration: InputDecoration(
      fillColor: Colors.black38,
      filled: true,
      contentPadding:
          const EdgeInsets.only(top: 15.0, bottom: 15.0, left: size10),
      labelStyle: const TextStyle(color: Colors.white),
      /* Border side */
      border: errorOutline(),
      enabledBorder: myTextInputBorder(hexaCodeToColor(AppColors.borderColor)),
      focusedBorder: myTextInputBorder(hexaCodeToColor(AppColors.lightBlueSky)),
      /* Error Handler */
      focusedErrorBorder: errorOutline(),
      errorText: snapshot.hasError ? snapshot.error.toString() : null,
    ),
  );
}

/* ------------------Input Decoration--------------------- */

OutlineInputBorder errorOutline() {
  /* User Error Input Outline Border */
  return const OutlineInputBorder(borderSide: BorderSide(color: Colors.red));
}

/* Button shadow */
BoxShadow shadow(BuildContext context,
  { Color? hexaCode, 
    double? blurRadius, 
    double? spreadRadius, 
    Offset? offset}) {
   
  return BoxShadow(
    color: hexaCode ?? (isDarkMode
        ? hexaCodeToColor(AppColors.darkBgd)
        : Colors.grey.withOpacity(0.2)),
    blurRadius: blurRadius ?? 6.0,
    spreadRadius: spreadRadius ?? 2.0,
    offset: offset ?? const Offset(0.5, 2.0),
  );
}

Widget customFlatButton(
    BuildContext context,
    String textButton,
    String widgetName,
    String buttonColor,
    FontWeight fontWeight,
    double fontSize,
    EdgeInsetsGeometry edgeMargin,
    EdgeInsetsGeometry edgePadding,
    BoxShadow boxShadow,
    Function? action) {
  return Container(
    margin: edgeMargin,
    width: double.infinity,
    height: 50.0,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(size5), boxShadow: [boxShadow]),
    child: TextButton(
      onPressed: action == null
      ? null
      : () {
          action(context);
        },
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(size5)),
        ),
        backgroundColor: hexaCodeToColor(buttonColor),
      ),
      child: Text(
        textButton,
        style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
      ),
    ),
  );
}

/* Border and Border Radius Chart Card */
BoxDecoration borderAndBorderRadius() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(5.0),
    border: Border.all(width: 2.0, color: hexaCodeToColor("#5F5F69")),
  );
}

/* -----------------------------------Background Color Style--------------------------------------------------- */

/* Scaffold Background Color */
BoxDecoration scaffoldBGColor(String color1, String color2) {
  return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [hexaCodeToColor(color1), hexaCodeToColor(color1)]));
}

Widget scaffoldBGDecoration(
  { double? top = 16.0,
    double? right = 16.0,
    double? bottom = 16.0,
    double? left = 16.0,
    Widget? child}) {
  return Container(
    width: double.infinity,
    height: double.infinity,
    padding: EdgeInsets.only(top: top!, right: right!, bottom: bottom!, left: left!),
    decoration: scaffoldBGColor(AppColors.lowWhite, AppColors.lowWhite),
    child: SafeArea(
      child: child!,
    ),
  );
}

/* Title gradient color */
final Shader linearGradient = LinearGradient(colors: [
  hexaCodeToColor(AppColors.lightBlueSky),
  hexaCodeToColor(AppColors.greenColor)
]).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

BoxDecoration signOutColor() {
  return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
        hexaCodeToColor("#1D0837"),
        hexaCodeToColor("#0F0F11"),
      ]));
}

/* -----------------------------------Dialog Result--------------------------------------------------- */

/* Dialog of response from server */
// ignore: type_annotate_public_apis

Future<void> successDialog(
  BuildContext context, String operationText, {
    Widget? route = const HomePage()
}) async {
  // await Future.delayed(const Duration(milliseconds: 30), (){});
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: hexaCodeToColor(AppColors.darkBgd),
        content: SizedBox(
          // height: MediaQuery.of(context).size.height / 2.6,
          width: MediaQuery.of(context).size.width * 0.7,
          child: SingleChildScrollView(
            child: Column(
              children: [

                const Icon(Icons.check_circle_outline_rounded, size: 20, color: Colors.green,),
                const MyText(
                  text: 'SUCCESS!',
                  fontSize: 20,
                  top: 10,
                  hexaColor: AppColors.lowWhite,
                  fontWeight: FontWeight.bold,
                ),
                MyText(
                  top: 8.0,
                  hexaColor: AppColors.lowWhite,
                  text: 'You have successfully $operationText',
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.1,
                ),

                MyGradientButton(
                  textButton: "Continue",
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  action: (){
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(context, Transition(child: route!), ModalRoute.withName('/'));
                  }
                )

              ],
            ),
          ),
        )
      );
    },
  );
}

Future<void> seedVerifyLaterDialog(
  BuildContext context, String operationText) async {

  bool isCheck = false;
  
  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateWidget) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: hexaCodeToColor(AppColors.whiteColorHexa),
            content: SizedBox(
              // height: MediaQuery.of(context).size.height / 2.6,
              width: MediaQuery.of(context).size.width * 0.7,
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Lottie.asset(
                        "assets/animation/warning-shield.json",
                        repeat: true,
                      ),
                    ),
                    const MyText(
                      text: 'Verify you Seed Phrase later?',
                      fontSize: 20,
                      top: 10,
                      bottom: 25,
                      fontWeight: FontWeight.bold,
                    ),
  
                    Theme(
                      data: ThemeData(),
                      child: CheckboxListTile(
                        title: const MyText(
                          text: "I understand that if I lose my Secret Seed Phrase I will not be able to access my wallet",
                          textAlign: TextAlign.start,
                        ),
                        activeColor: hexaCodeToColor(AppColors.primaryColor),
                        value: isCheck,
                        onChanged: (newValue) {
                          setStateWidget(() {
                            isCheck = newValue!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),

                    // Row(
                    //   children: [
                    //     SizedBox(
                    //       width: 20,
                    //       height: 20,
                    //       child: Transform.scale(
                    //         scale: 1.5,
                    //         child: Checkbox(
                    //           value: isCheck,
                    //           checkColor: Colors.green,
                    //           activeColor: hexaCodeToColor(AppColors.primaryColor),
                    //           onChanged: (bool? value) {
                    //             setStateWidget(() {
                    //               isCheck = value!;
                    //             });
                    //           },
                    //         ),
                    //       ),
                    //     ),

                    //     const MyText(
                    //       pLeft: 20,
                    //       width: 280,
                    //       text: "I understand that if I lose my Secret Seed Phrase I will not be able to access my wallet",
                    //       textAlign: TextAlign.start,
                    //     )
                    //   ],
                    // ),


                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.1,
                    ),

                    MyFlatButton(
                      isTransparent: true,
                      buttonColor: AppColors.greenColor,
                      textColor: isCheck == false ? AppColors.greyCode : AppColors.primaryColor,
                      textButton: "Yes, Verify Later",
                      action: () {
                        Navigator.pop(context);
                      },
                    ),

                    const SizedBox(height: 10,),

                    MyGradientButton(
                      textButton: "No, Verify Now",
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      action: (){
                        Navigator.pop(context);
                      }
                    )

                  ],
                ),
              ),
            )
          );
        }
      );
    },
  );
}

// Future<void> dialog(BuildContext context, Widget text, Widget title,
//     {Widget action, Color bgColor}) async {
//   await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: bgColor,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//           title: Align(
//             child: title,
//           ),
//           content: Padding(
//             padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
//             child: text,
//           ),
//           actions: <Widget>[
//             // ignore: deprecated_member_use
//             FlatButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Close'),
//             ),
//             action
//           ],
//         );
//       });
// }

Future dialogEvent(
  BuildContext context,
  String url,
  void Function() onClosed,
  void Function() onClaim,
) async {
  final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: const EdgeInsets.all(0),
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 1.9,
            width: MediaQuery.of(context).size.width * 0.8,
            child: ListView(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  child: Image.asset(
                    url,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                const MyText(
                  text: 'Selendra Airdrop',
                  //color: '#000000',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 16,
                ),
                const MyText(
                  text:
                      'Selendra will conduct 3 airdrops. Each drop will have 6 sessions with a total of 31,415,927 SEL tokens. Each session will last as long as 3 months to distribute to as many people as possible. The first airdrop will take place in April 2021, during Khmer New Year. Enjoy the airdrop, everyone.',
                  textAlign: TextAlign.start,
                  right: 16,
                  left: 16,
                  fontSize: 16,
                ),
                const SizedBox(
                  height: 28,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // ignore: deprecated_member_use
                    SizedBox(
                      height: 50,
                      width: 100,
                      child: ElevatedButton(
                        onPressed: onClosed,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.grey[50]),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: hexaCodeToColor(AppColors.textColor),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // ignore: deprecated_member_use
                    SizedBox(
                      height: 50,
                      width: 100,
                      child: ElevatedButton(
                        onPressed: onClaim,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(hexaCodeToColor(AppColors.secondary)),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))
                        ),
                        child: Text(
                          'Claim',
                          style: TextStyle(
                            color: hexaCodeToColor('#ffffff'),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      });
  return result;
}

Future dialogSuccess(BuildContext context, Widget text, Widget title,
    {Widget? action, Color? bgColor}) async {
  final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: bgColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Align(
            child: title,
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: text,
          ),
          actions: <Widget>[action ?? Container()],
        );
      });
  return result;
}

Future<void> txDetailDialog(BuildContext context, TxHistory txHistory) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Center(
          child: MyText(
          text: 'Transaction Detail',
          fontWeight: FontWeight.bold,
        )),
        content: SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  const MyText(
                    text: 'Date: ',
                    fontSize: 14.0,
                  ),
                  Expanded(
                      child: MyText(
                    text: txHistory.date,
                    textAlign: TextAlign.start,
                    fontSize: 14.0,
                    overflow: TextOverflow.ellipsis,
                  )),
                ],
              ),
              Row(
                children: [
                  const MyText(
                    text: 'Destination: ',
                    fontSize: 14.0,
                  ),
                  Expanded(
                      child: MyText(
                    text: txHistory.destination,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 14.0,
                  )),
                ],
              ),
              Row(
                children: [
                  const MyText(
                    text: 'Sender: ',
                    fontSize: 14.0,
                  ),
                  Expanded(
                      child: MyText(
                    text: txHistory.sender,
                    textAlign: TextAlign.start,
                    fontSize: 14.0,
                    overflow: TextOverflow.ellipsis,
                  )),
                ],
              ),
              Row(
                children: [
                  const MyText(
                    text: 'Organization: ',
                    fontSize: 14.0,
                  ),
                  Expanded(
                      child: MyText(
                    text: txHistory.org,
                    textAlign: TextAlign.start,
                    fontSize: 14.0,
                    overflow: TextOverflow.ellipsis,
                  )),
                ],
              ),
              Row(
                children: [
                  const MyText(
                    text: 'Amount: ',
                    fontSize: 14.0,
                  ),
                  Expanded(
                    child: MyText(
                      text: txHistory.amount,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget textMessage({String text = "Message", double fontSize = 20.0}) {
  return FittedBox(
    child: Text(text,
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600)),
  );
}

Widget textAlignCenter({String text = ""}) {
  return Text(text, textAlign: TextAlign.center);
}

/* Check for internet connection */
void noInternet(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
            title: const Text('No internet'),
            content: const Text("You're not connect to network"),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              )
            ]);
      });
}

Future<void> blurBackgroundDecoration(BuildContext context, Widget screen) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: Colors.white.withOpacity(0.1),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: 20.0,
              sigmaY: 20.0,
            ),
            child: screen,
          ),
        );
      });
}

/* ----------------------------------- Bottom App Bar ----------------------------------- */

/* Loading Progress */
Widget loading() {
  return Center(
    child: CircularProgressIndicator(
      backgroundColor: Colors.transparent,
      valueColor: AlwaysStoppedAnimation(hexaCodeToColor(AppColors.primaryColor))
    ),
  );
}

/* Progress */
Widget progress({bool isTicket = false, String? content}) {
  return Material(
    color: Colors.transparent,
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Lottie.asset(
              isTicket == true ? "assets/animation/loading-ticket.json" : "assets/animation/blockchain-animation.json",
              repeat: true,
              reverse: true,
            ),
            // CircularProgressIndicator(
            //   backgroundColor: Colors.transparent,
            //   valueColor: AlwaysStoppedAnimation(
            //     hexaCodeToColor(AppColors.secondary)
            //   )
            // ),
            if (content == null)
            Container()
            else
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, top: 16.0),
              child: MyText(
                text: content, 
                hexaColor: AppColors.whiteColorHexa,
              ),
            ),
          ],
        )
      ],
    ),
  );
}

dialogLoading(BuildContext context, {bool? isTicket = false, String? content}) {
  return showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: progress(isTicket: isTicket!, content: content)
      );
      // WillPopScope(
      //   onWillPop: () => Future(() => false),
      //   child: ,
      // );
    }
  );
}

dialogLoadingCustom(BuildContext context) {
  return showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      return const MyText(
        text: "This processing may take a bit longer\nPlease wait a moment",
        textAlign: TextAlign.center,
      );
      // WillPopScope(
      //   onWillPop: () => Future(() => false),
      //   child: ,
      // );
    }
  );
}

// For Approve
// processingDialog(BuildContext context, bool begin, bool middle, bool end) {
//   return showDialog(
//       barrierDismissible: true,
//       context: context,
//       builder: (context) {
//         return Material(
//           color: Colors.transparent,
//           child: Stack(
//             alignment: Alignment.center,
//             children: <Widget>[
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   CircularProgressIndicator(
//                       backgroundColor: Colors.transparent,
//                       valueColor: AlwaysStoppedAnimation(
//                           hexaCodeToColor(AppColors.lightBlueSky))),
//                   MyText(text: "Processing"),
//                   Column(children: <Widget>[
//                     Expanded(
//                         child: TimelineTile(
//                       axis: TimelineAxis.vertical,
//                       alignment: TimelineAlign.start,
//                       isFirst: true,
//                       // afterLineStyle: begin == true ? LineStyle(color: hexaCodeToColor(AppColors.secondary) : LineStyle(),
//                       indicatorStyle: IndicatorStyle(
//                         width: 20,
//                         height: 20,
//                         indicator: Container(
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             // color: AppServices.hexaCodeToColor(trackingProgress >= 0 ? AppColors.green : AppColors.lowBlack),
//                           ),
//                         ),
//                       ),
//                       // endChild: Padding(
//                       //   padding: EdgeInsets.only(left: 20),
//                       //   child: Column(
//                       //     crossAxisAlignment: CrossAxisAlignment.start,
//                       //     mainAxisAlignment: MainAxisAlignment.center,
//                       //     children: [
//                       //       MyText(text: "${trackingProgress >= 0 ? widget.topOrder!.dateTime.text : 'Estimating'}", color: AppColors.lowBlack,),
//                       //       MyText(text: "${status[0]}", color: trackingProgress >= 0 ? AppColors.green : AppColors.lowBlack, fontWeight: FontWeight.bold),
//                       //     ],
//                       //   )
//                       // ),
//                     )),
//                     Expanded(
//                         child: TimelineTile(
//                       // If TrackingProgress == Tracking
//                       // beforeLineStyle: trackingProgress != 0 ? LineStyle(color: AppServices.hexaCodeToColor(AppColors.green)) : LineStyle(),
//                       // afterLineStyle: trackingProgress > 1 ? LineStyle(color: AppServices.hexaCodeToColor(AppColors.green)) : LineStyle(),
//                       alignment: TimelineAlign.start,
//                       indicatorStyle: IndicatorStyle(
//                           width: 20,
//                           height: 20,
//                           drawGap: true,
//                           indicator: Container(
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               // color: AppServices.hexaCodeToColor(trackingProgress >= 1 ? AppColors.green : AppColors.lowBlack),
//                             ),
//                           )),
//                       // endChild: Padding(
//                       //   padding: EdgeInsets.only(left: 20),
//                       //   child: Column(
//                       //     crossAxisAlignment: CrossAxisAlignment.start,
//                       //     mainAxisAlignment: MainAxisAlignment.center,
//                       //     children: [

//                       //       MyText(text: "${trackingProgress >= 1 ? widget.topOrder!.dateTime.text : 'Estimating'}", color: AppColors.lowBlack,),
//                       //       MyText(text: "${status[1]}", color: trackingProgress >= 1 ? AppColors.green : AppColors.lowBlack, fontWeight: FontWeight.bold),
//                       //     ],
//                       //   )
//                       // ),
//                     )),
//                     Expanded(
//                         child: TimelineTile(
//                       // beforeLineStyle: trackingProgress > 1 ? LineStyle(color: AppServices.hexaCodeToColor(AppColors.green)) : LineStyle(),
//                       // afterLineStyle: trackingProgress > 2 ? LineStyle(color: AppServices.hexaCodeToColor(AppColors.green)) : LineStyle(),
//                       alignment: TimelineAlign.start,
//                       indicatorStyle: IndicatorStyle(
//                           width: 20,
//                           height: 20,
//                           drawGap: true,
//                           indicator: Container(
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               // color: AppServices.hexaCodeToColor(trackingProgress >= 2 ? AppColors.green : AppColors.lowBlack),
//                             ),
//                           )),
//                       endChild: Padding(
//                           padding: EdgeInsets.only(left: 20),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               // MyText(text: "${trackingProgress >= 2 ? widget.topOrder!.dateTime.text : 'Estimating'}", color: AppColors.lowBlack,),
//                               // MyText(text: "${status[2]}", color:  trackingProgress >= 2 ? AppColors.green : AppColors.lowBlack, fontWeight: FontWeight.bold),
//                             ],
//                           )),
//                     )),
//                   ])
//                 ],
//               )
//             ],
//           ),
//         );
//       });
// }

Widget logoSize(
  String logoName,
  double width,
  double height,
) {
  return Image.asset(logoName,width: width, height: height, color: Colors.white);
}

/* -----------------------------------Text Style--------------------------------------------------- */

/* Label User Input */
Widget labelUserInput(String text, String colorHexa) {
  return Text(
    text,
    style: TextStyle(
        color: hexaCodeToColor(colorHexa),
        fontSize: 12.0,
        fontWeight: FontWeight.bold),
  );
}

Widget textDisplay(String text, TextStyle textStyle) {
  return Text(
    text,
    style: textStyle,
  );
}

/* ---------------------------------Camera and Gallery------------------------------------------------ */

/* QR Code Generate Function */
Widget qrCodeGenerator(String wallet, String logoName, GlobalKey keyQrShare, {double width = 45, bool embeddedImage = true}) {
  return SizedBox(
    width: width.w,
    child: QrImage(
      padding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      embeddedImage: embeddedImage == true ? const AssetImage('assets/logo/bitirel-logo-circle.png') : null,
      embeddedImageStyle: QrEmbeddedImageStyle(
        size: Size(25.sp, 25.sp),
      ),
      eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.circle, color: Colors.black),
      dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.circle, color: Colors.black),
      data: wallet,
    ),
  );
}

Widget qrCodeProfile(String wallet, String logoName, GlobalKey keyQrShare) {
  return QrImage(
    padding: EdgeInsets.zero,
    backgroundColor: Colors.white,
    embeddedImage: AssetImage(logoName),
    embeddedImageStyle: QrEmbeddedImageStyle(
      size: const Size(50, 50),
    ),
    eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.circle, color: Colors.black),
    dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.circle, color: Colors.black),
    // version: QrVersions.auto,
    data: wallet,
  );
}

Widget textNotification(String text, BuildContext context) {
  return Align(
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.w300,
      ),
    ),
  );
}

/*----------------------------------------------- Field Icons trigger Widget ----------------------------------------------------- */
Widget fieldPicker(BuildContext context, String labelText, String widgetName,
    IconData icons, dynamic model, dynamic method) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      InkWell(
        onTap: () {
          if (widgetName == "fillDocsScreen") {
            method(labelText);
          } else {
            method();
          }
        },
        /* Text Field*/
        child: Container(
          padding: const EdgeInsets.only(
            top: 23.0,
            bottom: 23.0,
            left: 26.0,
            right: 26.0,
          ),
          decoration: BoxDecoration(
            color: hexaCodeToColor("#FFFFFF").withOpacity(0.1),
            borderRadius: BorderRadius.circular(size5),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  labelText,
                  style: const TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
              Icon(
                icons,
                color: Colors.white,
              ),
            ],
          ),
        ),
      )
    ],
  );
}

Widget inputField(
    {/* User Input Field */
    Key? key,
    BuildContext? context,
    String? labelText,
    String? prefixText,
    String? widgetName,
    bool? obcureText = false,
    bool? enableInput = true,
    List<TextInputFormatter>? textInputFormatter,
    TextInputType? inputType = TextInputType.text,
    TextInputAction? inputAction = TextInputAction.next,
    TextEditingController? controller,
    FocusNode? focusNode,
    IconButton? icon,
    String Function(String?)? validateField,
    Function? onChanged,
    Function? action}) {
  return TextFormField(
    key: key,
    enabled: enableInput,
    focusNode: focusNode,
    keyboardType: inputType,
    obscureText: obcureText!,
    controller: controller,
    textInputAction: inputAction,
    style: TextStyle(color: hexaCodeToColor("#ffffff"), fontSize: 18.0),
    validator: (String? value){
      return validateField!(value);
    },
    decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
            fontSize: 18.0,
            color: focusNode!.hasFocus || controller!.text != ""
                ? hexaCodeToColor("#FFFFF").withOpacity(0.3)
                : hexaCodeToColor("#ffffff")),
        prefixText: prefixText,
        prefixStyle: const TextStyle(color: Colors.white, fontSize: 18.0),
        /* Prefix Text */
        filled: true,
        fillColor: hexaCodeToColor("#FFFFFF").withOpacity(0.1),
        enabledBorder: myTextInputBorder(controller!.text != ""
            ? hexaCodeToColor("#FFFFFF").withOpacity(0.3)
            : Colors.transparent),
        /* Enable Border But Not Show Error */
        border: errorOutline(),
        /* Show Error And Red Border */
        focusedBorder:
            myTextInputBorder(hexaCodeToColor("#FFFFFF").withOpacity(0.3)),
        /* Default Focuse Border Color*/
        focusColor: hexaCodeToColor("#ffffff"),
        /* Border Color When Focusing */
        contentPadding:
            const EdgeInsets.all(23), // No Content Padding = -10.0 px
        suffixIcon: icon),
    inputFormatters: textInputFormatter,
    /* Limit Length Of Text Input */
    onChanged: (valueChange) {
      if (widgetName == "loginSecondScreen" || widgetName == "signUpFirstScreen") {
        onChanged!(labelText, valueChange);
      } else {
        onChanged!(valueChange);
      }
    },
    onFieldSubmitted: (value) {
      action!(context);
    },
  );
}

Widget customDropDown(
    String label,
    List<Map<String, dynamic>>? list,
    dynamic model,
    Function changeValue,
    PopupMenuItem Function(Map<String, dynamic>) item) {
  /* Custom DropDown */
  return Container(
    padding: const EdgeInsets.only(
      top: 11.0,
      bottom: 11.0,
      left: 26.0,
      right: 14.0,
    ),
    decoration: BoxDecoration(
      color: hexaCodeToColor(AppColors.whiteHexaColor),
      borderRadius: BorderRadius.circular(size5),
    ),
    child: Row(
      children: <Widget>[
        Expanded(
          child: MyText(
            text: label,
            textAlign: TextAlign.left,
          ),
        ),
        Theme(
          data: ThemeData(
              canvasColor: hexaCodeToColor("#FFFFFF").withOpacity(0.1)),
          child: PopupMenuButton(
            offset: Offset.zero,
            padding: const EdgeInsets.all(12),
            onSelected: (index) {
              changeValue(index);
            },
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
            itemBuilder: (BuildContext context) {
              return list == null
                  ? []
                  : list.map((list) {
                      return item(list);
                    }).toList();
            },
          ),
        ),
      ],
    ),
  );
}

Widget textButton(
  { BuildContext? context,
    String? textColor,
    String? text,
    EdgeInsets? padding = const EdgeInsets.all(13),
    void Function()? onTap,
    double? fontSize = 18.0,
    FontWeight? fontWeight = FontWeight.w400
  }) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: padding!,
      child: textScale(
          text: text!,
          hexaColor: textColor!,
          fontSize: fontSize!,
          underline: TextDecoration.none,
          fit: BoxFit.fill,
          fontWeight: fontWeight!),
    ),
  );
}

Widget textScale(
  { String? text,
    double? fontSize = 18.0,
    String? hexaColor = "#1BD2FA",
    TextDecoration? underline,
    BoxFit? fit = BoxFit.contain,
    FontWeight? fontWeight,
    TextAlign? textAlign = TextAlign.center}) {
  return FittedBox(
    fit: fit!,
    child: Text(text!,
        style: TextStyle(
          color: hexaCodeToColor(hexaColor!),
          decoration: underline,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
        textAlign: textAlign),
  );
}

Widget textDropDown(String text) {
  /* List Drop Down Text */
  return Align(child: Text(text));
}

Widget drawerText(String text, Color colors, double fontSize) {
  /* Drawer Text */
  return Text(
    text,
    style: TextStyle(
      color: colors,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget warningTitleDialog() {
  return const Text(
    'Oops...',
    style: TextStyle(fontWeight: FontWeight.bold),
  );
}

Widget disableNativePopBackButton(Widget child) {
  return WillPopScope(
    onWillPop: () => Future(() => false),
    child: child,
  );
}

Future<void> underContstuctionAnimationDailog({required BuildContext? context}){
  return DialogComponents().dialogCustom(
    context: context,
    contentPadding: EdgeInsets.zero,
    contents: "Under Construction",
    textButton: "OK",
    // image: Image.asset("assets/icons/success.png", width: 20.w, height: 10.h),
    lottie: Lottie.asset(
      "assets/animation/under-construction.json",
      repeat: true,
      reverse: true,
      height: 25.h,
    ),
    btn2: MyGradientButton(
      textButton: "OK",
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      action: () async {
        Navigator.pop(context!);
      },
    )
  );
}

Future<void> portfolioDailog({required BuildContext? context}){
  return DialogComponents().dialogCustom(
    context: context,
    textButton: "OK",
    contents2: const ChartData(),
    btn2: MyGradientButton(
      textButton: "OK",
      textColor: AppColors.lowWhite,
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      action: () async {
        Navigator.pop(context!);
      },
    )
  );
}

Future<void> fetchWalletAnimationDailog({required BuildContext? context}){
  return DialogComponents().dialogCustom(
    context: context,
    contents: "Under Construction",
    textButton: "OK",
    // image: Image.asset("assets/icons/success.png", width: 20.w, height: 10.h),
    lottie: Lottie.asset(
      "assets/animation/under-construction.json",
      width: 75.w, 
      repeat: true,

    ),
    btn2: MyGradientButton(
      textButton: "OK",
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      action: () async {
        Navigator.pop(context!);
      },
    )
  );
}

Widget textRowWidget(String leadingText, String trailingText) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10.0,),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Expanded(
          child: MyText(
            text: leadingText,
            hexaColor: AppColors.blackColor,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.start,
          ),
        ),

        // SizedBox(width: 20,),
        // Expanded(child: Container()),
        Expanded(
          child: MyText(
            text: trailingText,
            hexaColor: AppColors.blackColor,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    ),
  );
}

Widget tfPasswordWidget(TextEditingController password, String title, {Function? onSubmit}) {
  return TextFormField(
    obscureText: true,
    controller: password,
    onFieldSubmitted: (String value) {
      if (onSubmit != null) onSubmit();
    },
    style: TextStyle(
      color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,),
    ),
    decoration: InputDecoration(

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(width: 0, color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.orangeColor).withOpacity(0),),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(width: 0, color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.orangeColor).withOpacity(0),),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(width: 0, color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.orangeColor).withOpacity(0),),
      ),

      hintText: title,
      hintStyle: TextStyle(
        fontSize: 14,
        color: hexaCodeToColor("#AAAAAA"),
      ),

      prefixStyle: TextStyle(color: hexaCodeToColor(isDarkMode ? AppColors.whiteHexaColor : AppColors.orangeColor), fontSize: 18.0),
      
      /* Prefix Text */
      filled: true,
      fillColor: Colors.white//hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.lightColorBg),

    ),
    validator: (val){
      if(val != password.text) {
        return 'Password not match';
      }
      return null;
    }
  );
}

  Future qrProfileDialog(BuildContext context) async {
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
                    content: SizedBox(
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
                                  text: value.getKeyring.current.name,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  hexaColor: AppColors.blackColor,
                                ),

                                const SizedBox(height: 2),
                                
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
                          child: randomAvatar(value.getKeyring.current.icon ?? '')
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