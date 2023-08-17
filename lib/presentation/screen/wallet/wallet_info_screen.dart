import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/presentation/widget/chart/chart_m.dart';

class WalletInfo extends StatelessWidget {

  final SmartContractModel scModel;
  final List<SmartContractModel> lstScModel;
  final List<Market> market;

  const WalletInfo({
    required this.scModel,
    required this.lstScModel,
    required this.market,
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final walletPro = Provider.of<WalletProvider>(context, listen: false);

    walletPro.marketUCImpl.getMarkets();

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

          _infoTap(context, scModel),

          _infoTap(context, scModel),

        ]),
      ),
    );
  }

  Widget _infoTap(BuildContext context, SmartContractModel scModel) {
    return Column(
      children: [
        _tokenIconHeader(price: double.parse((scModel.balance ?? '0.0').replaceAll(",", "")).toStringAsFixed(2)),

        // _chartAsset(context),
    
        // lstScModel.isNotEmpty ? _tokenInfomation(walletPro) : const SizedBox(),

        Expanded(child: Container()),
        _buyAndsellBtn(context, scModel.address!, lstScModel.indexOf(scModel)),
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

  Widget _chartAsset(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      child: Consumer<WalletProvider>(
        builder: (context, pro, wg) {
          return Column(
            children: [

              if (pro.defaultListContract![pro.defaultListContract!.indexOf(scModel)].chart == null)
              const CircularProgressIndicator()

              else if (pro.defaultListContract![pro.defaultListContract!.indexOf(scModel)].chart!.isEmpty)
              const SizedBox()
              
              else Container(
                child: chartAsset(
                  lstScModel[lstScModel.indexOf(scModel)].name!,
                  lstScModel[lstScModel.indexOf(scModel)].symbol!,
                  'USD',
                  double.parse("${market[lstScModel.indexOf(scModel)].price}".replaceAll(",", "")).toStringAsFixed(2),
                  lstScModel[lstScModel.indexOf(scModel)].chart!,
                ),
              ),

            ],
          );
        }
      ),
    );
  }

  Widget _tokenInfomation(WalletProvider walletProvider) {
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

        market[walletProvider.defaultListContract!.indexOf(scModel)].marketCap != null ? 
        _rowTokenInfo(title: "Market Cap", price: double.parse("${market[walletProvider.defaultListContract!.indexOf(scModel)].marketCap}".replaceAll(",", "")).toStringAsFixed(2))
        : Container(),

        market[lstScModel.indexOf(scModel)].volume24h != null ?
        _rowTokenInfo(title: "Volume (24h)", price: double.parse("${market[lstScModel.indexOf(scModel)].volume24h}".replaceAll(",", "")).toStringAsFixed(2))
        : Container(),

        market[lstScModel.indexOf(scModel)].circulatingSupply != null ?
        _rowTokenInfo(title: "Circulating Supply", price: double.parse("${market[lstScModel.indexOf(scModel)].circulatingSupply}".replaceAll(",", "")).toStringAsFixed(2))
        : Container(),

        market[lstScModel.indexOf(scModel)].totalSupply != null ?
        _rowTokenInfo(title: "Total Supply", price: double.parse("${market[lstScModel.indexOf(scModel)].totalSupply}".replaceAll(",", "")).toStringAsFixed(2))
        : Container(),
        
        market[lstScModel.indexOf(scModel)].maxSupply != null ?
        _rowTokenInfo(title: "Max Supply", price: double.parse("${market[lstScModel.indexOf(scModel)].maxSupply}".replaceAll(",", "")).toStringAsFixed(2))
        : Container(),

    
        ],
      ),
    );
  }


  Widget _buyAndsellBtn(BuildContext context, String addr, int assetIndex) {
    return Row(
      children: [

        Expanded(
          child: MyButton(
            edgeMargin: const EdgeInsets.all(10),
            textButton: "Send",
            fontWeight: FontWeight.w600,
            buttonColor: "#ED2727",
            opacity: 0.9,
            action: () async {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TokenPayment(index: assetIndex) )
              );
            },
          ),
        ),
    
        Expanded(
          child: MyButton(
            edgeMargin: const EdgeInsets.all(10),
            textButton: "Receive",
            fontWeight: FontWeight.w600,
            buttonColor: "#00A478",
            opacity: 0.9,
            action: () async {
              
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReceiveWallet(addr: addr,))
              );
            },
          ),
        )
      ],
    );
  }
  
}