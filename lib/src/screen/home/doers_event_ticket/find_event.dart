import 'dart:ui';

import 'package:animated_background/animated_background.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/color.dart';
import 'package:wallet_apps/src/constants/textstyle.dart';
import 'package:wallet_apps/src/constants/ui_helper.dart';
import 'package:wallet_apps/src/models/event_model.dart';
import 'package:wallet_apps/src/screen/home/doers_event_ticket/detail_event.dart';
import 'package:wallet_apps/src/utils/date_utils.dart';

class FindEvent extends StatefulWidget {

  final bool? isRefetch;

  const FindEvent({Key? key, this.isRefetch}) : super(key: key);

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

          AppBar(
            automaticallyImplyLeading: false,
            leading: null,
            leadingWidth: 0,
            elevation: 0,
            title: Consumer<MDWProvider>(
              builder: (context, provider, widget){
              return MyText(
                text: "My NFTs Ticket: ${provider.model.tickets.length}",
                fontWeight: FontWeight.w600,
                fontSize: 17,
              );
            }),
          ),

          Expanded(
            child: Consumer<MDWProvider>(
              builder: (context, value, widget){
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: value.model.tickets.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(paddingSize),
                      child: Image.network("https://mdw.bitriel.com/_next/image?url=%2Fimages%2Fticket.png&w=1200&q=75"),
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

    // ticketInitializer();
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
        actions: [
          Align(
            widthFactor: 1.75,
            child: IconButton(
              onPressed: () {
                qrProfileDialog(context);
              },
              icon: Icon(Iconsax.scanning, color: Colors.white, size: 7.w),
            ),
          ),
        ],
      ),
      body: AnimatedBackground(
        behaviour: RacingLinesBehaviour(),
        vsync: this,
        child: SingleChildScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          child: eventNow(context),
        )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: hexaCodeToColor(AppColors.secondary),
        onPressed: (){
          _showPasses(context);
        },
        child: const Icon( Iconsax.ticket ),
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
              padding: const EdgeInsets.all(paddingSize),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        viewEventDetail(event);
                      },
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: CouponCard(
                            height: 200,
                            curvePosition: 100,
                            curveRadius: 20,
                            borderRadius: 10,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.25),
                                  Colors.white.withOpacity(0.25),
                                ],
                                begin: AlignmentDirectional.topStart,
                                end: AlignmentDirectional.bottomEnd,
                              ),
                            ),
                            firstChild: event.image.contains("https") ? Image.network(event.image, fit: BoxFit.fill,) : Image.asset(event.image, fit: BoxFit.fill,),
                            secondChild: Padding(
                              padding: const EdgeInsets.all(paddingSize),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: primaryLight,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(DateTimeUtils.getMonth(event.eventDate), style: monthStyle),
                                        Text(DateTimeUtils.getDayOfMonth(event.eventDate), style: titleStyle),
                                      ],
                                    ),
                                  ),
                                            
                                  UIHelper.horizontalSpace(16),
                                  
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MyText(
                                        text: event.name,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                      ),
                                            
                                
                                      MyText(
                                        text: event.organizer,
                                        fontSize: 14,
                                      ),
                                    ],
                                  ),
                                            
                                  Spacer(),
                                            
                                  SizedBox(
                                    // width: double.maxFinite,
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
                                        text: 'JOIN THE\nEVENT',
                                        fontWeight: FontWeight.bold,
                                        hexaColor: AppColors.whiteColorHexa,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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