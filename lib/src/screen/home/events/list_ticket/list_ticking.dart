import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/data/backend/post_request.dart';
import 'package:wallet_apps/src/components/appbar/event_c.dart';
import 'package:wallet_apps/data/models/mdw_ticketing/ticket_m.dart';
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
        
      }
      if (_tkModel.ticketTypesFromApi!.isNotEmpty){

        _tkModel.lsTicketTypes = List<TicketTypes>.empty(growable: true);

        for (var element in _tkModel.ticketTypesFromApi!) {
          _tkModel.lsTicketTypes!.add(
            TicketTypes.fromApi(element)
          );

        }
      }

      if (mounted) setState(() { });
    });

    if (kDebugMode) {
      
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: eventAppBar(context: context, title: widget.eventName!),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          if (_tkModel.ticketTypesFromApi == null) centerLoading()

          else if (_tkModel.ticketTypesFromApi!.isNotEmpty)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: paddingSize * 2, right: paddingSize * 2),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    // mainAxisExtent: 400,
                    childAspectRatio: 0.5
                  ),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _tkModel.lsTicketTypes!.length,
                  itemBuilder: (context, index){

                    return GestureDetector(
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: paddingSize),
                        child: ListTicketTypeBody(
                          lstLenght: _tkModel.lsTicketTypes!.length,
                          controller: _controller,
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
            
          else Center(
            child: Column(
              children: [

                Lottie.asset(
                  "assets/animation/search_empty.json",
                  repeat: true,
                  reverse: true,
                  width: 70.w,
                ),

                const Padding(
                  padding: EdgeInsets.all(paddingSize),
                  child: MyText(text: "Sorry, there are no results for this event, please try again later.", fontSize: 17, fontWeight: FontWeight.w600,),
                )
              ],
            ),
          ),

        ],
      ),

    );
  }
}