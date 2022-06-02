import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/asset_item_c.dart';
import 'package:wallet_apps/src/components/menu_item_c.dart';

class AssetsPageBody extends StatelessWidget {
  const AssetsPageBody({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: BodyScaffold(
        physic: BouncingScrollPhysics(),
        isSafeArea: true,
        bottom: 0,
        child: Column(
          children: [
            AppBarCustom(),
            
            _userWallet(context),
      
            SizedBox(height: 25),
      
            _selendraNetworkList(context),
      
            // SizedBox(height: 40),
      
            // _otherNetworkList(context),
      
            
      
          ],
        ),
      ),
      bottomNavigationBar: MyBottomAppBar(
        apiStatus: true,
      ),
    );
  }


  Widget _userWallet(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: hexaCodeToColor(AppColors.bluebgColor),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2.75,
      child: Column(
        children: [
          SizedBox(height: 10),
          Container(
            width: 100,
            height: 100,
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Colors.white, blurRadius: 20.0),
                  ],
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        'https://images.theconversation.com/files/93616/original/image-20150902-6700-t2axrz.jpg')
                  )
                )
              ),
            ),
          ),

          SizedBox(height: 12),
          MyText(
            text: "SAN Vuthy",
            color: AppColors.whiteColorHexa,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),

          SizedBox(height: 15),
          MyText(
            text: "\$134.72",
            color: AppColors.whiteColorHexa,
            fontSize: 16,
          ),

          SizedBox(height: 25),

          _operationRequest(context),
          // Row(
          //   children: [
          //     Expanded(
          //       child: MenuItem(
          //         title: "Send",
          //         icon: Transform.rotate(
          //           angle: 141.371669412,
          //           child: Icon(Iconsax.import, color: Colors.white, size: 35),
          //         ),
                  
          //         begin: Alignment.bottomLeft,
          //         end: Alignment.topRight,
          //         action: () {
          //         },
          //       ),
          //     ),

          //     SizedBox(width: 10,),

          //     Expanded(
          //       child: MenuItem(
          //         title: "Recieve",
          //         icon: Icon(Iconsax.import, color: Colors.white, size: 35),
          //         begin: Alignment.bottomCenter,
          //         end: Alignment.topCenter,
          //         action: () {
          //         },
          //       ),
          //     ),
              

          //   ],
          // )
        ],
      ),
    );
  }

  Widget _selendraNetworkList(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: paddingSize),
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                MyText(
                  text: "Selendra Network",
                  color: AppColors.titleAssetColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500
                ),
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: hexaCodeToColor(AppColors.titleAssetColor),
                    indent: 20,
                  ),
                ),
              ],
            ),

            Consumer<ContractProvider>(
              builder: (context, value, child) {
                return Column(
                  children: [
                    for (int index = 0; index < value.sortListContract.length; index++)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            RouteAnimation(
                              enterPage: AssetInfo(
                                index: index,
                                scModel: value.sortListContract[index]
                              ),
                            ),
                          );
                        },
                        child: AssetsItemComponent(
                          scModel: value.sortListContract[index]
                        )
                      )
                  ]
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _otherNetworkList(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: paddingSize),
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                MyText(
                  text: "Other Network",
                  color: AppColors.titleAssetColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500
                ),
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: hexaCodeToColor(AppColors.titleAssetColor),
                    indent: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _operationRequest(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: paddingSize),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width /2 ,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [hexaCodeToColor("#0D6BA6"), hexaCodeToColor("#2EF9C8")],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  MyText(
                    text: "Send",
                    fontSize: 16,
                    color: AppColors.whiteColorHexa,
                    fontWeight: FontWeight.w700,
                  ),
                  Transform.rotate(
                    angle: 141.371669412,
                    child: Icon(Iconsax.import, color: Colors.white, size: 35),
                  ),
                ],
              ),
            ),
          ),
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: paddingSize),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [hexaCodeToColor("#0D6BA6"), hexaCodeToColor("#2EF9C8")],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  MyText(
                    text: "Receieve",
                    fontSize: 16,
                    color: AppColors.whiteColorHexa,
                    fontWeight: FontWeight.w700,
                  ),
                  Icon(Iconsax.import, color: Colors.white, size: 35),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}