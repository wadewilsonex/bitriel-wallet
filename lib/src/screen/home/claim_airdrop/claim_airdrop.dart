import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/src/components/component.dart';
import 'package:wallet_apps/src/components/network_sensitive.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/provider/airdrop_p.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallet_apps/src/screen/home/claim_airdrop/intro_airdrop.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:date_format/date_format.dart';

import '../../../../index.dart';

class ClaimAirDrop extends StatefulWidget {
  @override
  _ClaimAirDropState createState() => _ClaimAirDropState();
}

class _ClaimAirDropState extends State<ClaimAirDrop> {

  TextEditingController? _emailController;
  TextEditingController? _phoneController;
  TextEditingController? _walletController;
  TextEditingController? _socialController;
  TextEditingController? _referralController;
  FocusNode? _emailFocusNode;
  FocusNode? _phoneFocusNode;
  FocusNode? _walletFocusNode;
  FocusNode? _socialFocusNode;

  final airdropKey = GlobalKey<FormState>();

  FlareControls flareController = FlareControls();

  bool _enableButton = false;
  bool _submitted = false;

  AirDropProvider? _airDropProvider;

  double iconSize = 50;

  String amount = '0';

  String pin = '';

  Map<String, dynamic>? value;

  // ignore: unnecessary_raw_strings

// your spreadsheet id
  static const _spreadsheetId = AppConfig.spreedSheetId;

  bool validateEmail(String value) {
    const Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final RegExp regex = RegExp(pattern.toString());
    // ignore: avoid_bool_literals_in_conditional_expressions
    return (!regex.hasMatch(value)) ? false : true;
  }

  String? onChangedEmail(String value) {
    if (_emailFocusNode!.hasFocus && _phoneController!.text.isNotEmpty) {
      setState(() {
        _enableButton = true;
      });
    } else if (_enableButton){
      setState(() {
        _enableButton = false;
      });
    }
    return null;
  }

  String? onChanged(String value) {
    if (_emailFocusNode!.hasFocus) {
      FocusScope.of(context).requestFocus(_phoneFocusNode);
    } else {
      if (_emailFocusNode!.hasFocus && _phoneController!.text.isNotEmpty) {
        setState(() {
          _enableButton = true;
        });
      } else if (_enableButton){
        setState(() {
          _enableButton = false;
        });
      }
    }

    return null;
  }

  String? validateEmailField(String value) {
    if (value.isEmpty || validateEmail(value) == false) {
      return 'Please fill in valid email address';
    }
    return null;
  }

  void onSubmit() {
    if (_emailFocusNode!.hasFocus) {
      FocusScope.of(context).requestFocus(_phoneFocusNode);
    } else if (_emailFocusNode!.hasFocus && _phoneController!.text.isNotEmpty) {
      if (_emailFocusNode!.hasFocus && _phoneController!.text.isNotEmpty) {
        setState(() {
          _enableButton = true;
        });
      } else if (_enableButton){
        setState(() {
          _enableButton = false;
        });
      }
    } else {
      if (_emailFocusNode!.hasFocus && _phoneController!.text.isNotEmpty) {
        setState(() {
          _enableButton = true;
        });
      } else if (_enableButton){
        setState(() {
          _enableButton = false;
        });
      }
    }
  }

  Future<bool> findAddress(String address) async {
    final gsheets = GSheets(address);
    // fetch spreadsheet by its id
    final ss = await gsheets.spreadsheet(_spreadsheetId);
    // get worksheet by its title

    final sheet = ss.worksheetById(0);
    final value = await sheet!.values.map.allRows();

    for (final i in value!) {
      if (i['Wallet']!.toLowerCase() == address.toLowerCase()) {
        return true;
      }
    }
    return false;
  }

  Future<void> submitForm() async {
    
    if (pin == '') pin = await Component.pinDialogBox(context);
  
    print("_airDropProvider!.getPrivateKey ${_airDropProvider!.getPrivateKey}");

    await fetchSigned();

    _airDropProvider!.setPrivateKey = (pin != '' ? await AppServices.getPrivateKey(pin, context) : pin)!;
    dialogLoading(context);
    // final gsheets = GSheets(AppConfig.credentials);
    // fetch spreadsheet by its id
    // final ss = await gsheets.spreadsheet(_spreadsheetId);
    // get worksheet by its title
    Map<String, dynamic> dbSignData = {};

    // final sheet = ss.worksheetById(0);
    print("submitForm");
    try {
      print("Value $value");
      int date = int.parse(value!['Date']);

      final byte32 = await _airDropProvider!.encodeRS(context, value!['r'], value!['s']);
      bool claimOut = await _airDropProvider!.isClaimOut(value!, byte32, context: context);
      // bool claimOut = false;
      print("claimOut $claimOut");
      if ( claimOut == false && DateTime.now().millisecondsSinceEpoch < date){
        print("Claim Success");

        // Close Dialog
        Navigator.pop(context);

        await enableAnimation();
      } else {
        // Close Dialog
        Navigator.pop(context);
      }

      // print("After $value");

      // if (value != null){

      //   int date = int.parse(value['Date']);

      //   print((DateTime.now().millisecondsSinceEpoch - date));

      //   print("DateTime.now().millisecondsSinceEpoch > date ${DateTime.now().millisecondsSinceEpoch > date}");

      //   print("DateTime.now().millisecondsSinceEpoch ${DateTime.now().millisecondsSinceEpoch}");

      //   dbSignData = await StorageServices.fetchData(DbKey.signData);

      //   print("dbSignData['first'] ${dbSignData}");

      //   if (value['attempt'] == 1){
          
      //     // In case No fee to do transaction Reuse old hash.
      //     // Reuse Because First Time Sign To DB will take long time to response and Response 504
      //     if (dbSignData.containsKey('isErrorFee')){
      //       print("isErrorFee");
      //       final byte32 = await _airDropProvider!.encodeRS(context, value['r'], value['s']);
      //       await claim(value, byte32);

      //       // In Case Have Fee and Success Claim With Old Hash
      //       // Need to remove isErrorFee key
      //       dbSignData.remove('isErrorFee');
      //       await StorageServices.storeData(dbSignData, DbKey.signData);
      //     }

      //     else if (DateTime.now().millisecondsSinceEpoch > date){
      //       print("DateTime.now().millisecondsSinceEpoch > date");
      //       final byte32 = await _airDropProvider!.encodeRS(context, value['r'], value['s']);
      //       await claim(value, byte32);
      //     } 
      //     // Condition Prevent Message From First Time Sign 
      //     else if (dbSignData['first'] == false) {
      //       await showDialog(
      //         context: context,
      //         builder: (context) {
      //           return AlertDialog(
      //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      //             title: Align(
      //               child: Text('Message'),
      //             ),
      //             content: Padding(
      //               padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
      //               child: Text("Please wait for 1 hour.\nYour remain time is ${
      //                 (date - DateTime.now().millisecondsSinceEpoch)
      //                 // formatDate( DateTime.parse( (DateTime.now().millisecondsSinceEpoch - date).toString() ).toLocal(), [
      //                 //   ':',
      //                 //   nn,
      //                 //   ':',
      //                 //   ss,
      //                 // ])
      //               }", textAlign: TextAlign.center),
      //             ),
      //             actions: <Widget>[
      //               TextButton(
      //                 onPressed: () => Navigator.pop(context),
      //                 child: const Text('Close'),
      //               ),
      //             ],
      //           );
      //         },
      //       );
      //     }

      //     // This condition for only first time
      //     if (dbSignData['first'] == true){
      //       final byte32 = await _airDropProvider!.encodeRS(context, value['r'], value['s']);
      //       await claim(value, byte32);
            
      //       // Update And Restore Sign Data
      //       dbSignData['first'] = false;
      //       await StorageServices.storeData(dbSignData, DbKey.signData);
      //     }
      //   }

    } catch (e) {
      print("Error submitForm ${e}");
      Navigator.pop(context);

      if (e.toString() == 'Exception: RPCError: got code 3 with msg "execution reverted: Your message is not signed by admin.".'){
        print("Re submit");
        await StorageServices.removeKey(DbKey.signData);
        await submitForm();
      } else {

        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              title: Align(
                child: Text('Opps'),
              ),
              content: Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Text(e.toString()),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );

      }
    }

  }

  Future<void> enableAnimation() async {
    flareController.play('Checkmark');

    setState(() {
      _submitted = true;
    });
    await StorageServices.setUserID('claim', 'claim');
    // Provider.of<ContractProvider>(context, listen: false).getBscBalance();
    // Provider.of<ContractProvider>(context, listen: false).getBnbBalance();

    Timer(const Duration(seconds: 3), () {
      setState(() {
        _submitted = false;
      });
    //   Navigator.pushNamedAndRemoveUntil(context, Home.route, ModalRoute.withName('/'));
    });
  }

  Future<void> pasteDataToClipboard() async {
    final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);

    _referralController!.text = data!.text!;
    _referralController!.selection = TextSelection.fromPosition(TextPosition(offset: _referralController!.text.length));
    setState(() {});
  }

  void initAirDrop() async {
    print("initAirDrop");
    await StorageServices.fetchData(DbKey.signData);
    await Future.delayed(Duration(milliseconds: 100), () async {

      _airDropProvider = Provider.of<AirDropProvider>(context, listen: false);
      await _airDropProvider!.initContract();
      _airDropProvider!.setConProvider(Provider.of<ContractProvider>(context, listen: false), context);
      await _airDropProvider!.airdropTokenAddress();
      await _airDropProvider!.signIn();
      
    });
  }

  Future<void> fetchSigned() async {
    value = await Provider.of<AirDropProvider>(context, listen: false).signToDb();

    setState(() {
      amount = value!['amount'];
    });
  }

  @override
  void initState() {
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _walletController = TextEditingController();
    _socialController = TextEditingController();
    _referralController = TextEditingController();

    _emailFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
    _walletFocusNode = FocusNode();
    _socialFocusNode = FocusNode();

    initAirDrop();

    super.initState();
  }

  @override
  void dispose() {
    _emailController?.dispose();
    _phoneController?.dispose();
    _walletController?.dispose();
    _socialController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _walletController!.text = Provider.of<ContractProvider>(context).ethAdd;
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    final contractPro = Provider.of<ContractProvider>(context);
    return Scaffold(
      body: NetworkSensitive(
        child: BodyScaffold(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Column(
                children: [

                  MyAppBar(
                    title: 'Claim Airdrop',
                    color: isDarkTheme
                      ? hexaCodeToColor(AppColors.darkCard)
                      : hexaCodeToColor(AppColors.whiteHexaColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  Expanded(
                    child: Form(
                      key: airdropKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // Container(
                            //   padding: const EdgeInsets.all(20),
                            //   width: MediaQuery.of(context).size.width,
                            //   child: ClipRRect(
                            //     borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            //     child: Image.asset(
                            //       'assets/bep20.png',
                            //       height: 180,
                            //       fit: BoxFit.cover,
                            //     ),
                            //   ),
                            // ),
                            
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: isDarkTheme
                                  ? hexaCodeToColor(AppColors.darkCard)
                                  : hexaCodeToColor(AppColors.whiteHexaColor),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [shadow(context)]
                              ),
                              child: Column(
                                children: [

                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: 
                                      isDarkTheme
                                        ? hexaCodeToColor(AppColors.darkBgd)
                                        : Colors.grey[300],//hexaCodeToColor(AppColors.whiteColorHexa),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        
                                        MyText(
                                          width: double.infinity,
                                          text: 'Address',
                                          fontWeight: FontWeight.bold,
                                          color: isDarkTheme
                                            ? AppColors.darkSecondaryText
                                            : AppColors.textColor,
                                          textAlign: TextAlign.left,
                                          bottom: 10.0,
                                        ),

                                        MyText(
                                          width: double.infinity,
                                          text: contractPro.ethAdd,
                                          fontWeight: FontWeight.bold,
                                          color: isDarkTheme
                                            ? AppColors.darkSecondaryText
                                            : AppColors.textColor,
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 24,
                                          bottom: 4.0,
                                        )

                                      ],
                                    ),
                                  ),

                                  MyText(
                                    top: 16.0,
                                    width: double.infinity,
                                    text: " 🟢 Status: ${amount == '0' ? '0' : (amount.replaceRange(2, amount.length, ''))} SEL available to claim",
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.left,
                                    color: isDarkTheme
                                      ? AppColors.darkSecondaryText
                                      : AppColors.textColor,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ]
                              ),
                            ),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyText(
                                  top: 16.0,
                                  pBottom: 16.0,
                                  left: 16.0,
                                  width: double.infinity,
                                  text: "Share the airdrop with your friends and family",
                                  fontWeight: FontWeight.bold,
                                  color: isDarkTheme
                                    ? AppColors.darkSecondaryText
                                    : AppColors.textColor,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  bottom: 4.0,
                                ),
                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Colors.white),
                                        padding: MaterialStateProperty.all(EdgeInsets.all(8)),
                                        shape: MaterialStateProperty.all(CircleBorder())
                                      ),
                                      onPressed: () async {
                                        final social = _airDropProvider!.urls[SocialMedia.twitter];
                                        if (await canLaunch(social)){
                                          await launch(social);
                                        }
                                      }, 
                                      child: SvgPicture.asset("assets/logo/twitter.svg", width: iconSize, height: iconSize,),
                                    ),

                                    SizedBox(width: 10,),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Colors.white),
                                        padding: MaterialStateProperty.all(EdgeInsets.all(8)),
                                        shape: MaterialStateProperty.all(CircleBorder())
                                      ),
                                      onPressed: () async {
                                        final social = _airDropProvider!.urls[SocialMedia.facebook];
                                        if (await canLaunch(social)){
                                          await launch(social);
                                        }
                                      }, 
                                      child: SvgPicture.asset("assets/logo/facebook.svg", width: iconSize, height: iconSize),
                                    ),
                                    SizedBox(width: 10,),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Colors.white),
                                        padding: MaterialStateProperty.all(EdgeInsets.all(8)),
                                        shape: MaterialStateProperty.all(CircleBorder())
                                      ),
                                      onPressed: () async {
                                        final social = _airDropProvider!.urls[SocialMedia.telegram];
                                        if (await canLaunch(social)){
                                          await launch(social);
                                        }
                                      }, 
                                      child: SvgPicture.asset("assets/logo/telegram.svg", width: iconSize, height: iconSize),
                                    )
                                  ],
                                )
                                
                              ]
                            ),

                            AirDropDes(),
                            
                            const SizedBox(height: 20),
                            MyFlatButton(
                              textButton: "Claim",
                              edgeMargin: const EdgeInsets.only(
                                top: 40,
                                left: 66,
                                right: 66,
                              ),
                              hasShadow: _enableButton,
                              action: submitForm//_enableButton ? submitForm : null,
                            ),
                            const SizedBox(height: 200),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_submitted == false)
                Container()
              else
                BackdropFilter(
                  // Fill Blur Background
                  filter: ImageFilter.blur(
                    sigmaX: 5.0,
                    sigmaY: 5.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: CustomAnimation.flareAnimation(
                          flareController,
                          "assets/animation/check.flr",
                          "Checkmark",
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}