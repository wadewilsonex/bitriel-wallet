import 'package:bitriel_wallet/index.dart';

class WalletInfo extends StatelessWidget {

  final SmartContractModel scModel;

  const WalletInfo({
    required this.scModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(  
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: hexaCodeToColor(AppColors.background),
          title: MyTextConstant(
            text: "${scModel.name} (${scModel.symbol})",
            fontSize: 26,
            color2: hexaCodeToColor(AppColors.midNightBlue),
            fontWeight: FontWeight.w600,
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Iconsax.arrow_left_2,
              size: 30,
              color: hexaCodeToColor(AppColors.midNightBlue),
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: ("Info"),
              ),
              Tab(
                text: ("Activity"),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [

          _infoTap(),

          // _activityTap()

        ]),
      ),
    );
  }

  Widget _infoTap() {
    return Column(
      children: [
        _tokenIconHeader(price: double.parse("${scModel.balance}".replaceAll(",", "")).toStringAsFixed(2)),
    
        _tokenInfomation(),
      ],
    );
  }

  Widget _tokenIconHeader({required String price}) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              color: Colors.white, 
              child: SizedBox(
                height: 80,
                width: 80,
                child: Image.asset("assets/logo/bitriel-logo.png", height: 80, width: 80,),
              ),
              // child: Image.network(
              //   market.logo, width: 80, height: 80, fit: BoxFit.fill,
              // )
            )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: MyTextConstant(
              text: "${price.replaceAllMapped(Fmt().reg, Fmt().mathFunc)} ${scModel.symbol}",
              fontSize: 25,
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

  Widget _tokenInfomation() {
    // print("scModel.marketData!.marketCap ${scModel.marketData!.marketCap}");
    return Padding(
      padding: const EdgeInsets.all(paddingSize),
      child: Column(
        children: [
    
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4,),
            child: Align(
              alignment: Alignment.topLeft,
              child: MyTextConstant(
                text: "About ${scModel.name}",
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
    
        scModel.marketData != null ? 
        _rowTokenInfo(title: "Market Cap", price: double.parse("${scModel.marketData!.marketCap}".replaceAll(",", "")).toStringAsFixed(2))
        : Container(),

        // scModel.market![index].volume24h != null ?
        // _rowTokenInfo(title: "Volume (24h)", price: double.parse("${scModel.market![index].volume24h}".replaceAll(",", "")).toStringAsFixed(2))
        // : Container(),

        // scModel.market![index].circulatingSupply != null ?
        // _rowTokenInfo(title: "Circulating Supply", price: double.parse("${scModel.market![index].circulatingSupply}".replaceAll(",", "")).toStringAsFixed(2))
        // : Container(),

        // scModel.market![index].totalSupply != null ?
        // _rowTokenInfo(title: "Total Supply", price: double.parse("${scModel.market![index].totalSupply}".replaceAll(",", "")).toStringAsFixed(2))
        // : Container(),
        
        // scModel.market![index].maxSupply != null ?
        // _rowTokenInfo(title: "Max Supply", price: double.parse("${scModel.market![index].maxSupply}".replaceAll(",", "")).toStringAsFixed(2))
        // : Container(),

    
        ],
      ),
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