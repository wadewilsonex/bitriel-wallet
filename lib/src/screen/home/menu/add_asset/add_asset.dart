import 'dart:ui';
import 'package:lottie/lottie.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/get_request.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';

class AddAsset extends StatefulWidget {
  static const route = '/addasset';

  final int? network;

  const AddAsset({Key? key, this.network = 0}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddAssetState();
  }
}

class AddAssetState extends State<AddAsset> {

  final ModelAsset _modelAsset = ModelAsset();

  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  
  String _tokenSymbol = '';
  int? initialValue;

  List<Map<String, dynamic>>? networkSymbol;

  List searchResults = [];

  List<Map<String, dynamic>>? getContractData = [];
  List<Map<String, dynamic>>? initContractData = [];
  String queryContractAddress = '';

  MarketProvider? mkPro;

  void onChangedQuery(dynamic v) { 
    setState(() {
      queryContractAddress = v;
      setResults(queryContractAddress);
    });
  }

  void setResults(String query) {
    searchResults = getContractData!
      .where((elem) =>
          elem['symbol']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          elem['name']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          elem['platforms']["binance_smart_chain"]
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase()) || 
          elem['platforms']["ethereum"]
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase()))
      .toList();
  }

  void onTapGetContractData(int index) {
    setState(() {
      _modelAsset.controllerAssetCode.text = getContractData![index]['platforms'][ initialValue == 0 ? "binance_smart_chain" : "ethereum"];
      queryContractAddress = getContractData![index]['platforms'][ initialValue == 0 ? "binance_smart_chain" : "ethereum"];
      setResults(queryContractAddress);
    });
  }

  void onTapGetResult(int index) {
    setState(() {
      _modelAsset.controllerAssetCode.text = searchResults[index]['platforms'][ initialValue == 0 ? "binance_smart_chain" : "ethereum"];
      queryContractAddress = searchResults[index]['platforms'][ initialValue == 0 ? "binance_smart_chain" : "ethereum"];
      setResults(queryContractAddress);
    });
  }
  
  @override
  void initState() {

    mkPro = Provider.of<MarketProvider>(context, listen: false);

    getContractAddress().then((value) => {
      initContractData = List<Map<String, dynamic>>.from(jsonDecode(value.body)),
    }).then((value) => {
      filterByChain(),
    });

    _modelAsset.result = {};
    _modelAsset.match = false;
    initialValue = widget.network;

    networkSymbol = [
      {"symbol": "BSC", "index": 0, "logo": "${Provider.of<AppProvider>(context, listen: false).dirPath}/token_logo/bnb.png"},
      {"symbol":"Ethereum", "index": 1, "logo": "${Provider.of<AppProvider>(context, listen: false).dirPath}/token_logo/eth.png"}
    ];
    
    AppServices.noInternetConnection(context: context);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void filterByChain() {

    if(initialValue == 0) {
      getContractData = initContractData!.where( (element) {
        if (element['platforms'].containsKey('binance_smart_chain')) return true;
        return false;
      }).toList();
    }
    else if(initialValue == 1){
      getContractData = initContractData!.where( (element) {
        if (element['platforms'].containsKey('ethereum')) return true;
        return false;
      }).toList();
    }

    setState(() {
      
    });
  }

  Future<bool> validateEtherAddress(String address) async {
    try {

      final res = await Provider.of<ApiProvider>(context, listen: false).validateEther(address);
      return res;
    } catch (e) {
      
        if (kDebugMode) {
          debugPrint("Error validateEtherAddress $e");
        }
      
    }
    return false;
  }

  Future<bool> validateAddress(String address) async {
    try {

      final res = await Provider.of<ApiProvider>(context, listen: false).validateAddress(address);
      return res;
    } catch (e) {
      
        if (kDebugMode) {
          debugPrint("Error validateAddress $e");
        }
      
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

    FocusScope.of(context).unfocus();
    
    try {

      final lsContract = Provider.of<ContractProvider>(context, listen: false).sortListContract;
      for (var element in lsContract) {
        if (_modelAsset.controllerAssetCode.text == (ApiProvider().isMainnet ? element.contract : element.contractTest)){
          _modelAsset.added = true;
        }
      }

      if (_modelAsset.added){
        _modelAsset.added = false;
        if(!mounted) return;
        Navigator.pop(context);
        
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              title: const Align(
                child: Text('Oops'),
              ),
              content: const Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Text(
                "This contract address already in your list",
                textAlign: TextAlign.center
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(paddingSize),
                  child: MyGradientButton(
                    textButton: "Close",
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    action: () => Navigator.pop(context),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        
        await Provider.of<ContractProvider>(context, listen: false).addToken(
          _tokenSymbol,
          context,
          network: networkSymbol![initialValue!]['symbol'],
          contractAddr: _modelAsset.controllerAssetCode.text,
        );

        if (mkPro!.queried!.isNotEmpty){
          MarketProvider.id.add(mkPro!.queried!['id']);
        }
        
        if(!mounted) return;
        await Provider.of<ContractProvider>(context, listen: false).sortAsset();

        /* --------------After Fetch Contract Balance Need To Save To Storage Again-------------- */
        if(!mounted) return;
        await StorageServices.storeAssetData(context);
        await enableAnimation();
      }
    } catch (e) {

      // Close Dialog Loading
      Navigator.pop(context);
      
        if (kDebugMode) {
          debugPrint("Error addAsset $e");
        }
      

      DialogComponents().dialogCustom(
        context: context,
        titles: "Opps",
        contents: e.toString(),
        btn2: MyGradientButton(
          textButton: "Close",
          textColor: AppColors.lowWhite,
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          action: () async {
            Navigator.pop(context);
          },
        )
      );
    }
  }

  Future<void> submitAsset() async {
    try {

      dialogLoading(context, animationAsset: "assets/animation/loading-files.json");
    
      setState(() {
        _tokenSymbol = "";
        _modelAsset.loading = true;
      });

      // Validate For ERC-20 || BEP-20
      final resEther = await Provider.of<ApiProvider>(context, listen: false).validateEther(_modelAsset.controllerAssetCode.text);//validateEtherAddress(_modelAsset.controllerAssetCode.text);
      // Validate For Substrate Address
      if(!mounted) return;
      final res = await Provider.of<ApiProvider>(context, listen: false).validateAddress(_modelAsset.controllerAssetCode.text);
      if (res || resEther) {

        // Check And Add Address ERC-20 || BEP-20
        if (initialValue == 1) { // 1 = Ethereum

          await searchEtherContract();

          if (!mounted) return;
          await Provider.of<MarketProvider>(context, listen: false).searchCoinFromMarket(_tokenSymbol);
        } 
        else {

          if(!mounted) return;
          final res = await Provider.of<ContractProvider>(context, listen: false).query(_modelAsset.controllerAssetCode.text, 'symbol', []);
          
          _tokenSymbol = res[0].toString();

          debugPrint("_tokenSymbol $_tokenSymbol");

          if (!mounted) return;
          await mkPro!.searchCoinFromMarket(_tokenSymbol);

          if (!mounted) return;
          if (mkPro!.lsCoin!.isNotEmpty) {
            
            setState(() {
              _modelAsset.logo = Provider.of<MarketProvider>(context, listen: false).lsCoin![0]['large'];
            });
        
          }
        }
        
        if (mkPro!.lsCoin!.isNotEmpty){

          await mkPro!.queryCoinFromMarket(mkPro!.lsCoin![0]['id']);
        }

        setState(() {
          
          _modelAsset.loading = false;
        });

        await addAsset();
        
      } else {
        
        Navigator.pop(context);

        if(!mounted) return;
        DialogComponents().dialogCustom(
          context: context,
          titles: "Opps",
          contents: "Invalid token contract address!",
          btn2: MyGradientButton(
            textButton: "Close",
            textColor: AppColors.lowWhite,
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            action: () async {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          )
        );
        
        setState(() {
          _modelAsset.loading = false;
        });
      }
    } catch (e) {

      Navigator.pop(context);
      setState(() {_modelAsset.loading = false;});

      DialogComponents().dialogCustom(
        context: context,
        titles: "Opps",
        contents: "$e",
        btn2: MyGradientButton(
          textButton: "Close",
          textColor: AppColors.lowWhite,
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          action: () async {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        )
      );

      
        if (kDebugMode) {
          debugPrint("Error submitAsset $e");
        }
      
    }
  }

  Future<void> searchEtherContract() async {

    debugPrint("searchEtherContract ${_modelAsset.controllerAssetCode.text}");
    try {
      final res = await Provider.of<ContractProvider>(context, listen: false).queryEther(_modelAsset.controllerAssetCode.text, 'symbol', []);
      debugPrint("Res $res");
      if (res != null) {
        setState(() {
          _tokenSymbol = res[0].toString();
          _modelAsset.loading = false;
        });
      }
    } catch (e) {
      
        if (kDebugMode) {
          debugPrint("Error searchEtherContract $e");
        }
      
      throw Exception(e);
    }
  }

  void onSubmit() async {
    submitAsset();
  }

  String? onChanged(String textChange) {
    if (_modelAsset.controllerAssetCode.text.isNotEmpty) {
      enableButton(true);
    } else {
      enableButton(false);
    }

    return null;
  }

  void onChangeNetwork(String network) {
    initialValue = int.parse(network);
    filterByChain();
  }

  void qrRes(String value) {
    // if (value != null) {
    if (value.isNotEmpty) {
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

    await Future.delayed(const Duration(seconds: 1), () {
      // Navigator.pushNamedAndRemoveUntil(context, Home.route, ModalRoute.withName('/'));
      Navigator.pushReplacement(context, Transition(child: const HomePage(activePage: 1,), transitionEffect: TransitionEffect.LEFT_TO_RIGHT,));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        backgroundColor: isDarkMode ? hexaCodeToColor(AppColors.darkBgd) : hexaCodeToColor(AppColors.lightColorBg),
        iconTheme: IconThemeData(
          color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor)
        ),
        elevation: 0,
        bottomOpacity: 0,
        title: MyText(
          text: "Add Custom Token",
          hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Iconsax.arrow_left_2,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 30,
          ),
        ),
      ),
      body: Stack(
        children: [

          AddAssetBody(
            assetM: _modelAsset,
            initialValue: initialValue,
            onChangeNetwork: onChangeNetwork,
            addAsset: addAsset,
            popScreen: popScreen,
            onChanged: onChanged,
            qrRes: qrRes,
            tokenSymbol: _tokenSymbol,
            onSubmit: onSubmit,
            networkSymbol: networkSymbol,
            submitAsset: submitAsset,
            onChangedQuery: onChangedQuery,
            setResults: setResults,
            onTapGetResult: onTapGetResult,
            onTapGetContractData: onTapGetContractData,
            getContractData: getContractData,
            queryContractAddress: queryContractAddress,
            searchResultsData: searchResults
          ),

          (_modelAsset.added == false)
          ? Container()
          : BackdropFilter(
              // Fill Blur Background
              filter: ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Lottie.asset(
                        "assets/animation/check.json",
                        alignment: Alignment.center,
                        width: 60.w,
                      )
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
