import 'dart:ui';

import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/cards/ticket_item_c.dart';
import 'package:wallet_apps/src/components/dialog/datetime_picker_c.dart';
import 'package:wallet_apps/src/components/radio/radio_session_c.dart';
import 'package:wallet_apps/src/models/mdw_ticketing/ticket_m.dart';

import '../bottom_sheet/datetime_ticket_c.dart';

class TicketCardComponent extends StatefulWidget{

  final DataSubmittion? dataSubmittion;
  final int? ticketTypeIndex;
  final TicketModel? ticketModel;
  final Map<String, dynamic>? ticketObj;
  final String? imageUrl;
  final double? mgLeft;
  final double? mgRight;
  /// Length Of List TicketTypes
  final int? lstLenght;
  final Function(bool, int)? onTabShow;
  final Function(String type, dynamic value)? onValueChange;
  final Function? onChangeSession;
  final Function? onChangeQty;

  TicketCardComponent({
    required this.dataSubmittion,
    required this.ticketTypeIndex,
    required this.ticketObj, 
    required this.ticketModel, 
    this.imageUrl, 
    this.mgLeft = 0, 
    this.mgRight = 0, 
    this.lstLenght, 
    this.onTabShow,
    this.onValueChange, 
    this.onChangeSession,
    this.onChangeQty
  });

  @override
  State<TicketCardComponent> createState() => _TicketCardComponentState();
}

class _TicketCardComponentState extends State<TicketCardComponent> {
  
  @override
  Widget build(BuildContext context){
    
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(18),
        child: CouponCard(
          height: MediaQuery.of(context).size.height - 100,
          width: MediaQuery.of(context).size.width - 60,
          curvePosition: 125,
          curveRadius: 30,
          borderRadius: 16,
          firstChild:  Stack(
            children: [
    
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.network("${widget.imageUrl}${widget.ticketObj!['image']}", fit: BoxFit.cover,),
              ),
    
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: hexaCodeToColor("#413B3B").withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  height: 145,
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: MyText(
                    text: widget.ticketObj!['name'].toString(),
                    color2: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                )
              )
            ],
          ),
          secondChild: Container(
            color: Colors.white,
            child: Column(
              children: [
                TicketItemComponent(label: "Price", value: widget.ticketObj!['price'].toString(),valueColor: AppColors.primaryColor, valueFontSize: 20),
                TicketItemComponent(label: "Description", value: widget.ticketObj!['description'].toString()),
                Row(
                  children: [
                    Expanded(
                      child: TicketItemComponent(label: "Start Date", value: AppUtils.timeZoneToDateTime(widget.ticketObj!['startDate'])),
                    ),
                    Expanded(
                      child: TicketItemComponent(label: "End Date", value: AppUtils.timeZoneToDateTime(widget.ticketObj!['endDate'])),
                    ),
                  ],
                ),
                TicketItemComponent(label: "Status", value: widget.ticketObj!['status'].toString()),

              ],
            ),
          )
        ),
      ),
    );

    // return SingleChildScrollView(
    //   child: Column(
    //     children: [
          
    //       Container(
    //         padding: EdgeInsets.only(bottom: 20),
    //         width: MediaQuery.of(context).size.width - 60,
    //         decoration: BoxDecoration(
    //           color: Colors.white,
    //           borderRadius: BorderRadius.circular(16)
    //         ),
    //         margin: EdgeInsets.only(top: 20, left: mgLeft!, right: mgRight!, bottom: 20),
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
            
    //             ClipRRect(
    //               borderRadius: BorderRadius.only(
    //                 topLeft: Radius.circular(16),
    //                 topRight: Radius.circular(16)
    //               ),
    //               child: Stack(
    //                 children: [
            
    //                   Container(
    //                     width: MediaQuery.of(context).size.width,
    //                     height: 145,
    //                     decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.only(
    //                         topLeft: Radius.circular(16),
    //                         topRight: Radius.circular(16)
    //                       )
    //                     ),
    //                     child: Image.network("$imageUrl${ticketObj!['image']}", fit: BoxFit.cover,),
    //                   ),
            
    //                   BackdropFilter(
    //                     filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
    //                     child: Container(
    //                       decoration: BoxDecoration(
    //                         color: hexaCodeToColor("#413B3B").withOpacity(0.4),
    //                         borderRadius: BorderRadius.circular(10)
    //                       ),
    //                       height: 145,
    //                       padding: const EdgeInsets.all(10),
    //                       alignment: Alignment.center,
    //                       child: MyText(
    //                         text: ticketObj!['name'].toString(),
    //                         color2: Colors.white,
    //                         fontSize: 18,
    //                         fontWeight: FontWeight.w700,
    //                       ),
    //                     )
    //                   )
    //                 ],
    //               ),
    //             ),
                
    //             TicketItemComponent(label: "Price", value: ticketObj!['price'].toString(),valueColor: AppColors.primaryColor, valueFontSize: 20),
    //             TicketItemComponent(label: "Description", value: ticketObj!['description'].toString()),
    //             Row(
    //               children: [
    //                 Expanded(
    //                   child: TicketItemComponent(label: "Start Date", value: ticketObj!['startDate'].toString()),
    //                 ),
    //                 Expanded(
    //                   child: TicketItemComponent(label: "End Date", value: ticketObj!['endDate'].toString()),
    //                 ),
    //               ],
    //             ),
    //             TicketItemComponent(label: "Status", value: ticketObj!['status'].toString()),
            
    //             TicketItemComponent(
    //               label: "Select Joining Date",
    //               onTap: () async {
    //                 print("dateTimePicker");
    //                 await dateTimePicker(
    //                   context: context
    //                 ).then((value) {
    //                   print("Result ${value}");
    //                   if (value != null){

    //                   }
    //                 });
    //               },
    //               child: Row(
    //                 children: [
            
    //                   Icon(Icons.date_range),
    //                   Expanded(child: Container()),
    //                   Icon(Icons.arrow_forward_ios_outlined)
    //                 ],
    //               )
    //             ),
    
    //             TicketItemComponent(
    //               label: "Session", 
    //               child: Row(
    //                 children: [
            
    //                   Icon(Iconsax.clock),
    //                   Expanded(child: Container()),
    //                   Icon(Icons.arrow_forward_ios_outlined)
    //                 ],
    //               )
    //             ),
                
    //             TicketItemComponent(
    //               label: "Ticket Amount", 
    //               child: Row(
    //                 children: [
            
    //                   Icon(Icons.airplane_ticket),
    //                   Expanded(child: Container()),
    //                   Icon(Icons.arrow_forward_ios_outlined)
    //                 ],
    //               )
    //             ),

    //             Container(
    //               margin: EdgeInsets.only(left: 20, right: 20, top: 30),
    //               child: ElevatedButton(
    //                 style: ButtonStyle(
    //                   shape: MaterialStatePropertyAll(RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.circular(10.0),
    //                   )),
    //                   padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 20)),
    //                   backgroundColor: MaterialStatePropertyAll(hexaCodeToColor(AppColors.primaryColor))
    //                 ),
    //                 onPressed: (){
                
    //                 }, 
    //                 child: MyText(
    //                   width: MediaQuery.of(context).size.width,
    //                   color2: Colors.white,
    //                   text: "Next",
    //                   fontWeight: FontWeight.w700,
    //                   fontSize: 17,
    //                 )
    //               ),
    //             )
            
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}