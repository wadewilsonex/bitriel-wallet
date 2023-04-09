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

  List<Map<String, dynamic>>? events = [];
  List<String>? images = [];

  String? _ipfsAPI;

  /// Connect Contract
  /// 
  /// And Query Amount's Ticket
  void ticketInitializer() async {
    
    Provider.of<MDWProvider>(context, listen: false).init();
    await Provider.of<MDWProvider>(context, listen: false).initNFTContract(context).then((value) async => {
      await Provider.of<MDWProvider>(context, listen: false).fetchItemsByAddress(),
    });
    
  }

  void fetchEvent() async {
    print("fetchEvent");
    await getAllEvent().then((value) async {
      events = List<Map<String, dynamic>>.from((await json.decode(value.body))['events']);
      print("events ${events!.length}");
    });
    
    // events!.add({
    //   ""
    // });

    if (mounted) {
      setState((){
        _ipfsAPI = dotenv.get('IPFS_API');
      });
    }
    
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
      body: Column(
        children: [
          events!.isNotEmpty ? ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: events!.length,
            itemBuilder: (context, index) {
              return EventCardComponents(
                ipfsAPI: _ipfsAPI,
                title: "Do For Metaverse",
                listEvent: events,
              );
            }
          ) : loading(),

          EventCardComponents(
            // ipfsAPI: _ipfsAPI,
            title: "ISI Dangkor Senchey FC",
            listEvent: [],
            eventName: "DSC VS PKRR",
            eventDate: "2023-04-09 03:45:00 PM",
          ),

        ],
      )

    );
  }

}