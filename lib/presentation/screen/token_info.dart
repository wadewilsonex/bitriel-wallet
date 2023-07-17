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

            tokenIconHeader(networkLogo: widget.market.logo, price: double.parse("${widget.market.price}".replaceAll(",", "")).toStringAsFixed(2)),

            tokenInfomation(),

          ],
        ),
      ),
      bottomNavigationBar: buyAndsellBtn()
    );
  }

  Widget tokenIconHeader({required String networkLogo, required String price}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              color: Colors.white, 
              child: Image.network(
                widget.market.logo, width: 80, height: 80, fit: BoxFit.fill,
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

  Widget rowTokenInfo({required String title, required String price}) {
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
  
  Widget tokenInfomation() {
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

        rowTokenInfo(title: "Market Cap", price: double.parse("${widget.market.marketCap}".replaceAll(",", "")).toStringAsFixed(2)),

        rowTokenInfo(title: "Volume (24h)", price: double.parse("${widget.market.volume24h}".replaceAll(",", "")).toStringAsFixed(2)),

        rowTokenInfo(title: "Circulating Supply", price: double.parse("${widget.market.circulatingSupply}".replaceAll(",", "")).toStringAsFixed(2)),

        rowTokenInfo(title: "Total Supply", price: double.parse("${widget.market.totalSupply}".replaceAll(",", "")).toStringAsFixed(2)),

      ],
    );
  }

  Widget buyAndsellBtn() {
    return Row(
      children: [

        Expanded(
          child: MyButton(
            edgeMargin: const EdgeInsets.all(10),
            textButton: "Buy",
            fontWeight: FontWeight.w600,
            buttonColor: AppColors.green,
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
            buttonColor: AppColors.red,
            opacity: 0.9,
            action: () async {

            },
          ),
        )
      ],
    );
  }

}