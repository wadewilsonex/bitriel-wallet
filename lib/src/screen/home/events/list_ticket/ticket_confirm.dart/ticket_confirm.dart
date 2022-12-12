import 'dart:ui';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/post_request.dart';
import 'package:wallet_apps/src/components/appbar/event_c.dart';
import 'package:wallet_apps/src/components/cards/ticket_item_c.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/models/mdw_ticketing/ticket_m.dart';
import 'package:wallet_apps/src/provider/payment_controller.dart';
import 'package:wallet_apps/src/provider/ticket_p.dart';
import 'package:wallet_apps/src/screen/home/events/list_ticket/list_ticking.dart';
import 'package:wallet_apps/src/screen/home/events/payment_option.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';

import 'package:transition/transition.dart';

class TicketConfirmation extends StatelessWidget {

  final DataSubmittion? dataSubmittion;

  const TicketConfirmation({Key? key, required this.dataSubmittion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: eventAppBar(context: context, title: Provider.of<TicketProvider>(context).eventName),
      body: Column(
        children: [

          Container(
            padding: const EdgeInsets.only(bottom: 20),
            /// If listLength > 1 Card Size Should Minus More 20 To Show A Little Side Of Other
            /// 
            /// Else If TicketType Have Only One Card Size Should Full Width Of The Screen
            width: MediaQuery.of(context).size.width - 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16)
            ),
            margin: const EdgeInsets.all(20),
            child: Column(
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
                        child: Image.network(dataSubmittion!.ticketTypeImage!, fit: BoxFit.cover,),
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
                            text: dataSubmittion!.ticketTypeName,
                            color2: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      )
                    ],
                  ),
                ),
          
                TicketItemComponent(
                  label: 'Price',
                  icon: Icon(Icons.price_change_outlined),
                  value: dataSubmittion!.price!.toString(),
                  valueColor: AppColors.primaryColor, 
                  valueFontSize: 20
                ),
          
                /// Select Date & Amount
                Row(
                  children: [
                    
                    Expanded(
                      child: TicketItemComponent(
                        label: 'Joining Date',
                        icon: Icon(Icons.calendar_month),
                        value: AppUtils.stringDateToDateTime(dataSubmittion!.date!),
                        valueColor: AppColors.primaryColor
                      )
                    ),
          
                    Expanded(
                      child: TicketItemComponent(
                        label: 'Amount',
                        icon: Icon(Icons.confirmation_number_outlined),
                        value: dataSubmittion!.item!.qty!.toString(),
                        valueColor: AppColors.primaryColor
                      )
                    ),
                  ],
                ),
          
                /// Select Date & Amount
                Row(
                  children: [
                    
                    Expanded(
                      child: TicketItemComponent(
                        label: 'Session',
                        icon: Icon(Icons.timelapse_sharp),
                        value: "${dataSubmittion!.from!} - ${dataSubmittion!.to!}",
                        valueColor: AppColors.primaryColor
                      )
                    ),
                  ],
                ),
          
                /// Select Date & Amount
                Row(
                  children: [
                    
                    Expanded(
                      child: TicketItemComponent(
                        label: 'User Name',
                        value: dataSubmittion!.name!,
                        valueColor: AppColors.primaryColor
                      )
                    ),
          
                    Expanded(
                      child: TicketItemComponent(
                        label: 'Phone Number',
                        value: dataSubmittion!.phoneNumber!,
                        valueColor: AppColors.primaryColor
                      )
                    ),
                  ],
                ),
          
                TicketItemComponent(
                  label: 'Email',
                  value: dataSubmittion!.email!,
                  valueColor: AppColors.primaryColor
                )
                
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: ElevatedButton(
              onPressed: () async {

                showDialog(
                  context: context, 
                  builder: (context){
                    return loading();
                  }
                );

                // Navigator.push(
                //   context, 
                //   MaterialPageRoute(builder: (context) => PaymentOptions(qty: 1, price: 10,))
                // );
                
                try {

                  final PaymentController controller = Get.put(PaymentController());
                  
                  await PostRequest().bookTicket(json.encode(DataSubmittion().toJson(dataSubmittion!))).then((value) async {
                    print(value.body);

                    Map<String, dynamic> jsn = Map<String, dynamic>.from((await json.decode(value.body)));
                    
                    await StorageServices.storeData(jsn['token'], DbKey.token);

                    await controller.makePayment(context, {'clientSecret': 'pi_3MDhjfJSyRUhBrUu0q0StOWF_secret_wKWu1Vtd6yPS9aFFdL9defKas'});

                    Navigator.pushAndRemoveUntil(
                      context, 
                      MaterialPageRoute(builder: (context) => HomePage(activePage: 4,))
                      ,(route) => false
                    );
                    
                  });
                } catch (e){
                  if (kDebugMode){
                    print("Error e");
                  }
                }
              }, 
              child: MyText(
                width: MediaQuery.of(context).size.width,
                color2: Colors.white,
                text: "Buy",
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
              style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )),
                padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 20)),
                backgroundColor: MaterialStatePropertyAll(hexaCodeToColor(AppColors.primaryColor)),
              ),
            )
            
          ),
        ],
      ),
    );
  }
}