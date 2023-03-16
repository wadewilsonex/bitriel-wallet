import 'package:event_crew/event_crew.dart' as event_c;
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/event_p.dart';

class Organization extends StatefulWidget {

  String? title;
  String? logo;

  Organization({Key? key, required this.title, required this.logo}) : super(key: key);

  @override
  State<Organization> createState() => _OrganizationState();
}

class _OrganizationState extends State<Organization> {

  final String primaryColor = "#254294";

  final Map<String, dynamic> itemsGridData = {
    "membershipType": ["Walk-In"
    // , "Basic", "Standard", "Premium", 
    ],
    "imageBackground": [
      "https://dangkorsenchey.com/images/memberships_card/Standard3.png"
      // "https://dangkorsenchey.com/images/memberships_card/Standard2.png", 
      // "https://dangkorsenchey.com/images/memberships_card/Standard3.png", 
      // "https://dangkorsenchey.com/images/memberships_card/Standard2.png"
    ],
    "count": [
      "10"
      // , 
      // "15", "100", "1000"
    ]
  };
  
  final event_c.HomeModel _homeModel = event_c.HomeModel();
  
  void onPageChange(int value){

    print("onPageChange $value");

    if (_homeModel.controller.page!.toInt() == 0){
      _homeModel.controller.animateToPage(value, duration: const Duration(milliseconds: 300), curve: Curves.easeOutExpo);
      _homeModel.active = value;
      _homeModel.color = Colors.blue.withOpacity(0.3);
    } else if ((_homeModel.controller.page!.toInt() == 1)){
      _homeModel.controller.animateToPage(value, duration: const Duration(milliseconds: 300), curve: Curves.easeOutExpo);
      _homeModel.active = value;
      _homeModel.color = Colors.red.withOpacity(0.3);
    } else if ((_homeModel.controller.page!.toInt() == 2)){
      print("last one");
      Navigator.pop(context);
    } 

    setState(() {
      
      _homeModel.active = value;
    });
  }
  
  void onTap(int value) async {
    print("On tap onTap $value");

    if (value == 0){
      _homeModel.controller.animateToPage(value, duration: const Duration(milliseconds: 300), curve: Curves.easeOutExpo);
      _homeModel.active = value;
      _homeModel.color = Colors.blue.withOpacity(0.3);
    } else if (value == 1){
      _homeModel.controller.animateToPage(value, duration: const Duration(milliseconds: 300), curve: Curves.easeOutExpo);
      _homeModel.active = value;
      _homeModel.color = Colors.red.withOpacity(0.3);
    } else if (value == 2){
      print("last one");
    //   await event_c.DialogCom().dialogMessage(
    //     context!, 
    //     title: ClipRRect(
    //       borderRadius: BorderRadius.circular(100),
    //       child: SizedBox(
    //         width: 30,
    //         child: event_c.Lottie.asset(
    //           "assets/animation/exit.json",
    //           repeat: true,
    //           reverse: true,
    //           height: 100
    //         ),
    //       ),
    //     ), 
    //     edgeInsetsGeometry: const EdgeInsets.all(20),
    //     content: event_c.AnimatedTextKit(
    //       repeatForever: true,
    //       pause: const Duration(seconds: 1),
    //       animatedTexts: [

    //         event_c.TypewriterAnimatedText(
    //           "Are you sure wanna log out?",
    //           textAlign: TextAlign.center,
    //           textStyle: TextStyle(
    //             fontSize: 14
    //           )
    //         ),

    //       ],
    //     ),
    //     // MyText(text: "Are you sure wanna sign out?",),
    //     action2: Container(
    //       // margin: EdgeInsets.only(left: 10),
    //       child: TextButton(
    //         // style: ButtonStyle(
    //         //   backgroundColor: MaterialStateProperty.all(Colors.red),
    //         //   shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
    //         // ),
    //         onPressed: () async {

    //           event_c.DialogCom().dialogLoading(context, content: "Signing Out");
    //           // await event_c.StorageServices.clearStorage();
                              
    //           // Dispose Web Socket
    //           // Provider.of<MDWSocketProvider>(context, listen: false).dispose();
                              
    //           // ignore: use_build_context_synchronously
              Navigator.pop(context);
    //           // await StorageServices.clearStorage();
                              
    //           // Dispose Web Socket
    //           // Provider.of<MDWSocketProvider>(context, listen: false).dispose();
                              
    //           // Navigator.pushAndRemoveUntil(
    //           //   context, 
    //           //   Transition(child: LoginPage(), transitionEffect: TransitionEffect.LEFT_TO_RIGHT), 
    //           //   (route) => false
    //           // );
    //         },
    //         child: const MyText(text: "Yes", left: 10, right: 10, color2: Colors.red, fontSize: 12, fontWeight: FontWeight.bold,),
    //       ),
    //     ),
    //   );
    } 
    setState(() { });
  }

  Future<void> func(String empty, String qrData) async {

    // Check Valid QR
    if (Provider.of<EventProvider>(context, listen: false).qrValidator(qrData)){

      event_c.SoundUtil.soundAndVibrate(event_c.SOUND.CONFIRMATION);

      await event_c.DialogCom().successMsg(context, 'Success');

    }
    // Check Valid QR 
    else {

      event_c.SoundUtil.soundAndVibrate(event_c.SOUND.FAILED);

      await event_c.DialogCom().errorMsg(context, 'Oops');
    }
  }

  @override
  initState(){

    Provider.of<EventProvider>(context, listen: false).initEventContract();

    // _homeModel.lstPageWidget[0] = checkInPage();
    _homeModel.pageViewListenerInit(setState: (){});
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: event_c.appBar(
        title: widget.title,
        networkLogo: widget.logo,
        textColor: primaryColor,
        avatarBgColor: primaryColor
      ),
      body: Column(
        children: [

          Expanded(
            child: event_c.MyPageView(
              homeModel: _homeModel,
              onPageChange: onPageChange,
              children: [
                checkInPage(),
                Container()
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: event_c.bottomAppBarNoCheck(
        context: context, bgColor: primaryColor, controller: _homeModel.controller, itemsList: _homeModel.itemsList, active: _homeModel.active, onTap: onTap
      // (context, i){
      //   // homeModel!.onTap(context, i, (){
      //   //   setState(() {
      //   //     print()
      //   //   });
      //   // });
      // }
      )

    );
  }

  Widget checkInPage() {
    return SafeArea(
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView.builder(
          itemCount: itemsGridData["membershipType"].length,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //   childAspectRatio: 16 / 7, 
          //   crossAxisCount: 1,
          // ),
          itemBuilder: (context, index) {

            return InkWell(
              onTap: (){

                Navigator.push(
                  context,
                  Transition(
                    child: event_c.QrScanner(title: 'Walk In', func: func,)
                  )
                );
                // .then((value) {
                //   if (value != null){

                //   }
                // });

              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(itemsGridData["imageBackground"][index]), 
                      fit: BoxFit.fill
                    ),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
            
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MyText(
                              text: itemsGridData["membershipType"][index],
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color2: Colors.white,
                            ),
                            MyText(
                              text: "${itemsGridData["count"][index]} Checked In",
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color2: Colors.grey[50],
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 75,
                              width: 75,
                              child: CircleAvatar(
                                backgroundColor: event_c.AppUtil.convertHexaColor(primaryColor),
                                radius: 100,
                                child: const Icon(Icons.camera_alt, size: 30, color: Colors.white,)
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        )
      ),
    );
  }
}