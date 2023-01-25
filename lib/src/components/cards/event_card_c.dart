import 'dart:ui';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/ticket_p.dart';
import 'package:wallet_apps/src/presentation/home/events/list_ticket/list_ticking.dart';

class EventCardComponents extends StatelessWidget {

  final String? ipfsAPI;
  final String? title;
  final String? eventName;
  final String? eventDate;
  final List<Map<String, dynamic>>? listEvent;

  const EventCardComponents({Key? key, 
    this.ipfsAPI,
    this.title, 
    this.eventName, 
    this.eventDate,
    this.listEvent
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
    
        MyText(
          top: 4.vmax,
          left: 4.vmax,
          bottom: 1.vmax,
          text: title,
          fontSize: 2.7,
          fontWeight: FontWeight.w600,
        ),
        
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 24.vmax,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: List.generate(
              listEvent!.length,
              (i) => Padding(
                padding: EdgeInsets.only(
                  left: i == 0 ? 3.vmax : 0,
                  right: i != 19 ? 5.vmax : 0,
                ),
                child: InkWell(
                  onTap: (){

                    Provider.of<TicketProvider>(context, listen: false).eventName = listEvent![i]['name']!;
                    
                    Navigator.push(
                      context, 
                      Transition(child: ListTicketType(eventName: listEvent![i]['name']!, eventId: listEvent![i]['_id']!), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2.vmax),
                    child: Stack(
                      children: [
                  
                        Container(
                          color: Colors.white,
                          height: 27.h,
                          width: MediaQuery.of(context).size.width - 13.vmax,
                          child: listEvent!.isNotEmpty ? Image.network("$ipfsAPI${listEvent![i]['image']}", fit: BoxFit.cover,) : Container()
                        ),
                  
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 1.8.vmax, bottom: 1.8.vmax),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1.5.vmax),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 9.0, sigmaY: 9.0),
                                  child: Container(
                                  // height: 8.h,
                                  padding: EdgeInsets.all(1.5.vmax),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    
                                      MyText(
                                        text: AppUtils.timeZoneToDateTime(listEvent![i]['startDate']),
                                        fontSize: 2.2,
                                        fontWeight: FontWeight.w600,
                                        bottom: 5,
                                        hexaColor: "#878787",
                                      ),
                                    
                                      MyText(
                                        text: listEvent![i]['name'], //"NIGHT MUSIC FESTIVAL",
                                        fontSize: 2.4,
                                        color2: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    
                        // Positioned(
                        //   right: 10,
                        //   top: 10,
                        //   child: Container(
                        //     // alignment: Alignment.bottomLeft,
                        //     decoration: BoxDecoration(
                        //       color: hexaCodeToColor("#413B3B").withOpacity(0.7),
                        //       borderRadius: BorderRadius.circular(30)
                        //     ),
                        //     // width: MediaQuery.of(context).size.width - 60,
                        //     height: 5.h,
                        //     width: 5.h,
                        //     padding: EdgeInsets.all(10),
                        //     child: Icon(Iconsax.heart, color: Colors.white, size: 4.w,),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
    
        ),
      ],
    );
  }
}