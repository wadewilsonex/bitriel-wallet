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

        MyText(
          top: 30,
          left: 22,
          bottom: 10,
          text: title,
          fontSize: 19,
          fontWeight: FontWeight.w600,
        ),

        CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 2.2,
            enlargeStrategy: CenterPageEnlargeStrategy.zoom,
            autoPlay: false,
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
            viewportFraction: 0.92
          ),
          items: listEvent!
            .map((item) => Container(
              margin: const EdgeInsets.all(5.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                child: InkWell(
                  onTap: (){

                    // Provider.of<TicketProvider>(context, listen: false).eventName = item['name']!;

                    // Navigator.push(
                    //   context,
                    //   Transition(child: ListTicketType(eventName: item['name']!, eventId: item['_id']!), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                    // );

                  },
                  child: Stack(
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: ipfsAPI != null ? 
                            Image.network("$ipfsAPI${item['image']}", fit: BoxFit.fill,)
                            : Image.network("https://scontent.fpnh24-1.fna.fbcdn.net/v/t39.30808-6/339333206_895335214912312_4599860087867644620_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=730e14&_nc_eui2=AeFExQUD41hruD3VhhVucJsszZlMxDRN73vNmUzENE3ve52cDQGYpnj7TzLG3CyuT2jczQKu-XiVjkf2Zz2laVhY&_nc_ohc=sZ3QMztusTcAX_UIcl2&_nc_ht=scontent.fpnh24-1.fna&oh=00_AfBnznIVLob09adhixE7Ps5sz7iIpbbyaf3FIvRcYZL01Q&oe=643650FB", fit: BoxFit.fill,),
                        ),
              
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, bottom: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 9.0, sigmaY: 9.0),
                                  child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
              
                                      MyText(
                                        text: listEvent == null ? eventDate : AppUtils.timeZoneToDateTime(item['startDate']),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        bottom: 5,
                                        hexaColor: AppColors.lowWhite,
                                      ),
              
                                      MyText(
                                        text: listEvent == null ? eventName : item['name'],
                                        fontSize: 16,
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
                      ],
                    ),
                ),
              ),
            ))
            .toList(),
        ),
      ],
    );
  }
}