import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/get_request.dart';
import 'package:wallet_apps/src/components/cards/event_card_c.dart';

class FindEvent extends StatefulWidget {
  static const route = '/event';

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

  List<Map<String, dynamic>>? events = [
    {
      "eventOrganizer": "ISI Dangkor Senchey FC",
      "eventName": "Football Match",
      "eventDate": "Sun, April 09, 2023 | 03:45 - 5:45 PM",
      "eventImage": "https://pbs.twimg.com/media/FtOwQmVaUAADJBx.jpg",
      "eventLocation": "AIA Stadium"
    },
    {
      "eventOrganizer": "Do For Metaverse",
      "eventName": "Vincent Van Gogh",
      "eventDate": "Mon, Dec 12, 2022 | 08:45 AM - 09:00 PM",
      "eventImage": "https://res.klook.com/image/upload/fl_lossy.progressive,q_85/c_fill,w_680/v1675424665/blog/gywlaeqip9pjmev9rmjq.jpg",
      "eventLocation": "Malaysia"
    },
  ];
  List<String>? images = [];

  String? _ipfsAPI;

  /// Connect Contract
  /// 
  /// And Query Amount's Ticket
  // void ticketInitializer() async {
    
  //   Provider.of<MDWProvider>(context, listen: false).init();
  //   await Provider.of<MDWProvider>(context, listen: false).initNFTContract(context).then((value) async => {
  //     await Provider.of<MDWProvider>(context, listen: false).fetchItemsByAddress(),
  //   });
    
  // }

  // void fetchEvent() async {
  //   print("fetchEvent");
  //   await getAllEvent().then((value) async {
  //     events = List<Map<String, dynamic>>.from((await json.decode(value.body))['events']);
  //     print("events ${events!.length}");
  //   });
    
  //   // events!.add({
  //   //   ""
  //   // });

  //   if (mounted) {
  //     setState((){
  //       _ipfsAPI = dotenv.get('IPFS_API');
  //     });
  //   }
    
  // }

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

    // fetchEvent();

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
      body: Column(
        children: [

          events!.isNotEmpty ? EventCardComponents(
            title: "Featured",
            listEvent: events,
          ) : loading(),

        ],
      )

    );
  }

}