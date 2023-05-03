import 'package:wallet_apps/index.dart';
import 'package:lottie/lottie.dart';
import 'package:wallet_apps/src/models/swap_m.dart';

class SwapStatusProgress extends StatelessWidget {
 
  final int ticks;
  final SwapStatusResponseObj? res;
 
  const SwapStatusProgress({Key? key, this.res, required this.ticks}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor)
        ),
        backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
        title: MyText(
          text: "Exchange Status",
          fontSize: 22,
          fontWeight: FontWeight.w600,
          hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Iconsax.arrow_left_2, size: 30),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: paddingSize),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  tick1(),
                  spacer(),
                  line(),
                  spacer(),
                  tick2(),
                  line(),
                  spacer(),
                  tick3(),
                  line(),
                  spacer(),
                  tick4(),
                ],
              ),
            ),
      
            if(ticks == 1)
            Padding(
              padding: const EdgeInsets.all(paddingSize),
              child: Column(
                children: [
      
                  MyText(
                    pBottom: 25,
                    text: res!.status!.toUpperCase(),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: 250,
                    child: Lottie.asset(
                      "assets/animation/waiting.json",
                      repeat: true,
                      reverse: true,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ],
              ),
            ),

            if(ticks == 2)
            Padding(
              padding: const EdgeInsets.all(paddingSize),
              child: Column(
                children: [
      
                  MyText(
                    // pBottom: 20,
                    text: res!.status!.toUpperCase(),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    child: Lottie.asset("assets/animation/confirmation.json",
                      repeat: true,
                      reverse: true,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ],
              ),
            ),

            if(ticks == 3)
            Padding(
              padding: const EdgeInsets.all(paddingSize),
              child: Column(
                children: [
      
                  MyText(
                    // pBottom: 20,
                    text: res!.status!.toUpperCase(),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    child: Lottie.asset(
                      "assets/animation/exchange.json",
                      repeat: true,
                      reverse: true,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ],
              ),
            ),

            if(ticks == 4)
            Padding(
              padding: const EdgeInsets.all(paddingSize),
              child: Column(
                children: [
      
                  MyText(
                    // pBottom: 20,
                    text: res!.status!.toUpperCase(),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    hexaColor: res!.status == "success" || res!.status == "refund"
                      ? AppColors.greenColor
                      : AppColors.redColor,
                  ),
                  SizedBox(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    child: Lottie.asset(
                      res!.status == "refund"
                      ? "assets/animation/refund.json"
                      :
                      res!.status == "failed" || res!.status == "overdue"
                      ? "assets/animation/failed.json"
                      : "assets/animation/success.json",
                      repeat: true,
                      reverse: true,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ],
              ),
            ),
            
      
            _swapStatusInfo(context, res!),
      
            
          ],
        ),
      ),
    );
 
 
  }
 
  Widget tick(bool isChecked){
    return isChecked ? Icon(Icons.check_circle,color: hexaCodeToColor(AppColors.primaryColor),) : Icon(Icons.radio_button_unchecked, color: hexaCodeToColor(AppColors.primaryColor),);
  }
 
  Widget tick1() {
    return ticks>0?tick(true):tick(false);
  }
  Widget tick2() {
    return ticks>1?tick(true):tick(false);
  }
  Widget tick3() {
    return ticks>2?tick(true):tick(false);
  }
  Widget tick4() {
    return ticks>3?tick(true):tick(false);
  }
 
  Widget spacer() {
    return Container(
      width: 5.0,
    );
  }
 
  Widget line() {
    return Container(
      color: hexaCodeToColor(AppColors.primaryColor),
      height: 5.0,
      width: 50.0,
    );
  }

  Widget _swapStatusInfo(BuildContext context ,SwapStatusResponseObj res) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: hexaCodeToColor(AppColors.whiteColorHexa),
            borderRadius: const BorderRadius.all(Radius.circular(18),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(paddingSize),
            child: Column(
              children: [

                Row(
                  children: [
                    Column(
                      children: [
                        
                        SizedBox(
                          height: 50,
                          child: SvgPicture.network(res.coinFromIcon!)
                        ),

                        MyText(
                          pTop: 5,
                          pBottom: 5,
                          text: "Sent ${res.depositAmount} ${res.coinFrom}\n(${res.coinFromNetwork})",
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          hexaColor: AppColors.greyCode,
                        ),
                      ],
                    ),
                        
                    Expanded(child: Icon(Iconsax.arrow_right_2, color: hexaCodeToColor(AppColors.primaryColor), size: 50,),),
                        
                    Column(
                      children: [
                        
                        SizedBox(
                          height: 50,
                          child: SvgPicture.network(res.coinToIcon!)
                        ),

                        Row(
                          children: [
                            MyText(
                              pTop: 5,
                              pBottom: 5,
                              text: res.status != "success" 
                                ? "Get ${res.withdrawalAmount} ${res.coinTo}\n(${res.coinToNetwork})" 
                                : "Got ${res.withdrawalAmount} ${res.coinTo}\n(${res.coinToNetwork})",
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              hexaColor: AppColors.greyCode,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                const Divider(),

                Row(
                  children: [
                    res.status == "success" 
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 25,
                              child: SvgPicture.network(res.coinFromIcon!)
                            ),

                            const MyText(
                              text: "Hash in:",
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              hexaColor: AppColors.greyCode,
                            )


                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: paddingSize),
                          child: MyText(
                            pTop: 10,
                            text: res.hashIn!.replaceRange(12, res.hashIn!.length - 12, "....."),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    )
                    
                    : MyText(
                      text: "Deposit ${res.coinFrom} To",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.greyCode,
                    ),
          
                    const Spacer(),
          
                    res.status == "success" 
                    
                    ? Container()
                    
                    : MyText(
                      text: res.deposit!.replaceRange(6, res.deposit!.length - 6, "....."),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.blackColor,
                    ),
                    
                    IconButton(
                      icon: Icon(Iconsax.copy, color: hexaCodeToColor(AppColors.primaryColor)),
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: res.status == "success" ? res.hashIn : res.deposit),
                        );
                        /* Copy Text */
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              res.status == "success" 
                              ? "Hash in is Copied to Clipboard"
                              : "Deposit Address is Copied to Clipboard"),
                          ),
                        );
                      },  
                    )
                  ],
                ),

                const Divider(),

                Row(
                  children: [
                    res.status == "success" 
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 25,
                              child: SvgPicture.network(res.coinToIcon!)
                            ),

                            const MyText(
                              text: "Hash out:",
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              hexaColor: AppColors.greyCode,
                            )


                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: paddingSize),
                          child: MyText(
                            pTop: 10,
                            text: res.hashOut!.replaceRange(12, res.hashOut!.length - 12, "....."),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    )
                    
                    : const MyText(
                      text: "Recipient Address",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.greyCode,
                    ),
          
                    const Spacer(),
          
                    res.status == "success" 
                    
                    ? Container()
                    
                    : MyText(
                      text: res.withdrawal!.replaceRange(6, res.withdrawal!.length - 6, "..."),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.blackColor,
                    ),
                    
                    IconButton(
                      icon: Icon(Iconsax.copy, color: hexaCodeToColor(AppColors.primaryColor)),
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: res.status == "success" ? res.hashOut : res.withdrawal),
                        );
                        /* Copy Text */
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              res.status == "success" 
                              ? "Hash out is Copied to Clipboard"
                              : "Recipient Address is Copied to Clipboard"),
                          ),
                        );
                      },  
                    )
                  ],
                ),

                const Divider(),
          
                Row(
                  children: const [
                    MyText(
                      pTop: 5,
                      pBottom: 5,
                      text: "Provider",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.greyCode,
                    ),
          
                    Spacer(),
          
                    MyText(
                      pTop: 5,
                      pBottom: 5,
                      text: "LetsExchange.io",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.blackColor,
                    )
                  ],
                ),

              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        Container(
          decoration: BoxDecoration(
            color: hexaCodeToColor(AppColors.whiteColorHexa),
            borderRadius: const BorderRadius.all(Radius.circular(18),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(paddingSize),
            child: Column(
              children: [
          
                Row(
                  children: [
                    const MyText(
                      pTop: 5,
                      text: "Exchange ID",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.greyCode,
                    ),
          
                    const Spacer(),
          
                    MyText(
                      text: res.transactionId,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.blackColor,
                    ),

                    IconButton(
                      icon: Icon(Iconsax.copy, color: hexaCodeToColor(AppColors.primaryColor)),
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: res.transactionId),
                        );
                        /* Copy Text */
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Exchange ID is Copied to Clipboard"),
                          ),
                        );
                      },  
                    )

                    
                  ],
                ),

              ],
            ),
          ),
        ),

        const SizedBox(height: 10),
        
      ],
    );
  }

}