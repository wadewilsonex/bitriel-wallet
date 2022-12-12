import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/post_request.dart';
import 'package:wallet_apps/src/components/appbar/event_c.dart';
import 'package:wallet_apps/src/components/cards/ticket_card_c.dart';
import 'package:wallet_apps/src/models/mdw_ticketing/ticket_m.dart';
import 'package:wallet_apps/src/provider/ticket_p.dart';
import 'package:wallet_apps/src/screen/home/events/list_ticket/body_list_ticket.dart';

class ListTicketType extends StatefulWidget {

  final String? eventName;
  final String? eventId;
  const ListTicketType({Key? key, required this.eventName, required this.eventId}) : super(key: key);

  @override
  State<ListTicketType> createState() => _ListTicketTypeState();
}

class _ListTicketTypeState extends State<ListTicketType> {

  String? imgUrl;
  
  TicketModel _tkModel = TicketModel();
  
  ScrollController _controller = ScrollController();

  @override
  void initState() {

    imgUrl = dotenv.get('IPFS_API');
    Provider.of<TicketProvider>(context, listen: false).eventName = widget.eventName;
    _tkModel.eventId = widget.eventId;
    
    queryTicket();
    super.initState();
  }

  void queryTicket() async {
    print("queryTicket");
    await PostRequest().getTicketsByEventId(widget.eventId!).then((value) async{
      
      print("value ${value.body}");
      _tkModel.ticketTypesFromApi = List<Map<String, dynamic>>.from(await json.decode(value.body));

      _tkModel.ticketTypesFromApi!.forEach( (element){
        print(element);
        _tkModel.lsTicketTypes!.add(
          TicketTypes.fromApi(element)
        );

      });
    });

    setState(() { });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: eventAppBar(context: context, title: widget.eventName!),
      body: _tkModel.lsTicketTypes!.isNotEmpty
      ? ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: _tkModel.lsTicketTypes!.length,
        itemBuilder: (context, index){
          return SingleChildScrollView(
            controller: _controller,
            physics: const BouncingScrollPhysics(),
            child: ListTicketTypeBody(
              lstLenght: _tkModel.lsTicketTypes!.length,
              controller: _controller,
              mgLeft: index == 0 ? 20 : 0,
              mgRight: 20,
              imgUrl: imgUrl,
              ticketModel: _tkModel,
              index: index,
            ),
          );

        }
      ) 
      : loading(),

    );
  }
}