import 'package:shimmer/shimmer.dart';
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
            
            _userWallet(context),
      
            SizedBox(height: 25),
      
            _selendraNetworkList(context),

          ],
        ),
      ),
    );
  }


  Widget _userWallet(BuildContext context) {

    return Consumer<ApiProvider>(
      builder: (context, provider, widget){

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

              if(provider.accountM.addressIcon == null)
              Shimmer.fromColors(
                child: Container(
                  width: 60,
                  height: 60,
                  margin: EdgeInsets.only(bottom: 3),
                  decoration: BoxDecoration(
                    color: hexaCodeToColor(AppColors.sliderColor),
                    shape: BoxShape.circle,
                    // boxShadow: [
                    //   BoxShadow(color: Colors.white, blurRadius: 20.0),
                    // ],
                  ),
                ), 
                period: const Duration(seconds: 2),
                baseColor: hexaCodeToColor(AppColors.sliderColor),
                highlightColor: hexaCodeToColor(AppColors.whiteColorHexa),
              ) 
              else Container(
                width: 60,
                height: 60,
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  color: hexaCodeToColor(AppColors.sliderColor),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.white, blurRadius: 20.0),
                  ],
                ),
                child: SvgPicture.string(provider.accountM.addressIcon!),
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
            ],
          ),
        );
      } 
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
    double width = 150;
    double height = 55;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
        Container(
          height: height,
          width: width,
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [hexaCodeToColor("#0D6BA6"), hexaCodeToColor("#2EF9C8")],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

        SizedBox(width: 10,),

        Container(
          height: height,
          width: width,
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [hexaCodeToColor("#0D6BA6"), hexaCodeToColor("#2EF9C8")],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        )
      ],
    );
  }
}