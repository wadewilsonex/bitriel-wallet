import 'package:bitriel_wallet/index.dart';

class ConfirmSwapExchange extends StatelessWidget {
  const ConfirmSwapExchange({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, title: "Confirm Swap"),
      body: Column(
        children: [
      
          _swapTokenInfo(),

          _trxExchangeInfo(context),

          Expanded(
            child: Container()
          ),

          MyButton(
            edgeMargin: const EdgeInsets.all(paddingSize),
            textButton: "Confirm",
            action: () async {
              
            },
          ),
      
        ],
      ),
    );
  }

  Widget _swapTokenInfo() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
    
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [
                const SizedBox(
                  height: 50,
                  width: 50,
                  child: CircleAvatar()
                ),
          
                const SizedBox(width: 10.0),
          
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextConstant(
                      text: "You Swap",
                      color2: hexaCodeToColor(AppColors.grey),
                      fontWeight: FontWeight.w600,
                    ),
          
                    const MyTextConstant(
                      text: "1 BNB",
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    )
                  ],
                )
              ],
            ),
          ),
    
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: (){
                
              },
              icon: Icon(Iconsax.arrow_down, color: hexaCodeToColor(AppColors.primary), size: 35,)
            ),
          ),
    
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [
                const SizedBox(
                  height: 50,
                  width: 50,
                  child: CircleAvatar()
                ),
          
                const SizedBox(width: 10.0),
          
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextConstant(
                      text: "You Will Get",
                      color2: hexaCodeToColor(AppColors.grey),
                      fontWeight: FontWeight.w600,
                    ),
          
                    const MyTextConstant(
                      text: "1 BNB",
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    )
                  ],
                )
              ],
            ),
          ),
    
        ],
      ),
    );
  }

  Widget _trxExchangeInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
    
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: hexaCodeToColor(AppColors.cardColor),
              borderRadius: const BorderRadius.all(Radius.circular(18),
              ),
            ),
            child: Column(
              children: [
            
                Row(
                  children: [
                    MyTextConstant(
                      text: "Deposit BNB To",
                      fontWeight: FontWeight.w600,
                      color2: hexaCodeToColor(AppColors.darkGrey),
                    ),
            
                    const Spacer(),
            
                    const MyTextConstant(
                      text: "0x123....3112d",
                      fontWeight: FontWeight.w600,
                    ),
                    
                    IconButton(
                      icon: Icon(Iconsax.copy, color: hexaCodeToColor(AppColors.primary), size: 20),
                      onPressed: () {
                        Clipboard.setData(
                          const ClipboardData(text: "0x1233r43....4j53213112d"),
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
                    MyTextConstant(
                      text: "Recipient Address",
                      fontWeight: FontWeight.w600,
                      color2: hexaCodeToColor(AppColors.darkGrey),
                    ),
            
                    const Spacer(),
            
                    const MyTextConstant(
                      text: "0x123....3112d",
                      fontWeight: FontWeight.w600,
                    ),
                    
                    IconButton(
                      icon: Icon(Iconsax.copy, color: hexaCodeToColor(AppColors.primary), size: 20),
                      onPressed: () {
                        Clipboard.setData(
                          const ClipboardData(text: "0x1233r43....4j53213112d"),
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
            
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      MyTextConstant(
                        text: "Provider",
                        fontWeight: FontWeight.w600,
                        color2: hexaCodeToColor(AppColors.darkGrey),
                      ),
                            
                      const Spacer(),
                            
                      const MyTextConstant(
                        text: "LetsExchange.io",
                        fontWeight: FontWeight.w600,
                      ),
                    
                      const SizedBox(width: 10),
                    
                    ],
                  ),
                ),
            
              ],
            ),
          ),
    
          const SizedBox(height: 10),
    
          Container(
            padding: const EdgeInsets.all(paddingSize),
            decoration: BoxDecoration(
              color: hexaCodeToColor(AppColors.cardColor),
              borderRadius: const BorderRadius.all(Radius.circular(18),
              ),
            ),
            child: Column(
              children: [
            
                Row(
                  children: [
    
                    Flexible(
                      flex: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                    
                          MyTextConstant(
                            text: "Exchange ID",
                            fontWeight: FontWeight.w600,
                            color2: hexaCodeToColor(AppColors.darkGrey),
                          ),

                          const SizedBox(height: 2.5,),
                          
                          MyTextConstant(
                            text: "Copy Exchange ID to check \ntransaction status",
                            fontSize: 11,
                            color2: hexaCodeToColor(AppColors.primary),
                            textAlign: TextAlign.start,
                          ),
                    
                        ],
                      ),
                    ),
            
                    const Spacer(),
            
                    const MyTextConstant(
                      text: "12321321314",
                      fontWeight: FontWeight.w600,
                    ),
    
                    IconButton(
                      icon: Icon(Iconsax.copy, color: hexaCodeToColor(AppColors.primary), size: 20,),
                      onPressed: () {
                        Clipboard.setData(
                          const ClipboardData(text: "12321321314"),
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
    
        ],
      ),
    ); 
  }


}