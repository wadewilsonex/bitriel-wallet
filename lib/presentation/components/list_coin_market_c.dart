import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import 'package:wallet_apps/index.dart';

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

  String periodID = '1DAY';
  void queryAssetChart(int index, StateSetter modalSetState) async {
    await ApiCalls().getChart(
      widget.listCoinMarket![index].symbol!, 
      'usd', periodID, 
      DateTime.now().subtract(const Duration(days: 6)), 
      DateTime.now()
    ).then((value) {
      setState(() {
        widget.listCoinMarket![index].chart = value;
      });

      modalSetState( () {});

    });
  }

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
    return InkWell(
      onTap: () async {

        showModalBottomSheet(
          backgroundColor: hexaCodeToColor(AppColors.lightColorBg),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical( 
              top: Radius.circular(25.0),
            ),
          ),
          context: context,
          builder: (BuildContext context) {

            return StatefulBuilder(
              builder: (context, modalSetState){

                widget.listCoinMarket![widget.index!].chart == null ? queryAssetChart(widget.index!, modalSetState) : null;

                return Padding(
                  padding: const EdgeInsets.all(paddingSize),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      if (widget.listCoinMarket![widget.index!].chart == null)
                      const CircularProgressIndicator()
                      
                      else if (widget.listCoinMarket![widget.index!].chart!.isNotEmpty)
                      FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          child: chartAsset(
                            Image.network(
                              widget.listCoinMarket![widget.index!].image!,
                              fit: BoxFit.fill,
                            ),
                            widget.listCoinMarket![widget.index!].name!,
                            widget.listCoinMarket![widget.index!].symbol!,
                            'USD',
                            double.parse("${widget.listCoinMarket![widget.index!].currentPrice}".replaceAll(",", "")).toStringAsFixed(5),
                            widget.listCoinMarket![widget.index!].chart!,
                          ),
                        ),
                      )

                      else Center(
                        child: Column(
                          children: [

                            Lottie.asset(
                              "assets/animation/search_empty.json",
                              repeat: true,
                              reverse: true,
                              width: 70.w,
                            ),

                            const Padding(
                              padding: EdgeInsets.all(paddingSize),
                              child: MyText(text: "Sorry, there are no results for this coin!", fontSize: 18, fontWeight: FontWeight.w600,),
                            )
                          ],
                        ),
                      ),
                      
                    ],
                  ),
                );
              }
            );
            
            
          }
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: <Widget>[
            
            // Asset Logo
            widget.listCoinMarket![widget.index!].image != null ? SizedBox(
              height: 45,
              width: 45,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(color: Colors.white, child: Image.network(widget.listCoinMarket![widget.index!].image!))
              ),
            ) 
            : const ClipRRect(
              child: SizedBox(
                height: 45,
                width: 45,
              ),
            ),
        
            // Asset Name
            SizedBox(width: 2.w),
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
                      
                      MyText(
                        text: widget.listCoinMarket![widget.index!].symbol != null ? '${widget.listCoinMarket![widget.index!].symbol!.toUpperCase()} ' : '',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        hexaColor: isDarkMode
                          ? AppColors.whiteColorHexa
                          : AppColors.textColor,
                        textAlign: TextAlign.start,
                      ),
    
                    ],
                  ),
            
                  MyText(
                    top: 4.0,
                    text: widget.listCoinMarket![widget.index!].name ?? '',
                    fontSize: 14,
                    hexaColor: AppColors.tokenNameColor,
                    textAlign: TextAlign.start,
                  )
                ],
              ),
            ),
            
            const Spacer(),
    
            // Total Amount
            MyText(
              fontSize: 17,
              // width: double.infinity,
              text: "\$${double.parse("${widget.listCoinMarket![widget.index!].currentPrice}".replaceAll(",", "")).toStringAsFixed(5)}",//!.length > 7 ? double.parse(scModel!.balance!).toStringAsFixed(4) : scModel!.balance,
              textAlign: TextAlign.right,
              fontWeight: FontWeight.w600,
              hexaColor: isDarkMode
                ? AppColors.whiteColorHexa
                : AppColors.textColor,
              overflow: TextOverflow.fade,
            ),
          ],
        ),
      ),
    );
  }
}
