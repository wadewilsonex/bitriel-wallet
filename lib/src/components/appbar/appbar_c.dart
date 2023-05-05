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

  const appBarHeight = 90.0;

  return AppBar(
    elevation: 0,
    toolbarHeight: appBarHeight,
    centerTitle: true,
    automaticallyImplyLeading: false,
    flexibleSpace: SafeArea(
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: hexaCodeToColor("#E6E6E6")),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.whiteColorHexa)
        ),
        child: Consumer<ApiProvider>(

          builder: (context, provider, child) {

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                // GestureDetector(
                //   onTap: () async {
            
                //     bottomSheetAddAccount(context);
                //   },
                //   child: avatarShimmer(
                //     context,
                //     height: 45,
                //     width: 45,
                //     txt: provider.netWorkConnected == false ? null : provider.getKeyring.current.icon,
                //     child: randomAvatar(provider.netWorkConnected == false ? '' : provider.getKeyring.current.icon!),
                //   ),
                // ),
                randomAvatar(provider.netWorkConnected == false ? '' : provider.getKeyring.current.icon!)
                
                // GestureDetector(
                //   onTap: () async {
                    
                //     try {
                      
                //       dialogLoading(context);
                //       await getSelendraEndpoint().then((value) async {
                //         Navigator.pop(context);
                //         // Assign Data and Store Endpoint Into Local DB
                //         await Provider.of<ApiProvider>(context, listen: false).initSelendraEndpoint(await json.decode(value.body)).then((value) async {
                //           await HomeFunctional().changeNetwork(context: context);
                //         });
            
                //       });
                //     }
                //     catch (e) {
                //       Navigator.pop(context);
                //       DialogComponents().customDialog(context, "Failed", "Please check your connection again", txtButton: "OK");
                //     }
                    
                //   },
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
            
                //       widgetShimmer(
                //         context,
                //         txt: provider.netWorkConnected == false ? null : provider.getKeyring.current.address,
                //         child: myText2(
                //           context,
                //           text: provider.netWorkConnected == false ? '' : provider.getKeyring.current.address!.replaceRange(6, provider.getKeyring.current.address!.length - 6, "......."),
                //           fontWeight: FontWeight.bold,
                //           textAlign: TextAlign.center,
                //           fontSize: 18,
                //         ),
                //       ),
            
                //       Row(
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
            
                //           myText2(context, text: "SELENDRA", hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.greyCode, fontSize: 16,),
            
                //           Padding(
                //             padding: const EdgeInsets.only(left: 4),
                //             child: Icon(Iconsax.arrow_down_1, size: 25, color: isDarkMode ? Colors.white : hexaCodeToColor("#5C5C5C"),),
                //           )
                //         ],
                //       ),
            
                //     ],
                //   )
                // ),
            
                // IconButton(
                //   iconSize: 22.sp,
                //   icon: Icon(
                //     Iconsax.scan,
                //     color: isDarkMode
                //       ? hexaCodeToColor(homePageModel!.activeIndex == 1 ? AppColors.whiteColorHexa : AppColors.whiteColorHexa)
                //       : hexaCodeToColor(homePageModel!.activeIndex == 1 ? "#6C6565" : "#6C6565"),
                //   ),
                //   onPressed: () async {
            
                //     await filterListWcSession(context);
                    
                //     // ignore: use_build_context_synchronously
                //     await TrxOptionMethod.scanQR(
                //       context,
                //       [],
                //     );
                //   },
                // ),

              ],
            );
          }
        ),
      ),
    ),
    
  );
}

Future<void> filterListWcSession(BuildContext context) async {

  WalletConnectProvider? wConnectC;

  wConnectC = Provider.of<WalletConnectProvider>(context, listen: false);
  wConnectC.setBuildContext = context;
  await StorageServices.fetchData("session").then((value) {
    if (value != null){

      wConnectC!.fromJsonFilter(List<Map<String, dynamic>>.from(value));
    }
  });
    
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

                      // Set Selendra Current Account With Selected Account
                      provider.getKeyring.setCurrent(provider.getKeyring.allAccounts[index]);

                      await StorageServices.readSecure(DbKey.privateList)!.then((value) async {

                        // Assign Selected Account SEL Address To Sorted Address List
                        Provider.of<ContractProvider>(context, listen: false).sortListContract[0].address = json.decode(value)[index]['address'];
                        
                        // Assign EVM Address to ethAddr
                        Provider.of<ContractProvider>(context, listen: false).ethAdd = json.decode(value)[index]['eth_address'];

                        // Assign BTC Address And Store New
                        Provider.of<ContractProvider>(context, listen: false).listContract[provider.btcIndex].address = json.decode(value)[index]['btc_address'];

                        await StorageServices.writeSecure(DbKey.bech32, json.decode(value)[index]['btc_address']);
                        // ignore: use_build_context_synchronously
                        provider.getBtcBalance(context: context);
                        
                        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                        Provider.of<ContractProvider>(context, listen: false).notifyListeners();
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
                  
                              avatarShimmer(
                                context,
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

// class MyAppBar extends StatelessWidget {
//   final double? pLeft;
//   final double? pTop;
//   final double? pRight;
//   final double? pBottom;
//   final EdgeInsetsGeometry? margin;
//   final String? title;
//   final Function? onPressed;
//   final Color? color;
//   final Widget? tile;
//   final double? fontSize;

//   const MyAppBar({
//     Key? key, 
//     this.pLeft = 0,
//     this.pTop = 0,
//     this.pRight = 0,
//     this.pBottom = 0,
//     this.margin = const EdgeInsets.fromLTRB(0, 0, 0, 0),
//     @required this.title,
//     this.color,
//     this.onPressed,
//     this.tile,
//     this.fontSize = 17,
//   }) : super(key: key);

Widget myAppBar(
  BuildContext context,
{
  double? pLeft,
  double? pTop,
  double? pRight,
  double? pBottom,
  EdgeInsetsGeometry? margin,
  String? title,
  Function? onPressed,
  Color? color,
  Widget? tile,
  double? fontSize,
}
) {
  
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