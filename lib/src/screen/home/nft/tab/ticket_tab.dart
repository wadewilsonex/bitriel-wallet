import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/cards/nft_c.dart';
import 'package:wallet_apps/src/models/nfts/ticket_nft_m.dart';

class TicketTab extends StatelessWidget {

  final List<TicketNFTModel>? lstTicket;

  const TicketTab({Key? key, required this.lstTicket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return lstTicket!.isNotEmpty 
    ? ListView.builder(
      itemCount: lstTicket!.length,
      itemBuilder: (context, index){
        return NFTCardComponent(eventName: lstTicket![index].ticketType!.name, index: index, length: lstTicket!.length, ticketNFTModel: lstTicket![index],);
      }
    ) : const Center(
      child: MyText(
        text: "No Ticket",
      ),
    );
    // ListView.builder(
    //   itemCount: 20,
    //   itemBuilder: (context, index){
    //     return TicketCardComponent(giftName: 'Claim Free SEL Tokens', index: index, length: 20,);
    //   }
    // );
  }
}