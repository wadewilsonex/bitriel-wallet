import 'package:animated_background/animated_background.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/home/doers_event_ticket/info_event_ticket.dart';

class EventTicket extends StatefulWidget {
  const EventTicket({Key? key}) : super(key: key);

  @override
  State<EventTicket> createState() => _EventTicketState();
}

class _EventTicketState extends State<EventTicket> with TickerProviderStateMixin{

  void _showPasses(BuildContext context) {
    showBarModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
      builder: (context) => SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            for (var i = 0; i < 10; i++)
            Padding(
              padding: const EdgeInsets.all(paddingSize),
              child: Image.asset(
                "assets/Singapore_Ticket.png",
              ),
            )
          ],  
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _cardEventTicketWidget(),
      ),
      bottomNavigationBar: Material(
        child: InkWell(
          onTap: () {
            _showPasses(context);
          },
          child: SizedBox(
            height: kToolbarHeight,
            width: double.infinity,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: paddingSize),
                child: Row(
                  children: [
                    MyText(
                      text: 'Passes',
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),

                    const Spacer(),

                    Icon(
                      Iconsax.arrow_up_2, 
                      color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor)
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _animationBackground() {
    return AnimatedBackground(
      behaviour: RacingLinesBehaviour(),
      vsync: this,
      child:Center(child: _cardEventTicketWidget()),
    );
  }
  Widget _cardEventTicketWidget(){
    return Container(
      padding: const EdgeInsets.all(paddingSize),
      child: CouponCard(
        height: 300,
        curvePosition: 180,
        curveRadius: 30,
        borderRadius: 10,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.white54,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        firstChild: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/Singapore_Ticket.png"),
          ],
        ),
        secondChild: Container(
          width: double.maxFinite,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 42),
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(horizontal: 80),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                hexaCodeToColor(AppColors.orangeColor)
              ),
            ),
            onPressed: () {
              print("ontap");
              Navigator.push(context, Transition(child: const InfoEventTicket(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
            },
            child: const MyText(
              text: 'JOIN THE EVENT',
              fontWeight: FontWeight.bold,
              hexaColor: AppColors.whiteColorHexa,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}