import 'package:wallet_apps/index.dart';

class NFTCardComponent extends StatelessWidget{

  final int? index;
  final int? length;
  final String? eventName;

  NFTCardComponent({required this.eventName, required this.index, required this.length});

  @override
  Widget build(BuildContext context){

    return InkWell(
      // onTap: onPressed!,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 121,
        margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: index == length!-1 ? 20 : 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
        
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.asset("${AppConfig.assetsPath}event_thumbnail.png", fit: BoxFit.cover,)
              ),
        
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 10, bottom: 10),
                  // alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      MyText(
                        text: eventName!, //"NIGHT MUSIC FESTIVAL",
                        fontSize: 16,
                        color2: Colors.white,
                        fontWeight: FontWeight.w700,
                      )
                    ],
                  ),
                ),
              ),

            ],
          ),
        )
    
        // Row(
        //   children: [
    
        //     ListView.builder(
        //       scrollDirection: Axis.horizontal,
        //       physics: const BouncingScrollPhysics(),
        //       shrinkWrap: true,
        //       itemCount: upcomingEvents.length,
        //       itemBuilder: (context, index) {
        
        //         final event = upcomingEvents[index];
                
        //         return Container(
        //           decoration: BoxDecoration(
    
        //             color: Colors.red,
        //           ),
        //           margin: const EdgeInsets.all(paddingSize),
        //           width: MediaQuery.of(context).size.width - 20,
        //           height: 200,
        //           child: Text("hello"),
        //         );
        //       },
        //     ),
        //   ],
        // ),
      ),
    );
  }
}

class GiftCardComponent extends StatelessWidget{

  final int? index;
  final int? length;
  final String? giftName;

  GiftCardComponent({ required this.giftName, required this.index, required this.length});

  Widget build(BuildContext context){
    return InkWell(
      // onTap: onPressed!,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 121,
        margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: index == length!-1 ? 20 : 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: hexaCodeToColor("#FEFEFE"),
        ),
        child: Row(
          children: [
        
            Container(
              width: 121,
              height: 121,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(AppConfig.assetsPath+"appbar_bg.jpg", fit: BoxFit.cover,),
              ),
            ),
        
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                MyText(
                  top: 10,
                  text: giftName!, //"NIGHT MUSIC FESTIVAL",
                  fontSize: 16,
                  hexaColor: "#49595F",
                  fontWeight: FontWeight.w800,
                ),

                MyText(
                  top: 5,
                  text: giftName!, //"NIGHT MUSIC FESTIVAL",
                  fontSize: 14,
                  hexaColor: "#49595F",
                  fontWeight: FontWeight.w600,
                )
              ],
            ),

          ],
        )
    
        // Row(
        //   children: [
    
        //     ListView.builder(
        //       scrollDirection: Axis.horizontal,
        //       physics: const BouncingScrollPhysics(),
        //       shrinkWrap: true,
        //       itemCount: upcomingEvents.length,
        //       itemBuilder: (context, index) {
        
        //         final event = upcomingEvents[index];
                
        //         return Container(
        //           decoration: BoxDecoration(
    
        //             color: Colors.red,
        //           ),
        //           margin: const EdgeInsets.all(paddingSize),
        //           width: MediaQuery.of(context).size.width - 20,
        //           height: 200,
        //           child: Text("hello"),
        //         );
        //       },
        //     ),
        //   ],
        // ),
      ),
    );
  }
}