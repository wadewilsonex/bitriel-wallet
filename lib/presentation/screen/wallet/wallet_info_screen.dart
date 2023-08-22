import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/presentation/screen/webview_screen.dart';
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

          _activityTap(context),

        ]),
      ),
    );
  }

  Widget _getGroupSeparator(String label) {
    return SizedBox(
      height: 50,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: hexaCodeToColor("#F4F4F4"),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: MyTextConstant(
              text: label,
              color2: hexaCodeToColor("#979797"),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.start,
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoTap(BuildContext context, SmartContractModel scModel) {
    return Column(
      children: [
        _tokenIconHeader(price: double.parse((scModel.balance ?? '0.0').replaceAll(",", "")).toStringAsFixed(2), scModel: scModel),

        // _chartAsset(context),
    
        // lstScModel.isNotEmpty ? _tokenInfomation(walletPro) : const SizedBox(),

        Expanded(child: Container()),
        _buyAndsellBtn(context, scModel.address!, lstScModel.indexOf(scModel)),
      ],
    );
  }

  Widget _dgAppbar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyTextConstant(
          text: "Sent ${scModel.symbol}",
          fontWeight: FontWeight.w700,
        ),

        IconButton(
          onPressed: () {
            Navigator.pop(context);
          }, 
          icon: const Icon(Iconsax.close_circle),
        )
      ],
    );
  }

  Widget _dgRowData({String? title1, String? title2, String? data1, String? data2}) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTextConstant(
              text: title1,
              fontSize: 10,
            ),

            MyTextConstant(
              text: data1,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        
        const Spacer(),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            MyTextConstant(
              text: title2,
              fontSize: 10,
            ),

            MyTextConstant(
              text: data2,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            )
          ],
        ),
      ],
    );
  }

  Widget _activityTap(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    insetPadding: const EdgeInsets.all(14.0),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
                    child: SizedBox(
                      height: 270,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [

                            _dgAppbar(context),

                            const SizedBox(height: 10),

                            _dgRowData(
                              title1: "Status",
                              data1: "Confirmded",
                              title2: "Date",
                              data2: "21 Aug at 10:11AM"
                            ),
                            
                            const Divider(),

                            _dgRowData(
                              title1: "From",
                              data1: "0xe111...8941",
                              title2: "To",
                              data2: "0xceBa...c647"
                            ),

                            const Divider(),

                            _dgRowData(
                              title1: "Amount",
                              data1: "1.00 ${scModel.symbol}",
                              title2: "",
                              data2: ""
                            ),

                            const SizedBox(height: 10),

                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AdsWebView(
                                    title: "Explorer",
                                    url: "https://bscscan.com/",
                                  ))
                                );
                              }, 
                              child: MyTextConstant(
                                text: "View on Explorer",
                                fontWeight: FontWeight.w600,
                                color2: hexaCodeToColor(AppColors.primaryBtn),
                              )
                            )
                            
                          ],
                        ),
                      ),
                    ),
                  );
                }
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: MyTextConstant(
                      text: "21 Aug at 10:11AM",
                      textAlign: TextAlign.start,
                      fontSize: 11,
                    ),
                  ),
                  
                  Row(
                    children: [
                    
                      SizedBox(
                        height: 35,
                        width: 35,
                        child: CircleAvatar(
                          backgroundColor: hexaCodeToColor(AppColors.lightGrey),
                          child: Icon(Iconsax.arrow_up_3, color: hexaCodeToColor(AppColors.darkGrey),)
                        ),
                      ),
                    
                      const SizedBox(width: 10),
                    
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                    
                          MyTextConstant(
                            text: "Sent ${scModel.symbol}",
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start,
                          ),
                    
                          MyTextConstant(
                            text: "From 0x212safl12....12321rff",
                            textAlign: TextAlign.start,
                            color2: hexaCodeToColor(AppColors.darkGrey),
                            fontSize: 11,
                          ),
                        ],
                      ),
                      
                      Expanded(child: Container()),
                    
                      MyTextConstant(
                        text: "+1.00 ${scModel.symbol}",
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start,
                        color2: hexaCodeToColor(AppColors.green),
                      ),
                    
                    ],
                  ),
                
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _tokenIconHeader({required String price, SmartContractModel? scModel}) {
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
                child: scModel!.logo != null ? Image.network(scModel.logo!) 
                : CircleAvatar(
                  child: MyTextConstant(
                    text: scModel.isBep20 == true ? "BEP20" : "ERC20",
                  ),
                  ),
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