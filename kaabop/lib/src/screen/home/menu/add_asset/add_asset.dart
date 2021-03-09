import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/models/token.m.dart';
import 'package:wallet_apps/src/provider/wallet_provider.dart';

class AddAsset extends StatefulWidget {
  final CreateAccModel sdkModel;
  AddAsset(this.sdkModel);
  static const route = '/addasset';
  @override
  State<StatefulWidget> createState() {
    return AddAssetState();
  }
}

class AddAssetState extends State<AddAsset> {
  ModelAsset _modelAsset = ModelAsset();

  FlareControls _flareController = FlareControls();

  GlobalKey<ScaffoldState> globalKey = new GlobalKey<ScaffoldState>();
  List<TokenModel> _token = [];

  @override
  void initState() {
    _modelAsset.result = {};
    _modelAsset.match = false;
    AppServices.noInternetConnection(globalKey);
    initContract();
    listToken();
    super.initState();
  }

  Future<bool> validateAddress(String address) async {
    final res = await widget.sdkModel.sdk.api.keyring.validateAddress(address);
    return res;
  }

  void validateAllFieldNotEmpty() {
    // Validator 1 : All Field Not Empty
    if (_modelAsset.controllerAssetCode.text.isNotEmpty &&
        _modelAsset.controllerIssuer.text.isNotEmpty) {
      validateAllFieldNoError();
    } else if (_modelAsset.enable)
      enableButton(false); // Disable Button If All Field Not Empty
  }

  void validateAllFieldNoError() {
    if (_modelAsset.responseAssetCode == null &&
        _modelAsset.responseIssuer == null) {
      enableButton(true); // Enable Button If All Field Not Empty
    } else if (_modelAsset.enable)
      enableButton(false); // Disable Button If All Field Not Empty
  }

  void enableButton(bool enable) {
    setState(() {
      _modelAsset.enable = enable;
    });
  }

  void onChanged(String textChange) {
    _modelAsset.formStateAsset.currentState.validate();
    enableButton(true);
  }

  void listToken() async {
    _token.add(TokenModel(
      logo: widget.sdkModel.contractModel.ptLogo,
      symbol: widget.sdkModel.contractModel.pTokenSymbol,
      org: widget.sdkModel.contractModel.pOrg,
      color: Colors.black,
    ));
    _token.add(TokenModel(
      logo: widget.sdkModel.contractModel.attendantM.attLogo,
      symbol: widget.sdkModel.contractModel.attendantM.aSymbol,
      org: widget.sdkModel.contractModel.attendantM.aOrg,
      color: Colors.transparent,
    ));
  }

  void addAsset(String symbol) async {
    dialogLoading(context);
    setState(() {
      widget.sdkModel.contractModel.isContain = true;
    });
    await _contractSymbol();
    await _getHashBySymbol().then((value) async {
      await _balanceOfByPartition();
    });
    await StorageServices.saveBool('KMPI', true);
    enableAnimation();
  }

  void addAssetInSearch(String symbol) async {
    if (symbol == 'KMPI') {
      widget.sdkModel.contractModel.isContain = true;
      await _contractSymbol();
      await _getHashBySymbol().then((value) async {
        await _balanceOfByPartition();
      });
      setPortfolio();
      await StorageServices.saveBool('KMPI', true);
      Navigator.pushNamedAndRemoveUntil(
          context, Home.route, ModalRoute.withName('/'));
    } else {
      setState(() {
        widget.sdkModel.contractModel.attendantM.isAContain = true;
      });
      await initAttendant();
      await StorageServices.saveBool(
        widget.sdkModel.contractModel.attendantM.aSymbol,
        true,
      );
      Navigator.pushNamedAndRemoveUntil(
          context, Home.route, ModalRoute.withName('/'));
    }
  }

  Future<void> initAttendant() async {
    await widget.sdkModel.sdk.api.initAttendant();
    //print(res);
    await getToken().then((value) {
      addATT();
    });
  }

  Future<void> initContract() async {
    await widget.sdkModel.sdk.api.callContract().then((value) {
      widget.sdkModel.contractModel.pContractAddress = value;
    });
  }

  Future<void> _contractSymbol() async {
    try {
      final res = await widget.sdkModel.sdk.api
          .contractSymbol(widget.sdkModel.keyring.keyPairs[0].address);
      if (res != null) {
        setState(() {
          widget.sdkModel.contractModel.pTokenSymbol = res[0];
        });
      }
    } catch (e) {
      //print(e.toString());
    }
  }

  Future<void> _getHashBySymbol() async {
    try {
      final res = await widget.sdkModel.sdk.api.getHashBySymbol(
        widget.sdkModel.keyring.keyPairs[0].address,
        widget.sdkModel.contractModel.pTokenSymbol,
      );

      if (res != null) {
        widget.sdkModel.contractModel.pHash = res;
      }
    } catch (e) {
      //print(e.toString());
    }
  }

  Future<void> _balanceOfByPartition() async {
    try {
      final res = await widget.sdkModel.sdk.api.balanceOfByPartition(
        widget.sdkModel.keyring.keyPairs[0].address,
        widget.sdkModel.keyring.keyPairs[0].address,
        widget.sdkModel.contractModel.pHash,
      );

      widget.sdkModel.contractModel.pBalance =
          BigInt.parse(res['output']).toString();
    } catch (e) {
      //print(e.toString());
    }
  }

  Future<void> getToken() async {
    final res = await widget.sdkModel.sdk.api
        .getAToken(widget.sdkModel.keyring.keyPairs[0].address);
    print(res);
    widget.sdkModel.contractModel.attendantM.aBalance =
        BigInt.parse(res).toString();
  }

  void addATT() {
    var walletProvider = Provider.of<WalletProvider>(context, listen: false);

    walletProvider.addAvaibleToken({
      'symbol': widget.sdkModel.contractModel.attendantM.aSymbol,
      'balance': widget.sdkModel.contractModel.attendantM.aBalance,
    });

    Provider.of<WalletProvider>(context, listen: false).getPortfolio();
  }

  void setPortfolio() {
    var walletProvider = Provider.of<WalletProvider>(context, listen: false);
    // walletProvider.clearPortfolio();
    // walletProvider.updateAvailableToken({
    //   'symbol': widget.sdkModel.contractModel.pTokenSymbol,
    //   'balance': widget.sdkModel.contractModel.pBalance,
    // });
    walletProvider.addAvaibleToken({
      'symbol': widget.sdkModel.contractModel.pTokenSymbol,
      'balance': widget.sdkModel.contractModel.pBalance,
    });

    Provider.of<WalletProvider>(context, listen: false).getPortfolio();
  }

  // void onSubmit() {
  //   if (_modelAsset.nodeAssetCode.hasFocus) {
  //     FocusScope.of(context).requestFocus(_modelAsset.nodeIssuer);
  //   } else if (_modelAsset.nodeIssuer.hasFocus) {
  //     if (_modelAsset.enable) submitAsset(context);
  //   }
  // }

  Future enableAnimation() async {
    Navigator.pop(context);
    setState(() {
      _modelAsset.added = true;
    });
    _flareController.play('Checkmark');
    Timer(Duration(milliseconds: 2500), () {
      Navigator.pop(context);
    });
  }

  void submitSearch(String symbol) async {
    // setState(() {
    //   _modelAsset.loading = true;
    // });
    if (symbol == 'KMPI') {
      await StorageServices.readBool('KMPI').then((value) async {
        if (!value) {
          addAssetInSearch(symbol);
        } else {
          await dialog(context, Text('This asset is already added!'),
              Text('Asset Added'));
        }
      });
    } else if (symbol == 'ATD') {
      await StorageServices.readBool('ATD').then((value) async {
        if (!value) {
          print(value);
          addAssetInSearch(symbol);
        } else {
          await dialog(context, Text('This asset is already added!'),
              Text('Asset Added'));
        }
      });
    }
  }

  void submitAsset() async {
    setState(() {
      _modelAsset.loading = true;
    });
    await StorageServices.readBool('KMPI').then((value) async {
      if (!value) {
        await validateAddress(_modelAsset.controllerAssetCode.text)
            .then((value) async {
          //print(value);
          if (value) {
            if (_modelAsset.controllerAssetCode.text ==
                widget.sdkModel.contractModel.pContractAddress) {
              setState(() {
                _modelAsset.match = true;
                _modelAsset.loading = false;
              });
            } else {
              setState(() {
                _modelAsset.loading = false;
                _modelAsset.controllerAssetCode.text = '';
              });
              await dialog(context, Text('Failed to find asset by address.'),
                  Text('Asset not found'));
            }
          } else {
            setState(() {
              _modelAsset.loading = false;
            });
            await dialog(context, Text('Please fill in a valid address!'),
                Text('Invalid Address'));
          }
        });
      } else {
        setState(() {
          _modelAsset.loading = false;
        });
        await dialog(
            context, Text('This asset is already added!'), Text('Asset Added'));
      }
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

  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            AddAssetBody(
              assetM: _modelAsset,
              popScreen: popScreen,
              onChanged: onChanged,
              onSubmit: null,
              submitAsset: submitAsset,
              addAsset: addAsset,
              submitSearch: submitSearch,
              token: _token,
              sdkModel: widget.sdkModel,
              qrRes: qrRes,
            ),
            _modelAsset.added == false
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
                          child: CustomAnimation.flareAnimation(
                              _flareController,
                              "assets/animation/check.flr",
                              "Checkmark"),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
