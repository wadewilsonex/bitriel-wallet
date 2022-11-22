import 'dart:ui' as ui;
import 'dart:ui';
import 'package:animated_background/animated_background.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/color.dart';
import 'package:wallet_apps/src/constants/textstyle.dart';
import 'package:wallet_apps/src/constants/ui_helper.dart';
import 'package:wallet_apps/src/models/event_model.dart';
import 'package:wallet_apps/src/provider/receive_wallet_p.dart';
import 'package:wallet_apps/src/screen/home/doers_event_ticket/detail_event.dart';
import 'package:wallet_apps/src/screen/home/doers_event_ticket/ticket_options.dart';
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
    Navigator.push(context, Transition(child: TicketOptions(title: event.name,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
    // Navigator.of(context).push(
    //   PageRouteBuilder(
    //     opaque: false,
    //     barrierDismissible: true,
    //     transitionDuration: const Duration(milliseconds: 300),
    //     pageBuilder: (BuildContext context, animation, __) {
    //       return FadeTransition(
    //         opacity: animation,
    //         child: TicketOptions(title: event.name),
    //       );
    //     },
    //   ),
    // );
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

          Consumer<MDWProvider>(
            builder: (context, value, widget){
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (() {
                        _passesDetails(context);
                      }),
                      child: Padding(
                        padding: const EdgeInsets.all(paddingSize),
                        child: CouponCard(
                          height: 150,
                          // backgroundColor: hexaCodeToColor(AppColors.primaryColor),
                          clockwise: true,
                          curvePosition: 125,
                          curveRadius: 30,
                          curveAxis: Axis.vertical,
                          borderRadius: 10,
                          firstChild: Image.network("https://mdw.bitriel.com/_next/image?url=%2Fimages%2Fticket.png&w=1200&q=75", fit: BoxFit.fill,),
                          secondChild: ClipRRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                              child: Container(
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isDarkMode ? [
                                      Colors.white.withOpacity(0.25),
                                      Colors.white.withOpacity(0.25),
                                    ]
                                    : 
                                    [
                                      Colors.black.withOpacity(0.25),
                                      Colors.black.withOpacity(0.25),
                                    ],
                                    begin: AlignmentDirectional.topStart,
                                    end: AlignmentDirectional.bottomEnd,
                                  ),
                                ),
                                padding: const EdgeInsets.all(18),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        
                                        const MyText(
                                          text: "ENTRY",
                                          // hexaColor: AppColors.whiteColorHexa,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                          
                                        Container(
                                          height: 25,
                                          width: 50,
                                          decoration: const BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.all(Radius.circular(25))
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: const [
                                              Icon(Iconsax.user, color: Colors.white, size: 14,),
                                          
                                              MyText(
                                                text: "10",
                                                hexaColor: AppColors.whiteColorHexa,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    const MyText(
                                      text: "MetaDoersWorld",
                                      // hexaColor: AppColors.whiteColorHexa,
                                      fontSize: 20,
                                      textAlign: TextAlign.start,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    const Spacer(),
                                    const MyText(
                                      text: "Meta doers world",
                                      // hexaColor: AppColors.whiteColorHexa,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
              // return ListView.builder(
              //   shrinkWrap: true,
              //   itemCount: value.model.tickets.length,
              //   itemBuilder: (context, index) {
              //     return Padding(
              //       padding: const EdgeInsets.all(paddingSize),
              //       child: Image.network("https://mdw.bitriel.com/_next/image?url=%2Fimages%2Fticket.png&w=1200&q=75"),
              //     );
              //   }
              // );
            }
          )
        ],  
      ),
    );
  }

  void _passesDetails(BuildContext context) {
    showBarModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
      builder: (context) => Column(
        children: [

          AppBar(
            automaticallyImplyLeading: false,
            leading: null,
            toolbarHeight: 200,
            leadingWidth: 0,
            elevation: 0,
            title: CouponCard(
              height: 150,
              // backgroundColor: hexaCodeToColor(AppColors.primaryColor),
              clockwise: true,
              curvePosition: 125,
              curveRadius: 30,
              curveAxis: Axis.vertical,
              borderRadius: 10,
              firstChild: Image.network("https://mdw.bitriel.com/_next/image?url=%2Fimages%2Fticket.png&w=1200&q=75", fit: BoxFit.fill,),
              secondChild: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDarkMode ? [
                          Colors.white.withOpacity(0.25),
                          Colors.white.withOpacity(0.25),
                        ]
                        : 
                        [
                          Colors.black.withOpacity(0.25),
                          Colors.black.withOpacity(0.25),
                        ],
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                      ),
                    ),
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Spacer(),
                        const MyText(
                          text: "TICKET DETAILS",
                          hexaColor: AppColors.orangeColor,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 4),
                        const MyText(
                          text: "MetaDoersWorld",
                          // hexaColor: AppColors.whiteColorHexa,
                          fontSize: 20,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.bold,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          Consumer<MDWProvider>(
            builder: (context, value, widget){
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 25,
                  itemBuilder: ((context, index) {
                    return Container(
                      margin: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: randomAvatar('Sam Allen')
                                  ),
                    
                                  SizedBox(width: 2.w,),
                    
                                  const MyText(
                                    text: "Sam Allen",
                                    fontWeight: FontWeight.bold,
                                  )
                                ],
                              ),
                    
                              const Spacer(),
                    
                              IconButton(
                                onPressed: () async{
                                  await _qrNFTDialog();
                                },
                                icon: Icon(Iconsax.scan_barcode, color: isDarkMode == true ? Colors.white : hexaCodeToColor(AppColors.darkGrey),),
                              )
                    
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              );
              // return ListView.builder(
              //   shrinkWrap: true,
              //   itemCount: value.model.tickets.length,
              //   itemBuilder: (context, index) {
              //     return Padding(
              //       padding: const EdgeInsets.all(paddingSize),
              //       child: Image.network("https://mdw.bitriel.com/_next/image?url=%2Fimages%2Fticket.png&w=1200&q=75"),
              //     );
              //   }
              // );
            }
          )
        ],  
      ),
    );
  }

  Future<Uint8List> _capturePng(GlobalKey globalKey) async {
    print('inside');
    RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    var pngBytes = byteData!.buffer.asUint8List();
    var bs64 = base64Encode(pngBytes);
    print(pngBytes);
    print(bs64);
    setState(() {});
    return pngBytes;
  }

  Future<void> qrShare(GlobalKey globalKey, String name) async {
    try {
      final RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      final image = await boundary.toImage(pixelRatio: 5.0);
      final ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = await File("${tempDir.path}/$name.png").create();
      await file.writeAsBytes(pngBytes);

      Share.shareXFiles([XFile(file.path)], text: name);
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
                  icon: const Icon(Iconsax.close_circle, color: Colors.white, size: 30),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                            
                                  const Flexible(
                                    child: MyText(
                                      text: "NFT TICKET\nMetaDoersWorld",
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

                    Container(
                      width: 250,
                      // padding: const EdgeInsets.all(paddingSize),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const MyText(
                                    text: "CONTRACT ADDRES",
                                    hexaColor: AppColors.greyColor,
                                    fontSize: 13,
                                  ),
                                  MyText(
                                    hexaColor: AppColors.whiteHexaColor,
                                    text: "${value.accountM.address!.replaceRange(5, value.accountM.address!.length - 5, "........")}",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),

                            // Spacer(),

                            SizedBox(
                              width: 18.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  MyText(
                                    text: "Pieces",
                                    hexaColor: AppColors.greyColor,
                                    fontSize: 13,
                                  ),
                                  MyText(
                                    text: "0",
                                    fontWeight: FontWeight.bold,
                                    hexaColor: AppColors.whiteHexaColor,
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 2.h,),

                    Container(
                      width: 250,
                      // padding: const EdgeInsets.all(paddingSize),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  MyText(
                                    text: "Token Standard",
                                    hexaColor: AppColors.greyColor,
                                    fontSize: 13,
                                  ),
                                  MyText(
                                    text: "ERC1155",
                                    fontWeight: FontWeight.bold,
                                    hexaColor: AppColors.whiteHexaColor,
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              width: 18.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  MyText(
                                    text: "Blockchain",
                                    hexaColor: AppColors.greyColor,
                                    fontSize: 13,
                                  ),
                                  MyText(
                                    text: "SELENDRA",
                                    fontWeight: FontWeight.bold,
                                    hexaColor: AppColors.whiteHexaColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 3.h,),

                    Padding(
                      padding: const EdgeInsets.all(paddingSize),
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                _capturePng(Provider.of<ReceiveWalletProvider>(context, listen: false).keyQrShare);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.orangeColor).withOpacity(0.2),
                                        shape: BoxShape.circle
                                    ),
                                    child: Icon(Iconsax.import_1, color: hexaCodeToColor(AppColors.whiteColorHexa)),
                                  ),
                            
                                  const MyText(
                                    text: "Download",
                                    hexaColor: AppColors.whiteHexaColor,
                                  )
                                ],
                              ),
                            ),

                            SizedBox(width: 10.w),
                            
                            InkWell(
                              onTap: () {
                                qrShare(Provider.of<ReceiveWalletProvider>(context, listen: false).keyQrShare, "NFT TICKET MetaDoersWorld");
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.orangeColor).withOpacity(0.2),
                                        shape: BoxShape.circle
                                    ),
                                    child: Icon(Iconsax.link, color: hexaCodeToColor(AppColors.whiteColorHexa)),
                                  ),
                            
                                  const MyText(
                                    text: "Share",
                                    hexaColor: AppColors.whiteHexaColor,
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
                                            
                                  const Spacer(),
                                            
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