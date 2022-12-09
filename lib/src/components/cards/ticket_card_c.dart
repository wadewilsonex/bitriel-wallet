import 'dart:ui';

import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/cards/ticket_item_c.dart';
import 'package:wallet_apps/src/components/dialog/datetime_picker_c.dart';
import 'package:wallet_apps/src/components/radio/radio_session_c.dart';
import 'package:wallet_apps/src/models/ticket_m.dart';

import '../bottom_sheet/datetime_ticket_c.dart';

class TicketCardComponent extends StatelessWidget{

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
    required this.onTabShow,
    required this.onValueChange, 
    required this.onChangeSession,
    required this.onChangeQty
  });

  @override
  Widget build(BuildContext context){
    print("dataSubmittion!.from!.isNotEmpty && dataSubmittion!.to!.isNotEmpty ${dataSubmittion!.from!.isNotEmpty && dataSubmittion!.to!.isNotEmpty}");
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
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
              mainAxisSize: MainAxisSize.min,
              children: [
            
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)
                  ),
                  child: Stack(
                    children: [
            
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 145,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16)
                          )
                        ),
                        child: Image.network("$imageUrl${ticketObj!['image']}", fit: BoxFit.cover,),
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
                            text: ticketObj!['name'].toString(),
                            color2: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      )
                    ],
                  ),
                ),
                
                TicketItemComponent(label: "Price", value: ticketObj!['price'].toString(),valueColor: AppColors.primaryColor, valueFontSize: 20),
                TicketItemComponent(label: "Description", value: ticketObj!['description'].toString()),
                Row(
                  children: [
                    Expanded(
                      child: TicketItemComponent(label: "Start Date", value: AppUtils.timeZoneToDateTime(ticketObj!['startDate'])),
                    ),
                    Expanded(
                      child: TicketItemComponent(label: "End Date", value: AppUtils.timeZoneToDateTime(ticketObj!['endDate'])),
                    ),
                  ],
                ),
                TicketItemComponent(label: "Status", value: ticketObj!['status'].toString()),

                /// 1
                TicketItemComponent(
                  label: "Select Joining Date",
                  onTap: () async {
                    print("dateTimePicker");
                    await dateTimeTicket(context: context, data: ticketModel!.lstMontYear!, tkTypeIndex: ticketTypeIndex ).then((value) {
                      // if (value != null){
                      //   print("Value $value");
                      // }

                      if (value != null){
                        /// Return Data: {'date': data[index]['value'][i], 'index': i}
                        onValueChange!('join_date', value);
                      }
                    });
                    // await dateTimePicker(
                    //   context: context,
                    //   ticketObj: ticketModel!.lstSession![ticketTypeIndex!]
                    // ).then((value) {
                    //   print("Result ${value}");
                    // });
                  },
                  child: Row(
                    children: [
            
                      Icon(Icons.date_range), 
                      ticketModel!.lsTicketTypes![ticketTypeIndex!].isDate! ? MyText(
                        left: 10,
                        text: AppUtils.stringDateToDateTime(ticketModel!.lsTicketTypes![ticketTypeIndex!].selectDate!),
                        fontWeight: FontWeight.w600,
                      ) : Container(),
                      Expanded(child: Container()),
                      Icon(Icons.arrow_forward_ios_outlined)
                    ],
                  )
                ),
    
                /// 2
                ticketModel!.lsTicketTypes![ticketTypeIndex!].isDate! ? TicketItemComponent(
                  label: "Session",
                  onTap: (){
                    onTabShow!(!(ticketModel!.lstMontYear![ticketTypeIndex!].isShow!), ticketTypeIndex!);
                  },
                  child: Row(
                    children: [
            
                      Icon(Iconsax.clock),
                      Expanded(child: Container()),
                      Icon(!(ticketModel!.lstMontYear![ticketTypeIndex!].isShow!) ? Icons.arrow_forward_ios_outlined : Icons.keyboard_arrow_down_sharp)
                      
                    ],
                  )
                ) : Container(),

                /// 2.1 Sessioin Drop Down
                /// 
                /// List Sessions
                if (ticketModel!.lstMontYear![ticketTypeIndex!].isShow!)
                  Container(
                    margin: EdgeInsets.only(left: 45, right: 45),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: ticketModel!.lstMontYear![ ticketTypeIndex! ].lstSessionsByMonth![ ticketModel!.lsTicketTypes![ticketTypeIndex!].mmYYIndex! ].lstDateAndSessions![ ticketModel!.lsTicketTypes![ticketTypeIndex!].joinDateIndex! ].sessions!.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            RadioComponent(
                              data: {
                                "from": ticketModel!.lstMontYear![ ticketTypeIndex! ].lstSessionsByMonth![ ticketModel!.lsTicketTypes![ticketTypeIndex!].mmYYIndex! ].lstDateAndSessions![ ticketModel!.lsTicketTypes![ticketTypeIndex!].joinDateIndex! ].sessions![index].from,
                                "to": ticketModel!.lstMontYear![ ticketTypeIndex! ].lstSessionsByMonth![ ticketModel!.lsTicketTypes![ticketTypeIndex!].mmYYIndex! ].lstDateAndSessions![ ticketModel!.lsTicketTypes![ticketTypeIndex!].joinDateIndex! ].sessions![index].to,
                              },
                              groupValue: ticketModel!.lstMontYear![ticketTypeIndex!].initSession,
                              value: index+1,
                              label: 'session', 
                              /// 1. [ticketTypeIndex] : [ {key: December-2022, value: [{date: 2022-12-13.... ]
                              /// 2. [value] 
                              title: """${ticketModel!.lstMontYear![ ticketTypeIndex! ].lstSessionsByMonth![ ticketModel!.lsTicketTypes![ticketTypeIndex!].mmYYIndex! ].lstDateAndSessions![ ticketModel!.lsTicketTypes![ticketTypeIndex!].joinDateIndex! ].sessions![index].from} - ${ticketModel!.lstMontYear![ ticketTypeIndex! ].lstSessionsByMonth![ ticketModel!.lsTicketTypes![ticketTypeIndex!].mmYYIndex! ].lstDateAndSessions![ ticketModel!.lsTicketTypes![ticketTypeIndex!].joinDateIndex! ].sessions![index].to}""", 
                              onChangeSession: onChangeSession,
                              index: ticketTypeIndex,
                            ),

                            if(index != ticketModel!.lstMontYear![ ticketTypeIndex! ].lstSessionsByMonth![ ticketModel!.lsTicketTypes![ticketTypeIndex!].mmYYIndex! ].lstDateAndSessions![ ticketModel!.lsTicketTypes![ticketTypeIndex!].joinDateIndex! ].sessions!.length-1) Divider(
                              height: 1,
                              thickness: 1,
                            ),
                            
                          ],
                        );
                      }
                    ),
                  ),
                
                if ( dataSubmittion!.from!.isNotEmpty && dataSubmittion!.to!.isNotEmpty )
                TicketItemComponent(
                  label: "Ticket Amount", 
                  child: Row(
                    children: [
            
                      Icon(Icons.airplane_ticket),
                      Expanded(child: Container()),

                      Row(
                        children: [

                          IconButton(
                            onPressed: (){
                              onChangeQty!(-1);
                            }, 
                            icon: Icon(Icons.add)
                          ),

                          MyText(
                            text: dataSubmittion!.item!.qty.toString(),
                            fontSize: 18,
                          ),

                          IconButton(
                            onPressed: (){

                              onChangeQty!(1);
                            }, 
                            icon: Icon(Icons.add)
                          )
                        ],
                      )
                    ],
                  )
                ) 
                else Container(),

                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                      padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 20)),
                      backgroundColor: MaterialStatePropertyAll(hexaCodeToColor( dataSubmittion!.item!.qty != 0 ? AppColors.primaryColor : AppColors.greyCode))
                    ),
                    onPressed: dataSubmittion!.item!.qty == 0 ? null : (){
                      // Navigator.push(
                      //   context, route
                      //   )
                    }, 
                    child: MyText(
                      width: MediaQuery.of(context).size.width,
                      color2: Colors.white,
                      text: "Next",
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    )
                  ),
                )
            
              ],
            ),
          ),
        ],
      ),
    );
  }
}