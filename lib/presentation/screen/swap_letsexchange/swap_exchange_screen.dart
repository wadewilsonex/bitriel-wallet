import 'package:bitriel_wallet/index.dart';

class SwapExchange extends StatelessWidget {
  const SwapExchange({super.key});

  @override
  Widget build(BuildContext context) {

    final LetsExchangeUCImpl letsExchangeUCImpl = LetsExchangeUCImpl();

    letsExchangeUCImpl.getLetsExchangeCoin();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: hexaCodeToColor(AppColors.background),
        title: MyTextConstant(
          text: "Swap",
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
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (builder) => const StatusExchange())
              );
            }, 
            child: MyTextConstant(
              text: "Status",
              color2: hexaCodeToColor(AppColors.primary),
            ),
          )
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: ValueListenableBuilder(
                  valueListenable: letsExchangeUCImpl.inputAmount,
                  builder: (context, value, wg) {
                    return Column(
                      children: [

                        _payInput(context, letsExchangeUCImpl),

                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: (){
                              
                            },
                            icon: Icon(Iconsax.refresh_circle, color: hexaCodeToColor(AppColors.primaryColor), size: 35,)
                          ),
                        ),
                      

                        _getDisplay(context, letsExchangeUCImpl),
                      ],
                    );
                  }
                ),
              ),
            ),

            Expanded(
              child: Container()
            ),

            Center(
              child: _buildNumberPad(context, letsExchangeUCImpl.inputAmount.value, letsExchangeUCImpl.onDeleteTxt, letsExchangeUCImpl.formatDouble)
            ),

            MyButton(
              edgeMargin: const EdgeInsets.all(paddingSize),
              textButton: "Swap",
              action: () async {
              },
            ),
      
          ],
        ),
      ),
    );
  }

  Widget _payInput(BuildContext context, LetsExchangeUCImpl leUCImpl) {
    return Padding(
      padding: const EdgeInsets.only(top: paddingSize, left: paddingSize, right: paddingSize),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Row(
              children: [
                
                MyTextConstant(
                  text: 'You send',
                  color2: hexaCodeToColor(AppColors.midNightBlue),
                  fontSize: 18,
                ),
                
              ],
            ),
          ),
          
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: const EdgeInsets.only(top: paddingSize, left: paddingSize / 2, bottom: paddingSize),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: hexaCodeToColor(AppColors.background)
                      ),
                      child: MyTextConstant(
                        textAlign: TextAlign.start,
                        text: leUCImpl.inputAmount.value.isEmpty ? "0.00" : leUCImpl.inputAmount.value.toString(),
                        fontSize: 20,
                        color2: leUCImpl.inputAmount.value.isEmpty ? hexaCodeToColor(AppColors.grey) : hexaCodeToColor(AppColors.midNightBlue),
                      ),
                    ),
                  ),
                ],
              ),

              Expanded(child: Container()),

              ValueListenableBuilder(
                valueListenable: leUCImpl.lstLECoin,
                builder: (context, value, wg) {
                  return value.isNotEmpty ? _ddTokenButton(
                    context: context, 
                    i: 0,
                    onPressed: () {
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SelectSwapToken(itemLE: value))
                      );

                    },
                    letsExchangeRepoImpl: leUCImpl
                  ) : const CircularProgressIndicator();
                }
              ),

            ],
          ),
          
        ],
      ),
    );
  }
  
  Widget _getDisplay(BuildContext context, LetsExchangeUCImpl leUCImpl){
    return Padding(
      padding: const EdgeInsets.only(left: paddingSize, right: paddingSize, bottom: paddingSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [

          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: MyTextConstant(
              text: 'You recieve',
              color2: hexaCodeToColor(AppColors.midNightBlue),
              fontSize: 18,
            ),
          ),    
          
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // pro.balance2.isNotEmpty ?
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    padding: const EdgeInsets.only(top: paddingSize, left: paddingSize / 2, bottom: paddingSize),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: hexaCodeToColor(AppColors.background)
                    ),
                    child: const MyTextConstant(
                      textAlign: TextAlign.start,
                      // text: pro.lstConvertCoin![pro.name2] != null ? "≈ ${pro.lstConvertCoin![pro.name2]}" : "≈ 0",
                      text: "≈ 0.00",
                      fontSize: 20,
                    ),
                  )
                ],
              ),

              Expanded(child: Container()),
            
              ValueListenableBuilder(
                valueListenable: leUCImpl.lstLECoin,
                builder: (context, value, wg) {
                  return value.isNotEmpty ? _ddTokenButton(
                    context: context, 
                    i: 1,
                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SelectSwapToken(itemLE: value))
                      );

                    },
                    letsExchangeRepoImpl: leUCImpl
                  ) : const CircularProgressIndicator();
                }
              ),
              
            ],
          ),
        ],
      ),
    );
  }

  /// dd stand for dropdown
  Widget _ddTokenButton({BuildContext? context, Function()? onPressed, required int? i, required LetsExchangeUCImpl letsExchangeRepoImpl}){
    
    return GestureDetector(
      onTap: onPressed!,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
      
          SizedBox(
            height: 30,
            width: 30,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: SvgPicture.network(i == 0 ? letsExchangeRepoImpl.lstLECoin.value[0].icon!.replaceAll("\\/", "/") : letsExchangeRepoImpl.lstLECoin.value[1].icon!.replaceAll("\\/", "/")) ,
            ),
          ),

          const SizedBox(width: 5),
          
          MyTextConstant(
            textAlign: TextAlign.start,
            text: i == 0 ? letsExchangeRepoImpl.lstLECoin.value[0].code : letsExchangeRepoImpl.lstLECoin.value[1].code,
            fontSize: 18,
            color2: hexaCodeToColor("#949393"),
          ),
      
          Icon(
            Iconsax.arrow_down_1,
            color: hexaCodeToColor(AppColors.primaryColor),
            size: 20
          ),
        ],
      ),
    );
  }

  Widget _buildNumberPad(context, String valInput, Function onDeleteTxt, Function formatCurrency) {
    return SwapNumPad(
      buttonSize: 10,
      valInput: valInput,
      buttonColor: hexaCodeToColor("#FEFEFE"),
      delete: onDeleteTxt,
      formatCurrency: formatCurrency,
    );
  }

}