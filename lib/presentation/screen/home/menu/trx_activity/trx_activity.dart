import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/constants/db_key_con.dart';

class TrxActivity extends StatefulWidget {
  const TrxActivity({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TrxActivityState();
  }
}

class TrxActivityState extends State<TrxActivity> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  bool isProgress = true;
  bool isLogout = false;

  final TxHistory _txHistoryModel = TxHistory();

  @override
  void initState() {
    AppServices.noInternetConnection(context: context);
    readTxHistory();

    super.initState();
  }

  Future<List<TxHistory>> readTxHistory() async {
    await StorageServices.fetchData(DbKey.txtHistory).then((value) {
      if (value != null) {
        _txHistoryModel.txHistoryList = value as List;
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
            _txHistoryModel.txKpi.add(TxHistory(
              date: i['date'].toString(),
              symbol: i['symbol'].toString(),
              destination: i['destination'].toString(),
              sender: i['sender'].toString(),
              amount: i['amount'].toString(),
              org: i['fee'].toString(),
            ));
          }
        }
      }
    });
    setState(() {});
    return _txHistoryModel.tx;
  }

  Future<void> _deleteHistory(int index, String symbol) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    if (symbol == 'SEL') {
      _txHistoryModel.tx.removeAt(index);
    } else {
      _txHistoryModel.txKpi.removeAt(index);
    }

    final newTxList = List.from(_txHistoryModel.tx)
      ..addAll(_txHistoryModel.txKpi);

    await clearOldHistory().then((value) async {
      await preferences.setString(DbKey.txtHistory, jsonEncode(newTxList));
    });
  }

  Future<void> clearOldHistory() async {
    await StorageServices.removeKey(DbKey.txtHistory);
  }

  Future<void> showDetailDialog(TxHistory txHistory) async {
    await txDetailDialog(context, txHistory);
  }

  /* Log Out Method */
  void logOut() async {
    /* Loading */
    dialogLoading(context);
    await StorageServices.clearStorage();
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  /* Scroll Refresh */
  void reFresh() {
    setState(() {
      isProgress = true;
    });
  }

  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'SEL'),
    const Tab(text: 'KMPI'),
  ];

  void popScreen() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        key: _globalKey,
        appBar: AppBar(
          title: const MyText(
            text: 'Transaction History',
            fontSize: 20,
            hexaColor: "#FFFFFF",
          ),
          bottom: TabBar(
            tabs: myTabs,
          ),
        ),
        body: TabBarView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: _txHistoryModel.tx.isEmpty
                  ? Container()
                  : ListView.builder(
                      itemCount: _txHistoryModel.tx.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          background: const DismissibleBackground(),
                          onDismissed: (direction) {
                            _deleteHistory(
                                index, _txHistoryModel.tx[index].symbol!);
                          },
                          child: GestureDetector(
                            onTap: () {
                              showDetailDialog(_txHistoryModel.tx[index]);
                            },
                            child: rowDecorationStyle(
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    padding: const EdgeInsets.all(6),
                                    margin: const EdgeInsets.only(right: 20),
                                    decoration: BoxDecoration(
                                      color:
                                          hexaCodeToColor(AppColors.secondary),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: Image.asset('${AppConfig.assetsPath}SelendraCircle-White.png'),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 16),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MyText(
                                          text:
                                              _txHistoryModel.tx[index].symbol,
                                          hexaColor: "#FFFFFF",
                                        ),
                                        MyText(
                                            text: _txHistoryModel.tx[index].org,
                                            fontSize: 15),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          MyText(
                                            text:
                                                _txHistoryModel.tx[index].date,
                                            fontSize: 12,
                                          ),
                                          const SizedBox(height: 5.0),
                                          MyText(
                                            text:
                                                '-${_txHistoryModel.tx[index].amount}',
                                            hexaColor: AppColors.secondarytext,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: _txHistoryModel.txKpi.isEmpty
                  ? Container()
                  : ListView.builder(
                      itemCount: _txHistoryModel.txKpi.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          background: const DismissibleBackground(),
                          onDismissed: (direction) {
                            _deleteHistory(
                                index, _txHistoryModel.txKpi[index].symbol!);
                          },
                          child: GestureDetector(
                            onTap: () {
                              showDetailDialog(_txHistoryModel.txKpi[index]);
                            },
                            child: rowDecorationStyle(
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    padding: const EdgeInsets.all(6),
                                    margin: const EdgeInsets.only(right: 20),
                                    decoration: BoxDecoration(
                                        color: hexaCodeToColor(
                                            AppColors.secondary),
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    child: Image.asset(
                                        '${AppConfig.assetsPath}koompi_white_logo.png'),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 16),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MyText(
                                          text: _txHistoryModel
                                              .txKpi[index].symbol,
                                          hexaColor: "#FFFFFF",
                                        ),
                                        MyText(
                                            text: _txHistoryModel
                                                .txKpi[index].org,
                                            fontSize: 15),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          MyText(
                                            text: _txHistoryModel
                                                .txKpi[index].date,
                                            fontSize: 12,
                                          ),
                                          const SizedBox(height: 5.0),
                                          MyText(
                                            text:
                                                '-${_txHistoryModel.txKpi[index].amount}',
                                            hexaColor: AppColors.secondarytext,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
