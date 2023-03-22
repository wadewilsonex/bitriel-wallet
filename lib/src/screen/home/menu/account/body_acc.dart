import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/account.m.dart';
import 'package:wallet_apps/src/screen/home/menu/backup/backup_key.dart';
import 'package:wallet_apps/src/screen/main/seeds/create_seeds/create_seeds.dart';

class AccountBody extends StatelessWidget{

  final String? walletName;
  final AccountM? accountModel;
  final Function? onSubmitName;
  final Function? onChangeName;
  final Function? onChangedBackup;
  final Function? onChangedChangePin;
  final Function? onSubmitChangePin;
  final Function? onSubmit;
  final Function? submitChangePin;
  final Function? submitBackUpKey;
  final Function? changeName;
  // final Function? deleteAccout;

  const AccountBody({
    Key? key, 
    this.walletName,
    this.accountModel, 
    this.onSubmitName,
    this.onChangeName,
    this.onChangedBackup, 
    this.onSubmit,
    this.onChangedChangePin, 
    this.onSubmitChangePin, 
    this.submitChangePin, 
    this.submitBackUpKey, 
    this.changeName, 
    // this.deleteAccout
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
     
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const MyText(
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
      body: Consumer<ApiProvider>(
        builder: (context, provider, widget){
          return ExpandedTileList.builder(
            itemCount: provider.getKeyring.allAccounts.length,
            maxOpened: 1,
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: paddingSize / 2),
            itemBuilder: (context, index, controller) {
              return ExpandedTile(
                theme: const ExpandedTileThemeData(
                  headerColor: Colors.white,
                  headerRadius: 10.0,
                  contentBackgroundColor: Colors.white,
                  contentRadius: 10.0,
                ),
                controller: index == 2 ? controller.copyWith(isExpanded: true) : controller,
                leading: Container(
                  alignment: Alignment.centerLeft,
                  width: 50,
                  height: 50,
                  child: randomAvatar(provider.accountM.addressIcon ?? '')
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: provider.accountM.name ?? '',
                      hexaColor: AppColors.blackColor,
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.start,
                    ),
          
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                    
                        Padding(
                          padding: const EdgeInsets.only(right: paddingSize / 2),
                          child: MyText(
                            text: provider.accountM.address!.replaceRange(8, provider.accountM.address!.length - 8, "........"),
                            hexaColor: AppColors.greyCode,
                            fontSize: 16,
                          ),
                        ),
                    
                        InkWell(
                          onTap: () async {
                            await Clipboard.setData(
                              ClipboardData(text: provider.accountM.address ??''),
                            );
                            Fluttertoast.showToast(
                              msg: "Copied address",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                            );
                          }, 
                          child: Icon(Iconsax.copy, color: hexaCodeToColor(AppColors.primaryColor), size: 20,)
                        )
                      ],
                    )
                  ],
                ),
                content: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => _editAccountNameDialog(context),
                        child: _itemButton(
                          icon: Iconsax.edit, 
                          title: "Edit Wallet Name", 
                          iconColor: AppColors.darkGrey,
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context, 
                            Transition(
                              child: const BackUpKey(),
                              transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                            )
                          );
                        },
                        child: _itemButton(
                          icon: Iconsax.export_1, 
                          title: "Export Wallet",
                          iconColor: AppColors.primaryColor, 
                          titleColor: AppColors.primaryColor
                        ),
                      ),

                      GestureDetector(
                        // onTap: () => _editAccountNameDialog(context),
                        child: _itemButton(
                          icon: Iconsax.trash, 
                          title: "Delete Wallet", 
                          titleColor: AppColors.redColor,
                          iconColor: AppColors.redColor,
                        ),
                      ),
                      
                    ],
                  ),
                ),
                // onTap: () {
                //   debugPrint("tapped!!");
                // },
              );
            },
          );
          // return ListView.builder(
          //   itemCount: provider.getKeyring.allAccounts.length,
          //   itemBuilder: (context, index) {
          //     return Column(
          //       children: [
                  

          //         // Container(
          //         //   padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: 5),
          //         //   child: Card(
          //         //     semanticContainer: true,
          //         //     clipBehavior: Clip.antiAliasWithSaveLayer,
          //         //     shape: const RoundedRectangleBorder(
          //         //       borderRadius: BorderRadius.all(Radius.circular(10))
          //         //     ),
          //         //     child: ExpansionTile(
          //         //       collapsedIconColor: Colors.black,
          //         //       iconColor: Colors.black,
          //         //       leading: Container(
          //         //         alignment: Alignment.centerLeft,
          //         //         width: 40,
          //         //         height: 40,
          //         //         decoration: BoxDecoration(
          //         //           borderRadius:BorderRadius.circular(5),
          //         //         ),
          //         //         child: randomAvatar(provider.accountM.addressIcon ?? '')
          //         //       ),
          //         //       title: Column(
          //         //         crossAxisAlignment: CrossAxisAlignment.start,
          //         //         children: [
          //         //           MyText(
          //         //             text: provider.accountM.name ?? '',
          //         //             hexaColor: AppColors.blackColor,
          //         //             fontSize: 19,
          //         //             fontWeight: FontWeight.w600,
          //         //             textAlign: TextAlign.start,
          //         //           ),
            
          //         //           Row(
          //         //             mainAxisSize: MainAxisSize.min,
          //         //             children: [
                            
          //         //               Padding(
          //         //                 padding: const EdgeInsets.only(right: paddingSize / 2),
          //         //                 child: MyText(
          //         //                   text: provider.accountM.address!.replaceRange(8, provider.accountM.address!.length - 8, "........"),
          //         //                   hexaColor: AppColors.greyCode,
          //         //                   fontSize: 16,
          //         //                 ),
          //         //               ),
                            
          //         //               InkWell(
          //         //                 onTap: () async {
          //         //                   await Clipboard.setData(
          //         //                     ClipboardData(text: provider.accountM.address ??''),
          //         //                   );
          //         //                   Fluttertoast.showToast(
          //         //                     msg: "Copied address",
          //         //                     toastLength: Toast.LENGTH_SHORT,
          //         //                     gravity: ToastGravity.CENTER,
          //         //                   );
          //         //                 }, 
          //         //                 child: Icon(Iconsax.copy, color: hexaCodeToColor(AppColors.primaryColor), size: 20,)
          //         //               )
          //         //             ],
          //         //           )
          //         //         ],
          //         //       ),
          //         //       children: <Widget>[

          //         //         Padding(
          //         //           padding: const EdgeInsets.only(top: paddingSize, left: paddingSize, right: paddingSize),
          //         //           child: Divider(
          //         //             thickness: 0.5,
          //         //             color: hexaCodeToColor(AppColors.darkGrey),
          //         //           ),
          //         //         ),

          //         //         SizedBox(
          //         //           width: MediaQuery.of(context).size.width,
          //         //           child: TextButton.icon(
          //         //             onPressed: () {
          //         //               _editAccountNameDialog(context);
          //         //             }, 
          //         //             icon: const Icon(Iconsax.edit_2, color: Colors.black, size: 22,), 
          //         //             label: const MyText(
          //         //               text: "Edit Account Name", 
          //         //               fontSize: 17,
          //         //               fontWeight: FontWeight.w500,
          //         //               hexaColor: AppColors.blackColor,
          //         //             ),
          //         //           ),
          //         //         ),

          //         //         SizedBox(
          //         //           width: MediaQuery.of(context).size.width,
          //         //           child: TextButton.icon(
          //         //             onPressed: () {
          //         //               Navigator.push(
          //         //                 context, 
          //         //                 Transition(
          //         //                   child: const BackUpKey(),
          //         //                   transitionEffect: TransitionEffect.RIGHT_TO_LEFT
          //         //                 )
          //         //               );
          //         //             }, 
          //         //             icon: const Icon(Iconsax.edit_2, color: Colors.black, size: 22,), 
          //         //             label: const MyText(
          //         //               text: "Export Wallet", 
          //         //               fontSize: 17,
          //         //               fontWeight: FontWeight.w500,
          //         //               hexaColor: AppColors.blackColor,
          //         //             ),
          //         //           ),
          //         //         ),

          //         //       ],
          //         //     ),
          //         //   ),
          //         // ),
          //       ],
          //     );
          //   }
          // );
        }
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: Row(
          children: [

            Expanded(
              child: MyGradientButton(
                edgeMargin: const EdgeInsets.all(paddingSize),
                textButton: "Create Wallet",
                fontWeight: FontWeight.w400,
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                action: () async {

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Passcode(label: PassCodeLabel.fromAccount,)
                      // const ImportAcc(
                      //   isBackBtn: true,
                      // )
                    )
                  ).then((value) async {
                    if (value != null){
                      
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateSeeds(newAcc: NewAccount(), passCode: value,)
                          // const ImportAcc(
                          //   isBackBtn: true,
                          // )
                        )
                      ).then((value) {
                        if (value != null && value == true){
                          
                          // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                          Provider.of<ApiProvider>(context, listen: false).notifyListeners();
                        }
                      });
                    }
                  });
                },
              ),
            ),
      
            Expanded(
              child: MyGradientButton(
                edgeMargin: const EdgeInsets.all(paddingSize),
                textButton: "Import Wallet",
                fontWeight: FontWeight.w400,
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                action: () async {

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Passcode(label: PassCodeLabel.fromAccount,)
                      // const ImportAcc(
                      //   isBackBtn: true,
                      // )
                    )
                  ).then((value) async {
                    if (value != null){

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImportAcc(isBackBtn: true, isAddNew: true, passCode: value,)
                          // const ImportAcc(
                          //   isBackBtn: true,
                          // )
                        )
                      ).then((value) {
                        if (value != null && value == true){
                          
                          // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                          Provider.of<ApiProvider>(context, listen: false).notifyListeners();
                        }
                      });
                    }
                  });

                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _itemButton({required String title, required IconData icon, String? titleColor, String? iconColor}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: paddingSize / 2),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: hexaCodeToColor(AppColors.lightColorBg),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              
              Icon(icon, color: hexaCodeToColor(iconColor!)),
        
              MyText(
                left: 10,
                text: title,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                hexaColor: titleColor ?? AppColors.blackColor,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _editAccountNameDialog(BuildContext context) => showDialog<String?>(
    context: context,
    builder: ((context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.symmetric(vertical: paddingSize),
      title: const MyText(text: "Account Name", fontSize: 20, fontWeight: FontWeight.w500, textAlign: TextAlign.start, color2: Colors.black,),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Form(
          child: MyInputField(
            autoFocus: true,
            hintText: 'Enter Name',
            controller: accountModel!.editNameController,
            onSubmit: () async {
              await changeName!();
            }, 
            focusNode: accountModel!.newNode,
          ),
        ),
      ),
      actions: [

        Row (
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: MyFlatButton(
                  edgeMargin: const EdgeInsets.symmetric(horizontal: paddingSize),
                  isTransparent: true,
                  buttonColor: AppColors.whiteHexaColor,
                  textColor: AppColors.blackColor,
                  textButton: "Cancel",
                  action: () {
                    _closeDialog(context);
                  },
                )
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: MyGradientButton(
                  edgeMargin: const EdgeInsets.symmetric(horizontal: paddingSize),
                  textButton: "Update",
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  action: () async {
                    await changeName!();
                  },
                ),
              ),
            ),
          ]
        )

        
      ],
    )),
  );

  void _closeDialog(BuildContext context) {
    Navigator.of(context).pop(accountModel!.editNameController.text); // dialog returns true
  }
}