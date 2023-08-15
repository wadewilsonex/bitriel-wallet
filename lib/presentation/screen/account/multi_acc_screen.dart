import 'package:bitriel_wallet/index.dart';

class MultiAccountScreen extends StatelessWidget {

  const MultiAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final MultiAccountImpl multiAccountImpl = MultiAccountImpl();

    multiAccountImpl.setContext = context;

    multiAccountImpl.accInfoFromLocalStorage();
    
    return Scaffold(
      backgroundColor: hexaCodeToColor(AppColors.background),
      appBar: appBar(context, title: "Account"),
      body: (multiAccountImpl.sdkProvier!.isConnected == false ) 
      ? const Center(child: CircularProgressIndicator(),)
      : ListView.builder(
        itemCount: multiAccountImpl.getAllAccount.length,
        itemBuilder:(context, index) {

          return InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () async {

              multiAccountImpl.switchAccount(multiAccountImpl.getAllAccount[index]);

            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 5),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(color: hexaCodeToColor(AppColors.primary))
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              Container(
                                alignment: Alignment.center,
                                width: 35,
                                height: 35,
                                child: RandomAvatar(multiAccountImpl.getAllAccount[index].icon ?? '')
                              ),

                              const SizedBox(width: 10),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  MyTextConstant(
                                    text: multiAccountImpl.getAllAccount[index].name ?? '',
                                    // hexaColor: AppColors.blackColor,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                    textAlign: TextAlign.start,
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(right: paddingSize / 2),
                                    child: MyTextConstant(
                                      text: multiAccountImpl.getAllAccount[index].address!.replaceRange(10, multiAccountImpl.getAllAccount[index].address!.length - 10, "........"),
                                      // hexaColor: AppColors.greyCode,
                                      fontSize: 14,
                                      color2: hexaCodeToColor(AppColors.darkGrey),
                                    ),
                                  ),

                                ],
                              ),
                            ]
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 0,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                          child: const Icon(
                            Iconsax.arrow_right_3
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),

                // Container(color: ,)
              ],
            ),
          );
        },
      ),

      bottomNavigationBar: Row(
        children: [

          Expanded(
            child: MyButton(
              edgeMargin: const EdgeInsets.all(10),
              textButton: "Create Wallet",
              fontWeight: FontWeight.w600,
              buttonColor: AppColors.bluebgColor,
              opacity: 0.9,
              // begin: Alignment.bottomLeft,
              // end: Alignment.topRight,
              action: () async {

                await multiAccountImpl.createWallet();
                
              },
            ),
          ),
      
          Expanded(
            child: MyButton(
              edgeMargin: const EdgeInsets.all(10),
              textButton: "Import Wallet",
              fontWeight: FontWeight.w600,
              // begin: Alignment.bottomLeft,
              // end: Alignment.topRight,
              buttonColor: AppColors.midNightBlue,
              opacity: 0.9,
              action: () async {

                await multiAccountImpl.importWallet();

              },
            ),
          )
        ],
      )
    );
  }

}