import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/data/models/mdw_ticketing/ticket_m.dart';

class ListTicketTypeBody extends StatelessWidget {

  final int? lstLenght;
  final String? imgUrl;
  final TicketModel? ticketModel;
  final ScrollController? controller;
  /// Index OF Month - Year
  final int? index;

  const ListTicketTypeBody({
    Key? key, 
    required this.imgUrl, 
    required this.index, 
    required this.ticketModel,
    required this.lstLenght,
    this.controller
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return CouponCard(
      height: 500,
      curvePosition: 250,
      curveRadius: 30,
      borderRadius: 10,
      decoration: BoxDecoration(
        color: hexaCodeToColor(AppColors.whiteColorHexa)
      ),
      firstChild: Stack(
        children: [

          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.network("$imgUrl${ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.image}", fit: BoxFit.cover,)
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: paddingSize / 2, left: paddingSize / 2),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.only(right: paddingSize, left: paddingSize, top: paddingSize / 2, bottom: paddingSize / 2),
                decoration: BoxDecoration(
                  color: hexaCodeToColor(AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: myText2(
                  context,
                  text: "USD \$${ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.price.toString()}",
                  color2: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )
        ],
      ),
      secondChild: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.name.toString(),
                hexaColor: AppColors.textColor,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.start,
                fontSize: 15,
              ),

              const Spacer(),

              MyText(
                text: ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.description.toString(),
                hexaColor: AppColors.greyCode,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                fontSize: 15,
              ),

              const SizedBox(height: 5,),

              MyText(
                text: ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.status.toString(),
                hexaColor: ticketModel!.lsTicketTypes![index!].defaultTicketSchemaType!.status == "Expired"
                    ? AppColors.warningColor
                    : AppColors.primaryColor,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                fontSize: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}