import 'package:bitriel_wallet/index.dart';

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
                    color: hexaCodeToColor(AppColors.cardColor),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Column(
                    children: [

                      ValueListenableBuilder(
                        valueListenable: createWalletImpl!.verifySeeds,
                        builder: (context, value, wg) {
                          
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
                    // if (value == false) return const SizedBox();
                    return Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        child: const Padding(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Iconsax.refresh),
                              SizedBox(width: 9),
                              MyTextConstant(
                                text: "Refresh",
                                fontSize: 17,
                                fontWeight: FontWeight.bold,  
                              ),
                            ],
                          ),
                        ),
                        onTap: () => {
                          createWalletImpl!.remove3Seeds(isReset: true),
                        }
                      ),
                    );
                  }
                ),
  
                Flexible(child: Container()),

                MyButton(
                  textButton: "Verify Later",
                  fontWeight: FontWeight.w600,
                  textColor: AppColors.primaryBtn,
                  borderWidth: 1,
                  isTransparent: true,
                  isTransparentOpacity: 0,
                  action: () async {

                    await seedVerifyLaterDialog(context, createWalletImpl!.verifyLater);

                  },
                ),
                
                const SizedBox(height: 10,),

                ValueListenableBuilder(
                  valueListenable: createWalletImpl!.isMatch, 
                  builder: (context, value, wg){
                    return MyButton(
                      textButton: "Next",
                      isTransparent: !value,
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
