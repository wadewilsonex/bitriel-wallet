import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wallet_apps/index.dart';

class PaymentOptions extends StatefulWidget {
  const PaymentOptions({Key? key}) : super(key: key);

  @override
  State<PaymentOptions> createState() => _PaymentOptionsState();
}

class _PaymentOptionsState extends State<PaymentOptions> {
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
          text: "Payment Options",
          fontWeight: FontWeight.bold,
          hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Iconsax.arrow_left_2),
        ),
      ),
      body: Column(
        children: [
          _headerPayment(),
          _otherPayment(),
        ],
      )
    );
  }

  Widget _headerPayment(){
    return Container(
      color: hexaCodeToColor(AppColors.defiMenuItem),
      child: Padding(
        padding: const EdgeInsets.all(paddingSize),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset("assets/appbar_event.png", width: 75,),

                const MyText(text: "Preferred Payment", fontSize: 16, left: 10, hexaColor: AppColors.whiteColorHexa,),
              ],
            ),

            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.all(paddingSize),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: hexaCodeToColor(AppColors.greyColor).withOpacity(0.2)
              ),
              child: Row(
                children: [
                  Image.asset("assets/logo/bitriel-logo-v2.png", width: 40),
                  
                  Padding(
                    padding: const EdgeInsets.only(left: paddingSize),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        MyText(text: "Bitriel Wallet", fontSize: 15, fontWeight: FontWeight.bold, hexaColor: AppColors.whiteColorHexa,),
                        MyText(text: "Pay Securely Selendra token", hexaColor: AppColors.lowWhite),

                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otherPayment(){
    return Padding(
      padding: const EdgeInsets.all(paddingSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MyText(text: "Stripe", fontSize: 16, fontWeight: FontWeight.bold),

          const SizedBox(height: 6),

          Container(
            padding: const EdgeInsets.all(paddingSize),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: hexaCodeToColor(AppColors.defiMenuItem),
            ),
            child: Row(
              children: [
                Icon(Iconsax.cards, size: 40, color: hexaCodeToColor(AppColors.iconGreyColor)),
                
                Padding(
                  padding: const EdgeInsets.only(left: paddingSize),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MyText(text: "Credit / Debit Card", fontSize: 15, fontWeight: FontWeight.bold, hexaColor: AppColors.whiteColorHexa),
                      
                      const SizedBox(height: 5),

                      Row(
                        children: [
                          Image.asset("assets/payment/visa.png" , width: 40,),

                          const SizedBox(width: 5),
                          Image.asset("assets/payment/mastercard.png", width: 40,),

                          const SizedBox(width: 5),
                          Image.asset("assets/payment/paypal.png", width: 40,),
                        ],
                      )

                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }


}