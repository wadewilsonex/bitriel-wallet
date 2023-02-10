import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/post_request.dart';
import 'package:wallet_apps/src/components/appbar/event_c.dart';
import 'package:wallet_apps/src/models/mdw_ticketing/ticket_m.dart';
import 'package:wallet_apps/src/provider/ticket_p.dart';
import 'package:wallet_apps/src/screen/home/events/list_ticket/body_list_ticket.dart';

import '../ticket_detail.dart';

class ListTicketType extends StatefulWidget {

  final String? eventName;
  final String? eventId;
  const ListTicketType({Key? key, required this.eventName, required this.eventId}) : super(key: key);

  @override
  State<ListTicketType> createState() => _ListTicketTypeState();
}

class _ListTicketTypeState extends State<ListTicketType> {

  String? imgUrl;
  
  final TicketModel _tkModel = TicketModel();
  
  final ScrollController _controller = ScrollController();

  @override
  void initState() {

    imgUrl = dotenv.get('IPFS_API');
    Provider.of<TicketProvider>(context, listen: false).eventName = widget.eventName;
    _tkModel.eventId = widget.eventId;
    
    queryTicket();
    super.initState();
  }

  void queryTicket() async {
    
    await PostRequest().getTicketsByEventId(widget.eventId!).then((value) async{
      
      _tkModel.ticketTypesFromApi = List<Map<String, dynamic>>.from(await json.decode(value.body));
      if (kDebugMode) {
        print('_tkModel.ticketTypesFromApi ${_tkModel.ticketTypesFromApi}');
      }
      if (_tkModel.ticketTypesFromApi!.isNotEmpty){

        _tkModel.lsTicketTypes = List<TicketTypes>.empty(growable: true);

        for (var element in _tkModel.ticketTypesFromApi!) {
          if (kDebugMode) {
            print(element);
          }
          _tkModel.lsTicketTypes!.add(
            TicketTypes.fromApi(element)
          );

        }
      }

      if (mounted) setState(() { });
    });

    if (kDebugMode) {
      print(("_tkModel.ticketTypesFromApi ${_tkModel.ticketTypesFromApi}"));
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: eventAppBar(context: context, title: widget.eventName!),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            if (_tkModel.ticketTypesFromApi == null) loading()

            else if (_tkModel.ticketTypesFromApi!.isNotEmpty)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: paddingSize, right: paddingSize, top: 10),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: paddingSize,
                      childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.1),
                    ),
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _tkModel.lsTicketTypes!.length,
                    itemBuilder: (context, index){

                      return SingleChildScrollView(
                        controller: _controller,
                        physics: const BouncingScrollPhysics(),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                Transition(
                                  child: TicketDetail(
                                    creator: widget.eventName!,
                                    name: _tkModel.lsTicketTypes![index].defaultTicketSchemaType!.name!,
                                    price: _tkModel.lsTicketTypes![index].defaultTicketSchemaType!.price!,
                                    image: NetworkImage(dotenv.get('IPFS_API')+_tkModel.lsTicketTypes![index].defaultTicketSchemaType!.image!),
                                    description: _tkModel.lsTicketTypes![index].defaultTicketSchemaType!.description!,
                                    startDate: _tkModel.lsTicketTypes![index].defaultTicketSchemaType!.startDate!,
                                    status: _tkModel.lsTicketTypes![index].defaultTicketSchemaType!.status!
                                  ),
                                  transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                                )
                            );
                          },
                          child: ListTicketTypeBody(
                            lstLenght: _tkModel.lsTicketTypes!.length,
                            controller: _controller,
                            mgLeft: index == 0 ? 20 : 0,
                            mgRight: 20,
                            imgUrl: imgUrl,
                            ticketModel: _tkModel,
                            index: index,
                          ),
                        ),
                      );

                    }
                  ),
                ),
              )

            //   Expanded(
            //     child: ListView.builder(
            //     physics: const BouncingScrollPhysics(),
            //     scrollDirection: Axis.horizontal,
            //     shrinkWrap: true,
            //     itemCount: _tkModel.lsTicketTypes!.length,
            //     itemBuilder: (context, index){
            //
            //       return SingleChildScrollView(
            //         controller: _controller,
            //         physics: const BouncingScrollPhysics(),
            //         child: ListTicketTypeBody(
            //           lstLenght: _tkModel.lsTicketTypes!.length,
            //           controller: _controller,
            //           mgLeft: index == 0 ? 20 : 0,
            //           mgRight: 20,
            //           imgUrl: imgUrl,
            //           ticketModel: _tkModel,
            //           index: index,
            //         ),
            //       );
            //
            //     }
            //   ),
            // )

            else const MyText(text: "No Ticket Type",)

          ],
        ),
      ),

    );
  }
}