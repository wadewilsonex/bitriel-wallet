import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/card_section_setting.m.dart';
import '../../../../models/graphql.m.dart';

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
      backgroundColor: hexaCodeToColor("#112641"),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Iconsax.arrow_left_2),
        ),
        
      ),
      body: AddressQuery(context),
    );
  }

  Widget AddressQuery(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(explorerQueries!.fetchAddressInfo("$controller")),
      ),
      builder: (QueryResult result, {fetchMore, refetch}) {
        if(result.hasException){
          return Text(result.exception.toString());
        }

        if(result.isLoading){
          return CircularProgressIndicator();
        }

        final int TotalBalance = result.data?["account_by_pk"]["free_balance"] + result.data?["account_by_pk"]["locked_balance"] + result.data?["account_by_pk"]["reserved_balance"];

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(paddingSize),
              child: addressDetailSection(
                context,
                controller,
                Fmt.balance(TotalBalance.toString(), 12),
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
        action: () {
        }
      ),
      CardSection(
        title: "Balance",
        trailingTitle: "${totalBalance} SEL",
        action: () {

        }
      ),
      CardSection(
        title: "Available",
        trailingTitle: "${availableBalance} SEL",
        action: () {

        }
      ),
      CardSection(
        title: "Locked",
        trailingTitle: "${lockedBalance} SEL",
        action: () {

        }
      ),
      CardSection(
          title: "Reserved",
          trailingTitle: "${reservedBalance} SEL",
          action: () {

          }
      ),
    ];
  }

  Widget textRow(BuildContext context, String leadingText, String trailingText) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(
            text: leadingText,
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColorHexa
          ),
          
          SizedBox(width: 20.w,),
          // Expanded(child: Container()),
          Flexible(
            child: MyText(
              text: trailingText,
              textAlign: TextAlign.start,
              color: "#C1C1C1"
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: hexaCodeToColor("#0a1d35"),
        borderRadius: BorderRadius.circular(20)
      ),
      child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: addressDetailList(context, controller, totalBalance, availableBalance, lockedBalance, reservedBalance).length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (){
                addressDetailList(context, controller, totalBalance, availableBalance, lockedBalance, reservedBalance)[index].action!();
              },
              child: Column(
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
              ),
            );
          }
      ),
    );
  }

}