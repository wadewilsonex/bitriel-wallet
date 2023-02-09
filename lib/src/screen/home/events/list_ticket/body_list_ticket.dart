import 'dart:ui';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/cards/ticket_item_c.dart';
import 'package:wallet_apps/src/models/mdw_ticketing/ticket_m.dart';

class ListTicketTypeBody extends StatelessWidget {

  final int? lstLenght;
  final double? mgLeft;
  final double? mgRight;
  final String? imgUrl;
  final TicketModel? ticketModel;
  final ScrollController? controller;
  /// Index OF Month - Year
  final int? index;

  const ListTicketTypeBody({
    Key? key, 
    required this.imgUrl, 
    required this.index, 
    required this.ticketModel,
    required this.lstLenght,
    required this.mgLeft,
    required this.mgRight,
    this.controller
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return CouponCard(
      height: 300,
      curvePosition: 150,
      curveRadius: 30,
      borderRadius: 10,
      decoration: BoxDecoration(
        color: hexaCodeToColor(AppColors.whiteColorHexa)
      ),
      firstChild: Stack(
        children: [

          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.network("$imgUrl${ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.image}", fit: BoxFit.cover,)
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: paddingSize / 2, left: paddingSize / 2),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.only(right: paddingSize, left: paddingSize, top: paddingSize / 2, bottom: paddingSize / 2),
                decoration: BoxDecoration(
                  color: hexaCodeToColor(AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: MyText(
                  text: "USD \$${ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.price.toString()}",
                  color2: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )
        ],
      ),
      secondChild: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.name.toString(),
                hexaColor: AppColors.textColor,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.start,
              ),

              const Spacer(),

              MyText(
                text: ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.description.toString(),
                hexaColor: AppColors.greyCode,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 5,),

              MyText(
                text: ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.status.toString(),
                hexaColor: ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.status == "Expired"
                    ? AppColors.warningColor
                    : AppColors.primaryColor,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );

    // return Column(
    //   children: [
    //
    //     Container(
    //       padding: const EdgeInsets.only(bottom: 20),
    //       /// If listLength > 1 Card Size Should Minus More 20 To Show A Little Side Of Other
    //       ///
    //       /// Else If TicketType Have Only One Card Size Should Full Width Of The Screen
    //       width: MediaQuery.of(context).size.width - (lstLenght! > 1 ? 60 : 40),
    //       decoration: BoxDecoration(
    //         color: Colors.white,
    //         borderRadius: BorderRadius.circular(16)
    //       ),
    //       margin: EdgeInsets.only(top: 20, left: mgLeft!, right: mgRight!, bottom: 20),
    //       child: Column(
    //         children: [
    //
    //           ClipRRect(
    //
    //             borderRadius: const BorderRadius.only(
    //               topLeft: Radius.circular(16),
    //               topRight: Radius.circular(16)
    //             ),
    //             child: Stack(
    //               children: [
    //
    //                 Container(
    //                   width: MediaQuery.of(context).size.width,
    //                   height: 145,
    //                   decoration: const BoxDecoration(
    //                     borderRadius: BorderRadius.only(
    //                       topLeft: Radius.circular(16),
    //                       topRight: Radius.circular(16)
    //                     )
    //                   ),
    //                   child: Image.network("$imgUrl${ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.image}", fit: BoxFit.cover,),
    //                 ),
    //
    //                 BackdropFilter(
    //                   filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
    //                   child: Container(
    //                     decoration: BoxDecoration(
    //                       color: hexaCodeToColor("#413B3B").withOpacity(0.4),
    //                       borderRadius: BorderRadius.circular(10)
    //                     ),
    //                     height: 145,
    //                     padding: const EdgeInsets.all(10),
    //                     alignment: Alignment.center,
    //                     child: MyText(
    //                       text: ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.name.toString(),
    //                       color2: Colors.white,
    //                       fontSize: 18,
    //                       fontWeight: FontWeight.w700,
    //                     ),
    //                   )
    //                 )
    //               ],
    //             ),
    //           ),
    //
    //           TicketItemComponent(label: "Price", value: ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.price.toString(), valueColor: AppColors.primaryColor, valueFontSize: 20),
    //
    //           TicketItemComponent(label: "Description", value: ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.description.toString()),
    //
    //           Row(
    //             children: [
    //               Expanded(
    //                 child: TicketItemComponent(label: "Start Date", value: AppUtils.timeZoneToDateTime(ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.startDate!)),
    //               ),
    //               Expanded(
    //                 child: TicketItemComponent(label: "End Date", value: AppUtils.timeZoneToDateTime(ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.endDate!)),
    //               ),
    //             ],
    //           ),
    //
    //           TicketItemComponent(label: "Status", value: ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.status.toString()),
    //
    //           TicketItemComponent(label: "Date", icon: const Icon(Icons.date_range), onTap: () async {
    //
    //               await showDialog(
    //                 context: context,
    //                 builder: (context){
    //                   return const AlertDialog(
    //                     title: MyText(
    //                       text: "Message",
    //                       fontSize: 17,
    //                       fontWeight: FontWeight.w600,
    //                     ),
    //                     content: MyText(
    //                       height: 30,
    //                       text: "Under construction",
    //                       fontSize: 16,
    //                     ),
    //                   );
    //                 }
    //               );
    //           },)
    //           // Reservation(
    //           //   ticketModel: ticketModel!,
    //           //   controller: controller,
    //           //   dataSubmittion: DataSubmittion.assignAboveData(
    //           //     ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.name!,
    //           //     "$imgUrl${ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.image!}",
    //           //     index!,
    //           //     ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.price!,
    //           //   ),
    //           //   index: index,
    //           //   eventId: ticketModel!.eventId,
    //           //   ticketTypeId: ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.id,
    //           //   ticketTypeModel: ticketModel!.lsTicketTypes![index!]
    //           // )
    //
    //         ],
    //       )
    //
    //     ),
    //   ],
    // );

  }
}