import 'dart:ui';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
// import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_apps/src/components/component.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/models/tx_history.dart';
import 'package:wallet_apps/src/screen/home/asset_info/activity_list.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
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
      Navigator.pushAndRemoveUntil(context, Transition(child: HomePage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT), ModalRoute.withName('/'));
    });
  }

  Future<List<TxHistory>> readTxHistory() async {
    await StorageServices.fetchData(DbKey.txtHistory).then((value) {
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
      if (ApiProvider().isDebug == true) print("Error _deleteHistory $e");
    }
    return null;
  }

  Future<void> clearOldHistory() async {
    await StorageServices.removeKey(DbKey.txtHistory);
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

  Color bg = Colors.white.withOpacity(0.06);

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
          // floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBox) {
            return [

              SliverAppBar(
                elevation: 0,
                // pinned: true,
                floating: true,
                snap: true,
                forceElevated: innerBox,
                automaticallyImplyLeading: false,
                leading: Container(),
                backgroundColor: isDarkTheme
                  ? bg
                  : Colors.white,
                flexibleSpace: Column(children: [

                  // AppBar
                  Expanded(
                      child: Container(
                        color: hexaCodeToColor(AppColors.bluebgColor),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: paddingSize),
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
                                      size: 22.5.sp
                                    )
                                  )
                                ),

                                ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                    widget.scModel!.logo!,
                                    fit: BoxFit.contain,
                                    width: 10.w,
                                    height: 10.w,
                                  )
                                ),

                                MyText(
                                  left: 2.w,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkTheme
                                    ? AppColors.whiteHexaColor
                                    : AppColors.blackColor,
                                  text: widget.scModel!.symbol!
                                  // widget.scModel!.id! == null
                                  //     ? widget.scModel!.symbol!
                                  //     : widget.scModel!.id!.toUpperCase(),
                                ),

                                Expanded(child: Container()),

                                // Right Text
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: MyText(
                                    text: widget.scModel!.org,
                                    fontWeight: FontWeight.w700,
                                    color: isDarkTheme
                                      ? AppColors.whiteHexaColor
                                      : AppColors.darkCard,
                                  )
                                ),
                              ],
                            )
                          ),
                      )
                      ),
                ]),
              ),

              // Body
              SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    Container(
                      color: isDarkTheme
                        ? bg
                        : hexaCodeToColor(AppColors.whiteHexaColor),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          MyText(
                            text: '${widget.scModel!.balance}${' ${widget.scModel!.symbol}'}',
                            //AppColors.secondarytext,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                            color: isDarkTheme
                              ? AppColors.whiteColorHexa
                              : AppColors.textColor,
                          ),
                          
                          MyText(
                            top: 8.0,
                            text: "≈ \$ ${widget.scModel!.money!.toStringAsFixed(2)}",
                            // widget.scModel!.balance != AppString.loadingPattern && widget.scModel!.marketPrice != null
                            //   ? '≈ \$$totalUsd'
                            //   : '≈ \$0.00',

                            fontSize: 18,
                            color: isDarkTheme
                              ? AppColors.whiteColorHexa
                              : AppColors.textColor,
                            //fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 8.0),
                            
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              const SizedBox(width: 6.0),
                              widget.scModel!.change24h != null && widget.scModel!.change24h != ''
                              ? MyText(
                                text: "≈ \$ ${widget.scModel!.money!.toStringAsFixed(2)}",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: double.parse(widget.scModel!.change24h!).isNegative
                                  ? '#FF0000'
                                  : isDarkTheme
                                    ? '#00FF00'
                                    : '#66CD00',
                              )
                              : Flexible(
                                child: MyText(
                                  text: widget.scModel!.change24h!,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkTheme
                                    ? '#00FF00'
                                    : '#66CD00',
                                )
                              )
                            ],
                          ),

                        ],
                      ),
                    ),
                    
                    // TabBar
                    Row(
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
                                    ? bg
                                    : hexaCodeToColor(
                                        AppColors.whiteHexaColor),
                                border: Border(
                                  bottom: BorderSide(
                                    color: _tabIndex == 0
                                        ? hexaCodeToColor("#D4D6E3")
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: MyText(
                                fontWeight: FontWeight.bold,
                                text: "Activity",
                                color: _tabIndex == 0
                                    ? AppColors.whiteColorHexa
                                    : isDarkTheme
                                        ? AppColors.iconColor
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
                                  ? bg
                                  : hexaCodeToColor(AppColors.whiteHexaColor),
                                border: Border(
                                  bottom: BorderSide(
                                    color: _tabIndex == 1
                                      ? hexaCodeToColor("#D4D6E3")
                                      : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: MyText(
                                fontWeight: FontWeight.w600,
                                text: "Details",
                                color: _tabIndex == 1
                                    ? AppColors.whiteColorHexa
                                    : AppColors.iconColor
                              ),
                            ),
                          ),
                        ),
                      ],
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
              Consumer<ContractProvider>(builder: (context, value, child) {
                return widget.transactionInfo == null
                    ? Container(
                        color: isDarkTheme
                          ? bg
                          : hexaCodeToColor(AppColors.whiteHexaColor),
                        child: Center(
                          child: SvgPicture.asset(
                            AppConfig.iconsPath+'no_data.svg',
                            width: 150,
                            height: 150,
                          )
                        ),
                      )
                    : Container(
                      color: isDarkTheme ? hexaCodeToColor(AppColors.darkCard) : hexaCodeToColor(AppColors.whiteColorHexa),
                      child: ActivityList(
                        transactionInfo: widget.transactionInfo,
                      ),
                    );
              }),

              if (widget.scModel!.marketData != null)
                Container(
                  color: isDarkTheme
                      ? bg
                      : hexaCodeToColor(AppColors.whiteHexaColor),
                  child: AssetDetail(widget.scModel!.marketData!),
                )
              else
                Container(
                  color: isDarkTheme
                      ? bg
                      : hexaCodeToColor(AppColors.whiteHexaColor),
                  child: Center(
                    child: SvgPicture.asset(
                      AppConfig.iconsPath+'no_data.svg',
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
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
