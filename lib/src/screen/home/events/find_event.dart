import 'dart:ui' as ui;
import 'dart:ui';
import 'package:animated_background/animated_background.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/get_request.dart';
import 'package:wallet_apps/src/backend/post_request.dart';
import 'package:wallet_apps/src/components/cards/event_card_c.dart';
import 'package:wallet_apps/src/constants/color.dart';
import 'package:wallet_apps/src/constants/textstyle.dart';
import 'package:wallet_apps/src/constants/ui_helper.dart';
import 'package:wallet_apps/src/models/event_model.dart';
import 'package:wallet_apps/src/provider/receive_wallet_p.dart';
import 'package:wallet_apps/src/screen/home/events/detail_event.dart';
import 'package:wallet_apps/src/screen/home/nft/details_nft/body_details_nft.dart';
import 'package:wallet_apps/src/screen/home/nft/details_nft/details_nft.dart';
import 'package:wallet_apps/src/screen/home/events/list_ticket/list_ticking.dart';
import 'package:wallet_apps/src/screen/home/nft/details_nft/details_nft.dart';
import 'package:wallet_apps/src/screen/home/events/ticket_options.dart';
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

  List<Map<String, dynamic>>? events = [];
  List<String>? images = [];

  String? _ipfsAPI;

  /// Connect Contract
  /// 
  /// And Query Amount's Ticket
  void ticketInitializer() async {
    
    Provider.of<MDWProvider>(context, listen: false).init();
    await Provider.of<MDWProvider>(context, listen: false).initNFTContract(context);
    await Provider.of<MDWProvider>(context, listen: false).fetchItemsByAddress();
  }

  void fetchEvent() async {

    await getAllEvent().then((value) async {
      events = List<Map<String, dynamic>>.from((await json.decode(value.body))['events']);
      
    });

    setState((){
      _ipfsAPI = dotenv.get('IPFS_API');
    });
    
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

    fetchEvent();

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
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: 1,
        itemBuilder: (context, index) {
          
          return EventCardComponents(
            ipfsAPI: _ipfsAPI,
            title: "Meta Doers World", 
            eventDate: "10 - 21 august, 2022", 
            eventName: "NIGHT MUSIC FESTIVAL",
            listEvent: events,
            // onPressed: (){
            //   Navigator.push(
            //     context, 
            //     Transition(child: ListTicket(eventName: events![index]['name']!, eventId: events![index]['_id']!), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
            //   );
            // }
          );
        }
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: hexaCodeToColor(AppColors.secondary),
      //   onPressed: (){
      //     _showPasses(context);
      //   },
      //   child: const Icon( Iconsax.ticket ),
      // ),

    );
  }

}