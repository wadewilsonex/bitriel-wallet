import 'package:bitriel_wallet/index.dart';

class MultiAccountScreen extends StatelessWidget {

  const MultiAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final MultiAccountImpl multiAccountImpl = MultiAccountImpl();

    multiAccountImpl.setContext = context;

    if (multiAccountImpl.sdkProvier!.isConnected ) print(multiAccountImpl.getAllAccount.length);

    multiAccountImpl.accInfoFromLocalStorage();
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const MyTextConstant(
          text: "Multi-Wallets",
          fontSize: 18,
          color2: Colors.black,
          fontWeight: FontWeight.w600
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Iconsax.arrow_left_2,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 30,
          ),
        ),
      ),
      body: (multiAccountImpl.sdkProvier!.isConnected == false ) 
      ? const Center(child: CircularProgressIndicator(),)
      : ListView.builder(
        itemCount: multiAccountImpl.getAllAccount.length,
        itemBuilder:(context, index) {

          return InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () async {

              // accountModel!.accIndex = index;

              // ignore: use_build_context_synchronously
              await showModalBottomSheet(
                backgroundColor: hexaCodeToColor(AppColors.lightColorBg),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical( 
                    top: Radius.circular(25.0),
                  ),
                ),
                context: context,
                builder: (BuildContext context) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      
                      Padding(
                        padding: const EdgeInsets.only(top: paddingSize, left: paddingSize, right: paddingSize),
                        child: MyTextConstant(
                          text: multiAccountImpl.getAllAccount[index].name ?? '',
                          // hexaColor: AppColors.blackColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                        ),
                      ),

                      const Divider(),
                    
                      GestureDetector(
                        onTap: () {
                          editAccountNameDialog(context);
                        },
                        child: itemButton(
                          icon: Iconsax.edit, 
                          title: "Edit Wallet Name", 
                          iconColor: AppColors.darkGrey,
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context, 
                          //   Transition(
                          //     child: BackUpKey(acc: provider.getKeyring.allAccounts[index],),
                          //     transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                          //   )
                          // );
                        },
                        child: itemButton(
                          icon: Iconsax.export_1, 
                          title: "Export Wallet",
                          iconColor: AppColors.primaryColor, 
                          titleColor: AppColors.primaryColor
                        ),
                      ),

                      GestureDetector(
                        onTap: () {

                          // Navigator.push(
                          //   context, 
                          //   Transition(
                          //     child: ChangePin(acc: provider.getKeyring.allAccounts[index],),
                          //     transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                          //   )
                          // );
                        },
                        child: itemButton(
                          icon: Iconsax.lock, 
                          title: "Change PIN",
                          iconColor: AppColors.warningColor, 
                          titleColor: AppColors.warningColor
                        ),
                      ),

                      GestureDetector(
                        onTap: () async {

                          // Map? accToChange;
              
                          // accountModel!.accIndex = index;

                          // String? data = await StorageServices.readSecure(DbKey.privateList)!;

                          // List<dynamic>? decode = json.decode(data); 

                          // /// If Delete Current Account
                          // if (provider.getKeyring.keyPairs[index].address == provider.getKeyring.current.address){
                          //   // ignore: use_build_context_synchronously
                          //   accToChange = await DialogComponents().dialogCustom(
                          //     context: context,
                          //     titles: "You are on current wallet! Are you sure to want delete this wallet?",
                          //     contents2: SizedBox(
                          //       width: MediaQuery.of(context).size.width,
                          //       child: Column(
                          //         mainAxisSize: MainAxisSize.min,
                          //         children: [

                          //           const MyText(
                          //             pBottom: 10,
                          //             text: "Please choose another wallet below to move to current wallet.",
                          //             fontWeight: FontWeight.w600,
                          //           ),

                          //           ListView.builder(
                          //             shrinkWrap: true,
                          //             itemCount: provider.getKeyring.keyPairs.length,
                          //             itemBuilder: (context, j){
                          //               return (provider.getKeyring.keyPairs[j].address != provider.getKeyring.keyPairs[index].address) 
                          //               ? ListTile(
                          //                 onTap: (){
                          //                   Navigator.pop(context, decode![j]);
                          //                 },
                          //                 selectedColor: Colors.blue,
                          //                 leading: SizedBox(
                          //                   width: 50,
                          //                   child: randomAvatar(provider.getKeyring.allAccounts[j].icon ?? '',)
                          //                 ),
                          //                 title: MyText(text: provider.getKeyring.keyPairs[j].name, textAlign: TextAlign.left,), 
                          //                 subtitle: MyText(text: provider.getKeyring.keyPairs[j].address!.replaceRange(10, provider.getKeyring.allAccounts[j].address!.length - 10, "........"), textAlign: TextAlign.left),
                          //               ) 
                          //               : Container();
                          //             },
                          //           ),
                          //         ],
                          //       )
                          //     ),
                          //     btn2: Container(),
                          //     btn: Padding(
                          //       padding: const EdgeInsets.all(paddingSize),
                          //       child: MyGradientButton(
                          //         textButton: "Cancel",
                          //         begin: Alignment.bottomLeft,
                          //         end: Alignment.topRight,
                          //         action: () => Navigator.pop(context),
                          //       ),
                          //     ),
                          //   );
                          // } else {

                          //   // ignore: use_build_context_synchronously
                          //   accToChange = await DialogComponents().dialogCustom(
                          //     context: context,
                          //     titles: 'Are you sure to delete this wallet?',
                          //     contents: 'Your current wallet, and assets will be removed from this app permanently\n\n You can Only recover your wallet with your Secret Recovery Seed Phrases',
      
                          //     btn: MyFlatButton(
                          //       height: 60,
                          //       edgeMargin: const EdgeInsets.symmetric(horizontal: paddingSize),
                          //       isTransparent: false,
                          //       buttonColor: AppColors.whiteHexaColor,
                          //       textColor: AppColors.redColor,
                          //       textButton: "Confirm",
                          //       isBorder: true,
                          //       action: () {

                          //         List<dynamic> current = decode!.where((element) {
                                    
                          //           if (element['address'] == provider.getKeyring.current.address){
                          //             return true;
                          //           }
                          //           return false;
                          //         }).toList();
                          //         Navigator.pop(context, current[0]);

                          //         // Close pop buttom sheet
                          //         Navigator.pop(context);
                                  
                          //       },
                          //     ),

                          //     btn2: Padding(
                          //       padding: const EdgeInsets.all(paddingSize),
                          //       child: MyGradientButton(
                          //         textButton: "Cancel",
                          //         begin: Alignment.bottomLeft,
                          //         end: Alignment.topRight,
                          //         action: () => Navigator.pop(context),
                          //       ),
                          //     ),
                          //   );
                          // }
                          
                          // // Remove Selected Account From Cache
                          // if(accToChange != null) {

                          //   await provider.getSdk.api.keyring.deleteAccount(
                          //     provider.getKeyring,
                          //     provider.getKeyring.allAccounts[index],
                          //   );

                          //   // Remove Acc In PrivateList
                          //   decode!.removeAt(index);
                            
                          //   // Set New SEL Account
                          //   provider.getKeyring.setCurrent(provider.getKeyring.allAccounts[decode.indexOf(accToChange)]);
                            
                          //   // Assign EVM Address to ethAddr
                          //   Provider.of<ContractProvider>(context, listen: false).ethAdd = decode[decode.indexOf(accToChange)]['eth_address'];

                          //   // Assign Selected Account SEL Address To Sorted Address List
                          //   Provider.of<ContractProvider>(context, listen: false).sortListContract[0].address = provider.getKeyring.current.address;

                          //   // Assign BTC Address And Store New
                          //   Provider.of<ContractProvider>(context, listen: false).listContract[provider.btcIndex].address = decode[decode.indexOf(accToChange)]['btc_address'];
                          //   await StorageServices.writeSecure(DbKey.bech32, decode[decode.indexOf(accToChange)]['btc_address']);
                            
                          //   // ignore: use_build_context_synchronously
                          //   provider.getBtcBalance(context: context);
                          
                          //   await StorageServices.writeSecure(DbKey.privateList, json.encode(decode));
                          //   // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                          //   provider.notifyListeners();
                          //   // ignore: invalid_use_of_protected_member
                          //   Provider.of<ContractProvider>(context, listen: false).notifyListeners();
                            
                          //   ContractsBalance.getAllAssetBalance();
                          // }

                        },
                        child: itemButton(
                          icon: Iconsax.trash, 
                          title: "Delete Wallet", 
                          titleColor: AppColors.redColor,
                          iconColor: AppColors.redColor,
                        ),
                      ),

                      const SizedBox(height: 10),
                      
                    ],
                  );
                }
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 5),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: 50,
                                  height: 50,
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

                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: paddingSize / 2),
                                          child: MyTextConstant(
                                            text: multiAccountImpl.getAllAccount[index].address!.replaceRange(10, multiAccountImpl.getAllAccount[index].address!.length - 10, "........"),
                                            // hexaColor: AppColors.greyCode,
                                            fontSize: 16,
                                          ),
                                        ),
                                    
                                        InkWell(
                                          onTap: () async {
                                            await Clipboard.setData(
                                              ClipboardData(text: multiAccountImpl.getAllAccount[index].address ??''),
                                            );
                                            // Fluttertoast.showToast(
                                            //   msg: "Copied address",
                                            //   toastLength: Toast.LENGTH_SHORT,
                                            //   gravity: ToastGravity.CENTER,
                                            // );
                                          }, 
                                          child: Icon(Iconsax.copy, color: hexaCodeToColor(AppColors.primaryColor), size: 20,)
                                        )
                                      ],
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
            child: MyGradientButton(
              edgeMargin: const EdgeInsets.all(paddingSize),
              textButton: "Create Wallet",
              fontWeight: FontWeight.w400,
              // begin: Alignment.bottomLeft,
              // end: Alignment.topRight,
              action: () async {

                await multiAccountImpl.createWallet();

                // await Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const Pincode(label: PinCodeLabel.fromAccount,)
                //     // const ImportAcc(
                //     //   isBackBtn: true,
                //     // )
                //   )
                // ).then((value) async {
                //   if (value != null){
                    
                //     await Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => CreateSeeds(newAcc: NewAccount(), passCode: value,)
                //         // const ImportAcc(
                //         //   isBackBtn: true,
                //         // )
                //       )
                //     ).then((value) {
                //       if (value != null && value == true){
                        
                //         // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                //         Provider.of<ApiProvider>(context, listen: false).notifyListeners();
                //       }
                //     });
                //   }
                // });
              },
            ),
          ),
      
          Expanded(
            child: MyGradientButton(
              edgeMargin: const EdgeInsets.all(paddingSize),
              textButton: "Import Wallet",
              fontWeight: FontWeight.w400,
              // begin: Alignment.bottomLeft,
              // end: Alignment.topRight,
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