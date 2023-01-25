import 'package:lottie/lottie.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/asset_item_c.dart';
import 'package:wallet_apps/src/components/category_card_c.dart';
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
    print("25.sp ${25.sp}");
    return Scaffold(
      backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
      body: BodyScaffold(
        scrollController: model!.scrollController,
        width: MediaQuery.of(context).size.width,
        // physic: NeverScrollableScrollPhysics(),
        isSafeArea: false,
        bottom: 0,
        child: Container(
          // padding: EdgeInsets.only(left: paddingSize, right: paddingSize, bottom: paddingSize, top: paddingSize+10),
          color: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Padding(
                padding: EdgeInsets.only(left: paddingSize, right: paddingSize, bottom: paddingSize, top: paddingSize+10),
                child: _userWallet(context),
              ),
          
              Container(
                height: 6.vmax,
                margin: EdgeInsets.only(bottom: 5),
                child: categoryToken()
              ),
          
              Divider(
                thickness: 1,
                color: hexaCodeToColor(isDarkMode ? AppColors.titleAssetColor : AppColors.greyColor,),
              ),
          
              Padding(
                padding: EdgeInsets.only(left: paddingSize, right: paddingSize, bottom: paddingSize),
                child: Column(
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
                ),
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
            color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.whiteColorHexa),
            borderRadius: BorderRadius.all(Radius.circular(20.sp)),
          ),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: 20.sp, right: 20.sp, bottom: 20.sp),
          child: Column(
            children: [
              
              SizedBox(height: 5.vmax),
              
              Consumer<ContractProvider>(
                builder: (context, provider, widget){
                  return MyText(
                    text: "\$ ${ (provider.mainBalance).toStringAsFixed(2) }",
                    // hexaColor: AppColors.whiteColorHexa,
                    fontSize: 3.4,
                    fontWeight: FontWeight.w600,
                  );
                }
              ),
              
              SizedBox(height: 1.vmax),
              Consumer<ContractProvider>(
                builder: (context, provider, widget){
                  return MyText(
                    text: provider.listContract.isEmpty ? '' : """≈ ${ provider.usdToBtc(provider.mainBalance, double.parse(provider.listContract[apiProvider.btcIndex].marketPrice ?? '0') ) } BTC""",
                    // hexaColor: AppColors.tokenNameColor,
                  );
                }
              ),

              SizedBox(height: 5.vmax),
              _operationRequest(context),
            ],
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
                  
                  Transform.rotate(
                    angle: 141.371669412,
                    child: Icon(Iconsax.import, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.secondary,), size: 4.vmax,),
                  ),
          
                  MyText(
                    text: "Send",
                    hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(
            height: 15,
            child: VerticalDivider(
              color: hexaCodeToColor("#D9D9D9"),
              thickness: 1,
            ),
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
                  
                  Icon(Iconsax.import, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.secondary), size: 4.vmax),
          
                  MyText(
                    text: "Receive",
                    hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
        ],
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