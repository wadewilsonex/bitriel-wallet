import 'package:wallet_apps/data/models/asset_info.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/presentation/screen/home/transaction/trx_explorer_webview.dart';

class BodyTransactionDetail extends StatelessWidget {
  final AssetInfoModel? assetInfoModel;

  BodyTransactionDetail({
    Key? key,
    this.assetInfoModel,
  }) : super(key: key);

  final double logoSize = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        bottomOpacity: 0,
        leadingWidth: 7,
        centerTitle: true,
        title: const MyText(
          text: "SEL Transfer",
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: Consumer<AppProvider>(
        builder: (context, pro, wg) {
          return Column(
            children: [
              // rowInfo("Time","09-12-2022 02:30"),
              headerWidget(context),

              amountTrx(context),

              trxInfo(context),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  thickness: 1,
                  color: hexaCodeToColor(AppColors.greyColor),
                ),
              ),

              viewTrx(context),

              Expanded(child: Container()),
              Image.file(File("${pro.dirPath}/logo/bitriel-white.png")),
              Expanded(child: Container()),
            ],
          );
        }
      ),
    );
  }

  Widget headerWidget(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: hexaCodeToColor(AppColors.bluebgColor),
            child: const Icon(Iconsax.export_3),
          ),

          const MyText(
            left: 10,
            text: "Sent",
            hexaColor: AppColors.whiteColorHexa,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),

          Expanded(child: Container()),
          Expanded(
            child: MyFlatButton(
              height: 60,
              textButton: "Repeat",
              buttonColor: AppColors.bluebgColor,
              action: () {

              },
            ),
          ),
        ],
      ),
    );
  }

  Widget amountTrx(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: 10,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: hexaCodeToColor(AppColors.bluebgColor)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const MyText(
              text: "Amount",
              hexaColor: AppColors.greyColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),

            Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: assetInfoModel!.smartContractModel!.logo!.contains('http')
                        ? Image.network(
                      assetInfoModel!.smartContractModel!.logo!,
                      fit: BoxFit.contain,
                      width: logoSize,
                      height: logoSize,
                    )
                        : Image.asset(
                      assetInfoModel!.smartContractModel!.logo!,
                      fit: BoxFit.contain,
                      width: logoSize,
                      height: logoSize,
                    )
                ),

                MyText(
                  left: 2.5,
                  text: "-1 SEL",
                  hexaColor: AppColors.whiteColorHexa,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget trxInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          rowInfo("From","seZt2QtqVN515CqU2YrsviLLJq9grYxY89ZNAbVqVkCkffnkf"),

          rowInfo("To","seZt2QtqVN515CqU2YrsviLLJq9grYxY89ZNAbVqVkCkffnkf"),

          rowInfo("Gas Fee","0.000008 SEL"),

          rowInfo("Txid","0xd1d77197f30161ea761f1782d5870c5fdccc37246a963627e47849d982a1b347"),

          rowInfo("Time","09-12-2022 02:30"),

        ],
      ),
    );
  }

  Widget rowInfo(String leadingText, String trailingText){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: paddingSize - 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MyText(
            width: 100,
            text: leadingText,
            hexaColor: AppColors.greyColor,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.start,
          ),

          Expanded(
            child: MyText(
              textAlign: TextAlign.start,
              text: trailingText,
              hexaColor: AppColors.whiteColorHexa,
            ),
          ),

        ],
      ),
    );
  }

  Widget viewTrx(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          QrImage(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            data: "1234567890",
            version: QrVersions.auto,
            size: 100.0,
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  Transition(child: const TrxExplorerWebView(url: "https://explorer.selendra.org/"), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const MyText(
                  right: 5,
                  text: "View in browser",
                  hexaColor: AppColors.greyColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
                Icon(Iconsax.global, color: hexaCodeToColor(AppColors.greyColor))
              ],
            ),
          ),
        ],
      ),
    );
  }

}