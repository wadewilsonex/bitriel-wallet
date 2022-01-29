import 'package:loading_indicator/loading_indicator.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/transaction_p.dart';

class WalletBody extends StatelessWidget {

  final Function? query;

  const WalletBody({ Key? key, this.query}) : super(key: key);

  final double iconSize = 26;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    final totalValue = Provider.of<TrxProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          // padding: EdgeInsets.only(bottom: 70),
          child: Column(
            children: [
              
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    padding: EdgeInsets.only(right: 10, top: 10),
                    onPressed: () async {
                      await MyBottomSheet().listToken(context: context, query: query);
                    }, 
                    icon: SvgPicture.asset(AppConfig.iconPath+"list.svg", width: iconSize - 10, height: iconSize - 10,)
                  )
                ],
              ),

              Container(
                height: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Consumer<TrxProvider>(
                      builder: (context, provider, widget){
                        return provider.isTotal 
                        ? ThreeDotLoading(
                          indicator: Indicator.ballPulseRise,
                          padding: EdgeInsets.only(left: 5, right: 5, bottom: 30),
                          height: 50, 
                          width: 100
                        )
                        : MyText(text: "\$ ${provider.totalValue}", fontSize: 30, bottom: 30, color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.blackColor);
                      }
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Column(
                          children: [

                            ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(CircleBorder())
                              ),
                              onPressed: (){

                              }, 
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: SvgPicture.asset(AppConfig.iconPath+"send.svg", width: iconSize, height: iconSize),
                              )
                            ),

                            MyText(top: 10, text: "Send", color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.blackColor)
                          ],
                        ),

                        Column(
                          children: [

                            ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(CircleBorder())
                              ),
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ReceiveWallet())
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: SvgPicture.asset(AppConfig.iconPath+"receive.svg", width: iconSize, height: iconSize),
                              )
                            ),
                            MyText(top: 10, text: "Receive", color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.blackColor)
                          ],
                        )

                      ]
                    ),

                  ],
                  
                )
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Consumer<ContractProvider>(builder: (context, value, child) {
                    return value.isReady
                      // Asset List As Row
                      ? AnimatedOpacity(
                          opacity: value.isReady ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          child: Column(
                            children: [
                              for (int index = 0; index < value.sortListContract.length; index++)
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    RouteAnimation(
                                      enterPage: SubmitTrx(index, value.sortListContract[index].address ?? '', false, value.sortListContract,)
                                      // AssetInfo(
                                      //   index: index,
                                      //   scModel: value.sortListContract[index]
                                      // ),
                                    ),
                                  );
                                },
                                child: AssetItem(
                                  scModel: value.sortListContract[index]
                                )
                              )
                            ],
                          )
                          //AssetList(),
                        )
                      // Loading Data Effect Shimmer
                      : MyShimmer(
                        isDarkTheme: isDarkTheme,
                      );
                  }),
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}