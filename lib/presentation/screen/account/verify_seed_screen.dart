import 'package:bitriel_wallet/index.dart';

class VerifySeedScreen extends StatelessWidget {
  
  final String? seed;
  final String? pin;
  final CreateWalletImpl? createWalletImpl;
  
  const VerifySeedScreen({super.key, this.seed, this.pin, required this.createWalletImpl});

  // final CreateKeyModel? createKeyModel;
  // final Function? submit;
  // final Function? submitUnverify;
  // final Function? onTap;
  // final Function? remove3Seeds;

  // const VerifySeeds({
  //   Key? key, 
  //   this.createKeyModel,
  //   this.submit,
  //   this.onTap,
  //   this.submitUnverify,
  //   this.remove3Seeds
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    createWalletImpl!.remove3Seeds();

    return Scaffold(
      backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
      // appBar: AppBar(
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      //   leading: IconButton(
      //     icon: const Icon(Iconsax.arrow_left_2, size: 30,),
      //     color: Colors.black,
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.only(left: paddingSize, right: paddingSize, bottom: paddingSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                const SeedContents(
                  title: 'Verify Seed', 
                  subTitle: 'Almost done. Please input the words in the numerical order.'
                ),
  
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
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: SeedsCompoent.getColumn(context, value.join(" "), 0, moreSize: 2.5),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: SeedsCompoent.getColumn(context, value.join(" "), 1, moreSize: 2.5),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: SeedsCompoent.getColumn(context, value.join(" "), 2, moreSize: 2.5),
                              ),
                            ],
                          );
                        }
                      ),
                    ],
                  )
                ),
  
                // if (createKeyModel!.tmpThreeNum!.isNotEmpty) Padding(
                //   padding: const EdgeInsets.only(top: 20),
                //   child: Container(
                //     alignment: Alignment.center,
                //     height: 30,
                //     child: ListView.builder(
                //       scrollDirection: Axis.horizontal,
                //       physics: const NeverScrollableScrollPhysics(),
                //       shrinkWrap: true,
                //       itemCount: createKeyModel!.tmpThreeNum!.length,
                //       itemBuilder: (context, i){
                //         return SeedsCompoent().seedContainer(context, createKeyModel!.lsSeeds![int.parse(createKeyModel!.tmpThreeNum![i])], int.parse(createKeyModel!.tmpThreeNum![i]), i, onTap);
                //       }
                //     ),
                //   ),
                // ),
  
                // const SizedBox(height: 3),
                // // Display Refresh Button When User Fill Out All
                // if (createKeyModel!.tmpThreeNum!.isEmpty)
                // Align(
                //   alignment: Alignment.center,
                //   child: InkWell(
                //     child: Padding(
                //       padding: const EdgeInsets.all(15),
                //       child: Row(
                //         mainAxisSize: MainAxisSize.min,
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Icon(Iconsax.refresh, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,), size: 3.h),
                //           const SizedBox(width: 9),
                //           const MyText(
                //             text: "Try Again",
                //             fontSize: 17,
                //             fontWeight: FontWeight.bold,  
                //           ),
                //         ],
                //       ),
                //     ),
                //     onTap: () => remove3Seeds!()
                //   ),
                // ),
  
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

                MyGradientButton(
                  textButton: "Continue",
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  action: () async {
                    // submit!();
                  },
                )
              ],
            ),
          ),
        ),
      )
    );
  }

}
