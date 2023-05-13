import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/presentation/components/ticket_c.dart';
import 'package:wallet_apps/presentation/screen/home/home/home.dart';
import 'package:lottie/lottie.dart';

class SuccessTransferBody extends StatelessWidget {

  final String? assetLogo;
  final String? fromAddress;
  final String? toAddress;
  final String? amount;
  final String? fee;
  final String? hash;
  final String? trxDate;
  final String? assetSymbol;
  final ModelScanPay? scanPayM;
  final bool? isDebitCard;
  final num? qty;
  final num? price;

  const SuccessTransferBody({
    Key? key,
    this.assetLogo,
    this.fromAddress,
    this.toAddress,
    this.amount,
    this.fee,
    this.hash,
    this.trxDate,
    this.assetSymbol,
    this.scanPayM,
    this.isDebitCard,
    this.qty,
    this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            isDebitCard == true ? _detailDebitTrxWidget(context) : _detailTrxWidget(context),
          ],
        ),
      ),
      bottomNavigationBar: Material(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [ hexaCodeToColor("#F27649"), hexaCodeToColor("#F28907") ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.25, 0.74],
              tileMode: TileMode.decal,
            ),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(context, Transition(child: const HomePage(activePage: 1, isTrx: true,)), ModalRoute.withName('/'));
            },
            child: SizedBox(
              height: kToolbarHeight,
              width: double.infinity,
              child: Center(
                child: MyText(
                  text: isDebitCard == true ? 'View Tickets' : "Go To Wallet",
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  hexaColor: AppColors.whiteColorHexa,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _detailTrxWidget(BuildContext context) {
  //   return Column(
  //     children: [
  //       Column(
  //         children: const [
  //           Padding(
  //             padding: EdgeInsets.only(top: paddingSize + 50),
  //             child: Icon(Iconsax.tick_circle, color: Colors.lightGreen, size: 40,),
  //           ),
  //           MyText(text: "Success" ,fontSize: 18, fontWeight: FontWeight.w600,)
  //         ],
  //       ),
  //       Container(
  //         height: 490,
  //         margin: const EdgeInsets.all(16),
  //         width: MediaQuery.of(context).size.width,
  //         child: CustomPaint(
  //           painter: TicketPainter(
  //             borderColor: Colors.transparent,
  //             bgColor: hexaCodeToColor(isDarkMode ? AppColors.defiMenuItem : AppColors.whiteColorHexa),
  //             dsahHeight: 0.7
  //           ),
  //           child: Container(
  //             padding: const EdgeInsets.all(16),
  //             child: Column(
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     CircleAvatar(
  //                       child: Image.asset(assetLogo!),
  //                     ),
  //                     Expanded(
  //                       child: Padding(
  //                         padding: const EdgeInsets.symmetric(horizontal: paddingSize),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             MyText(
  //                               text: "- $amount ${Provider.of<ContractProvider>(context).sortListContract[scanPayM!.assetValue].symbol}",
  //                               hexaColor: AppColors.redColor,
  //                               fontWeight: FontWeight.w500,
  //                             ),
  //                             MyText(
  //                               text: toAddress!,
  //                               fontWeight: FontWeight.w600,
  //                               textAlign: TextAlign.start,
  //                             )
  //                           ],
  //                         ),
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //                 const SizedBox(height: 20),
  //                 const Spacer(),

  //                 textRowWidget("Hash:", hash!),
  //                 textRowWidget("Transaction Date:", trxDate!),
  //                 textRowWidget("From:", Provider.of<ApiProvider>(context).getKeyring.current.address!),
  //                 textRowWidget("To Address:", toAddress!),
  //                 textRowWidget("Fee:", fee!),

  //                 const Spacer(),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

    Widget _detailTrxWidget(BuildContext context) {
      return SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(paddingSize),
            margin: const EdgeInsets.only(top: 80, left: paddingSize, right: paddingSize, bottom: paddingSize),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(18))
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Lottie.asset(
                    "assets/animation/success.json",
                    repeat: true,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),

                const MyText(
                  text: "Payment Success!",
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),

                MyText(
                  pTop: 10,
                  text: "- $amount $assetSymbol",
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color2: Colors.red,
                ),

                const Padding(
                  padding: EdgeInsets.all(paddingSize),
                  child: Divider(),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // textRowWidget(context, "Hash", hash!, isCopy: true),
                      // textRowWidget(context, "Hash", hash!.replaceRange(6, hash!.length - 6, "......."), isCopy: true),
                      textRowWidget(context, "From", Provider.of<ApiProvider>(context).getKeyring.current.address!.replaceRange(6, Provider.of<ApiProvider>(context).getKeyring.current.address!.length - 6, "......."), isCopy: true),
                      textRowWidget(context, "To Address", toAddress!.replaceRange(6, toAddress!.length - 6, "......."), isCopy: true),
                      // textRowWidget(context, "Fee", "768768"),
                      textRowWidget(context, "Payment Date", AppUtils().formattedDate),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      );
  }

  Widget _detailDebitTrxWidget(BuildContext context) {
    return Column(
      children: [
        Column(
          children: const [
            Padding(
              padding: EdgeInsets.only(top: paddingSize + 50),
              child: Icon(Iconsax.tick_circle, color: Colors.lightGreen, size: 40,),
            ),
            MyText(text: "Success" ,fontSize: 18, fontWeight: FontWeight.w600,)
          ],
        ),

        SafeArea(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: CustomPaint(
                painter: TicketPainter(
                  borderColor: Colors.black.withOpacity(0.2),
                  bgColor: const Color(0xFFFFFFFF),
                  dsahHeight: 0.7
                ),
                child: Column(
                  children: [
                    
                    Padding(
                      padding: const EdgeInsets.all(paddingSize + 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: hexaCodeToColor(AppColors.orangeColor),
                                width: 2,
                              ),
                              // color: hexaCodeToColor(AppColors.orangeColor),
                              shape: BoxShape.circle
                            ),
                            child: Icon(Iconsax.receipt, color: hexaCodeToColor(AppColors.orangeColor), size: 25,),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: paddingSize),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyText(
                                  text: "- \$${price! * qty!}",
                                  hexaColor: AppColors.redColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                                const MyText(
                                  text: "SELENDRA Pte., Ltd",
                                  hexaColor: AppColors.blackColor,
                                  textAlign: TextAlign.start,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 1,),

                    Padding(
                      padding: const EdgeInsets.all(paddingSize + 5),
                      child: Column(
                        children: [
                          textRowWidget(context, "Trx. ID:", "12435351353", isCopy: true),
                          textRowWidget(context, "Card Holder:", "4242 XXXX XXXX 4242"),
                          textRowWidget(context, "Transaction Date:", "Oct 01, 2022 5:50PM"),
                          textRowWidget(context, "From:", fromAddress!, isCopy: true),
                          textRowWidget(context, "Original Amount:", "${price! * qty!} USD"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        
        // Padding(
        //   padding: const EdgeInsets.all(20),
        //   child: CouponCard(
        //     height: 380,
        //     curvePosition: 100,
        //     curveRadius: 50,
        //     borderRadius: 25,
        //     decoration: const BoxDecoration(
        //       gradient: LinearGradient(
        //         colors: [
        //           Colors.white,
        //           Colors.white54,
        //         ],
        //         begin: Alignment.topLeft,
        //         end: Alignment.bottomRight,
        //       ),
        //     ),
        //     firstChild: Padding(
        //       padding: const EdgeInsets.all(paddingSize),
        //       child: Row(
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         children: [
        //           Container(
        //             height: 50,
        //             width: 50,
        //             padding: const EdgeInsets.all(10),
        //             decoration: BoxDecoration(
        //               border: Border.all(
        //                 color: hexaCodeToColor(AppColors.orangeColor),
        //                 width: 2,
        //               ),
        //               // color: hexaCodeToColor(AppColors.orangeColor),
        //               shape: BoxShape.circle
        //             ),
        //             child: Icon(Iconsax.receipt, color: hexaCodeToColor(AppColors.orangeColor), size: 25,),
        //           ),
        //           Padding(
        //             padding: const EdgeInsets.symmetric(horizontal: paddingSize),
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 MyText(
        //                   text: "- \$$amount",
        //                   hexaColor: AppColors.redColor,
        //                   fontWeight: FontWeight.w600,
        //                   fontSize: 18,
        //                 ),
        //                 MyText(
        //                   text: "SELENDRA Co,LTD",
        //                   hexaColor: AppColors.blackColor,
        //                   textAlign: TextAlign.start,
        //                 )
        //               ],
        //             ),
        //           )
        //         ],
        //       ),
        //     ),
        //     secondChild: Container(
        //       width: double.maxFinite,
        //       decoration: BoxDecoration(
        //         border: Border(
        //           top: BorderSide(color: Colors.grey.withOpacity(0.5)),
        //         ),
        //       ),
        //       padding: const EdgeInsets.all(paddingSize),
        //       child: Column(
        //         children: [
        //           textRowWidget("Trx. ID:", "12435351353"),
        //           textRowWidget("Card Holder:", "4242 XXXX XXXX 4242"),
        //           textRowWidget("Transaction Date:", "Oct 01, 2022 5:50PM"),
        //           textRowWidget("From:", fromAddress!),
        //           textRowWidget("Original Amount:", "$amount USD"),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),


        // Container(
        //   height: 490,
        //   margin: const EdgeInsets.all(16),
        //   width: MediaQuery.of(context).size.width,
        //   child: CustomPaint(
        //     painter: TicketPainter(
        //       borderColor: Colors.transparent,
        //       bgColor: hexaCodeToColor(isDarkMode ? AppColors.defiMenuItem : AppColors.whiteColorHexa)
        //     ),
        //     child: Container(
        //       padding: const EdgeInsets.all(16),
        //       child: Column(
        //         children: [
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               CircleAvatar(
        //                 backgroundColor: Colors.black,
        //                 child: Image.asset("assets/appbar_event.png"),
        //               ),
        //               Expanded(
        //                 child: Padding(
        //                   padding: const EdgeInsets.symmetric(horizontal: paddingSize),
        //                   child: Column(
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       MyText(
        //                         text: "- \$$amount",
        //                         hexaColor: AppColors.redColor,
        //                         fontWeight: FontWeight.w600,
        //                         fontSize: 18,
        //                       ),
        //                       MyText(
        //                         text: "SELENDRA Co.LTD",
        //                         textAlign: TextAlign.start,
        //                       )
        //                     ],
        //                   ),
        //                 ),
        //               )
        //             ],
        //           ),
        //           const SizedBox(height: 50),
        //           // Spacer(),

        //           textRowWidget("Trx. ID:", "12435351353"),
        //           textRowWidget("Card Holder:", "4242 xxxx xxx 4242"),
        //           textRowWidget("Transaction Date:", "Oct 01, 2022 5:50PM"),
        //           textRowWidget("From:", fromAddress!),
        //           textRowWidget("Original Amount:", "$amount USD"),

        //           Spacer(),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

}