import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';

class AddAsset extends StatefulWidget {
  static const route = '/addasset';
  @override
  State<StatefulWidget> createState() {
    return AddAssetState();
  }
}

class AddAssetState extends State<AddAsset> {

  final ModelAsset _modelAsset = ModelAsset();

  final FlareControls _flareController = FlareControls();

  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  FlareControls flareController = FlareControls();
  
  String _tokenSymbol = '';
  int initialValue = 0;

  List<Map<String, dynamic>> networkSymbol = [
    {"symbol": "Binance Smart Chain", "index": 0},
    {"symbol":"Ethereum", "index": 1}
  ];

  @override
  void initState() {
    _modelAsset.result = {};
    _modelAsset.match = false;
    AppServices.noInternetConnection(globalKey);

    super.initState();
  }

  Future<bool> validateEtherAddress(String address) async {
    try {

      final res = await Provider.of<ApiProvider>(context, listen: false).validateEther(address);
      return res;
    } catch (e) {
      print("Error validateEtherAddress $e");
    }
    return false;
  }

  Future<bool> validateAddress(String address) async {
    try {

      final res = await Provider.of<ApiProvider>(context, listen: false).validateAddress(address);
      return res;
    } catch (e) {
      print("Error validateAddress $e");
    }
    return false;
  }

  void validateAllFieldNotEmpty() {
    // Validator 1 : All Field Not Empty
    if (_modelAsset.controllerAssetCode.text.isNotEmpty &&  _modelAsset.controllerIssuer.text.isNotEmpty) {
      validateAllFieldNoError();
    } else if (_modelAsset.enable) {
      enableButton(false);
    } // Disable Button If All Field Not Empty
  }

  void validateAllFieldNoError() {
    if (_modelAsset.responseAssetCode == null && _modelAsset.responseIssuer == null) {
      enableButton(true); // Enable Button If All Field Not Empty
    } else if (_modelAsset.enable) {
      enableButton(false);
    } // Disable Button If All Field Not Empty
  }

  // ignore: avoid_positional_boolean_parameters
  void enableButton(bool enable) {
    setState(() {
      _modelAsset.enable = enable;
    });
  }

  Future<void> addAsset() async {

    bool isMatch = false;
    
    try {

      dialogLoading(context);

      final lsContract = await Provider.of<ContractProvider>(context, listen: false).listContract;
      lsContract.forEach((element) async {
        if (_modelAsset.controllerAssetCode.text == element.address){
          isMatch = true;
        }
      });

      if (isMatch){

        Navigator.pop(context);
        
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              title: Align(
                child: Text('Oops'),
              ),
              content: Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Text(
                "This contract address already in your list",
                textAlign: TextAlign.center
                ),
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
      } else {
        
        await Provider.of<ContractProvider>(context, listen: false).addToken(
          _tokenSymbol,
          context,
          network: networkSymbol[initialValue]['symbol'],
          contractAddr: _modelAsset.controllerAssetCode.text,
        );

        await Provider.of<ContractProvider>(context, listen: false).sortAsset();

        /* --------------After Fetch Contract Balance Need To Save To Storage Again-------------- */
        await StorageServices.storeAssetData(context);
        await enableAnimation();
      }
    } catch (e) {
      print("Error addAsset $e");
    }
  }

  Future<void> submitAsset() async {
    try {
    
      setState(() {
        _modelAsset.loading = true;
      });

      final resEther = await Provider.of<ApiProvider>(context, listen: false).validateEther(_modelAsset.controllerAssetCode.text);//validateEtherAddress(_modelAsset.controllerAssetCode.text);

      final res = await Provider.of<ApiProvider>(context, listen: false).validateAddress(_modelAsset.controllerAssetCode.text);

      if (res || resEther) {
        if (res) {
          if (_modelAsset.controllerAssetCode.text == AppConfig.kmpiAddr) {
            setState(() {
              _modelAsset.match = true;
              _modelAsset.loading = false;
            });
          }
        } else {

          if (initialValue == 'Ethereum') {
            await searchEtherContract();
          } else {
            final res = await Provider.of<ContractProvider>(context, listen: false).query(_modelAsset.controllerAssetCode.text, 'symbol', []);
            _tokenSymbol = res[0].toString();
          }
          setState(() {
          
            _modelAsset.loading = false;
          });
        }
      } else {
        
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10.0)),
              title: Align(
                child: Text('Opps'),
              ),
              content: Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Text('Invalid token contract address!'),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ]
            );
          },
        );
        //await dialog('Invalid token contract address!', 'Opps');
        setState(() {
          _modelAsset.loading = false;
        });
      }
    } catch (e) {
      setState(() {
      
        _modelAsset.loading = false;
      });

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            title: Align(
              child: Text('Oops'),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Text(
              "$e",
              textAlign: TextAlign.center
              ),
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
      print("Error submitAsset $e");
    }
  }

  Future<void> searchEtherContract() async {
    try {
      final res = await Provider.of<ContractProvider>(context, listen: false).queryEther(_modelAsset.controllerAssetCode.text, 'symbol', []);
      if (res != null) {
        setState(() {
          _tokenSymbol = res[0].toString();
          _modelAsset.loading = false;
        });
      }
    } catch (e) {
      print("Error searchEtherContract $e");
    }
  }

  void onSubmit() {
    if (_modelAsset.formStateAsset.currentState!.validate()) {
      submitAsset();
    }
  }

  String? onChanged(String textChange) {
    if (_modelAsset.controllerAssetCode.text.isNotEmpty) {
      enableButton(true);
    } else {
      enableButton(false);
    }

    return null;
  }

  void onChangeDropDown(String network) {
    setState(() {
      initialValue = int.parse(network);
    });
  }

  void qrRes(String value) {
    if (value != null) {
      setState(() {
        _modelAsset.controllerAssetCode.text = value;
        _modelAsset.enable = true;
      });
    }
  }

  void popScreen() {
    Navigator.pop(context, {});
  }

  Future<void> enableAnimation() async {

    Navigator.pop(context);
    setState(() {
      _modelAsset.added = true;
    });
    flareController.play('Checkmark');

    Timer(const Duration(milliseconds: 2500), () {
      Navigator.pushNamedAndRemoveUntil(context, Home.route, ModalRoute.withName('/'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: Stack(
        children: [
          AddAssetBody(
            assetM: _modelAsset,
            initialValue: initialValue.toString(),
            onChangeDropDown: onChangeDropDown,
            addAsset: addAsset,
            popScreen: popScreen,
            onChanged: onChanged,
            qrRes: qrRes,
            tokenSymbol: _tokenSymbol,
            onSubmit: onSubmit,
            networkSymbol: networkSymbol,
            submitAsset: submitAsset,
          ),
          (_modelAsset.added == false)
          ? Container()
          : BackdropFilter(
              // Fill Blur Background
              filter: ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: CustomAnimation.flareAnimation(_flareController, AppConfig.animationPath+"check.flr", "Checkmark"),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
