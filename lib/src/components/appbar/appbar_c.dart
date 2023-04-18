import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/get_request.dart';
import 'package:wallet_apps/src/components/shimmers/shimmer_c.dart';
import 'package:wallet_apps/src/components/walletconnect_c.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:wallet_apps/src/provider/verify_seed_p.dart';
import 'package:wallet_apps/src/screen/home/home/home_func.dart';
import 'package:wallet_apps/src/service/exception_handler.dart';

PreferredSizeWidget defaultAppBar({
  required BuildContext? context,
  required HomePageModel? homePageModel,
  required bool? pushReplacement
}) {

  const appBarHeight = 80.0;

  return AppBar(
    backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
    elevation: 0,
    toolbarHeight: appBarHeight,
    // leadingWidth: 30,
    centerTitle: true,
    flexibleSpace: SafeArea(
      child: Container(
        width: MediaQuery.of(context!).size.width,
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(color: hexaCodeToColor("#E6E6E6")),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.whiteColorHexa)
        ),
      ),
    ),

    automaticallyImplyLeading: false,
    
    title: Consumer<ApiProvider>(

      builder: (context, provider, child) {

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: () async {

                  bottomSheetAddAccount(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: AvatarShimmer(
                    height: 45,
                    width: 45,
                    txt: provider.netWorkConnected == false ? null : provider.getKeyring.current.icon,
                    child: randomAvatar(provider.netWorkConnected == false ? '' : provider.getKeyring.current.icon!),
                  ),
                )
              ),
            ),

            const Spacer(),
            
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {

                return GestureDetector(
                  onTap: () async {
                    
                    try {
                      dialogLoading(context);
                      await getSelendraEndpoint().then((value) async {
                        Navigator.pop(context);
                        // Assign Data and Store Endpoint Into Local DB
                        await Provider.of<ApiProvider>(context, listen: false).initSelendraEndpoint(await json.decode(value.body)).then((value) async{
                          await HomeFunctional().changeNetwork(context: context, setState: setState);
                        });

                      });
                    }
                    catch (e) {
                      print("catch $e");
                      Navigator.pop(context);
                      customDialog(context, "Failed", "Please check your connection again", txtButton: "OK");
                    }
                    
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: WidgetShimmer(
                          txt: provider.netWorkConnected == false ? null : provider.getKeyring.current.address,
                          child: MyText(
                            text: provider.netWorkConnected == false ? null : provider.getKeyring.current.address!.replaceRange(6, provider.getKeyring.current.address!.length - 6, "......."),
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                            fontSize: 18,
                          ),
                        ),
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          MyText(text: "SELENDRA", hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.greyCode, fontSize: 16,),

                            Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(Iconsax.arrow_down_1, size: 25, color: isDarkMode ? Colors.white : hexaCodeToColor("#5C5C5C"),),
                          )
                        ],
                      ),

                    ],
                  )
                );

              },
            ),

            const Spacer(),

            Expanded(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: IconButton(
                  iconSize: 22.sp,
                  icon: Icon(
                    Iconsax.scan,
                    color: isDarkMode
                        ? hexaCodeToColor(homePageModel!.activeIndex == 1 ? AppColors.whiteColorHexa : AppColors.whiteColorHexa)
                        : hexaCodeToColor(homePageModel!.activeIndex == 1 ? "#6C6565" : "#6C6565"),
                  ),
                  onPressed: () async {

                    await filterListWcSession(context);
                    
                    // ignore: use_build_context_synchronously
                    await TrxOptionMethod.scanQR(
                      context,
                      [],
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }
    ),
  );
}

Future<void> filterListWcSession(BuildContext context) async {

  WalletConnectProvider? wConnectC;

  wConnectC = Provider.of<WalletConnectProvider>(context, listen: false);
  wConnectC.setBuildContext = context;
  await StorageServices.fetchData("session").then((value) {
      
      wConnectC!.fromJsonFilter(List<Map<String, dynamic>>.from(value));
    }
  );
    
}

void bottomSheetAddAccount(BuildContext context) async{
  
  return showBarModalBottomSheet(
    backgroundColor: hexaCodeToColor(AppColors.lightColorBg),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical( 
        top: Radius.circular(25.0),
      ),
    ),
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, mySetState) {
          return Consumer<ApiProvider>(
            builder: (context, provider, wg) {

              return ListView.builder(
                itemCount: provider.getKeyring.allAccounts.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: provider.getKeyring.allAccounts[index].address == provider.getKeyring.current.address ? null : () async {

                      dialogLoading(context);

                      provider.getKeyring.setCurrent(provider.getKeyring.allAccounts[index]);

                      await StorageServices.readSecure(DbKey.privateList)!.then((value) {
                        print("value $value");

                        print("json.decode(value)[index]['eth_address' ${json.decode(value)[index]['eth_address']}");

                        Provider.of<ContractProvider>(context, listen: false).ethAdd = json.decode(value)[index]['eth_address'];

                        print("Provider.of<ContractProvider>(context, listen: false).ethAdd ${Provider.of<ContractProvider>(context, listen: false).ethAdd}");

                      });
                      provider.notifyListeners();
                      await ContractsBalance.getAllAssetBalance();

                      Navigator.pop(context);
                      
                      Provider.of<VerifySeedsProvider>(context, listen: false).notifyListeners();
                      mySetState( () {});
                      
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                  
                        Padding(
                          padding: const EdgeInsets.all(paddingSize),
                          child: Row(
                            children: [
                  
                              AvatarShimmer(
                                txt: provider.getKeyring.current.icon,
                                child: randomAvatar(provider.getKeyring.allAccounts[index].icon ?? '',),
                              ),
                  
                              const SizedBox(width: 10),
                        
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyText(
                                    text: provider.getKeyring.allAccounts[index].name,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.start,
                                  ),
                              
                                  MyText(
                                    text: provider.getKeyring.allAccounts[index].address == null ? "" : provider.getKeyring.allAccounts[index].address!.replaceRange(6, provider.getKeyring.current.address!.length - 6, "......."),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    textAlign: TextAlign.start,
                                    hexaColor: AppColors.greyCode,
                                  ),
                                ],
                              ),
                  
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: provider.getKeyring.allAccounts[index].address == provider.getKeyring.current.address 
                                  ? const Icon(Icons.check_circle_rounded, color: Colors.green, size: 30,) 
                                  : const Icon(Icons.circle, color: Color.fromARGB(255, 199, 199, 199), size: 30,) 
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              );
            }
          );
        }
      );
    }
  );
}

// class AppBarCustom extends StatelessWidget {
//   final double? pLeft;
//   final double? pTop;
//   final double? pRight;
//   final double? pBottom;
//   final EdgeInsetsGeometry? margin;
//   final Function? onPressed;
//   final Color? color;
//   final Widget? tile;
//   final GlobalKey<ScaffoldState>? globalKey;
  
//   const AppBarCustom({Key? key, 
//     this.pLeft = 0,
//     this.pTop = 0,
//     this.pRight = 0,
//     this.pBottom = 0,
//     this.margin = const EdgeInsets.fromLTRB(0, 0, 0, 0),
//     this.color,
//     this.onPressed,
//     this.tile,
//     this.globalKey,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       key: globalKey,
//       child: Container(
//         height: 65.0,
//         width: MediaQuery.of(context).size.width,
//         margin: margin,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             IconButton(
//               icon: Icon(
//                 Iconsax.profile_circle, 
//                 size: 25, 
//                 color: hexaCodeToColor(AppColors.whiteHexaColor)
//               ),
              
//               onPressed: () {

//               },
//             ),
            
//             IconButton(
//               icon: Icon(
//                 Iconsax.scan,
//                 size: 25,
//                 color: hexaCodeToColor(AppColors.whiteHexaColor),
//               ),
//               onPressed: () {
                
//               },
//             ),
//           ],
//         )
//       )
//     );
//   }
// }

class MyAppBar extends StatelessWidget {
  final double? pLeft;
  final double? pTop;
  final double? pRight;
  final double? pBottom;
  final EdgeInsetsGeometry? margin;
  final String? title;
  final Function? onPressed;
  final Color? color;
  final Widget? tile;
  final double? fontSize;

  const MyAppBar({
    Key? key, 
    this.pLeft = 0,
    this.pTop = 0,
    this.pRight = 0,
    this.pBottom = 0,
    this.margin = const EdgeInsets.fromLTRB(0, 0, 0, 0),
    @required this.title,
    this.color,
    this.onPressed,
    this.tile,
    this.fontSize = 17,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Container(
        color: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
        width: MediaQuery.of(context).size.width,
        margin: margin,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  /* Menu Icon */
                  iconSize: 40.0,
                  icon: Icon(
                    Iconsax.arrow_left_2,
                    color: isDarkMode ? Colors.white : Colors.black,
                    size: 22.5,
                  ),
                  onPressed: (){
                    onPressed!();
                  },
                ),
                MyText(
                  hexaColor: isDarkMode
                    ? AppColors.whiteColorHexa
                    : AppColors.textColor,
                  text: title,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600
                ),
              ],
            ),
            tile ?? Container()
          ],
        )
      )
    );
  }
}