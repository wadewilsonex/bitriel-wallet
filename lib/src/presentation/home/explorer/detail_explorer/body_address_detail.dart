import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/card_section_setting.m.dart';
import '../../../../graphql/graphql.dart';

class ExplorerDetailBody extends StatelessWidget {
  final ExplorerQueries? explorerQueries;
  final String? controller;

  const ExplorerDetailBody({
    Key? key,
    this.explorerQueries,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor)
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Iconsax.arrow_left_2),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            controller!.startsWith("0x") == true ? hashQuery(context) : Container(),

            controller!.startsWith("se") == true ? addressQuery(context) : Container(),

            // controller!.startsWith("0x") || controller!.startsWith("se") == false ? notFoundWidget() : Container(),

          ],
        ),
      ),
    );
  }

  Widget hashQuery(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(explorerQueries!.fetchHashInfo("$controller")),
      ),
      builder: (QueryResult result, {fetchMore, refetch}) {
        if(result.hasException){
          return Text(result.exception.toString());
        }

        if(result.isLoading){
          return const CircularProgressIndicator();
        }

        if(result.data?["extrinsic"].isEmpty){
          return notFoundWidget();
        }

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(paddingSize),
              child: hashDetailSection(
                context,
                controller,
                result.data?["extrinsic"][0]["block_id"].toString(),
                AppUtils.timeStampToDateTime(result.data?["extrinsic"][0]["transfers"][0]["timestamp"]),
                result.data?["extrinsic"][0]["transfers"][0]["extrinsic_id"].toString(),
                replaceRange(result.data?["extrinsic"][0]["hash"].toString()),
                replaceRange(result.data?["extrinsic"][0]["transfers"][0]["from_address"].toString()),
                replaceRange(result.data?["extrinsic"][0]["transfers"][0]["to_address"].toString()),
                Fmt.balance(result.data?["extrinsic"][0]["transfers"][0]["amount"].toString(), 12),
                Fmt.balance(result.data?["extrinsic"][0]["transfers"][0]["fee_amount"].toString(), 12),
                result.data?["extrinsic"][0]["transfers"][0]["success"]
              ),
            )
          ],
        );
      },
    );
  }

  Widget notFoundWidget() {
    return Padding(
      padding: EdgeInsets.all(paddingSize),
      child: Column(
        children: [
          Lottie.asset(
            "assets/animation/no-results.json",
            repeat: false,
            height: 30.vmax,
          ),

          MyText(
              text: "Oops! This is an invalid search string. The search string you entered was: \n $controller",
              textAlign: TextAlign.center,
              hexaColor: isDarkMode ? AppColors.greyCode : AppColors.darkGrey,
          ),

        ],
      ),
    );
  }

  Widget addressQuery(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(explorerQueries!.fetchAddressInfo("$controller")),
      ),
      builder: (QueryResult result, {fetchMore, refetch}) {
        if(result.hasException){
          return Text(result.exception.toString());
        }

        if(result.isLoading){
          return const CircularProgressIndicator();
        }

        if(result.data?["account_by_pk"] == null){
          return notFoundWidget();
        }

        final int totalBalance = result.data?["account_by_pk"]["free_balance"] + result.data?["account_by_pk"]["locked_balance"] + result.data?["account_by_pk"]["reserved_balance"];

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(paddingSize),
              child: addressDetailSection(
                context,
                controller,
                Fmt.balance(totalBalance.toString(), 12),
                Fmt.balance(result.data?["account_by_pk"]["free_balance"].toString(), 12),
                Fmt.balance(result.data?["account_by_pk"]["locked_balance"].toString(), 12),
                Fmt.balance(result.data?["account_by_pk"]["reserved_balance"].toString(), 12),
              ),
            )
          ],
        );
      },
    );
  }


  List<CardSection> addressDetailList(
      BuildContext? context,
      String? controller,
      String? totalBalance,
      String? availableBalance,
      String? lockedBalance,
      String? reservedBalance
  ) {
    return [
      CardSection(
        title:"Address",
        trailingTitle: "$controller",
      ),
      CardSection(
        title: "Balance",
        trailingTitle: "$totalBalance SEL",
      ),
      CardSection(
        title: "Available",
        trailingTitle: "$availableBalance SEL",
      ),
      CardSection(
        title: "Locked",
        trailingTitle: "$lockedBalance SEL",
      ),
      CardSection(
        title: "Reserved",
        trailingTitle: "$reservedBalance SEL",
      ),
    ];
  }

  List<CardSection> hashDetailList(
      BuildContext? context,
      String? controller,
      String? block,
      String? time,
      String? extrinsicID,
      String? hash,
      String? from,
      String? to,
      String? amount,
      String? fee,
      bool? isSuccess
    ) {
    return [
      CardSection(
        title: "Block",
        trailingTitle: "$block",
      ),
      CardSection(
        title: "Time",
        trailingTitle: "$time",
      ),
      CardSection(
        title: "Extrinsic ID",
        trailingTitle: "$extrinsicID",
      ),
      CardSection(
        title: "Hash",
        trailingTitle: "$hash",
      ),
      CardSection(
        title: "From",
        trailingTitle: "$from",
      ),
      CardSection(
        title: "To",
        trailingTitle: "$to",
      ),
      CardSection(
        title: "Amount",
        trailingTitle: "$amount SEL",
      ),
      CardSection(
        title: "Fee",
        trailingTitle: "$fee SEL",
      ),
      CardSection(
        title: "Success",
        trailingTitle: isSuccess == true ? "Success" : "Failed",
      ),
    ];
  }

  Widget textRow(BuildContext context, String leadingText, String trailingText) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Expanded(
            child: MyText(
              text: leadingText,
              fontWeight: FontWeight.bold,
              hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,
              textAlign: TextAlign.start,
            ),
          ),

          // SizedBox(width: 20.w,),
          // Expanded(child: Container()),
          Expanded(
            child: MyText(
              text: trailingText,
              textAlign: TextAlign.start,
              hexaColor: isDarkMode ? AppColors.greyCode : AppColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget addressDetailSection(
      BuildContext context,
      String? controller,
      String? totalBalance,
      String? availableBalance,
      String? lockedBalance,
      String? reservedBalance,
    ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: hexaCodeToColor(isDarkMode ? "#0a1d35" : AppColors.whiteColorHexa),
        borderRadius: BorderRadius.circular(20)
      ),
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 10),
          itemCount: addressDetailList(context, controller, totalBalance, availableBalance, lockedBalance, reservedBalance).length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                textRow(
                    context,
                    addressDetailList(context, controller, totalBalance, availableBalance, lockedBalance, reservedBalance)[index].title!,
                    addressDetailList(context, controller, totalBalance, availableBalance, lockedBalance, reservedBalance)[index].trailingTitle!
                ),

                addressDetailList(
                    context,
                    controller,
                    totalBalance,
                    availableBalance,
                    lockedBalance,
                    reservedBalance
                ).length - 1 == index ?
                Container() :
                Divider(
                  thickness: 1,
                  color: hexaCodeToColor(AppColors.greyColor).withOpacity(0.2),
                ),
              ],
            );
          }
      ),
    );
  }

  Widget hashDetailSection(
      BuildContext context,
      String? controller,
      String? block,
      String? time,
      String? extrinsicID,
      String? hash,
      String? from,
      String? to,
      String? amount,
      String? fee,
      bool? isSuccess
      ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: hexaCodeToColor(isDarkMode ? "#0a1d35" : AppColors.whiteColorHexa),
        borderRadius: BorderRadius.circular(20)
      ),
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 10),
          itemCount: hashDetailList(
            context,
            controller,
            block,
            time,
            extrinsicID,
            hash,
            from,
            to,
            amount,
            fee,
            isSuccess,
          ).length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                textRow(
                    context,
                    hashDetailList(
                      context,
                      controller,
                      block,
                      time,
                      extrinsicID,
                      hash,
                      from,
                      to,
                      amount,
                      fee,
                      isSuccess,
                    )[index].title!,

                    hashDetailList(
                      context,
                      controller,
                      block,
                      time,
                      extrinsicID,
                      hash,
                      from,
                      to,
                      amount,
                      fee,
                      isSuccess,
                    )[index].trailingTitle!
                ),

                hashDetailList(
                  context,
                  controller,
                  block,
                  time,
                  extrinsicID,
                  hash,
                  from,
                  to,
                  amount,
                  fee,
                  isSuccess,
                ).length - 1 == index ?
                Container() :
                Divider(
                  thickness: 1,
                  color: hexaCodeToColor(AppColors.greyColor).withOpacity(0.2),
                ),
              ],
            );
          }
      ),
    );
  }

}