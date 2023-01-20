import 'dart:ui';

import 'package:lottie/lottie.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/asset_item_c.dart';
import 'package:wallet_apps/src/components/category_card_c.dart';
import 'package:wallet_apps/src/screen/home/swap/swap_method/swap_method.dart';
class AssetsPageBody extends StatelessWidget {
  
  final HomePageModel? homePageModel;
  final AssetPageModel? model;
  final Function? onTapCategories;
  final Function? onHorizontalChanged;
  final Function? onVerticalUpdate;

  const AssetsPageBody({ 
    Key? key,
    this.homePageModel,
    this.onTapCategories,
    this.model,
    this.onHorizontalChanged,
    this.onVerticalUpdate
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
      body: BodyScaffold(
        scrollController: model!.scrollController,
        width: MediaQuery.of(context).size.width,
        // physic: NeverScrollableScrollPhysics(),
        isSafeArea: false,
        bottom: 0,
        child: Container(
          padding: const EdgeInsets.all(20),
          color: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              _userWallet(context),
          
              SizedBox(
                height: 30.sp,
                child: categoryToken()
              ),
          
              Row(
                children: [
                  MyText(
                    text: "Assets",
                    hexaColor: isDarkMode ? AppColors.titleAssetColor : AppColors.greyColor,
                    fontWeight: FontWeight.w500
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: hexaCodeToColor(isDarkMode ? AppColors.titleAssetColor : AppColors.greyColor,),
                    ),
                  ),
                ],
              ),
          
              Column(
                children: [
                  GestureDetector(
                    onHorizontalDragEnd: (details) {
                      onHorizontalChanged!(details);
                    },
                    onVerticalDragUpdate: (detail){
                      
                      onVerticalUpdate!(detail);
                    },

                    child: SizedBox(
                      // Provide Screen Height Per Assets Length (model!.assetLength)
                      // width: MediaQuery.of(context).size.width,
                      height: 8.h * model!.assetLength,
                      child: TabBarView(
                        controller: model!.tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                      
                          _selendraNetworkList(context, Provider.of<ContractProvider>(context).sortListContract),
                          _selendraNetworkList(context, model!.nativeAssets! ),
                          _selendraNetworkList(context, model!.bep20Assets!, networkIndex: 2),
                          _selendraNetworkList(context, model!.erc20Assets!, networkIndex: 3)
                          
                        ]
                      ),
                    )
                  ),

                  if ( (model!.tabController!.index == 2 && model!.bep20Assets!.isEmpty) || (model!.tabController!.index == 3 && model!.erc20Assets!.isEmpty )) 
                  GestureDetector(
                    onHorizontalDragEnd: (details) {
                      onHorizontalChanged!(details);
                    },
                    onVerticalDragUpdate: (details) {

                      // Prevent Scroll When Empty Asset
                      if(model!.assetLength > 5) onVerticalUpdate!(details);
                    },
                    child: SizedBox(
                      height: 60.sp,
                      child: OverflowBox(
                        minHeight: 60.h,
                        maxHeight: 60.h,
                        child: Lottie.asset("${AppConfig.animationPath}no-data.json", width: 60.w, height: 60.w),
                      )
                    ),
                  ),

                  // Add Asset For BEP-20
                  if (model!.tabController!.index == 2) 
                  addMoreAsset(context, const EdgeInsets.only(bottom: 20.0, top: 20.0 ))

                  // Add Asset For ERC-20
                  else if (model!.tabController!.index == 3) 
                  addMoreAsset(context, model!.erc20Assets!.isEmpty ? EdgeInsets.zero : const EdgeInsets.only(bottom: 20.0, top: 20.0 )),
                  
                  // For Gesture
                  if ( (model!.tabController!.index == 2 || model!.tabController!.index == 3 || model!.tabController!.index == 1) && model!.assetLength < 5)
                  GestureDetector(
                    onHorizontalDragEnd: (details) {
                      onHorizontalChanged!(details);
                    },
                    onVerticalDragUpdate: (details) {

                      // Prevent Scroll When Empty Asset
                      if(model!.assetLength > 5) onVerticalUpdate!(details);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 8.h * 5,
                      color: Colors.transparent,
                    ),
                  )
                ],
              )
              
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

  Widget _selendraNetworkList(BuildContext context, List<SmartContractModel> lsAsset, {int? networkIndex}){
    return ListView.builder(
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
                  // Navigator.push(
                  //   context,
                  //   Transition(child: const ReceiveWallet(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                  // );
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
                onTap: () {
                  Navigator.push(
                    context,
                    Transition(child: const SwapMethod(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
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

  Widget categoryToken(){

    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: model!.categories!.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: [
            
            CategoryCard(
              index: index,
              title: model!.categories![index],
              selectedIndex: model!.categoryIndex!,
              onTap: onTapCategories!,
            ),

          ],
        );
      }
    );
  }

  Widget addMoreAsset(BuildContext context, EdgeInsetsGeometry padding){
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        onHorizontalChanged!(details);
      },
      onVerticalDragUpdate: (details) {
        onVerticalUpdate!(details);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        padding: padding,
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
                  MaterialPageRoute(builder: (context) => AddAsset(network: model!.tabController!.index == 2 ? 0 : 1,))
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
}