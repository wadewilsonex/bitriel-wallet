import 'dart:ui';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/asset_item_c.dart';
import 'package:wallet_apps/src/screen/home/nft/details_ticket/body_details_ticket.dart';
import 'package:wallet_apps/src/screen/home/swap/swap_method/swap_method.dart';
class WalletPageBody extends StatelessWidget {
  
  final HomePageModel? homePageModel;
  final AssetPageModel? model;
  // final Function? onTapCategories;
  // final Function? onHorizontalChanged;
  // final Function? onVerticalUpdate;

  const WalletPageBody({
    Key? key,
    this.homePageModel,
    this.model,
    // this.onTapCategories,
    // this.onHorizontalChanged,
    // this.onVerticalUpdate
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
      body: BodyScaffold(
        scrollController: model!.scrollController,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // physic: const BouncingScrollPhysics(),
        isSafeArea: false,
        bottom: 0,
        child: Container(
          // padding: const EdgeInsets.all(20),
          color: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: _userWallet(context),
              ),
        

              const SizedBox(height: 10,),

              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TabBar(
                          labelColor: hexaCodeToColor(AppColors.primaryColor),
                          unselectedLabelColor: hexaCodeToColor(AppColors.greyColor),
                          indicatorColor: hexaCodeToColor(AppColors.primaryColor),
                          labelStyle: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w700, fontFamily: 'NotoSans'),
                          unselectedLabelStyle: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600, fontFamily: 'NotoSans'),
                          tabs: const [
                            Tab(
                              text: "Assets",
                            ),
                                        
                            Tab(
                              text: "NFTs",
                            )
                          ],
                        ),
                      ),
                
                      Expanded(
                        child: TabBarView(
                          // physics: const BouncingScrollPhysics(),
                          children: [
                            
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  _selendraNetworkList(context, Provider.of<ContractProvider>(context).sortListContract),
                                ],
                              )
                            ),
                                    
                            // const Center(
                            //   child: MyText(
                            //     text: "Your NFTs will be shown here",
                            //     hexaColor: AppColors.greyCode,
                            //     fontSize: 17,
                            //   ),
                            // ),
                            ListView(
                              children: [
                                for (int i = 0; i < 10; i++)
                                Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    child: nftAndTicket(context)
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // _otherNetworkList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userWallet(BuildContext context) {

    return Consumer<ApiProvider>(
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
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: Column(
                children: [
                  
                  SizedBox(height: 2.5.h),
                  
                  Consumer<ContractProvider>(
                    builder: (context, provider, widget){
                      return MyText(
                        text: "\$ ${ (provider.mainBalance).toStringAsFixed(2) }",
                        hexaColor: AppColors.whiteColorHexa,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                      );
                    }
                  ),
                  
                  // SizedBox(height: 0.5.h),
                  Consumer<ContractProvider>(
                    builder: (context, provider, widget){
                      return MyText(
                        text: provider.listContract.isEmpty ? '' : """≈ ${ (provider.mainBalance / double.parse(provider.listContract[apiProvider.btcIndex].marketPrice ?? '0')).toStringAsFixed(5) } BTC""",
                        hexaColor: AppColors.whiteColorHexa,
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
    );
  }

  Widget _selendraNetworkList(BuildContext context, List<SmartContractModel> lsAsset){
    return Column(
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
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
            );
          }
        ),

        // addMoreAsset(context)
      ],
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
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hexaCodeToColor(AppColors.primaryColor).withOpacity(0.05)
                      ),
                      child: Transform.rotate(
                        angle: 141.371669412,
                        child: Icon(Iconsax.import, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.secondary)),
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
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hexaCodeToColor(AppColors.primaryColor).withOpacity(0.05)
                      ),
                      child: Icon(Iconsax.import, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.secondary))
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
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hexaCodeToColor(AppColors.primaryColor).withOpacity(0.05)
                      ),
                      child: Icon(Iconsax.card, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.secondary))
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
                  await showBarModalBottomSheet(
                      context: context,
                      backgroundColor: hexaCodeToColor(AppColors.lightColorBg),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical( 
                          top: Radius.circular(25.0),
                        ),
                      ),
                      builder: (context) => Column(
                        children: const [
                          SwapMethod(),
                        ],  
                      ),
                    );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
              
                  children: [
                    
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hexaCodeToColor(AppColors.primaryColor).withOpacity(0.05)
                      ),
                      child: Icon(Iconsax.arrow_swap, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.secondary))
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

  Widget addMoreAsset(BuildContext context,){
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
              bottom: 10.sp,
            ),
        
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => AddAsset(network: model?.assetTabController!.index == 2 ? 0 : 1,))
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

  Widget nftAndTicket(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                Transition(
                    child: DetailsTicketingBody(),
                    transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                )
            );
          },
          child: CouponCard(
            height: 150,
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
                    fontSize: 22,
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