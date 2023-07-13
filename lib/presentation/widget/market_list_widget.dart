import 'package:bitriel_wallet/index.dart';

class CoinMarketList extends StatefulWidget {

  final List<ListMetketCoinModel>? listCoinMarket;
  final int? index;

  const CoinMarketList({Key? key,
    @required this.listCoinMarket,
    @required this.index,
  }) : super(key: key);

  @override
  State<CoinMarketList> createState() => _CoinMarketListState();
}

class _CoinMarketListState extends State<CoinMarketList> {

  // String periodID = '1DAY';
  // void queryAssetChart(int index, StateSetter modalSetState) async {
  //   await ApiCalls().getChart(
  //     widget.listCoinMarket![index].symbol!, 
  //     'usd', periodID, 
  //     DateTime.now().subtract(const Duration(days: 6)), 
  //     DateTime.now()
  //   ).then((value) {
  //     setState(() {
  //       widget.listCoinMarket![index].chart = value;
  //     });

  //     modalSetState( () {});

  //   });
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          // Asset Logo
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              color: Colors.white, 
              child: Image.network(
                widget.listCoinMarket![widget.index!].image!, width: 30, height: 30,
              )
            )
          ),
      
          // Asset Name
          const SizedBox(width: 10),
    
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          
                Row( 
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    
                    MyTextConstant(
                      text: widget.listCoinMarket![widget.index!].symbol != null ? '${widget.listCoinMarket![widget.index!].symbol!.toUpperCase()} ' : '',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color2: hexaCodeToColor(AppColors.text),
                      textAlign: TextAlign.start,
                    ),
    
                  ],
                ),
          
                MyTextConstant(
                  text: widget.listCoinMarket![widget.index!].name ?? '',
                  fontSize: 12,
                  color2: hexaCodeToColor(AppColors.darkGrey),
                  textAlign: TextAlign.start,
                )
              ],
            ),
          ),
          
          const Spacer(),
    
          // Total Amount
          MyTextConstant(
            fontSize: 17,
            // width: double.infinity,
            text: "\$${double.parse("${widget.listCoinMarket![widget.index!].currentPrice}".replaceAll(",", "")).toStringAsFixed(2)}",//!.length > 7 ? double.parse(scModel!.balance!).toStringAsFixed(4) : scModel!.balance,
            textAlign: TextAlign.right,
            fontWeight: FontWeight.w600,
            color2: hexaCodeToColor(AppColors.text),
            overflow: TextOverflow.fade,
          ),
        ],
      ),
    );
  }
}