import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/presentation/screen/wallet/wallet_info_screen.dart';

class WalletScreen extends StatelessWidget {

  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {

    TextEditingController searchController = TextEditingController();

    final walletPro = Provider.of<WalletProvider>(context, listen: false);
    // print(walletPro.marketUCImpl.lstMarket.value);

    if (context.mounted){

      walletPro.setBuildContext = context;
      
      if (walletPro.defaultListContract!.isEmpty) {
        walletPro.getAsset();
      }
    }

    return Scaffold(
      appBar: defaultAppBar(context: context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            _cardPortfolio(context),

            Padding(
              padding: const EdgeInsets.only(bottom: 15, right: 15, left: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
            
                  Expanded(child: _searchBar(searchController)),

                  IconButton(
                    onPressed: () async {
                      await pushNewScreen(context, screen: const AddAsset(), withNavBar: false);
                    }, 
                    icon: const Icon(Iconsax.add_circle)
                  ),
            
                  
                ],
              ),
            ),

            _getGroupSeparator("Native"),
            Consumer<WalletProvider>(
              builder: (context, pro, wg) {
                if (pro.defaultListContract!.isEmpty) return const CircularProgressIndicator();
                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: pro.listNative!.map((e) {

                    return _getItem(ctx: context, coinMarketCap: walletPro.marketUCImpl, element: e, assetsModel: pro.listNative!);

                  }).toList(),
                );
              }
            ),

            _getGroupSeparator("EVM"),
            Consumer<WalletProvider>(
              builder: (context, pro, wg) {
                if (pro.defaultListContract!.isEmpty) return const CircularProgressIndicator();
                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: pro.listEvmNative!.map((e) {
                    
                    return _getItem(ctx: context, coinMarketCap: walletPro.marketUCImpl, element: e, assetsModel: pro.listEvmNative!);
                    // return Text(pro.listEvmNative![pro.listEvmNative!.indexOf(e)].symbol!);

                  }).toList(),
                );
              }
            ),

            _getGroupSeparator("BEP20"),
            Consumer<WalletProvider>(
              builder: (context, pro, wg) {
                if (pro.defaultListContract!.isEmpty) return const CircularProgressIndicator();
                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: pro.listBep20!.map((e) {
                    
                    return _getItem(ctx: context, coinMarketCap: walletPro.marketUCImpl, element: e, assetsModel: pro.listBep20!);
                    // return Text(pro.listEvmNative![pro.listEvmNative!.indexOf(e)].symbol!);

                  }).toList(),
                );
              }
            ),

            _getGroupSeparator("ERC20"),
            Consumer<WalletProvider>(
              builder: (context, pro, wg) {
                if (pro.defaultListContract!.isEmpty) return const CircularProgressIndicator();
                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: pro.listErc20!.map((e) {
                    
                    return _getItem(ctx: context, coinMarketCap: walletPro.marketUCImpl, element: e, assetsModel: pro.listErc20!);
                    // return Text(pro.listEvmNative![pro.listEvmNative!.indexOf(e)].symbol!);

                  }).toList(),
                );
              }
            )

          ],
        ),
      ),
    );
     
  }

  Widget _cardPortfolio(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: hexaCodeToColor(AppColors.cardColor),
        borderRadius: const BorderRadius.all(Radius.circular(20))
      ),
      child: Column(
        children: [

          MyTextConstant(
            text: "Avialable balance",
            color2: hexaCodeToColor(AppColors.darkGrey),
            fontSize: 15,
          ),

          MyTextConstant(
            text: "\$125.42",
            color2: hexaCodeToColor(AppColors.midNightBlue),
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),

          const SizedBox(height: 15),

          Row(
            children: [

            Expanded(
              child: MyIconButton(
                edgeMargin: const EdgeInsets.all(10),
                fontWeight: FontWeight.w600,
                buttonColor: AppColors.green,
                action: () async {
                  await pushNewScreen(context, screen: const TokenPayment(), withNavBar: false);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const TokenPayment())
                  // );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyTextConstant(
                      text: "Send",
                      color2: hexaCodeToColor(AppColors.white),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      overflow: TextOverflow.ellipsis,
                    ),

                      const SizedBox(width: 5,),

                      const Icon(Iconsax.send_sqaure_2, color: Colors.white, size: 20,)
                    ],
                  ),
                ),
              ),
        
            Expanded(
              child: MyIconButton(
                edgeMargin: const EdgeInsets.all(10),
                fontWeight: FontWeight.w600,
                buttonColor: "161414",
                action: () async {
                  
                  await pushNewScreen(context, screen: const ReceiveWallet(), withNavBar: false);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const ReceiveWallet())
                  // );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyTextConstant(
                      text: "Receive",
                      color2: hexaCodeToColor(AppColors.white),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      overflow: TextOverflow.ellipsis,
                    ),

                      const SizedBox(width: 5,),

                      const Icon(Iconsax.receive_square_2, color: Colors.white, size: 20,)
                    ],
                  ),
                ),
              )
            ],
          ),

        ],
      )
    );
  }

  Widget _searchBar(TextEditingController searchController) {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        hintText: 'Search coins, tokens',
        // Add a clear button to the search bar
        suffixIcon: IconButton(
          icon: const Icon(Iconsax.close_circle),
          onPressed: () => searchController.clear(),
        ),
        // Add a search icon or button to the search bar
        prefixIcon: IconButton(
          icon: const Icon(Iconsax.search_normal_1),
          onPressed: () {
            // Perform the search here
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }

  Widget _getGroupSeparator(String label) {
    return SizedBox(
      height: 50,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: hexaCodeToColor("#F4F4F4"),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: MyTextConstant(
              text: label,
              color2: hexaCodeToColor("#979797"),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.start,
            ),
          ),
        ),
      ),
    );
  }

  Widget _getItem({required BuildContext ctx, required MarketUCImpl coinMarketCap, required SmartContractModel element, required List<SmartContractModel> assetsModel}) {


    return SizedBox(
      child: ValueListenableBuilder(
        valueListenable: coinMarketCap.lstMarket,
        builder: (context, value, wg) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
            leading: SizedBox(
              height: 25, 
              width: 25, 
              child: Image.asset(
                "assets/logo/bitriel-logo.png",
                fit: BoxFit.contain,
                height: 50,
                width: 50,
              ),
            ),
            title: MyTextConstant(
              text: assetsModel[assetsModel.indexOf(element)].name!,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.start,
            ),
            subtitle: MyTextConstant(
              text: assetsModel[assetsModel.indexOf(element)].symbol!,
              color2: hexaCodeToColor(AppColors.grey),
              fontSize: 12,
              textAlign: TextAlign.start,
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyTextConstant(
                  text: assetsModel[assetsModel.indexOf(element)].balance!,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.start,
                ),

                MyTextConstant(
                  text: "\$0.00",
                  color2: hexaCodeToColor(AppColors.grey),
                  fontSize: 12,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                ctx,
                MaterialPageRoute(builder: (context) => WalletInfo(scModel: element, lstScModel: assetsModel, market: value,))
              );
            },
          );
        }
      ),
    );
  }

}
