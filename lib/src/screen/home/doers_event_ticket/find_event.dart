import 'package:animated_background/animated_background.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/event_model.dart';
import 'package:wallet_apps/src/screen/home/doers_event_ticket/detail_event.dart';
import 'package:wallet_apps/src/utils/date_utils.dart';

class FindEvent extends StatefulWidget {
  const FindEvent({Key? key}) : super(key: key);

  @override
  State<FindEvent> createState() => _FindEventState();
}

class _FindEventState extends State<FindEvent> with TickerProviderStateMixin{

  late ScrollController scrollController;
  late AnimationController controller;
  late AnimationController opacityController;
  late Animation<double> opacity;

  void viewEventDetail(Event event) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (BuildContext context, animation, __) {
          return FadeTransition(
            opacity: animation,
            child: EventDetailPage(event),
          );
        },
      ),
    );
  }

  void _showPasses(BuildContext context) {
    showBarModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
      builder: (context) => Column(
        children: [

          Expanded(
            child: Consumer<MDWProvider>(
              builder: (context, value, widget){
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: value.tickets.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(paddingSize),
                      child: Image.network("https://mdw.bitriel.com/_next/image?url=https%3A%2F%2Fgateway.kumandra.org%2Ffiles%2FQmYnGREwatJdkkYnBkHEGhRTcnB2RGB3ARsZRFKBahH7hz&w=1080&q=75"),
                    );
                  }
                );
              }
            ),
          )
        ],  
      ),
    );
  }

  /// Connect Contract
  /// 
  /// And Query Amount's Ticket
  void ticketInitializer() async {
    
    Provider.of<MDWProvider>(context, listen: false).init();
    await Provider.of<MDWProvider>(context, listen: false).initNFTContract(context);
    await Provider.of<MDWProvider>(context, listen: false).fetchItemsByAddress();
  }

  @override
  void initState() {
    
    // Init Member
    scrollController = ScrollController();
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..forward();
    opacityController = AnimationController(vsync: this, duration: const Duration(microseconds: 1));
    opacity = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      curve: Curves.linear,
      parent: opacityController,
    ));
    scrollController.addListener(() {
      opacityController.value = offsetToOpacity(
          currentOffset: scrollController.offset, maxOffset: scrollController.position.maxScrollExtent / 2);
    });

    ticketInitializer();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: const Color(0xff7c94b6),
            image: DecorationImage(
              colorFilter: ColorFilter.mode(Colors.purple.withOpacity(1.0), BlendMode.softLight),
              image: const AssetImage("assets/appbar_bg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        title: Image.asset(
          "assets/appbar_event.png",
          fit: BoxFit.contain,
          height: 40,
        ),
      ),
      body: AnimatedBackground(
        behaviour: RacingLinesBehaviour(),
        vsync: this,
        child: SingleChildScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // const SizedBox(height: 30,),
              eventNow(context),
              // const SizedBox(height: 20,),
            ],
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: hexaCodeToColor(AppColors.secondary),
        onPressed: (){
          _showPasses(context);
        },
        child: const Icon(Icons.airplane_ticket),
      ),

    );
  }

  Widget eventNow(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: upcomingEvents.length,
          itemBuilder: (context, index) {
            final event = upcomingEvents[index];
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 50,
                    height: 100,
                    margin: const EdgeInsets.only(right: 20),
                    child: Column(
                      children: <Widget>[
                        MyText(text: DateTimeUtils.getDayOfMonth(event.eventDate), fontWeight: FontWeight.bold, hexaColor: AppColors.orangeColor, fontSize: 22,),
                        MyText(text: DateTimeUtils.getMonth(event.eventDate), fontWeight: FontWeight.bold, fontSize: 18)
                      ],
                    ),
                  ),
                  Expanded(
                    child: CouponCard(
                      height: 250,
                      curvePosition: 180,
                      curveRadius: 15,
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
                      firstChild: GestureDetector(
                        onTap: () {
                          viewEventDetail(event);
                        },
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(event.image, fit: BoxFit.cover,),
                                
                            Positioned(
                              top: paddingSize,
                              left: paddingSize / 1.5,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: hexaCodeToColor(AppColors.defiMenuItem),
                                  borderRadius: BorderRadius.circular(100)
                                ),
                                child: MyText(
                                  text: event.name,
                                  textAlign: TextAlign.start,
                                  hexaColor: AppColors.whiteColorHexa,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      secondChild: Padding(
                        padding: const EdgeInsets.all(paddingSize),
                        child: SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                hexaCodeToColor(AppColors.orangeColor)
                              ),
                            ),
                            onPressed: () {
                              viewEventDetail(event);
                            },
                            child: const MyText(
                              text: 'JOIN THE EVENT',
                              fontWeight: FontWeight.bold,
                              hexaColor: AppColors.whiteColorHexa,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}