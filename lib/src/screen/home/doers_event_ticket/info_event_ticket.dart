

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/ticket_info_m.dart';

class InfoEventTicket extends StatefulWidget {
  const InfoEventTicket({Key? key}) : super(key: key);

  @override
  State<InfoEventTicket> createState() => _InfoEventTicketState();
}

class _InfoEventTicketState extends State<InfoEventTicket> {

  final List<TicketInfoModel> ticketInfo = [
    TicketInfoModel(
      image: "https://2s7gjr373w3x22jf92z99mgm5w-wpengine.netdna-ssl.com/wp-content/uploads/2022/01/metaversse_shutterstock_thinkhubstudio.jpg",
      title: "MDW NFT Ticket",
      subtitle: "Year of DOERS",
      merchant: "DOERS GROUP",
      validity: "Valid until 04/Dec/2022",
      description: "DOERS GROUP NFT",
      price: "1000 SEL"
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      body: Column(
        children: [
          Container(
            // height: MediaQuery.of(context).size.height * .35,
            // padding: const EdgeInsets.only(bottom: 30),
            width: double.infinity,
            child: Image.network("${ticketInfo[0].image}"),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 40, right: 14, left: 14),
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Product Name',
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '\$135.00',
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque auctor consectetur tortor vitae interdum.',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: hexaCodeToColor(AppColors.greyCode),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: Colors.white,
        padding: EdgeInsets.all(paddingSize),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 10),
            Text(
              '${ticketInfo[0].price}',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 50),
            Expanded(
              child: InkWell(
                onTap: () {
                  
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                      'BUY NOW',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}