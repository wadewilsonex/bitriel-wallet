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
    return Scaffold(
      body: BodyScaffold(
        scrollController: model!.scrollController,
        width: MediaQuery.of(context).size.width,
        // physic: NeverScrollableScrollPhysics(),
        isSafeArea: false,
        bottom: 0,
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            _userWallet(context),
        
            Padding(
              padding: const EdgeInsets.all(paddingSize),
              child: SizedBox(
                height: 30.sp,
                child: categoryToken()
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: paddingSize),
              child: Row(
                children: [
                  MyText(
                    text: "Assets",
                    color: AppColors.titleAssetColor,
                    fontWeight: FontWeight.w500
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: hexaCodeToColor(AppColors.titleAssetColor),
                      indent: 2.w,
                    ),
                  ),
                ],
              ),
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

                  child: Container(
                    // Provide Screen Height Per Assets Length (model!.assetLength)
                    // width: MediaQuery.of(context).size.width,
                    height: 8.h * model!.assetLength,
                    child: TabBarView(
                      controller: model!.tabController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                    
                        _selendraNetworkList(context, Provider.of<ContractProvider>(context).sortListContract),
                        _selendraNetworkList(context, model!.nativeAssets!, ),
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
                      child: Lottie.asset(AppConfig.animationPath+"no-data.json", width: 60.w, height: 60.w),
                    )
                  ),
                ),

                // Add Asset For BEP-20
                if (model!.tabController!.index == 2) 
                addMoreAsset(context, EdgeInsets.only(bottom: 20.0, top: 20.0 ))

                // Add Asset For ERC-20
                else if (model!.tabController!.index == 3) 
                addMoreAsset(context, model!.erc20Assets!.isEmpty ? EdgeInsets.zero : EdgeInsets.only(bottom: 20.0, top: 20.0 )),
                
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
    );
  }


  Widget _userWallet(BuildContext context) {

    return Consumer<ApiProvider>(
      builder: (context, apiProvider, widget){

        return Container(
          decoration: BoxDecoration(
            color: hexaCodeToColor(AppColors.bluebgColor),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              
              // PieChartSample1(),

              // PieChartSample2(),

              // PieChartSample3(),

              // if(apiProvider.accountM.addressIcon == null)
              // Shimmer.fromColors(
              //   child: Container(
              //     width: 60,
              //     height: 60,
              //     margin: EdgeInsets.only(bottom: 3),
              //     decoration: BoxDecoration(
              //       color: hexaCodeToColor(AppColors.sliderColor),
              //       shape: BoxShape.circle,
              //       // boxShadow: [
              //       //   BoxShadow(color: Colors.white, blurRadius: 20.0),
              //       // ],
              //     ),
              //   ), 
              //   period: const Duration(seconds: 2),
              //   baseColor: hexaCodeToColor(AppColors.sliderColor),
              //   highlightColor: hexaCodeToColor(AppColors.whiteColorHexa),
              // ) 
              // else Container(
              //   width: 60,
              //   height: 60,
              //   margin: const EdgeInsets.only(right: 5),
              //   decoration: BoxDecoration(
              //     color: hexaCodeToColor(AppColors.sliderColor),
              //     shape: BoxShape.circle,
              //     boxShadow: [
              //       BoxShadow(color: Colors.white, blurRadius: 10.0),
              //     ],
              //   ),
              //   child: SvgPicture.string(apiProvider.accountM.addressIcon!),
              // ),

              // SizedBox(height: 2.h),
              // if(apiProvider.accountM.addressIcon == null)
              // Shimmer.fromColors(
              //   child: Container(
              //     width: 100,
              //     height: 8.0,
              //     margin: EdgeInsets.only(bottom: 3),
              //     color: Colors.white,
              //   ), 
              //   period: const Duration(seconds: 2),
              //   baseColor: hexaCodeToColor(AppColors.sliderColor),
              //   highlightColor: hexaCodeToColor(AppColors.whiteColorHexa),
              // )
              // else MyText(
              //   bottom: 3,
              //   text: apiProvider.accountM.name ?? '',
              //   color: AppColors.whiteColorHexa,
              //   fontSize: 20.sp,
              // ),

              SizedBox(height: 2.h),
              Consumer<ContractProvider>(
                builder: (context, provider, widget){
                  return MyText(
                    text: "\$ ${ (provider.mainBalance).toStringAsFixed(2) }",
                    color: AppColors.whiteColorHexa,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  );
                }
              ),
              
              SizedBox(height: 2.h),
              Consumer<ContractProvider>(
                builder: (context, provider, widget){
                  return MyText(
                    text: provider.listContract.isEmpty ? '' : """≈ ${ (provider.mainBalance / double.parse(provider.listContract[apiProvider.btcIndex].marketPrice ?? '0')).toStringAsFixed(5) } BTC""",
                    color: AppColors.tokenNameColor,
                    fontWeight: FontWeight.bold,
                  );
                }
              ),

              SizedBox(height: 3.h),
              _operationRequest(context),
            ],
          ),
        );
      } 
    );
  }

  Widget _selendraNetworkList(BuildContext context, List<SmartContractModel> lsAsset, {int? networkIndex}){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: paddingSize),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
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
      )
          
      // )
      
    );
  }

  Widget _operationRequest(BuildContext context) {
    double width = 30.w;
    double height = 7.h;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
        MyGradientButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              MyText(
                text: "Send",
                color: AppColors.whiteColorHexa,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          height: height,
          width: width,
          lsColor: ["#035A8F", "#035A8F"],
          begin: Alignment.bottomRight, 
          end: Alignment.topLeft, 
          action: (){
            Navigator.push(
              context, 
              Transition(child: SubmitTrx("", true, []), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
            );
          }
        ),

        SizedBox(width: 10,),
        
        MyGradientButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              MyText(
                text: "Receive",
                color: AppColors.whiteColorHexa,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          height: height,
          width: width,
          lsColor: ["#035A8F", "#035A8F"],
          begin: Alignment.bottomRight, 
          end: Alignment.topLeft, 
          action: (){
            Navigator.push(
              context, 
              Transition(child: ReceiveWallet(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
            );
          }
        )
      ],
    );
  }

  Widget categoryToken(){

    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: model!.categories!.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: [
            CategoryCard(
              index: index,
              title: model!.categories![index],
              selectedIndex: model!.categoryIndex!,
              onTap: onTapCategories!,
            ),

            SizedBox(width: 2.5.w),
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
              child: MyText(
                text: "Import asset",
                color: AppColors.primaryColor,
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