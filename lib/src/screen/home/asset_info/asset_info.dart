import 'dart:ui';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
// import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_apps/src/components/component.dart';
import 'package:wallet_apps/src/models/tx_history.dart';
import 'package:wallet_apps/src/screen/home/asset_info/activity_list.dart';
import '../../../../index.dart';
import 'asset_detail.dart';

class AssetInfo extends StatefulWidget {
  final int? index;
  final SmartContractModel? scModel;

  // final String id;
  // final String assetLogo;
  // final String balance;
  // final String tokenSymbol;
  // final String org;
  // final String marketPrice;
  // final String priceChange24h;
  // final Market marketData;
  final List<TransactionInfo>? transactionInfo;
  final bool? showActivity;

  const AssetInfo({
    @required this.index,
    @required this.scModel,
    this.transactionInfo,
    this.showActivity
    // this.id,
    // this.assetLogo,
    // this.balance,
    // this.tokenSymbol,
    // this.org,
    // this.marketPrice,
    // this.priceChange24h,
    // this.marketData,
    // this.transactionInfo,
    // this.showActivity,
  });

  @override
  _AssetInfoState createState() => _AssetInfoState();
}

class _AssetInfoState extends State<AssetInfo> {
  
  final FlareControls _flareController = FlareControls();
  final ModelScanPay _scanPayM = ModelScanPay();
  final GetWalletMethod _method = GetWalletMethod();
  PageController controller = PageController();
  String totalUsd = '';

  int _tabIndex = 0;

  final TxHistory _txHistoryModel = TxHistory();

  final List<Map> _checkInList = [];
  final List<Map> _checkOutList = [];
  List<Map> _checkAll = [];
  GlobalKey<ScaffoldState>? _globalKey;

  Future enableAnimation() async {
    Navigator.pop(context);
    setState(() {
      _scanPayM.isPay = true;
    });
    _flareController.play('Checkmark');
    Timer(const Duration(milliseconds: 2500), () {
      Navigator.pushNamedAndRemoveUntil(context, Home.route, ModalRoute.withName('/'));
    });
  }

  Future<List<TxHistory>> readTxHistory() async {
    await StorageServices.fetchData('txhistory').then((value) {
      if (value != null) {
        for (final i in value) {
          // ignore: unnecessary_parenthesis
          if ((i['symbol'] == 'SEL')) {
            _txHistoryModel.tx.add(TxHistory(
              date: i['date'].toString(),
              symbol: i['symbol'].toString(),
              destination: i['destination'].toString(),
              sender: i['sender'].toString(),
              amount: i['amount'].toString(),
              org: i['fee'].toString(),
            ));
          } else {
            _txHistoryModel.txKpi.add(
              TxHistory(
                date: i['date'].toString(),
                symbol: i['symbol'].toString(),
                destination: i['destination'].toString(),
                sender: i['sender'].toString(),
                amount: i['amount'].toString(),
                org: i['fee'].toString(),
              ),
            );
          }
        }
      }
    });
    setState(() {});
    return _txHistoryModel.tx;
  }

  Future<void> deleteHistory(int index, String symbol) async {
    try {

      final SharedPreferences _preferences = await SharedPreferences.getInstance();

      if (symbol == 'SEL') {
        _txHistoryModel.tx.removeAt(index);
      } else {
        _txHistoryModel.txKpi.removeAt(index);
      }

      final newTxList = List.from(_txHistoryModel.tx)..addAll(_txHistoryModel.txKpi);

      await clearOldHistory().then((value) async {
        await _preferences.setString('txhistory', jsonEncode(newTxList));
      });

    } catch (e) {
      print("Error _deleteHistory $e");
    }
    return null;
  }

  Future<void> clearOldHistory() async {
    await StorageServices.removeKey('txhistory');
  }

  Future<void> refresh() async {
    await Future.delayed(const Duration(seconds: 3)).then((value) async {
      if (widget.scModel!.symbol == "ATD") {
        // Provider.of<ContractProvider>(context, listen: false).getAStatus();
        // await getCheckInList();
        // await getCheckOutList();
        await sortList();
      }
    });
  }

  // Future? getCheckInList() async {

  //   final res = await ApiProvider().getCheckInList(ApiProvider.keyring.keyPairs[0].address!);

  //   setState(() {
  //     _checkInList.clear();
  //   });

  //   for (final i in res) {
  //     final String latlong = i['location'].toString();

  //     await addressName(LatLng(double.parse(latlong.split(',')[0]), double.parse(latlong.split(',')[1]))).then((value) async {
  //       if (value != null) {
  //         await dateConvert(int.parse(i['time'].toString())).then((time) {
  //           setState(() {
  //             _checkInList
  //                 .add({'time': time, 'location': value, 'status': true});
  //           });
  //         });
  //       }
  //     });
  //   }
  //   if (!mounted) return;
  //   return res;
  // }

  // Future? getCheckOutList() async {

  //   final res = await ApiProvider().getCheckOutList(ApiProvider.keyring.keyPairs[0].address!);

  //   setState(() {
  //     _checkOutList.clear();
  //   });

  //   for (final i in res) {
  //     final String latlong = i['location'].toString();

  //     await addressName(LatLng(double.parse(latlong.split(',')[0]), double.parse(latlong.split(',')[1]))).then((value) async {
  //       if (value != null) {
  //         await dateConvert(int.parse(i['time'].toString())).then((time) {
  //           setState(() {
  //             _checkOutList
  //                 .add({'time': time, 'location': value, 'status': false});
  //           });
  //         });
  //       }
  //     });
  //   }
  //   if (!mounted) return;
  //   return res;
  // }

  // Future<void> initATD() async {
  //   if (widget.tokenSymbol == "ATD") {
  //     Provider.of<ContractProvider>(context, listen: false).getAStatus();
  //     await getCheckInList();
  //     await getCheckOutList();
  //     sortList();
  //   }
  // }

  // Future<String> addressName(LatLng place) async {
  //   final List? placemark = await placemarkFromCoordinates(place.latitude, place.longitude);

  //   return placemark![0].thoroughfare ??
  //       '' + ", " + placemark[0].subLocality ??
  //       '' + ", " + placemark[0].administrativeArea ??
  //       '';
  // }

  Future<String> dateConvert(int millisecond) async {
    final df = DateFormat('dd-MM-yyyy hh:mm a');
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(millisecond);

    return df.format(date);
  }

  Future<void> sortList() async {
    _checkAll = List.from(_checkInList)..addAll(_checkOutList);

    _checkAll.sort(
      (a, b) => a['time'].toString().compareTo(
            b['time'].toString(),
          ),
    );
    setState(() {});
    if (!mounted) return;
  }

  String onSubmit(String value) {
    return value;
  }

  Future<void> showDetailDialog(TxHistory txHistory) async {
    await txDetailDialog(context, txHistory);
  }

  // Future<void> qrRes() async {
  //   final _response =
  //       await Navigator.push(context, transitionRoute(QrScanner()));

  //   if (_response != null && _response != "null") {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => CheckIn(
  //           qrRes: _response.toString(),
  //         ),
  //       ),
  //     );
  //   }
  // }

  void onPageChange(int index) {
    setState(() {
      _tabIndex = index;
    });
  }

  void onTabChange(int tabIndex) {
    controller.animateToPage(
      tabIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    print("init asset detail ${widget.scModel!.address}");
    _globalKey = GlobalKey<ScaffoldState>();

    if (widget.showActivity != null) {
      _tabIndex = 1;
      controller = PageController(initialPage: 1);
    }

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      key: _globalKey,
      body: BodyScaffold(
        isSafeArea: true,
        bottom: 0,
        height: MediaQuery.of(context).size.height,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBox) {
            return [
              SliverAppBar(
                pinned: true,
                expandedHeight: 77,
                forceElevated: innerBox,
                automaticallyImplyLeading: false,
                leading: Container(),
                backgroundColor: isDarkTheme
                  ? hexaCodeToColor(AppColors.darkCard)
                  : Colors.white,
                flexibleSpace: Column(children: [
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(right: 16),
                                      child: Icon(
                                          Platform.isAndroid
                                              ? Icons.arrow_back
                                              : Icons.arrow_back_ios,
                                          color: isDarkTheme
                                              ? Colors.white
                                              : Colors.black,
                                          size: 28))),

                              Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.only(right: 8),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Image.asset(
                                  widget.scModel!.logo!,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              MyText(
                                fontSize: 18.0,
                                color: isDarkTheme
                                    ? AppColors.whiteHexaColor
                                    : AppColors.blackColor,
                                text: widget.scModel!.id! == null
                                    ? widget.scModel!.symbol!
                                    : widget.scModel!.id!.toUpperCase(),
                              ),

                              Expanded(child: Container()),

                              // Right Text
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: MyText(
                                    fontSize: 16.0,
                                    text:
                                        widget.scModel!.org! == 'BEP-20' ? 'BEP-20' : '',
                                    color: isDarkTheme
                                        ? AppColors.whiteHexaColor
                                        : AppColors.darkCard,
                                  )),
                            ],
                          ))),
                ]),
              ),

              // Under Line of AppBar
              SliverList(
                delegate: SliverChildListDelegate([
                Divider(
                    height: 3,
                    color: isDarkTheme
                        ? hexaCodeToColor(AppColors.darkCard)
                        : Colors.grey.shade400)
              ])),

              // Body
              SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    Container(
                      color: isDarkTheme
                        ? hexaCodeToColor(AppColors.darkBgd)
                        : hexaCodeToColor(AppColors.whiteHexaColor),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          MyText(
                            text: '${widget.scModel!.balance}${' ${widget.scModel!.symbol}'}',
                            //AppColors.secondarytext,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                            color: isDarkTheme
                              ? AppColors.whiteColorHexa
                              : AppColors.textColor,
                          ),
                          
                          MyText(
                            top: 8.0,
                            text: widget.scModel!.balance != AppString.loadingPattern && widget.scModel!.marketPrice != null
                              ? '≈ \$$totalUsd'
                              : '≈ \$0.00',

                            fontSize: 28,
                            color: isDarkTheme
                              ? AppColors.whiteColorHexa
                              : AppColors.textColor,
                            //fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 8.0),
                          if (widget.scModel!.marketPrice == null)
                            Container()
                          else
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyText(
                                  text: widget.scModel!.marketPrice != null ? '\$ ${widget.scModel!.marketPrice}' : '',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkTheme
                                    ? AppColors.whiteColorHexa
                                    : AppColors.textColor,
                                ),

                                const SizedBox(width: 6.0),
                                widget.scModel!.change24h != null && widget.scModel!.change24h != ''
                                ? MyText(
                                  text: double.parse(widget.scModel!.change24h!).isNegative
                                    ? '${widget.scModel!.change24h}%'
                                    : '+${widget.scModel!.change24h}%',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: double.parse(widget.scModel!.change24h!).isNegative
                                    ? '#FF0000'
                                    : isDarkTheme
                                        ? '#00FF00'
                                        : '#66CD00'
                                        ,
                                )
                                : Flexible(
                                  child: MyText(
                                    text: widget.scModel!.change24h!,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkTheme
                                      ? '#00FF00'
                                      : '#66CD00',
                                  )
                                )
                              ],
                            ),

                          MyText(
                            text: '${widget.scModel!.balance}${' ${widget.scModel!.symbol}'}',
                            //AppColors.secondarytext,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                            color: isDarkTheme
                              ? AppColors.whiteColorHexa
                              : AppColors.textColor,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 40),
                            padding: widget.scModel!.symbol == 'ATD'
                                ? const EdgeInsets.symmetric()
                                : const EdgeInsets.symmetric(vertical: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 150,
                                  // ignore: deprecated_member_use
                                  child: Consumer<ContractProvider>(
                                    builder: (context, provider, widgets){
                                      return ElevatedButton(
                                        onPressed: () async {
                                          try {

                                            if(widget.scModel!.symbol != 'ATT') {
                                              
                                              await MyBottomSheet().trxOptions(
                                                context: context,
                                                portfolioList: provider.sortListContract
                                              );
                                            } else {
                                              dialogLoading(context);
                                              await Future.delayed(Duration(milliseconds: 1300), (){});
                                              // Close Loading
                                              Navigator.pop(context);
                                              await successDialog(context, "check in!");
                                            }
                                          } catch (e) {
                                            print("Error Transfer $e");
                                          }
                                        },
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(hexaCodeToColor(AppColors.secondary)),
                                        ),
                                        // disabledColor: Colors.grey[700],
                                        // focusColor: hexaCodeToColor(AppColors.secondary),
                                        child: MyText(
                                          text: widget.scModel!.symbol == 'ATT' ? 'Check In' : 'Transfer',
                                          color: AppColors.whiteColorHexa
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                SizedBox(
                                  height: 50,
                                  width: 150,
                                  // ignore: deprecated_member_use
                                  child: FlatButton(
                                    onPressed: () async {
                                      if(widget.scModel!.symbol != 'ATT') {
                                        if (widget.scModel!.symbol == 'BTC') {
                                          widget.scModel!.address = Provider.of<ApiProvider>(context, listen: false).btcAdd;
                                        } else if (widget.scModel!.org == 'Testnet' || widget.scModel!.symbol == 'DOT'){
                                          widget.scModel!.address = Provider.of<ApiProvider>(context, listen: false).accountM.address!;
                                        } else {
                                          widget.scModel!.address = Provider.of<ContractProvider>(context, listen: false).ethAdd;
                                        }
                                        setState(() { });
                                        AssetInfoC().showRecieved(
                                          context,
                                          _method,
                                          symbol: widget.scModel!.symbol,
                                          org: widget.scModel!.org,
                                          scModel: widget.scModel
                                        );
                                        
                                      } else {
                                        dialogLoading(context);
                                        await Future.delayed(Duration(milliseconds: 1300), (){});
                                        // Close Loading
                                        Navigator.pop(context);
                                        await successDialog(context, "check out!");
                                      }
                                    },
                                    color: hexaCodeToColor(
                                      AppColors.secondary,
                                    ),
                                    disabledColor: Colors.grey[700],
                                    focusColor: hexaCodeToColor(
                                      AppColors.secondary,
                                    ),
                                    child: MyText(
                                      text: widget.scModel!.symbol == 'ATT' ? 'Check Out' : 'Recieved',
                                      color: AppColors.whiteColorHexa,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 32.0,
                      color: isDarkTheme
                          ? hexaCodeToColor(AppColors.darkBgd)
                          : hexaCodeToColor(AppColors.whiteHexaColor),
                    ),
                    Container(
                      //padding: const EdgeInsets.only(top: 32.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                onTabChange(0);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: isDarkTheme
                                      ? hexaCodeToColor(AppColors.darkCard)
                                      : hexaCodeToColor(
                                          AppColors.whiteHexaColor),
                                  border: Border(
                                    bottom: BorderSide(
                                      color: _tabIndex == 0
                                          ? hexaCodeToColor(AppColors.secondary)
                                          : Colors.transparent,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                child: MyText(
                                  text: "Details",
                                  color: _tabIndex == 0
                                      ? AppColors.secondary
                                      : isDarkTheme
                                          ? AppColors.darkSecondaryText
                                          : AppColors.textColor,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                onTabChange(1);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: isDarkTheme
                                      ? hexaCodeToColor(AppColors.darkCard)
                                      : hexaCodeToColor(
                                          AppColors.whiteHexaColor),
                                  border: Border(
                                    bottom: BorderSide(
                                      color: _tabIndex == 1
                                          ? hexaCodeToColor(AppColors.secondary)
                                          : Colors.transparent,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                child: MyText(
                                  text: "Activity",
                                  color: _tabIndex == 1
                                      ? AppColors.secondary
                                      : isDarkTheme
                                          ? AppColors.darkSecondaryText
                                          : AppColors.textColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ), //
                    ),
                  ],
                ),
              ),
            ];
          },

          body: PageView(
            controller: controller,
            onPageChanged: (index) {
              onPageChange(index);
            },
            children: <Widget>[
              if (widget.scModel!.marketData != null)
                Container(
                  color: isDarkTheme
                      ? hexaCodeToColor(AppColors.darkCard)
                      : hexaCodeToColor(AppColors.whiteHexaColor),
                  child: AssetDetail(widget.scModel!.marketData!),
                )
              else
                Container(
                  color: isDarkTheme
                      ? hexaCodeToColor(AppColors.darkCard)
                      : hexaCodeToColor(AppColors.whiteHexaColor),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/no_data.svg',
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
              Consumer<ContractProvider>(builder: (context, value, child) {
                return widget.transactionInfo == null
                    ? Container(
                        color: isDarkTheme
                          ? hexaCodeToColor(AppColors.darkCard)
                          : hexaCodeToColor(AppColors.whiteHexaColor),
                        child: Center(
                            child: SvgPicture.asset(
                          'assets/icons/no_data.svg',
                          width: 150,
                          height: 150,
                        )),
                      )
                    : Container(
                        color: isDarkTheme ? hexaCodeToColor(AppColors.darkCard) : hexaCodeToColor(AppColors.whiteColorHexa),
                        child: ActivityList(
                          transactionInfo: widget.transactionInfo,
                        )
                        // child: SingleChildScrollView(
                        //   physics: NeverScrollableScrollPhysics(),
                        //   child: Column(
                        //     children: [
                        //       ActivityItem(),
                        //       ActivityItem(),
                        //       ActivityItem(),
                        //     ],
                        //   ),
                        // ),
                        );
              })
              // Container(
              //   color: isDarkTheme
              //       ? hexaCodeToColor(AppColors.darkCard)
              //       : hexaCodeToColor(AppColors.whiteHexaColor),
              //   child: Center(
              //       child: SvgPicture.asset(
              //     'assets/icons/no_data.svg',
              //     width: 150,
              //     height: 150,
              //   )),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
