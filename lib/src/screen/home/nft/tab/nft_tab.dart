import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/cards/nft_c.dart';
import 'package:wallet_apps/src/models/nfts/ticket_nft_m.dart';

class NftTab extends StatelessWidget {

  final List<TicketNFTModel>? lstTicket;

  const NftTab({Key? key, required this.lstTicket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: MyText(
        text: "No NFT",
      ),
    );
    // lstTicket!.isNotEmpty ?
    // ListView.builder(
    //   itemCount: lstTicket!.length,
    //   itemBuilder: (context, index){
    //     return NFTCardComponent(eventName: lstTicket![index].ticketType!.name, index: index, length: lstTicket!.length,);
    //   }
    // ) : Center(
    //   child: MyText(
    //     text: "No Ticket",
    //   ),
    // );
  }
}