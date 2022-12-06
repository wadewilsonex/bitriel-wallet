import 'dart:ui';

import 'package:animated_background/animated_background.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/color.dart';
import 'package:wallet_apps/src/constants/textstyle.dart';
import 'package:wallet_apps/src/constants/ui_helper.dart';
import 'package:wallet_apps/src/models/event_model.dart';
import 'package:wallet_apps/src/screen/home/events/detail_event.dart';
import 'package:wallet_apps/src/utils/date_utils.dart';

class TicketOptions extends StatefulWidget {

  final String title;

  const TicketOptions({Key? key, required this.title}) : super(key: key);

  @override
  State<TicketOptions> createState() => _TicketOptionsState();
}

class _TicketOptionsState extends State<TicketOptions> with TickerProviderStateMixin{

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
        elevation: 0,
        iconTheme: IconThemeData(
          color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor)
        ),
        backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
        title: MyText(
          text: widget.title,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Iconsax.arrow_left_2),
        ),
      ),
      body: AnimatedBackground(
        behaviour: RacingLinesBehaviour(),
        vsync: this,
        child: Padding(
          padding: const EdgeInsets.all(paddingSize),
          child: ticketOptionsGrid(context),
        )
      ),
    );
  }

  Widget ticketOptionsGrid(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 1.0,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10
      ),
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: upcomingEvents.length,
      itemBuilder: (context, index) {
        final event = upcomingEvents[index];
        return GestureDetector(
          onTap: () {
            viewEventDetail(event);
          },
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: CouponCard(
                height: 500,
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
                firstChild: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset("assets/ads/banner.jpg", fit: BoxFit.fill),
                    // Image.network("https://mdw.bitriel.com/_next/image?url=%2Fimages%2Fticket.png&w=1200&q=75", fit: BoxFit.fill,),
                        
                    Positioned(
                      bottom: paddingSize - 5,
                      left: paddingSize / 1.5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 48.0,
                              offset: const Offset(0.0, 2)
                            )
                          ],
                          border: Border.all(
                            color: isDarkMode ? Colors.transparent : hexaCodeToColor(AppColors.orangeColor).withOpacity(0.5),
                            width: 1,
                          ),
                          color: hexaCodeToColor(isDarkMode ? AppColors.defiMenuItem : AppColors.whiteColorHexa),
                          borderRadius: BorderRadius.circular(100)
                        ),
                        child: MyText(
                          text: "USD \$10",
                          textAlign: TextAlign.start,
                          // hexaColor: AppColors.whiteColorHexa,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
                secondChild: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyText(
                            text: "Early Bird",
                            fontWeight: FontWeight.w600,
                          ),

                          const Spacer(),      

                          MyText(
                            text: "MDW",
                          ),
                        ],
                      ),
                                
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}