import 'dart:ui';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/fullscreen_img_c.dart';
import 'package:wallet_apps/src/components/ticket_c.dart';
import 'package:wallet_apps/src/models/nfts/ticket_nft_m.dart';

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
    // Timer(Duration(milliseconds: 10), (){

    //   SystemChrome.setPreferredOrientations([
    //     DeviceOrientation.portraitUp,
    //   ]);
    // });
    // queryEventInfo();
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Stack(
            children: [
        
              ClipRRect(
                child: SizedBox(
                  height: 224,
                  width: MediaQuery.of(context).size.width,
                  child: Hero(
                    tag: "${dotenv.get("IPFS_API")}${widget.ticketNFTModel!.ticketType!.image}",
                    child: Image.network(
                      "${dotenv.get("IPFS_API")}${widget.ticketNFTModel!.ticketType!.image}", 
                      fit: BoxFit.cover
                    )
                    ),
                ),
              ),
        
              Column(
                children: [
                  // Stack Button Back
        
                  Container(
                    height: 80
                    // margin: EdgeInsets.only(bottom: 50),
                  ),
        
                  Container(
                    height: 89,
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FullScreenImageViewer(
                            // "https://images.all-free-download.com/images/graphiclarge/beach_cloud_dawn_horizon_horizontal_landscape_ocean_601821.jpg"
                            "${dotenv.get("IPFS_API")}${widget.ticketNFTModel!.ticketType!.image}"
                            )
                          ),
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
                            )
                          ),
                        ),
                      ),
                    )
                  ),
        
          
                  // Stack Ticketing Details 
                  // Flexible(flex: 5, child: _detailDebitTrxWidget(context)),
                  Align(
                    alignment: AlignmentDirectional.bottomCenter,
                    child: _detailDebitTrxWidget(context),
                  ),
                  
                  // Stack Text Button Full Screen Image
                  // Positioned(
                  //   child: ,
                  // ),
                ],
              ),

              SafeArea(
                child: Container(
                  padding: const EdgeInsets.only(left: 2.9, right: 2.9, top: 2.9),
                  child: Row(
                    children: [
                                    
                      InkWell(
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
                                    
                      Expanded(child: Container()),
                                    
                      // Stack Button Share
                      InkWell(
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
                      )
                    ],
                  ),
                ),
              ),
        
            ],
          ),
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          
                MyText(
                  text: widget.ticketNFTModel!.eventData!.name,
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
                
                Container(
                  margin: const EdgeInsets.only(bottom: 2.9),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      const MyText(
                        bottom: 10,
                        text: "Ticket Price",
                        hexaColor: AppColors.lightGreyColor,
                      ),
          
                      MyText(
                        hexaColor: AppColors.textColor,
                        text: widget.ticketNFTModel!.ticketType!.price!.toString(),
                        fontSize: 2.9,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
          
                Container(
                  margin: const EdgeInsets.only(bottom: 2.9),
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
          
                      Expanded(
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
          
                Container(
                  margin: const EdgeInsets.only(bottom: 2.9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
          
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
          
                            const MyText(
                              bottom: 10,
                              text: "Ticket Type",
                              hexaColor: AppColors.lightGreyColor,
                            ),
          
                            MyText(
                              hexaColor: AppColors.textColor,
                              text: widget.ticketNFTModel!.ticketType!.name!,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
          
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
          
                            MyText(
                              bottom: 10,
                              text: "Visitor",
                              hexaColor: AppColors.lightGreyColor,
                            ),
          
                            MyText(
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
          
                SizedBox(height: 5.5.h,),
          
                Center(
                  child: Column(
                    children: [
          
                      const MyText(
                        top: 2.9,
                        text: "Show This QR Code to Ticket Checker",
                        hexaColor: AppColors.textColor,
                        fontWeight: FontWeight.w600,
                      ),
          
                      SizedBox(height: 2.5.h,),
          
                      InkWell(
                        onTap: () {
          
                          showDialog(
                            context: context, 
                            builder: (context){
                              return Container(
                                color: Colors.black,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                alignment: Alignment.center,
                                // padding: EdgeInsets.all(16),
                                child: Image.network(widget.ticketNFTModel!.qrUrl!),
                              );
                            }
                          );
                        },
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: Image.network(widget.ticketNFTModel!.qrUrl!)
                        ),
                      )
                    ],
                  ),
                ),
          
          
                // Spacer(),
              ],
            ),
          ),
        ),
      ),
    );

  }
}