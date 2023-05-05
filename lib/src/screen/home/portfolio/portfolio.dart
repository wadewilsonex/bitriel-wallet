import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/home/portfolio/body_portfolio.dart';

class Portfolio extends StatefulWidget{

  final List<dynamic>? listData;
  // /final List<CircularSegmentEntry> listChart;

  const Portfolio({Key? key, @required this.listData}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PortfolioState();
  }
}

class PortfolioState extends State<Portfolio>{

  final PortfolioM _portfolioM = PortfolioM();

  @override
  void initState(){
    setChartData();
    AppServices.noInternetConnection(context: context);
    super.initState();
  }

  void setChartData(){
    // setState(() {
    //   _portfolioM.circularChart = widget.listChart;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyScaffold(
        context,
        height: MediaQuery.of(context).size.height,
        child: PortfolioBody(
          listData: widget.listData,
          portfolioM: _portfolioM,
        )
      )
    );
  }
}
