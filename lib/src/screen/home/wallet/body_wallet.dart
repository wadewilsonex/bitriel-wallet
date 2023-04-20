import 'dart:ui';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/asset_item_c.dart';
import 'package:wallet_apps/src/provider/verify_seed_p.dart';
import 'package:wallet_apps/src/screen/home/nft/details_ticket/body_details_ticket.dart';
import 'package:wallet_apps/src/screen/home/swap/bitriel_swap/swap.dart';
import 'package:wallet_apps/src/screen/home/swap/swap_method/swap_method.dart';
import 'package:wallet_apps/src/screen/main/seeds/create_seeds/create_seeds.dart';
class WalletPageBody extends StatelessWidget {
  
  final HomePageModel? homePageModel;
  final AssetPageModel? model;
  final TextEditingController? searchController;
  final Function? dismiss;

  const WalletPageBody({
    Key? key,
    this.homePageModel,
    this.model,
    this.searchController,
    this.dismiss
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: hexaCodeToColor(AppColors.lightColorBg),
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverSafeArea(
                top: false,
                sliver: SliverAppBar(
                  toolbarHeight: 270,
                  pinned: true,
                  floating: true,
                  snap: true,
                  title: _userWallet(context),
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  bottom: TabBar(
                    labelColor: hexaCodeToColor(AppColors.primaryColor),
                    unselectedLabelColor: hexaCodeToColor(AppColors.greyColor),
                    indicatorColor: hexaCodeToColor(AppColors.primaryColor),
                    labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'NotoSans'),
                    unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'NotoSans'),
                    tabs: const [
                      Tab(
                        text: "Assets",
                      ),
                                  
                      // Tab(
                      //   text: "NFTs",
                      // )
                    ],
                  ),
                ),
              ),
            ),
          ],
          
          body: _tabBarView(context, dismiss!),
        ),
      ),
    );
  }

  Widget _tabBarView(BuildContext context, Function dismiss) {
    return TabBarView(
      children: [
        
        SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [

                const SizedBox(height: 10),
                Consumer<ContractProvider>(
                  builder: (context, pro, wg) {
                    return _selendraNetworkList(context, pro.sortListContract, pro, dismiss);
                  }
                ),

                _addMoreAsset(context),
              ],
            )
          ),
        ),
          
        // ListView(
        //   children: [
        //     for (int i = 0; i < 10; i++)
        //     Container(
        //         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        //         child: _nftAndTicket(context)
        //     ),
        //   ],
        // ),
      ],
    );
  }

  Widget _userWallet(BuildContext context) {

    ApiProvider api = Provider.of<ApiProvider>(context, listen: false);

    return Column(
      children: [

        Consumer<VerifySeedsProvider>(
          builder: (context, verifyingP, wg) {
            verifyingP.unverifyAcc = null;

            // if (verifyingP.unverifyAcc != null){
              List tmp = verifyingP.getPrivateList.where((e) {
                if (e['address'] == api.getKeyring.current.address) return true;
                return false;
              }).toList();

              if (tmp.isNotEmpty){
                verifyingP.unverifyAcc = tmp[0];
              }
            // }

            if (verifyingP.unverifyAcc == null) return Container();

            return verifyingP.unverifyAcc!["status"] == false ? Container(
              height: 50,
              decoration: BoxDecoration(
                color: hexaCodeToColor(AppColors.warningColor).withOpacity(0.25),
                borderRadius: const BorderRadius.all(Radius.circular(16))
              ),
              child: Row(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 10,),
                      Icon(Iconsax.warning_2, color: hexaCodeToColor(AppColors.redColor),),
                      const MyText(
                        pLeft: 10,
                        text: "Verify your Seed Phrase",
                        fontWeight: FontWeight.w600,
                        hexaColor: AppColors.redColor,
                      ),
                    ],
                  ),

                  const Spacer(),

                  TextButton(
                    onPressed: () async{

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Pincode(label: PinCodeLabel.fromAccount,)
                        )
                      ).then((passCodeValue) async {
                        if (passCodeValue != null){
                          
                          await api.getKeyring.store.getDecryptedSeed(api.getKeyring.current.pubKey, passCodeValue).then((getMnemonic) async{
                            try {

                              if(getMnemonic!.containsKey("seed")){


                                // Verifying Account To Get Mnemonic
                                verifyingP.mnemonic = getMnemonic["seed"];
                                verifyingP.isVerifying = true;

                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateSeeds(passCode: passCodeValue, newAcc: null,)
                                    // const ImportAcc(
                                    //   isBackBtn: true,
                                    // )
                                  )
                                ).then((value) {
                                  if (value != null && value == true){
                                    
                                    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                                    Provider.of<ApiProvider>(context, listen: false).notifyListeners();
                                  }
                                });
                              }
                              else{
                                throw Exception("wrong mnemonic");
                                
                              }
                              
                            } catch (e) {
                              if (kDebugMode) {
                                print("error mnemonic $e");
                              }
                            }

                          });

                        }
                      });
                      
                    }, 
                    child: const MyText(
                      text: "Verify Now",
                      fontWeight: FontWeight.w700,
                      hexaColor: AppColors.primaryColor,
                    ),
                  )
                ],
              )
            ) : const SizedBox();
          }
        ),

        const SizedBox(height: 5,),

        Consumer<ApiProvider>(
          builder: (context, apiProvider, widget){

            return Container(
              decoration: BoxDecoration(
                color: hexaCodeToColor(AppColors.whiteColorHexa),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                image: const DecorationImage(
                  image: AssetImage('assets/bg-glass.jpg'),
                  fit: BoxFit.cover
                ),
              ),
              width: MediaQuery.of(context).size.width,
              
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Column(
                    children: [
                      
                      SizedBox(height: 2.5.h),
                      
                      Consumer<ContractProvider>(
                        builder: (context, provider, widget){
                          return MyText(
                            text: "\$${ (provider.mainBalance).toStringAsFixed(2) }",
                            hexaColor: AppColors.whiteColorHexa,
                            fontWeight: FontWeight.w700,
                            fontSize: 23,
                          );
                        }
                      ),
                      
                      // SizedBox(height: 0.5.h),
                      Consumer<ContractProvider>(
                        builder: (context, provider, widget){
                          return MyText(
                            text: "${AppUtils.toBTC(provider.mainBalance, double.parse(provider.listContract[apiProvider.btcIndex].marketPrice!)).toStringAsFixed(5)} BTC", // provider.listContract.isEmpty ? '' : """≈ ${ (provider.mainBalance / double.parse(provider.listContract[apiProvider.btcIndex].marketPrice ?? '0')).toStringAsFixed(5) } BTC""",
                            hexaColor: AppColors.whiteColorHexa,
                            fontSize: 18,
                          );
                        }
                      ),
                          
                      SizedBox(height: 2.5.h),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, bottom: 2.5.h),
                        child: _operationRequest(context),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } 
        ),
      ],
    );
  }

  Widget _selendraNetworkList(BuildContext context, List<SmartContractModel> lsAsset, ContractProvider pro, Function dismiss){
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: lsAsset.length,
      shrinkWrap: true,
      itemBuilder: (context, index){
        return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  Transition(
                    child: AssetInfo(
                      index: index,
                      scModel: lsAsset[index]
                    ),
                    transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                  ),
                );
              },
              child: AssetsItemComponent(
                scModel: lsAsset[index]
              )
            )
        // lsAsset[index].isAdded == true
        //   ? 
          // Dismissible(
          //   key: Key(index.toString()),
          //   onDismissed: (DismissDirection dismissDirection) async {

          //     await dismiss(lsAsset, index);
          //   },

          //   background: Container(
          //     color: Colors.red,
          //     child: Padding(
          //       padding: const EdgeInsets.all(15),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.end,
          //         children: const [
          //           Icon(Iconsax.trash, color: Colors.white),

          //           SizedBox(width: 5),

          //           Text('Remove', style: TextStyle(color: Colors.white)),
          //         ],
            
          //       ),
            
          //     ),
            
          //   ),
          //   direction: DismissDirection.endToStart,
          //   child: GestureDetector(
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         Transition(
          //           child: AssetInfo(
          //             index: index,
          //             scModel: lsAsset[index]
          //           ),
          //           transitionEffect: TransitionEffect.RIGHT_TO_LEFT
          //         ),
          //       );
          //     },
          //     child: AssetsItemComponent(
          //       scModel: lsAsset[index]
          //     )
          //   ),
          // ) 
          // : GestureDetector(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       Transition(
          //         child: AssetInfo(
          //           index: index,
          //           scModel: lsAsset[index]
          //         ),
          //         transitionEffect: TransitionEffect.RIGHT_TO_LEFT
          //       ),
          //     );
          //   },
          //   child: AssetsItemComponent(
          //     scModel: lsAsset[index]
          //   )
          // )
          ;
      }
    );
  }

  Widget _operationRequest(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: hexaCodeToColor("#FEFEFE").withOpacity(0.9),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: hexaCodeToColor(AppColors.primaryColor))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            Expanded( 
              flex: 3,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context, 
                    Transition(child: const SubmitTrx("", true, []), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
              
                  children: [
                    
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hexaCodeToColor(AppColors.primaryColor).withOpacity(0.05)
                      ),
                      child: Transform.rotate(
                        angle: 141.371669412,
                        child: Icon(Iconsax.import, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.secondary), size: 20.sp,),
                      ),
                    ),
            
                    const MyText(
                      text: "Send",
                      hexaColor: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),

            VerticalDivider(
              color: hexaCodeToColor("#D9D9D9"),
              thickness: 1,
            ),

            Expanded(
              flex: 3,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    Transition(child: const ReceiveWallet(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
              
                  children: [
                    
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hexaCodeToColor(AppColors.primaryColor).withOpacity(0.05)
                      ),
                      child: Icon(Iconsax.import, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.secondary), size: 20.sp)
                    ),
            
                    MyText(
                      text: "Receive",
                      hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),

            VerticalDivider(
              color: hexaCodeToColor("#D9D9D9"),
              thickness: 1,
            ),
            
            Expanded(
              flex: 3,
              child: InkWell(
                onTap: () {
                  underContstuctionAnimationDailog(context: context);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
              
                  children: [
                    
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hexaCodeToColor(AppColors.primaryColor).withOpacity(0.05)
                      ),
                      child: Icon(Iconsax.card, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.secondary), size: 20.sp)
                    ),
            
                    MyText(
                      text: "Buy",
                      hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),

            VerticalDivider(
              color: hexaCodeToColor("#D9D9D9"),
              thickness: 1,
            ),
            
            Expanded(
              flex: 3,
              child: InkWell(
                onTap: () async {
                  Navigator.push(
                    context,
                    Transition(child: const SwapPage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                  );
                  // await showBarModalBottomSheet(
                  //   context: context,
                  //   backgroundColor: hexaCodeToColor(AppColors.lightColorBg),
                  //   shape: const RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.vertical( 
                  //       top: Radius.circular(25.0),
                  //     ),
                  //   ),
                  //   builder: (context) => Column(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: const [
                  //       SwapMethod(),
                  //     ],  
                  //   ),
                  // );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
              
                  children: [
                    
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hexaCodeToColor(AppColors.primaryColor).withOpacity(0.05)
                      ),
                      child: Icon(Iconsax.arrow_swap, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.secondary), size: 20.sp)
                    ),
            
                    const MyText(
                      text: "Swap",
                      hexaColor: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _addMoreAsset(BuildContext context){
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            MyText(
              text: "Don't see your token?",
              color2: Colors.grey.shade400,
            ),
        
            TextButton(
              onPressed: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const AddAsset())
                );
              },
              child: const MyText(
                text: "Import asset",
                hexaColor: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                // left: 5.sp
              )
            )
          ],
        ),
      ),
    );
  }

  Widget _nftAndTicket(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                Transition(
                    child: const DetailsTicketingBody(),
                    transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                )
            );
          },
          child: CouponCard(
            height: 200,
            backgroundColor: Colors.white,
            curveAxis: Axis.vertical,
            firstChild: Image.network("https://dangkorsenchey.com/images/isi-dsc-logo.png"),
            secondChild: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  MyText(
                    text: 'ISI DSC',
                    textAlign: TextAlign.start,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  Spacer(),
                  MyText(
                    text: 'Valid Till - 15 FEB 2023',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }


}