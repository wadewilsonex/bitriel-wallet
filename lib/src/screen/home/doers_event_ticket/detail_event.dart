import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/event_model.dart';
import 'package:wallet_apps/src/constants/color.dart';
import 'package:wallet_apps/src/constants/textstyle.dart';
import 'package:wallet_apps/src/constants/ui_helper.dart';
import 'package:wallet_apps/src/provider/receive_wallet_p.dart';
import 'package:wallet_apps/src/screen/home/doers_event_ticket/checkout_ticket.dart';
import 'package:wallet_apps/src/utils/date_utils.dart';

class EventDetailPage extends StatefulWidget {
  final Event event;
  const EventDetailPage(this.event, {Key? key}) : super(key: key);
  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> with TickerProviderStateMixin {
  late Event event;
  late AnimationController controller;
  late AnimationController bodyScrollAnimationController;
  late ScrollController scrollController;
  late Animation<double> scale;
  late Animation<double> appBarSlide;
  double headerImageSize = 0;
  bool isFavorite = false;

  Future<void> qrShare(GlobalKey globalKey, String name) async {
    try {
      final RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      final image = await boundary.toImage(pixelRatio: 5.0);
      final ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = await File("${tempDir.path}/$name.png").create();
      await file.writeAsBytes(pngBytes);

      Share.shareFiles([file.path], text: name);
    } catch (e) {
      if (ApiProvider().isDebug == true) {
        if (kDebugMode) {
          print("Error qrShare ${e.toString()}");
        }
      }
    }
  }

  Future _qrNFTDialog() async {
    return await showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (BuildContext context){
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 80,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            actions: [
              Align(
                widthFactor: 1.75,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Iconsax.close_circle, color: Colors.white, size: 30),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          body: Consumer<ApiProvider>(
            builder: (context, value, child) {
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Column(
                  children: [
                    RepaintBoundary(
                      key: Provider.of<ReceiveWalletProvider>(context, listen: false).keyQrShare,
                      child: AlertDialog(
                        contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        backgroundColor: hexaCodeToColor(AppColors.whiteColorHexa),
                        content: SizedBox(
                          width: 250,
                          child: Consumer<ReceiveWalletProvider>(
                            builder: (context, provider, widget){
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                            
                                  Flexible(
                                    child: MyText(
                                      text: "NFT TICKET\n${event.name}",
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      hexaColor: AppColors.blackColor,
                                      overflow: TextOverflow.fade,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                            
                                  SizedBox(height: 2.h),
                                  
                                  qrCodeProfile(
                                    value.contractProvider!.ethAdd.isNotEmpty ? value.contractProvider!.ethAdd : '',
                                    "assets/logo/bitirel-logo-circle.png",
                                    provider.keyQrShare,
                                  ),
                                ],
                              ); 
                            }
                          ),
                        )
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(paddingSize),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const MyText(
                                    text: "CONTRACT ADDRES",
                                  ),
                                  MyText(
                                    text: "${value.accountM.address!.replaceRange(5, value.accountM.address!.length - 5, "........")}",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),

                            Spacer(),

                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  MyText(
                                    text: "Pieces",
                                  ),
                                  MyText(
                                    text: "0",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(paddingSize),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  MyText(
                                    text: "Token Standard",
                                  ),
                                  MyText(
                                    text: "ERC1155",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),

                            Spacer(),

                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  MyText(
                                    text: "Blockchain",
                                  ),
                                  MyText(
                                    text: "SELENDRA",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(paddingSize),
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.orangeColor).withOpacity(0.2),
                                        shape: BoxShape.circle
                                    ),
                                    child: Icon(Iconsax.import_1, color: hexaCodeToColor(AppColors.whiteColorHexa)),
                                  ),
                                ),

                                MyText(
                                  text: "Download",
                                )
                              ],
                            ),

                            SizedBox(width: 10.w),
                            
                            GestureDetector(
                              onTap: () {
                                qrShare(Provider.of<ReceiveWalletProvider>(context, listen: false).keyQrShare, "NFT TICKET ${event.name}");
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.orangeColor).withOpacity(0.2),
                                        shape: BoxShape.circle
                                    ),
                                    child: Icon(Iconsax.share, color: hexaCodeToColor(AppColors.whiteColorHexa)),
                                  ),
                            
                                  MyText(
                                    text: "Share",
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    
                  ],
                ),
              );
            }
          ),
        );
      }
    );
  }

  
  @override
  void initState() {
    event = widget.event;
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    bodyScrollAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.offset >= headerImageSize / 2) {
          if (!bodyScrollAnimationController.isCompleted) bodyScrollAnimationController.forward();
        } else {
          if (bodyScrollAnimationController.isCompleted) bodyScrollAnimationController.reverse();
        }
      });

    appBarSlide = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: bodyScrollAnimationController,
    ));

    scale = Tween(begin: 1.0, end: 0.5).animate(CurvedAnimation(
      curve: Curves.linear,
      parent: controller,
    ));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    bodyScrollAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    headerImageSize = MediaQuery.of(context).size.height / 4.4;
    return SafeArea(
      child: ScaleTransition(
        scale: scale,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
          child: Scaffold(
            body: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      buildHeaderImage(),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            buildEventTitle(),
                            UIHelper.verticalSpace(16),
                            buildEventDate(),
                            UIHelper.verticalSpace(24),
                            buildAboutEvent(),
                            UIHelper.verticalSpace(24),
                            buildOrganizeInfo(),
                            UIHelper.verticalSpace(75),
                            // buildEventLocation(),
                            // UIHelper.verticalSpace(124),
                            //...List.generate(10, (index) => ListTile(title: Text("Dummy content"))).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: buildPriceInfo(),
                ),
                AnimatedBuilder(
                  animation: appBarSlide,
                  builder: (context, snapshot) {
                    return Transform.translate(
                      offset: Offset(0.0, -1000 * (1 - appBarSlide.value)),
                      child: Material(
                        elevation: 2,
                        color: Theme.of(context).primaryColor,
                        child: buildHeaderButton(hasTitle: true),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeaderImage() {
    double maxHeight = MediaQuery.of(context).size.height;
    double minimumScale = 0.8;
    return GestureDetector(
      onVerticalDragUpdate: (detail) {
        controller.value += detail.primaryDelta! / maxHeight * 2;
      },
      onVerticalDragEnd: (detail) {
        if (scale.value > minimumScale) {
          controller.reverse();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Stack(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: headerImageSize,
            child: Hero(
              tag: event.image,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
                child: Image.network(
                  event.image,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          buildHeaderButton(),
        ],
      ),
    );
  }

  Widget buildHeaderButton({bool hasTitle = false}) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
              margin: const EdgeInsets.all(0),
              color: hasTitle ? Theme.of(context).primaryColor : Colors.white,
              child: InkWell(
                onTap: () {
                  if (bodyScrollAnimationController.isCompleted) bodyScrollAnimationController.reverse();
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Iconsax.arrow_left_2,
                    color: hasTitle ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            // if (hasTitle) Text(event.name, style: titleStyle.copyWith(color: Colors.white)),
            // Card(
            //   shape: const CircleBorder(),
            //   elevation: 0,
            //   color: Theme.of(context).primaryColor,
            //   child: InkWell(
            //     customBorder: const CircleBorder(),
            //     onTap: () => setState(() => isFavorite = !isFavorite),
            //     child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.white),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildEventTitle() {
    return Row(
      children: [
        MyText(
          text: event.name,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),

        IconButton(
          onPressed: () async{
            await _qrNFTDialog();
          },
          icon: const Icon(Iconsax.scan_barcode, color: Colors.white,),
        )
      ],
    );
  }

  Widget buildEventDate() {
    return Row(
      children: <Widget>[
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
        UIHelper.horizontalSpace(12),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MyText(text: DateTimeUtils.getDayOfWeek(event.eventDate), fontSize: 18, fontWeight: FontWeight.bold,),
            UIHelper.verticalSpace(4),
            Text(event.eventTime, style: subtitleStyle),
          ],
        ),
        const Spacer(),
        // Container(
        //   padding: const EdgeInsets.all(2),
        //   decoration: const ShapeDecoration(shape: StadiumBorder(), color: primaryLight),
        //   child: Row(
        //     children: <Widget>[
        //       UIHelper.horizontalSpace(8),
        //       Text("Add To Calendar", style: subtitleStyle.copyWith(color: Theme.of(context).primaryColor)),
        //       FloatingActionButton(
        //         mini: true,
        //         onPressed: () {},
        //         child: const Icon(Icons.add),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Widget buildAboutEvent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const MyText(text: "About", fontWeight: FontWeight.bold, fontSize: 18),
        UIHelper.verticalSpace(),
        Text(event.description, style: subtitleStyle),
        // UIHelper.verticalSpace(8),
        // InkWell(
        //   child: Text(
        //     "Read more...",
        //     style: TextStyle(color: Theme.of(context).primaryColor, decoration: TextDecoration.underline),
        //   ),
        //   onTap: () {},
        // ),
      ],
    );
  }

  Widget buildOrganizeInfo() {
    return Row(
      children: <Widget>[
        CircleAvatar(
          child: Text(event.organizer[0]),
        ),
        UIHelper.horizontalSpace(16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MyText(text: event.organizer, fontWeight: FontWeight.bold, fontSize: 18,),
            UIHelper.verticalSpace(4),
            const Text("Organizer", style: subtitleStyle),
          ],
        ),
        const Spacer(),
        // TextButton(
        //   onPressed: () {},
        //   style: TextButton.styleFrom(
        //     shape: const StadiumBorder(),
        //   ),
        //   child: Text("Follow", style: TextStyle(color: Theme.of(context).primaryColor)),
        // )
      ],
    );
  }

  Widget buildEventLocation() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        'assets/map.jpg',
        height: MediaQuery.of(context).size.height / 3,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildPriceInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightBg),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("Price", style: subtitleStyle),
              UIHelper.verticalSpace(8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "SEL ${event.priceToken} ≈ \$${event.price}", style: titleStyle.copyWith(color: hexaCodeToColor(AppColors.orangeColor))),
                      // const TextSpan(text: "/per person", style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: hexaCodeToColor(AppColors.orangeColor),
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              Navigator.push(context, Transition(child: OrderConfirmScreen(event: event,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
            },
            child: Text(
              "Get a Ticket",
              style: titleStyle.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}
