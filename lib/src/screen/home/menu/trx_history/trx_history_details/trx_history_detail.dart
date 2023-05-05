// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wallet_apps/index.dart';

class TrxHistoryDetails extends StatefulWidget {
  
  final String _title;
  final Map<String, dynamic> _trxInfo;

  const TrxHistoryDetails(this._trxInfo, this._title, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TrxHistoryDetailsState();
  }
}

class TrxHistoryDetailsState extends State<TrxHistoryDetails> {

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  // final RefreshController _refreshController = RefreshController();

  bool isProgress = true;
  bool isLogout = false;

  @override
  void initState() {
    AppServices.noInternetConnection(context: context);
    super.initState();
  }

  /* Scroll Refresh */
  void reFresh() {
    setState(() {
      isProgress = true;
    });
    // _refreshController.refreshCompleted();
  }

  void popScreen() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: bodyScaffold(
        context,
        child: TrxHistoryDetailsBody(
          title: widget._title, 
          trxInfo: widget._trxInfo, 
          popScreen: popScreen
        ),
      ),
    );
  }
}
