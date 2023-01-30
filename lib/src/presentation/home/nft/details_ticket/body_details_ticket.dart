import 'dart:ui';

import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/ticket_c.dart';
import 'package:wallet_apps/src/provider/receive_wallet_p.dart';
import 'package:wallet_apps/src/components/fullscreen_img_c.dart';

class DetailsTicketingBody extends StatelessWidget {

  const DetailsTicketingBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints(
          maxHeight: double.infinity,
        ),
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [

            Stack(
              children: [

                Image.network("https://source.unsplash.com/800x600/?music"),

                // Stack Button Back
                Positioned(
                  left: 25,
                  top: 25,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          shape: BoxShape.circle
                      ),
                      child: Icon(Iconsax.arrow_left_2, color: hexaCodeToColor(AppColors.whiteColorHexa)),
                    ),
                  ),
                ),
            
                // Stack Button Share
                Positioned(
                  right: 25,
                  top: 25,
                  child: InkWell(
                    onTap: () {
            
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          shape: BoxShape.circle
                      ),
                      child: Icon(Iconsax.link, color: hexaCodeToColor(AppColors.whiteColorHexa)),
                    ),
                  ),
                ),
                
                // Stack Text Button Full Screen Image
                Positioned(
                  child: Container(
                    height:250,
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FullScreenImageViewer('assets/ticket.png')),
                        );
                      },
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: paddingSize / 2, horizontal: paddingSize * 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(30)
                            ),
                            child: const MyText(
                              text: "Full Screen",
                              fontWeight: FontWeight.w600,
                              textAlign: TextAlign.center,
                              hexaColor: "#CFCFCF",
                              fontSize: 2.5,
                            )
                          ),
                        ),
                      ),
                    )
                  ),
                ),

              ],
            ),
            // Stack Ticketing Details 
            // Flexible(flex: 5, child: _detailDebitTrxWidget(context)),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: _detailDebitTrxWidget(context),
            ),
          ],
        ),
      )
    );
  }


  Widget _detailDebitTrxWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(21),
      width: MediaQuery.of(context).size.width,
      child: CustomPaint(
        painter: TicketPainter(
          borderColor: Colors.black.withOpacity(0.2),
          bgColor: const Color(0xFFFFFFFF),
          dsahHeight: 0.37
        ),
        child: Padding(
          padding: EdgeInsets.all(2.9.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const MyText(
                text: "Night Music Festival",
                hexaColor: AppColors.orangeColor,
                fontSize: 2.9,
                fontWeight: FontWeight.w600,
              ),

              SizedBox(height: 2.h,),

              const MyText(
                text: "Get Ready for the best music festival.",
                hexaColor: AppColors.textColor,
              ),

              SizedBox(height: 3.h,),
              
              SizedBox(
                width: 250,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const MyText(
                              text: "Ticket Price",
                              hexaColor: AppColors.lightGreyColor,
                            ),
                            
                            SizedBox(height: 1.h,),

                            const MyText(
                              hexaColor: AppColors.textColor,
                              text: "\$55.00",
                              fontSize: 2.9,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 3.h,),

              SizedBox(
                width: 300,
                child: Center(
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
                              text: "28th, March",
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        width: 22.w,
                        child: Column(
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
                      ),
                    ],
                  ),
                ),
              ),


              SizedBox(height: 3.h,),

              SizedBox(
                width: 300,
                child: Center(
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

                      SizedBox(
                        width: 22.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const MyText(
                              text: "Visitor",
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
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 5.5.h,),

              Center(
                child: Column(
                  children: [
                    const MyText(
                      text: "Show This QR Code to Ticket Checker",
                      hexaColor: AppColors.textColor,
                      fontWeight: FontWeight.w600,
                    ),

                    SizedBox(height: 2.5.h,),

                    SizedBox(
                      height: 150,
                      width: 150,
                      child: qrCodeGenerator("", "", Provider.of<ReceiveWalletProvider>(context, listen: false).keyQrShare)
                    )
                  ],
                ),
              ),


              // Spacer(),
            ],
          ),
        ),
      ),
    );

  }
}