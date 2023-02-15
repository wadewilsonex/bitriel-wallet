import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/receive_wallet_p.dart';

class DetailsTicketingBody extends StatelessWidget {

  const DetailsTicketingBody({Key? key}) : super(key: key);

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
          text: "Ticket Detail",
          fontSize: 18,
          fontWeight: FontWeight.bold,
          hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Iconsax.arrow_left_2),
        ),
      ),
      body: _detailDebitTrxWidget(context)
    );
  }


  Widget _detailDebitTrxWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(paddingSize),
      child: CouponCard(
        height: MediaQuery.of(context).size.height,
        curvePosition: 250,
        curveRadius: 30,
        borderRadius: 10,
        clockwise: true,
        backgroundColor: Colors.white,
        border: BorderSide(color: hexaCodeToColor(AppColors.primaryColor)),
        shadow: const BoxShadow(
          color: Colors.black54,
          blurRadius: 1
        ),
        // decoration: BoxDecoration(
        //   // color: Colors.white
        //   gradient: LinearGradient(
        //     colors: [
        //       Colors.purple,
        //       Colors.purple.shade700,
        //     ],
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //   ),
        // ),
        firstChild: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const MyText(
              text: "DSC Match",
              hexaColor: AppColors.primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),

            SizedBox(height: 2.5.h,),

            SizedBox(
                height: 150,
                width: 150,
                child: qrCodeGenerator("", "", Provider.of<ReceiveWalletProvider>(context, listen: false).keyQrShare, embeddedImage: false)
            )

          ],
        ),
        secondChild: Container(
          width: double.maxFinite,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.white),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 42),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MyText(
                          text: "Name",
                          hexaColor: AppColors.lightGreyColor,
                        ),

                        SizedBox(height: 1.h,),

                        const MyText(
                          hexaColor: AppColors.textColor,
                          text: "Daveat",
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),

                    // Expanded(
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       const MyText(
                    //         text: "Ticket Price",
                    //         hexaColor: AppColors.lightGreyColor,
                    //       ),
                    //
                    //       SizedBox(height: 1.h,),
                    //
                    //       const MyText(
                    //         hexaColor: AppColors.textColor,
                    //         text: "\$55.00",
                    //         fontSize: 20,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),

              SizedBox(height: 3.h,),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const MyText(
                            text: "Date",
                            hexaColor: AppColors.lightGreyColor,
                          ),

                          SizedBox(height: 1.h,),

                          const MyText(
                            hexaColor: AppColors.textColor,
                            text: "28th, March, 2023",
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MyText(
                          text: "Time",
                          hexaColor: AppColors.lightGreyColor,
                        ),

                        SizedBox(height: 1.h,),

                        const MyText(
                          hexaColor: AppColors.textColor,
                          text: "22:00 - 24:00",
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ],
                ),
              ),


              SizedBox(height: 3.h,),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const MyText(
                            text: "Ticket Type",
                            hexaColor: AppColors.lightGreyColor,
                          ),

                          SizedBox(height: 1.h,),

                          const MyText(
                            hexaColor: AppColors.textColor,
                            text: "Premium\nC10-C12",
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),


                  ],
                ),
              ),

              SizedBox(height: 3.h,),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const MyText(
                            text: "Location",
                            hexaColor: AppColors.lightGreyColor,
                          ),

                          SizedBox(height: 1.h,),

                          const MyText(
                            hexaColor: AppColors.textColor,
                            text: "AIA Stadium, K-Mall, Phnom Penh",
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),


                  ],
                ),
              ),
            ],
          )
        ),
      ),
    );

    // return Container(
    //   margin: const EdgeInsets.all(21),
    //   width: MediaQuery.of(context).size.width,
    //   child: CustomPaint(
    //     painter: TicketPainter(
    //       borderColor: Colors.black.withOpacity(0.2),
    //       bgColor: const Color(0xFFFFFFFF),
    //       dsahHeight: 0.525
    //     ),
    //     child: Padding(
    //       padding: const EdgeInsets.all(20.0),
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //
    //           Center(
    //             child: Column(
    //               children: [
    //                 Center(
    //                   child: const MyText(
    //                     text: "DSC Match",
    //                     hexaColor: AppColors.primaryColor,
    //                     fontSize: 20,
    //                     fontWeight: FontWeight.w600,
    //                   ),
    //                 ),
    //
    //                 SizedBox(height: 2.5.h,),
    //
    //                 SizedBox(
    //                     height: 150,
    //                     width: 150,
    //                     child: qrCodeGenerator("", "", Provider.of<ReceiveWalletProvider>(context, listen: false).keyQrShare)
    //                 )
    //               ],
    //             ),
    //           ),
    //
    //           SizedBox(height: 7.h,),
    //
    //           SizedBox(
    //             width: 250,
    //             child: Center(
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 children: [
    //
    //                   Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       const MyText(
    //                         text: "Name",
    //                         hexaColor: AppColors.lightGreyColor,
    //                       ),
    //
    //                       SizedBox(height: 1.h,),
    //
    //                       const MyText(
    //                         hexaColor: AppColors.textColor,
    //                         text: "Daveat",
    //                         fontWeight: FontWeight.bold,
    //                       ),
    //                     ],
    //                   ),
    //
    //                   // Expanded(
    //                   //   child: Column(
    //                   //     mainAxisAlignment: MainAxisAlignment.start,
    //                   //     crossAxisAlignment: CrossAxisAlignment.start,
    //                   //     children: [
    //                   //       const MyText(
    //                   //         text: "Ticket Price",
    //                   //         hexaColor: AppColors.lightGreyColor,
    //                   //       ),
    //                   //
    //                   //       SizedBox(height: 1.h,),
    //                   //
    //                   //       const MyText(
    //                   //         hexaColor: AppColors.textColor,
    //                   //         text: "\$55.00",
    //                   //         fontSize: 20,
    //                   //         fontWeight: FontWeight.bold,
    //                   //       ),
    //                   //     ],
    //                   //   ),
    //                   // ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //
    //           SizedBox(height: 3.h,),
    //
    //           SizedBox(
    //             width: 300,
    //             child: Center(
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //
    //                   Expanded(
    //                     child: Column(
    //                       mainAxisAlignment: MainAxisAlignment.start,
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         const MyText(
    //                           text: "Date",
    //                           hexaColor: AppColors.lightGreyColor,
    //                         ),
    //
    //                         SizedBox(height: 1.h,),
    //
    //                         const MyText(
    //                           hexaColor: AppColors.textColor,
    //                           text: "28th, March",
    //                           fontWeight: FontWeight.bold,
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //
    //                   SizedBox(
    //                     width: 25.w,
    //                     child: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         const MyText(
    //                           text: "Time",
    //                           hexaColor: AppColors.lightGreyColor,
    //                         ),
    //
    //                         SizedBox(height: 1.h,),
    //
    //                         const MyText(
    //                           hexaColor: AppColors.textColor,
    //                           text: "22:00 - 24:00",
    //                           fontWeight: FontWeight.bold,
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //
    //
    //           SizedBox(height: 3.h,),
    //
    //           SizedBox(
    //             width: 300,
    //             child: Center(
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //
    //                   Expanded(
    //                     child: Column(
    //                       mainAxisAlignment: MainAxisAlignment.start,
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         const MyText(
    //                           text: "Ticket Type",
    //                           hexaColor: AppColors.lightGreyColor,
    //                         ),
    //
    //                         SizedBox(height: 1.h,),
    //
    //                         const MyText(
    //                           hexaColor: AppColors.textColor,
    //                           text: "Premium\nC10-C12",
    //                           fontWeight: FontWeight.bold,
    //                           textAlign: TextAlign.start,
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //
    //
    //                 ],
    //               ),
    //             ),
    //           ),
    //
    //           SizedBox(height: 3.h,),
    //
    //           SizedBox(
    //             width: 300,
    //             child: Center(
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //
    //                   Expanded(
    //                     child: Column(
    //                       mainAxisAlignment: MainAxisAlignment.start,
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         const MyText(
    //                           text: "Location",
    //                           hexaColor: AppColors.lightGreyColor,
    //                         ),
    //
    //                         SizedBox(height: 1.h,),
    //
    //                         const MyText(
    //                           hexaColor: AppColors.textColor,
    //                           text: "AIA Stadium, K-Mall, Phnom Penh",
    //                           fontWeight: FontWeight.bold,
    //                           textAlign: TextAlign.start,
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //
    //
    //                 ],
    //               ),
    //             ),
    //           ),
    //
    //
    //           // Spacer(),
    //         ],
    //       ),
    //     ),
    //   ),
    // );

  }
}