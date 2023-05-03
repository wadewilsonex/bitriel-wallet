import 'package:wallet_apps/index.dart';
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

  List<Map<String, dynamic>>? allEvents = [
    {
      "eventOrganizer": "ISI Dangkor Senchey FC",
      "eventName": "Football Match",
      "eventDate": "Sun, April 09, 2023 | 03:45 - 5:45 PM",
      "eventImage": "https://pbs.twimg.com/media/FtOwQmVaUAADJBx.jpg",
      "eventLocation": "AIA Stadium",
      "eventCategory": "Sport",
    },
        {
      "eventOrganizer": "Do For Metaverse",
      "eventName": "Vincent Van Gogh",
      "eventDate": "Mon, Dec 12, 2022 | 08:45 AM - 09:00 PM",
      "eventImage": "https://res.klook.com/image/upload/fl_lossy.progressive,q_85/c_fill,w_680/v1675424665/blog/gywlaeqip9pjmev9rmjq.jpg",
      "eventLocation": "Malaysia",
      "eventCategory": "Art",
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
  //   debugPrint("fetchEvent");
  //   await getAllEvent().then((value) async {
  //     events = List<Map<String, dynamic>>.from((await json.decode(value.body))['events']);
  //     debugPrint("events ${events!.length}");
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
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: DefaultTabController(
        length: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            
            allEvents!.isNotEmpty ? EventCardComponents(
              title: "Featured",
              listEvent: allEvents,
            ) : centerLoading(),
            
            const MyText(
              top: 15,
              left: 22,
              bottom: 10,
              text: "Popular Event",
              fontSize: 22,
              hexaColor: AppColors.blackColor,
              fontWeight: FontWeight.w600,
            ),
            
            
            _categoryEvent(),
            
          ],
        ),
      ),
    );
  }

  Widget _categoryEvent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 60,
          padding: const EdgeInsets.only(left: paddingSize / 2, bottom: 20,),
          child: TabBar(
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: hexaCodeToColor(AppColors.primaryColor),
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: hexaCodeToColor(AppColors.primaryColor)
            ),
            tabs: [
              Tab(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: hexaCodeToColor(AppColors.primaryColor), width: 1)),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text('All')
                  ),
                ),
              ),
              Tab(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: hexaCodeToColor(AppColors.primaryColor), width: 1)),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text('Art')
                  ),
                ),
              ),
              Tab(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: hexaCodeToColor(AppColors.primaryColor), width: 1)),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text('Sport')
                  ),
                ),
              ),
            ],
          ),
        ),
    
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: TabBarView(
            children: [
              _allEvent(allEvents),
              _eachEvent(allEvents, "Art"),
              _eachEvent(allEvents, "Sport"),
            ],
          ),
        ),
    
      ],
    );
  }

  Widget _allEvent(List<Map<String, dynamic>>? item) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.25),
      ),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: item!.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index){
        return _allEventList(item, index);
      }
    );
  }

  Widget _eachEvent(List<Map<String, dynamic>>? item, String category) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.25),
      ),
      shrinkWrap: false,
      scrollDirection: Axis.vertical,
      itemCount: item!.where((eventCategory) => eventCategory["eventCategory"] == category).length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index){
        return _eachEventList(item, index, category);
      }
    );
  }

  Widget _allEventList(List<Map<String, dynamic>> item, int index) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: paddingSize),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16))
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Container(
                padding: const EdgeInsets.all(10),
                height: 250,
                width: 250,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(16)) ,
                  child: Image.network(item[index]["eventImage"], fit: BoxFit.cover,)
                ),
              ),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: paddingSize),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: item[index]['eventName'],
                      fontSize: 22,
                      hexaColor: AppColors.primaryColor,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                    ),
              
                    MyText(
                      pTop: 10,
                      text: item[index]["eventDate"],
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.blackColor,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              Container(
                padding: const EdgeInsets.all(paddingSize),
                child: Row(
                  children: [
                    Icon(Iconsax.location, color: hexaCodeToColor(AppColors.primaryColor),),
              
                    MyText(
                      pLeft: 5,
                      text: item[index]["eventLocation"],
                      fontSize: 18,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
              
            ],
          ),
        ),
      ],
    );
  }

  Widget _eachEventList(List<Map<String, dynamic>> item, int index, String category) {

    final filterList = item.where((eventCategory) => eventCategory["eventCategory"] == category).toList();

    return InkWell(
      onTap: () {
        
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: paddingSize),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16))
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 250,
                  width: 250,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16)) ,
                    child: Image.network(filterList[index]["eventImage"], fit: BoxFit.cover,)
                  ),
                ),
                
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: paddingSize),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        text: filterList[index]['eventName'],
                        fontSize: 22,
                        hexaColor: AppColors.primaryColor,
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                
                      MyText(
                        pTop: 10,
                        text: filterList[index]["eventDate"],
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        hexaColor: AppColors.blackColor,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                Container(
                  padding: const EdgeInsets.all(paddingSize),
                  child: Row(
                    children: [
                      Icon(Iconsax.location, color: hexaCodeToColor(AppColors.primaryColor),),
                
                      MyText(
                        pLeft: 5,
                        text: filterList[index]["eventLocation"],
                        fontSize: 18,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )
                
              ],
            ),
          ),
        ],
      ),
    );
            
  }
}