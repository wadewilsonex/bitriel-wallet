import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/ticket_c.dart';
import 'package:wallet_apps/src/screen/home/doers_event_ticket/find_event.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';

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
              Navigator.pushAndRemoveUntil(context, Transition(child: const HomePage(activePage: 3,) ), ModalRoute.withName('/'));
            },
            child: const SizedBox(
              height: kToolbarHeight,
              width: double.infinity,
              child: Center(
                child: MyText(
                  text: 'View Tickets',
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

  Widget _detailTrxWidget(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: paddingSize + 50),
              child: Icon(Iconsax.tick_circle, color: Colors.lightGreen, size: 40.sp,),
            ),
            MyText(text: "Success" ,fontSize: 18, fontWeight: FontWeight.w600,)
          ],
        ),
        Container(
          height: 490,
          margin: const EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width,
          child: CustomPaint(
            painter: TicketPainter(
              borderColor: Colors.transparent,
              bgColor: hexaCodeToColor(isDarkMode ? AppColors.defiMenuItem : AppColors.whiteColorHexa)
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        child: Image.asset(assetLogo!),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: paddingSize),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                text: "- $amount ${Provider.of<ContractProvider>(context).sortListContract[scanPayM!.assetValue].symbol}",
                                hexaColor: AppColors.redColor,
                                fontWeight: FontWeight.w500,
                              ),
                              MyText(
                                text: toAddress!,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.start,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Spacer(),

                  textRowWidget("Hash:", hash!),
                  textRowWidget("Transaction Date:", trxDate!),
                  textRowWidget("From:", Provider.of<ApiProvider>(context).accountM.address!),
                  textRowWidget("To Address:", toAddress!),
                  textRowWidget("Fee:", fee!),

                  Spacer(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _detailDebitTrxWidget(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: paddingSize + 50),
              child: Icon(Iconsax.tick_circle, color: Colors.lightGreen, size: 40.sp,),
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
                                MyText(
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

                    SizedBox(height: 1.h,),

                    Padding(
                      padding: const EdgeInsets.all(paddingSize + 5),
                      child: Column(
                        children: [
                          textRowWidget("Trx. ID:", "12435351353"),
                          textRowWidget("Card Holder:", "4242 XXXX XXXX 4242"),
                          textRowWidget("Transaction Date:", "Oct 01, 2022 5:50PM"),
                          textRowWidget("From:", fromAddress!),
                          textRowWidget("Original Amount:", "${price! * qty!} USD"),
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