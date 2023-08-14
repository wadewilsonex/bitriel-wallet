import 'package:bitriel_wallet/data/api/api_chart.dart';
import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/presentation/widget/chart/chart_m.dart';

class TokenInfo extends StatefulWidget {
  final String tokenName;
  final List<Market> market;
  final int? index;

  const TokenInfo({
    super.key,
    required this.tokenName,
    required this.market,
    required this.index,
  });

  @override
  State<TokenInfo> createState() => _TokenInfoState();
}

class _TokenInfoState extends State<TokenInfo> {

  void queryAssetChart(int index) async {
    await ApiCalls().getChart(
      widget.market[index].symbol, 
      'usd', '1DAY', 
      DateTime.now().subtract(const Duration(days: 6)), 
      DateTime.now()
    ).then((value) {
      setState(() {
        widget.market[index].chart = value;
      });

    });
  }

  @override
  void initState() {
    super.initState();
    queryAssetChart(widget.index!);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, title: widget.tokenName),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            children: [
      
              _tokenIconHeader(networkLogo: widget.market[widget.index!].logo, price: double.parse("${widget.market[widget.index!].price}".replaceAll(",", "")).toStringAsFixed(2)),
      
              _chartAsset(),
      
              _tokenInfomation(),
      
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buyAndsellBtn()
    );
  }

  Widget _tokenIconHeader({required String networkLogo, required String price}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              color: Colors.white, 
              child: Image.network(
                widget.market[widget.index!].logo, width: 80, height: 80, fit: BoxFit.fill,
              )
            )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: MyTextConstant(
              text: "\$${price.replaceAllMapped(Fmt().reg, Fmt().mathFunc)}",
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          
        ],
      ),
    );
  }

  Widget _rowTokenInfo({required String title, required String price}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyTextConstant(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color2: hexaCodeToColor(AppColors.darkGrey),
          ),
    
          MyTextConstant(
            text: "\$${price.replaceAllMapped(Fmt().reg, Fmt().mathFunc)}",
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color2: hexaCodeToColor(AppColors.midNightBlue),
          ),
        ],
      ),
    );

  }

  Widget _chartAsset() {
    return Column(
      children: [
        widget.market[widget.index!].chart == null ? const CircularProgressIndicator() :
        Container(
          child: chartAsset(
            widget.market[widget.index!].name,
            widget.market[widget.index!].symbol,
            'USD',
            double.parse("${widget.market[widget.index!].price}".replaceAll(",", "")).toStringAsFixed(2),
            widget.market[widget.index!].chart!,
          ),
        ),
      ],
    );
  }
  
  Widget _tokenInfomation() {
    return Column(
      children: [

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Align(
            alignment: Alignment.topLeft,
            child: MyTextConstant(
              text: "About ${widget.tokenName}",
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),

        widget.market[widget.index!].marketCap != null ? 
        _rowTokenInfo(title: "Market Cap", price: double.parse("${widget.market[widget.index!].marketCap}".replaceAll(",", "")).toStringAsFixed(2))
        : Container(),

        widget.market[widget.index!].volume24h != null ?
        _rowTokenInfo(title: "Volume (24h)", price: double.parse("${widget.market[widget.index!].volume24h}".replaceAll(",", "")).toStringAsFixed(2))
        : Container(),

        widget.market[widget.index!].circulatingSupply != null ?
        _rowTokenInfo(title: "Circulating Supply", price: double.parse("${widget.market[widget.index!].circulatingSupply}".replaceAll(",", "")).toStringAsFixed(2))
        : Container(),

        widget.market[widget.index!].totalSupply != null ?
        _rowTokenInfo(title: "Total Supply", price: double.parse("${widget.market[widget.index!].totalSupply}".replaceAll(",", "")).toStringAsFixed(2))
        : Container(),
        
        widget.market[widget.index!].maxSupply != null ?
        _rowTokenInfo(title: "Max Supply", price: double.parse("${widget.market[widget.index!].maxSupply}".replaceAll(",", "")).toStringAsFixed(2))
        : Container(),

      ],
    );
  }

  Widget _buyAndsellBtn() {
    return Row(
      children: [

        Expanded(
          child: MyButton(
            edgeMargin: const EdgeInsets.all(10),
            textButton: "Buy",
            fontWeight: FontWeight.w600,
            buttonColor: "#00A478",
            opacity: 0.9,
            action: () async {

            
            },
          ),
        ),
    
        Expanded(
          child: MyButton(
            edgeMargin: const EdgeInsets.all(10),
            textButton: "Sell",
            fontWeight: FontWeight.w600,
            buttonColor: "#ED2727",
            opacity: 0.9,
            action: () async {

            },
          ),
        )
      ],
    );
  }

}