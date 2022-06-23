import 'package:shimmer/shimmer.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/asset_item_c.dart';
import 'package:wallet_apps/src/components/menu_item_c.dart';
import 'dart:math';
import 'package:wallet_apps/src/components/pie_chart.dart';
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
            
            _userWallet(context),
      
            SizedBox(height: 25),
      
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: paddingSize),
              child: _selendraNetworkList(context),
            ),

            // SizedBox(height: 25),

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

  Widget _selendraNetworkList(BuildContext context){
    return Container(
      child: Column(
        children: [

          Row(
            children: [
              MyText(
                text: "Assets",
                // text: "Selendra Network",
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

          Consumer<ContractProvider>(
            builder: (context, value, child) {
              return Column(
                children: [
                  for (int index = 0; index < value.sortListContract.length; index++)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          Transition(
                            child: AssetInfo(
                              index: index,
                              scModel: value.sortListContract[index]
                            ),
                            transitionEffect: TransitionEffect.RIGHT_TO_LEFT
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
    );
  }

  Widget _otherNetworkList(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: paddingSize - 10),
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
                text: "Receieve",
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
}