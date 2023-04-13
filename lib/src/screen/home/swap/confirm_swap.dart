

import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/swap_m.dart';
import 'package:wallet_apps/src/provider/receive_wallet_p.dart';

class ConfirmSwap extends StatefulWidget {

  final SwapResponseObj? res;

  const ConfirmSwap({Key? key, this.res}) : super(key: key);

  @override
  State<ConfirmSwap> createState() => _ConfirmSwapState();
}

class _ConfirmSwapState extends State<ConfirmSwap> {

  @override
  initState(){
    
    super.initState();
  }
  
  Future<void> confirmSwapMethod()async {
    print("Submit");

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const MyText(
          text: "Confirm Transaction",
          fontSize: 18,
          color2: Colors.black,
          fontWeight: FontWeight.w600
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Iconsax.arrow_left_2,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 30,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(paddingSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
      
            Row(
              children: [
                SvgPicture.network(widget.res!.coin_from_icon!.replaceAll("\/", "\\")),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MyText(
                      pLeft: 8,
                      text: "You Swap",
                      fontSize: 18,
                    ),
                    MyText(
                      pLeft: 8,
                      text: "${widget.res!.deposit_amount} ${widget.res!.coin_from} (${widget.res!.coin_from_network})",
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    )
                  ],
                ),

      
              ],
            ),

            const SizedBox(height: 15),

            Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: hexaCodeToColor(isDarkMode ? AppColors.titleAssetColor : AppColors.primaryColor)),
                  borderRadius: BorderRadius.circular(30)
                ),
                padding: const EdgeInsets.all(5),
                child: Icon(Iconsax.arrow_down, color: hexaCodeToColor(AppColors.primaryColor), size: 27),
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                SvgPicture.network(widget.res!.coin_to_icon!.replaceAll("\/", "\\")),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MyText(
                      pLeft: 8,
                      text: "You Will Get",
                      fontSize: 18,
                    ),
                    MyText(
                      pLeft: 8,
                      text: "${widget.res!.withdrawal_amount} ${widget.res!.coin_to} (${widget.res!.coin_to_network})",
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    )
                  ],
                ),

      
              ],
            ),

            const SizedBox(height: 20),

            _swapInfo(widget.res!),

            const Spacer(), 
            MyGradientButton(
              textButton: "Proceed with Swap",
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              action: () async {
                // underContstuctionAnimationDailog(context: context);
                confirmSwapMethod();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _swapInfo(SwapResponseObj res) {
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
                    MyText(
                      text: "Deposit ${res.coin_from} To",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.greyCode,
                    ),
          
                    const Spacer(),
          
                    MyText(
                      text: widget.res!.deposit!.replaceRange(6, widget.res!.deposit!.length - 6, "..."),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.blackColor,
                    ),
                    
                    IconButton(
                      icon: Icon(Iconsax.copy, color: hexaCodeToColor(AppColors.primaryColor)),
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: widget.res!.deposit),
                        );
                        /* Copy Text */
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Deposit Address is Copied to Clipboard"),
                          ),
                        );
                      },  
                    )
                  ],
                ),

                const Divider(),

                Row(
                  children: [
                    const MyText(
                      text: "Recipient Address",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.greyCode,
                    ),
          
                    const Spacer(),
          
                    MyText(
                      text: widget.res!.withdrawal!.replaceRange(6, widget.res!.withdrawal!.length - 6, "..."),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.blackColor,
                    ),
                    
                    IconButton(
                      icon: Icon(Iconsax.copy, color: hexaCodeToColor(AppColors.primaryColor)),
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: widget.res!.withdrawal),
                        );
                        /* Copy Text */
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Recipient Address is Copied to Clipboard"),
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
                      text: "Let's Exchange",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.blackColor,
                    )
                  ],
                ),

                const Divider(),
          
                Row(
                  children: [
                    const MyText(
                      pTop: 5,
                      pBottom: 5,
                      text: "Network Fee",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.greyCode,
                    ),
          
                    const Spacer(),
          
                    MyText(
                      pTop: 5,
                      pBottom: 5,
                      text: res.fee!,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.blackColor,
                    )
                  ],
                )
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MyText(
                          pTop: 5,
                          text: "Exchange ID",
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          hexaColor: AppColors.greyCode,
                        ),
                        MyText(
                          width: MediaQuery.of(context).size.width / 2.2,
                          text: "Copy Exchange ID to check transaction status",
                          fontSize: 12,
                          hexaColor: AppColors.primaryColor,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
          
                    const Spacer(),
          
                    MyText(
                      text: res.transaction_id,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.blackColor,
                    ),

                    IconButton(
                      icon: Icon(Iconsax.copy, color: hexaCodeToColor(AppColors.primaryColor)),
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: res.transaction_id),
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
                  children: const [
                    MyText(
                      pTop: 5,
                      pBottom: 5,
                      text: "Max Total",
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.blackColor,
                    ),
          
                    Spacer(),
          
                    MyText(
                      pTop: 5,
                      pBottom: 5,
                      text: "Total",
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.blackColor,
                    )
                  ],
                ),

              ],
            ),
          ),
        ),
      ],
    );
  }

}