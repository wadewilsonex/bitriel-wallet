import 'dart:ui';
import 'package:gsheets/gsheets.dart';
import 'package:wallet_apps/presentation/components/network_sensitive.dart';
import 'package:wallet_apps/constants/db_key_con.dart';
import 'package:wallet_apps/data/provider/airdrop_p.dart';
import 'package:wallet_apps/presentation/screen/home/claim_airdrop/intro_airdrop.dart';

import '../../../../index.dart';

class ClaimAirDrop extends StatefulWidget {
  const ClaimAirDrop({Key? key}) : super(key: key);

  @override
  ClaimAirDropState createState() => ClaimAirDropState();
}

class ClaimAirDropState extends State<ClaimAirDrop> {

  TextEditingController? _emailController;
  TextEditingController? _phoneController;
  TextEditingController? _walletController;
  TextEditingController? _socialController;
  TextEditingController? _referralController;
  FocusNode? _emailFocusNode;
  FocusNode? _phoneFocusNode;

  final airdropKey = GlobalKey<FormState>();

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


    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: const Align(
            child: Text('Opps'),
          ),
          content: const Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: MyText(text: "Airdrop has ended the session. \nPlease wait for another airdrop."),
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

  Future<void> enableAnimation() async {

    setState(() {
      _submitted = true;
    });
    await StorageServices.setUserID('claim', DbKey.claim);

    Timer(const Duration(seconds: 3), () {
      setState(() {
        _submitted = false;
      });
      
    });
  }

  Future<void> pasteDataToClipboard() async {
    final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);

    _referralController!.text = data!.text!;
    _referralController!.selection = TextSelection.fromPosition(TextPosition(offset: _referralController!.text.length));
    setState(() {});
  }

  void initAirDrop() async {
    
    await Future.delayed(const Duration(milliseconds: 100), () async {

      _airDropProvider = Provider.of<AirDropProvider>(context, listen: false);
      _airDropProvider!.setConProvider(Provider.of<ContractProvider>(context, listen: false), context);
      await _airDropProvider!.signIn();
      
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
     
    return Scaffold(
      body: NetworkSensitive(
        child: bodyScaffold(
          context,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Column(
                children: [

                  myAppBar(
                    context,
                    title: 'Claim Airdrop',
                    color: isDarkMode
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: SvgPicture.asset("${AppConfig.illustrationsPath}mainnet.svg", width: 270, height: 270,),
                            ),
                            
                            MyText(
                              text: "Celebrate Selendra Mainnet Launch\nShare 222 \$SEL in airdrop",
                              fontWeight: FontWeight.bold,
                              hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,
                              fontSize: 22,
                              bottom: 5.0,
                              top: 32.0,
                            ),
                            
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: isDarkMode
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
                                    margin: const EdgeInsets.only(bottom: 16.0),
                                    decoration: BoxDecoration(
                                      color: 
                                      isDarkMode
                                        ? hexaCodeToColor(AppColors.darkBgd)
                                        : Colors.grey[300],//hexaCodeToColor(AppColors.whiteColorHexa),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        
                                        MyText(
                                          width: double.infinity,
                                          text: 'Address',
                                          fontWeight: FontWeight.bold,
                                          hexaColor: isDarkMode
                                            ? AppColors.darkSecondaryText
                                            : AppColors.textColor,
                                          textAlign: TextAlign.left,
                                          bottom: 10.0,
                                        ),

                                        // Consumer<ApiProvider>(
                                        //   builder: (context, provider, widget){
                                        //     return provider.getKeyring.current.address != null 
                                        //     ? MyText(
                                        //       width: double.infinity,
                                        //       text: provider.getKeyring.current.address,
                                        //       fontWeight: FontWeight.bold,
                                        //       hexaColor: isDarkMode
                                        //         ? AppColors.darkSecondaryText
                                        //         : AppColors.textColor,
                                        //       textAlign: TextAlign.left,
                                        //       overflow: TextOverflow.ellipsis,
                                        //       fontSize: 24,
                                        //       bottom: 4.0,
                                        //     ) 
                                        //     : const ThreeDotLoading(width: 50, height: 30);
                                        //   },
                                        // )

                                      ],
                                    ),
                                  ),

                                  Consumer<ApiProvider>(
                                    builder: (context, provider, widget){
                                      return ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.red[900]),
                                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                                        ),
                                        onPressed: provider.getKeyring.current.address != null ? submitForm : null,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Positioned(
                                              left: 20,
                                              top: 15,
                                              child: SvgPicture.asset("${AppConfig.illustrationsPath}cloud1.svg", width: 50, height: 30),
                                            ),
                                            Positioned(
                                              right: 10,
                                              bottom: 15,
                                              child: SvgPicture.asset("${AppConfig.illustrationsPath}cloud2.svg", width: 50, height: 30),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                // color: Colors.black.withOpacity(0.35),
                                              ),
                                              width: double.infinity,
                                              height: 70,
                                            ),
                                            const MyText(text: 'Submit', top: 10, bottom: 10, hexaColor: AppColors.whiteColorHexa, fontWeight: FontWeight.bold, fontSize: 25,)
                                          ],
                                        ),
                                      );
                                    }
                                  ),

                                  const AirDropDes(),
                                ]
                              ),
                            ),
                            
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
                    children: const <Widget>[
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