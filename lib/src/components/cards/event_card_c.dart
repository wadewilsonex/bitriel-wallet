import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/ticket_p.dart';
import 'package:wallet_apps/src/screen/home/events/list_ticket/list_ticking.dart';

class EventCardComponents extends StatelessWidget {

  final String? ipfsAPI;
  final String? title;
  final String? eventName;
  final String? eventDate;
  final List<Map<String, dynamic>>? listEvent;

  const EventCardComponents({
    Key? key, 
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

        title != null ? MyText(
          top: 15,
          left: 22,
          bottom: 10,
          text: title,
          fontSize: 22,
          hexaColor: AppColors.blackColor,
          fontWeight: FontWeight.w600,
        ) : Container(),

        CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 16 / 13,
            // aspectRatio: 2.2,
            enlargeStrategy: CenterPageEnlargeStrategy.zoom,
            autoPlay: false,
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
            viewportFraction: 0.92
          ),
          items: listEvent!
            .map((item) => InkWell(
              onTap: (){

                // Provider.of<TicketProvider>(context, listen: false).eventName = item['name']!;

                // Navigator.push(
                //   context,
                //   Transition(child: ListTicketType(eventName: item['name']!, eventId: item['_id']!), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                // );

              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(5.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16))
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      padding: const EdgeInsets.all(paddingSize),
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(16)) ,
                        child: Image.network(item["eventImage"], fit: BoxFit.cover,)
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: paddingSize),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: item['eventName'],
                            fontSize: 22,
                            hexaColor: AppColors.primaryColor,
                            fontWeight: FontWeight.w700,
                            textAlign: TextAlign.start,
                          ),

                          MyText(
                            pTop: 10,
                            text: item["eventDate"],
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            hexaColor: AppColors.blackColor,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(paddingSize),
                      child: Row(
                        children: [
                          Icon(Iconsax.location, color: hexaCodeToColor(AppColors.primaryColor),),

                          MyText(
                            pLeft: 5,
                            text: item["eventLocation"],
                            fontSize: 18,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    )

                  ],
                ),
              ),
              // child: Stack(
              //     children: <Widget>[
              //       SizedBox(
              //         height: MediaQuery.of(context).size.height,
              //         width: MediaQuery.of(context).size.width,
              //         child: Image.network(item["asset"], fit: BoxFit.cover,),
              //       ),
            
              //       Align(
              //         alignment: Alignment.bottomLeft,
              //         child: Container(
              //           margin: const EdgeInsets.only(left: 10, bottom: 10),
              //           child: ClipRRect(
              //             borderRadius: BorderRadius.circular(10),
              //               child: BackdropFilter(
              //                 filter: ImageFilter.blur(sigmaX: 9.0, sigmaY: 9.0),
              //                 child: Container(
              //                 decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(10),
              //                 ),
              //                 padding: const EdgeInsets.all(10),
              //                 child: Column(
              //                   mainAxisSize: MainAxisSize.min,
              //                   mainAxisAlignment: MainAxisAlignment.center,
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
            
              //                     MyText(
              //                       text: item["eventDate"],
              //                       fontSize: 15,
              //                       fontWeight: FontWeight.w600,
              //                       bottom: 5,
              //                       hexaColor: AppColors.lowWhite,
              //                     ),
            
              //                     MyText(
              //                       text: item['eventName'],
              //                       fontSize: 16,
              //                       color2: Colors.white,
              //                       fontWeight: FontWeight.w700,
              //                     )
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
            ))
            .toList(),
        ),
      ],
    );
  }
}