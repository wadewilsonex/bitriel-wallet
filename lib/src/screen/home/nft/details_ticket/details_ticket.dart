import 'dart:ui';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/get_request.dart';
import 'package:wallet_apps/src/components/fullscreen_img_c.dart';
import 'package:wallet_apps/src/components/ticket_c.dart';
import 'package:wallet_apps/src/models/nfts/ticket_nft_m.dart';
import 'package:wallet_apps/src/provider/receive_wallet_p.dart';
import 'package:wallet_apps/src/screen/home/nft/details_ticket/body_details_ticket.dart';

class DetailsTicketing extends StatefulWidget {

  final TicketNFTModel? ticketNFTModel;
  
  const DetailsTicketing({Key? key, required this.ticketNFTModel}) : super(key: key);

  @override
  State<DetailsTicketing> createState() => _DetailsTicketingState();
}

class _DetailsTicketingState extends State<DetailsTicketing> {
  
  // void queryEventInfo() async {
  //   await queryEventById(widget.ticketNFTModel!.eventId!).then((value) async {
  //     print("value ${value}");
  //     widget.ticketNFTModel!.eventData = EventData.fromJson((await json.decode(value.body)));

  //     setState(() {
        
  //     });
  //   });
  // }

  @override
  initState(){
    // queryEventInfo();
    super.initState();
  }

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

                ClipRRect(
                  child: Container(
                    height: 224,
                    width: MediaQuery.of(context).size.width,
                    child: Image.network("${dotenv.get("IPFS_API")}${widget.ticketNFTModel!.ticketType!.image}", fit: BoxFit.cover),
                  ),
                ),

                // Stack Button Back
                Positioned(
                  left: 25,
                  top: 25 + 20,
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
                      child: Icon(Iconsax.arrow_left_2, color: hexaCodeToColor(AppColors.whiteColorHexa), size: 14),
                    ),
                  ),
                ),
            
                // Stack Button Share
                Positioned(
                  right: 25,
                  top: 25 + 20,
                  child: InkWell(
                    onTap: () {
            
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle
                      ),
                      child: Icon(Iconsax.link, color: hexaCodeToColor(AppColors.whiteColorHexa), size: 14,),
                    ),
                  ),
                ),
                
                // Stack Text Button Full Screen Image
                Positioned(
                  child: Container(
                    height:220,
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FullScreenImageViewer("${dotenv.get("IPFS_API")}${widget.ticketNFTModel!.ticketType!.image}")),
                        );
                      },
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: paddingSize / 2, horizontal: paddingSize * 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(30)
                            ),
                            child: const MyText(
                              text: "Full Screen",
                              fontWeight: FontWeight.w600,
                              textAlign: TextAlign.center,
                              hexaColor: "#CFCFCF",
                              // fontSize: 17,
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              MyText(
                text: widget.ticketNFTModel!.eventData!.name,
                hexaColor: AppColors.orangeColor,
                fontSize: 20,
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

                            MyText(
                              hexaColor: AppColors.textColor,
                              text: widget.ticketNFTModel!.ticketType!.price!.toString(),
                              fontSize: 20,
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

                            MyText(
                              hexaColor: AppColors.textColor,
                              text: AppUtils.stringDateToDateTime(widget.ticketNFTModel!.reservation!.session!.date!),
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

                            MyText(
                              textAlign: TextAlign.start,
                              hexaColor: AppColors.textColor,
                              text: "${widget.ticketNFTModel!.reservation!.session!.from!} - ${widget.ticketNFTModel!.reservation!.session!.to!}",
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

                            MyText(
                              hexaColor: AppColors.textColor,
                              text: widget.ticketNFTModel!.ticketType!.name!,
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
                              text: "User",
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
                      top: 20,
                      text: "Show This QR Code to Ticket Checker",
                      hexaColor: AppColors.textColor,
                      fontWeight: FontWeight.w600,
                    ),

                    SizedBox(height: 2.5.h,),

                    SizedBox(
                      height: 150,
                      width: 150,
                      child: qrCodeGenerator(widget.ticketNFTModel!.qrUrl!, "", Provider.of<ReceiveWalletProvider>(context, listen: false).keyQrShare)
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