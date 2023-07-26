import 'package:bitriel_wallet/index.dart';

class WalletInfo extends StatelessWidget {

  const WalletInfo({
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
            text: "Bitcoin (BTC)",
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

          _activityTap()

        ]),
      ),
    );
  }

  Widget _infoTap() {
    return Column(
      children: [
        tokenIconHeader(price: double.parse("0.11".replaceAll(",", "")).toStringAsFixed(2)),
    
        tokenInfomation(),
      ],
    );
  }

  Widget tokenIconHeader({required String price}) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              color: Colors.white, 
              child: const SizedBox(
                height: 80,
                width: 80,
                child: Placeholder(),
              ),
              // child: Image.network(
              //   market.logo, width: 80, height: 80, fit: BoxFit.fill,
              // )
            )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: MyTextConstant(
              text: "${price.replaceAllMapped(Fmt().reg, Fmt().mathFunc)} BTC",
              fontSize: 25,
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
    return Padding(
      padding: const EdgeInsets.all(paddingSize),
      child: Column(
        children: [
    
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4,),
            child: Align(
              alignment: Alignment.topLeft,
              child: MyTextConstant(
                text: "About Bitcoin",
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
    
          rowTokenInfo(title: "Market Cap", price: "408,910,725,000.00"),
    
          rowTokenInfo(title: "Volume (24h)", price: "408,910,725,000.00"),
    
          rowTokenInfo(title: "Circulating Supply", price: "408,910,725,000.00"),
    
          rowTokenInfo(title: "Total Supply", price: "408,910,725,000.00"),
    
          rowTokenInfo(title: "Max Supply", price: "408,910,725,000.00"),
    
        ],
      ),
    );
  }

Widget _getGroupSeparator(AssetsModel assetsModel) {
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
            text: assetsModel.chain,
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

Widget _getItem(BuildContext ctx, AssetsModel assetsModel) {
  return SizedBox(
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Icon(assetsModel.icon),
      title: Text(assetsModel.name),
      onTap: () {
        Navigator.push(
          ctx,
          MaterialPageRoute(builder: (context) => TransactionDetail())
        );
      },
    ),
  );
}

Widget _activityTap() {
  return StickyGroupedListView<AssetsModel, String>(
    shrinkWrap: true,
    elements: elements,
    order: StickyGroupedListOrder.ASC,
    groupBy: (AssetsModel element) => element.chain,
    groupComparator: (String value1, String value2) => value2.compareTo(value1),
    itemComparator: (AssetsModel element1, AssetsModel element2) => element1.chain.compareTo(element2.chain),
    floatingHeader: true,
    groupSeparatorBuilder: _getGroupSeparator,
    itemBuilder: _getItem,
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