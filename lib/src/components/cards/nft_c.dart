import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/nfts/ticket_nft_m.dart';
import 'package:wallet_apps/src/screen/home/nft/details_ticket/details_ticket.dart';

class NFTCardComponent extends StatelessWidget{

  final int? index;
  final int? length;
  final String? eventName;
  final TicketNFTModel? ticketNFTModel;

  const NFTCardComponent({Key? key, required this.eventName, required this.index, required this.length, required this.ticketNFTModel}) : super(key: key);

  @override
  Widget build(BuildContext context){

    return InkWell(
      onTap: (){

        Navigator.push(
          context, 
          Transition(child: DetailsTicketing(ticketNFTModel: ticketNFTModel,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
        );

      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 121,
        margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: index == length!-1 ? 20 : 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
        
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.network("${dotenv.get('IPFS_API')}${ticketNFTModel!.ticketType!.image}", fit: BoxFit.cover,)
              ),
        
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 10, bottom: 10),
                  // alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      MyText(
                        text: eventName!, //"NIGHT MUSIC FESTIVAL",
                        fontSize: 16,
                        color2: Colors.white,
                        fontWeight: FontWeight.w700,
                      )
                    ],
                  ),
                ),
              ),

            ],
          ),
        )
      ),
    );
  }
}

class TicketCardComponent extends StatelessWidget{

  final int? index;
  final int? length;
  final String? giftName;

  const TicketCardComponent({Key? key,  required this.giftName, required this.index, required this.length}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return InkWell(
      // onTap: onPressed!,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 121,
        margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: index == length!-1 ? 20 : 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: hexaCodeToColor("#FEFEFE"),
        ),
        child: Row(
          children: [
        
            Container(
              width: 121,
              height: 121,
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset("${AppConfig.assetsPath}appbar_bg.jpg", fit: BoxFit.cover,),
              ),
            ),
        
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                MyText(
                  top: 10,
                  text: giftName!, //"NIGHT MUSIC FESTIVAL",
                  fontSize: 16,
                  hexaColor: "#49595F",
                  fontWeight: FontWeight.w800,
                ),

                MyText(
                  top: 5,
                  text: giftName!, //"NIGHT MUSIC FESTIVAL",
                  fontSize: 14,
                  hexaColor: "#49595F",
                  fontWeight: FontWeight.w600,
                )
              ],
            ),

          ],
        )
      ),
    );
  }
}