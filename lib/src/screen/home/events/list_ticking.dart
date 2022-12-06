import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/post_request.dart';
import 'package:wallet_apps/src/components/appbar/event_c.dart';
import 'package:wallet_apps/src/components/cards/ticket_card_c.dart';

class ListTicket extends StatefulWidget {

  final String? eventName;
  final String? eventId;
  const ListTicket({Key? key, required this.eventName, required this.eventId}) : super(key: key);

  @override
  State<ListTicket> createState() => _ListTicketState();
}

class _ListTicketState extends State<ListTicket> {

  String? imageUrl;
  
  List<Map<String, dynamic>>? lsTickets;

  @override
  void initState() {
    imageUrl = dotenv.get('IPFS_API');
    queryTicket();
    super.initState();
  }

  void queryTicket() async {
    await PostRequest().getTicketsByEventId(widget.eventId!).then((value) async{
      print("queryTicket ${value.body}");
      lsTickets = List<Map<String, dynamic>>.from(await json.decode(value.body));

      setState(() {
        
      });

      print("lsTickets $lsTickets");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: eventAppBar(context: context, title: widget.eventName!),
      body: lsTickets != null ? ListView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: List.generate(
          lsTickets!.length,
          (index) => TicketCardComponent(
            ticketObj: lsTickets![index], 
            imageUrl: imageUrl,
            mgLeft: index == 0 ? 20 : 0,
            mgRight: 20//index != (lsTickets!.length -1) ? 20 : 0,
          )
        )
      ) : Center(
        child: CircularProgressIndicator(),
      ),

    );
  }
}