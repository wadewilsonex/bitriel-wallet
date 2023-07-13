import 'package:bitriel_wallet/index.dart';

class TokenInfo extends StatefulWidget {
  final String tokenName;
  final Market market;

  const TokenInfo({
    super.key,
    required this.tokenName,
    required this.market,
  });

  @override
  State<TokenInfo> createState() => _TokenInfoState();
}

class _TokenInfoState extends State<TokenInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, title: widget.tokenName),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            tokenInfomation(),
          ],
        ),
      ),
    );
  }

  Widget rowTokenInfo({required String title, required String price}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyTextConstant(
            text: title,
            fontSize: 18,
          ),
    
          MyTextConstant(
            text: "\$$price",
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );

  }
  
  Widget tokenInfomation() {
    return Column(
      children: [

        Align(
          alignment: Alignment.topLeft,
          child: MyTextConstant(
            text: "About ${widget.tokenName}",
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),

        rowTokenInfo(title: "Market Cap", price: double.parse("${widget.market.marketCap}".replaceAll(".", "")).toStringAsFixed(2)),

        rowTokenInfo(title: "Volume (24h)", price: double.parse("${widget.market.volume24h}".replaceAll(".", "")).toStringAsFixed(2)),

      ],
    );
  }

}