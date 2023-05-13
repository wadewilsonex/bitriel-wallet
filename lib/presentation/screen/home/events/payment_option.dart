import 'package:get/get.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/data/provider/payment_controller.dart';

class PaymentOptions extends StatefulWidget {
  
  final num qty;
  final num price;
  const PaymentOptions({Key? key, required this.qty, required this.price}) : super(key: key);

  @override
  State<PaymentOptions> createState() => _PaymentOptionsState();
}

class _PaymentOptionsState extends State<PaymentOptions> {

  final PaymentController controller = Get.put(PaymentController());

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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor)
        ),
        backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
        title: MyText(
          text: "Payment Methods",
          fontSize: 20,
          fontWeight: FontWeight.bold,
          hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Iconsax.arrow_left_2, size: 30,),
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
    return Consumer<AppProvider>(
      builder: (context, pro, wg) {
        return Container(
          decoration: BoxDecoration(
            color: isDarkMode ? hexaCodeToColor(AppColors.defiMenuItem) : hexaCodeToColor(AppColors.whiteColorHexa),
          ),
          child: Padding(
            padding: const EdgeInsets.all(paddingSize),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.file(File(isDarkMode ? "${pro.dirPath}/default/appbar_event.png" : "${pro.dirPath}/default/appbar_event_black.png"), width: 75,),

                    const MyText(text: "Preferred Payment", fontWeight: FontWeight.bold, fontSize: 16, left: 10),
                  ],
                ),

                const SizedBox(height: 15),

                Consumer<AppProvider>(
                  builder: (context, pro, wg) {
                    return Container(
                      padding: const EdgeInsets.all(paddingSize),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDarkMode ? Colors.transparent : hexaCodeToColor(AppColors.orangeColor).withOpacity(0.5),
                          width: 1,
                        ),
                        color: isDarkMode ? hexaCodeToColor(AppColors.defiMenuItem) : hexaCodeToColor(AppColors.whiteColorHexa),
                      ),
                      child: Row(
                        children: [
                          Image.file(File("${pro.dirPath}/logo/bitriel-logo-)v2.png"), width: 40),
                          
                          Padding(
                            padding: const EdgeInsets.only(left: paddingSize),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                MyText(text: "Bitriel Wallet", fontSize: 15, fontWeight: FontWeight.bold, ),
                                MyText(text: "Pay Securely SEL Token", ),

                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
        );
      }
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

          GestureDetector(
            onTap: () async {
              dialogLoading(context);
              // await controller.makePayment(context, );
            },
            child: Container(
              padding: const EdgeInsets.all(paddingSize),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDarkMode ? Colors.transparent : hexaCodeToColor(AppColors.orangeColor).withOpacity(0.5),
                  width: 1,
                ),
                color: isDarkMode ? hexaCodeToColor(AppColors.defiMenuItem) : hexaCodeToColor(AppColors.whiteColorHexa),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.cards, size: 40, color: hexaCodeToColor(AppColors.primaryColor)),
                  
                  Consumer<AppProvider>(
                    builder: (context, pro, wg) {
                      return Padding(
                        padding: const EdgeInsets.only(left: paddingSize),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const MyText(text: "Credit / Debit Card", fontSize: 15, fontWeight: FontWeight.bold),
                            
                            const SizedBox(height: 5),
          
                            Row(
                              children: [
                                Image.file(File("${pro.dirPath}/payment/visa.png") , width: 40,),
          
                                const SizedBox(width: 5),
                                Image.file(File("${pro.dirPath}/payment/mastercard.png"), width: 40,),
          
                                const SizedBox(width: 5),
                                Image.file(File("${pro.dirPath}/payment/paypal.png"), width: 40,),
                              ],
                            )
          
                          ],
                        ),
                      );
                    }
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
    
}