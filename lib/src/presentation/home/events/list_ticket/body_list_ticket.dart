import 'dart:ui';
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

    return Column(
      children: [

        Container(
          padding: const EdgeInsets.only(bottom: 20),
          /// If listLength > 1 Card Size Should Minus More 20 To Show A Little Side Of Other
          /// 
          /// Else If TicketType Have Only One Card Size Should Full Width Of The Screen
          width: MediaQuery.of(context).size.width - (lstLenght! > 1 ? 60 : 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16)
          ),
          margin: EdgeInsets.only(top: 20, left: mgLeft!, right: mgRight!, bottom: 20),
          child: Column(
            children: [

              ClipRRect(

                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16)
                ),
                child: Stack(
                  children: [

                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 145,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16)
                        )
                      ),
                      child: Image.network("$imgUrl${ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.image}", fit: BoxFit.cover,),
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
                          text: ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.name.toString(),
                          color2: Colors.white,
                          fontSize: 2.6,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    )
                  ],
                ),
              ),

              TicketItemComponent(label: "Price", value: ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.price.toString(), valueColor: AppColors.primaryColor, valueFontSize: 20),
              
              TicketItemComponent(label: "Description", value: ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.description.toString()),
              
              Row(
                children: [
                  Expanded(
                    child: TicketItemComponent(label: "Start Date", value: AppUtils.timeZoneToDateTime(ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.startDate!)),
                  ),
                  Expanded(
                    child: TicketItemComponent(label: "End Date", value: AppUtils.timeZoneToDateTime(ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.endDate!)),
                  ),
                ],
              ),
              
              TicketItemComponent(label: "Status", value: ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.status.toString()),
              
              TicketItemComponent(label: "Date", icon: const Icon(Icons.date_range), onTap: () async {

                  await showDialog(
                    context: context, 
                    builder: (context){
                      return AlertDialog(
                        title: const MyText(
                          text: "Message",
                          fontSize: 2.5,
                          fontWeight: FontWeight.w600,
                        ),
                        content: MyText(
                          height: 4.4.sp,
                          text: "Under construction",
                          fontSize: 2.4,
                        ),
                      );
                    }
                  );
              },)
              // Reservation(
              //   ticketModel: ticketModel!,
              //   controller: controller,
              //   dataSubmittion: DataSubmittion.assignAboveData(
              //     ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.name!,
              //     "$imgUrl${ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.image!}",
              //     index!,
              //     ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.price!,
              //   ),
              //   index: index,
              //   eventId: ticketModel!.eventId,
              //   ticketTypeId: ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.id,
              //   ticketTypeModel: ticketModel!.lsTicketTypes![index!]
              // )

            ],
          )

        ),
      ],
    );
  }
}