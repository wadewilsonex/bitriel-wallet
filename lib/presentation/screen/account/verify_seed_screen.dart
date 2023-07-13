import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/presentation/widget/appbar_widget.dart';

class VerifySeedScreen extends StatelessWidget {
  
  final String? seed;
  final String? pin;
  final CreateWalletImpl? createWalletImpl;
  
  const VerifySeedScreen({super.key, this.seed, this.pin, required this.createWalletImpl});

  @override
  Widget build(BuildContext context) {

    if (createWalletImpl!.tmpThreeSeedIndex.value.isEmpty && createWalletImpl!.isMatch.value == false) createWalletImpl!.remove3Seeds();

    return Scaffold(
      backgroundColor: hexaCodeToColor(AppColors.background),
      appBar: appBar(context, title: "Verify Mnemonic"),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.only(left: paddingSize, right: paddingSize, bottom: paddingSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                _textHeader(),
  
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDarkMode ? hexaCodeToColor(AppColors.whiteColorHexa).withOpacity(0.06) : hexaCodeToColor("#E8E8E8"),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Column(
                    children: [

                      ValueListenableBuilder(
                        valueListenable: createWalletImpl!.verifySeeds,
                        builder: (context, value, wg) {
                          // print("createWalletImpl!.verifySeeds ${createWalletImpl!.verifySeeds}");
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: SeedsCompoent.getColumn(context, value.join(" "), 0, moreSize: 10),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: SeedsCompoent.getColumn(context, value.join(" "), 1, moreSize: 10),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: SeedsCompoent.getColumn(context, value.join(" "), 2, moreSize: 10),
                              ),
                            ],
                          );
                        }
                      ),
                    ],
                  )
                ),
  
                ValueListenableBuilder(
                  valueListenable: createWalletImpl!.tmpThreeSeedIndex, 
                  builder: (context, value, wg){
                    print("createWalletImpl!.tmpThreeSeedIndex ${createWalletImpl!.tmpThreeSeedIndex}");
                    // if (createWalletImpl!.tmpThreeSeedIndex.value.isNotEmpty) 
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: value.length,
                          itemBuilder: (context, i){
                            
                            return SeedsCompoent.seedContainer(
                              context, 
                              createWalletImpl!.seed.value.split(" ")[value[i]], 
                              value[i],
                              i, 
                              createWalletImpl!.onTapThreeSeeds
                            );
                          }
                        ),
                      ),
                    );
                  }
                ),
  
                const SizedBox(height: 3),
                
                // Display Refresh Button When User Fill Out All
                ValueListenableBuilder(
                  valueListenable: createWalletImpl!.isReset, 
                  builder: (context, value, wg){
                    if (value == false) return const SizedBox();
                    return Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Iconsax.refresh, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,), size: 30),
                              const SizedBox(width: 9),
                              const MyTextConstant(
                                text: "Try Again",
                                fontSize: 17,
                                fontWeight: FontWeight.bold,  
                              ),
                            ],
                          ),
                        ),
                        onTap: () => createWalletImpl!.remove3Seeds(isReset: true)
                      ),
                    );
                  }
                ),
  
                Flexible(child: Container()),
                
                // Consumer<VerifySeedsProvider>(
                //   builder: (context, pro, wg){
                //     return pro.isVerifying == false ? 
                    MyFlatButton(
                      height: 60,
                      isTransparent: true,
                      buttonColor: AppColors.whiteHexaColor,
                      textColor: AppColors.primaryColor,
                      textButton: "Verify Later",
                      action: () async {
                        await seedVerifyLaterDialog(context, createWalletImpl!.verifyLater);
                      },
                    ),
                //     : Container();
                //   }
                // ),

                const SizedBox(height: 10,),

                ValueListenableBuilder(
                  valueListenable: createWalletImpl!.isMatch, 
                  builder: (context, value, wg){
                    return MyGradientButton(
                      textButton: "Next",
                      isTransparent: !  value,
                      action: value == false ? null : () async {
                        // submit!();
                        await createWalletImpl!.addAndImport();
                      },
                    );
                  }
                )
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget _textHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyTextConstant(
          text: 
            "Almost done. Please input the words in the numerical order.",
          textAlign: TextAlign.start,
          fontSize: 19,
          color2: hexaCodeToColor(AppColors.darkGrey)
        )
      ],
    );
  }


}
