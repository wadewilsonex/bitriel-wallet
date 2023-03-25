import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/acc_c.dart';
import 'package:wallet_apps/src/models/account.m.dart';
import 'package:wallet_apps/src/screen/home/menu/account/c_account.dart';
import 'package:wallet_apps/src/screen/home/menu/backup/backup_key.dart';
import 'package:wallet_apps/src/screen/home/menu/backup/body_backup_key.dart';
import 'package:wallet_apps/src/screen/home/menu/changePin/changepin.dart';

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
        title: MyText(
          text: walletName,
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
        actions: [
          IconButton(
            onPressed: () {
              _settingWalletBottomSheet(context);
            }, 
            icon: const Icon(Iconsax.setting_2, color: Colors.black, size: 30,)
          )
        ],
      ),
      body: BodyScaffold(
        child: accountModel!.loading
        ? const Center( child: CircularProgressIndicator())
        : Column(
          children: [
            SizedBox(height: 1,),

            Consumer<ApiProvider>(
              builder: (context, provider, widget){
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: ExpansionTile(
                      collapsedIconColor: Colors.black,
                      iconColor: Colors.black,
                      leading: Container(
                        alignment: Alignment.centerLeft,
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius:BorderRadius.circular(5),
                        ),
                        child: randomAvatar(provider.getKeyring.current.icon ?? '')
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: provider.getKeyring.current.name ?? '',
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
                                  text: provider.getKeyring.current.address!.replaceRange(8, provider.getKeyring.current.address!.length - 8, "........"),
                                  hexaColor: AppColors.greyCode,
                                  fontSize: 16,
                                ),
                              ),
                          
                              InkWell(
                                onTap: () async {
                                  await Clipboard.setData(
                                    ClipboardData(text: provider.getKeyring.current.address ??''),
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
                      children: <Widget>[

                        Padding(
                          padding: const EdgeInsets.only(top: paddingSize, left: paddingSize, right: paddingSize),
                          child: Divider(
                            thickness: 0.5,
                            color: hexaCodeToColor(AppColors.darkGrey),
                          ),
                        ),

                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TextButton.icon(
                            onPressed: () {
                              _editAccountNameDialog(context);
                            }, 
                            icon: const Icon(Iconsax.edit_2, color: Colors.black, size: 22,), 
                            label: const MyText(
                              text: "Edit Account Name", 
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              hexaColor: AppColors.blackColor,
                            ),
                          ),
                        ),

                        // SizedBox(
                        //   width: MediaQuery.of(context).size.width,
                        //   child: TextButton.icon(
                        //     onPressed: () {
                        //       print("tab");
                        //     }, 
                        //     icon: const Icon(Iconsax.edit_2, color: Colors.black, size: 22,), 
                        //     label: const MyText(
                        //       text: "Edit account name", 
                        //       fontSize: 17,
                        //       fontWeight: FontWeight.w500,
                        //       hexaColor: AppColors.blackColor,
                        //     ),
                        //   ),
                        // ),

                      ],
                    ),
                  ),
                );
              }
            ),

            // Container(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Container(
            //     width: double.infinity,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(10),
            //       color: isDarkMode
            //         ? Colors.white.withOpacity(0.06)
            //         : hexaCodeToColor(AppColors.whiteHexaColor),
            //       boxShadow: [shadow(context)]
            //     ),
            //     child: Column(
            //       children: [
                    
            //         SizedBox(height: 1.h,),

            //         Consumer<ApiProvider>(
            //           builder: (context, provider, widget){
            //             return Column(
            //               children: [

            //                 Consumer<ApiProvider>(
            //                   builder: (context, value, child) {
            //                     return Container(
            //                       alignment: Alignment.centerLeft,
            //                       margin: const EdgeInsets.only(
            //                         bottom: 16,
            //                         top: 16,
            //                       ),
            //                       width: 70,
            //                       height: 70,
            //                       decoration: BoxDecoration(
            //                         borderRadius:BorderRadius.circular(5),
            //                       ),
            //                       child: randomAvatar(value.accountM.addressIcon ?? '')
            //                     );
            //                   },
            //                 ),
                            
            //                 MyText(
            //                   text: provider.accountM.name ?? '',
            //                   hexaColor: AppColors.primaryColor,
            //                   fontSize: 20,
            //                   fontWeight: FontWeight.w600,
            //                 ),

            //                 Row(
            //                   mainAxisSize: MainAxisSize.min,
            //                   children: [
                            
            //                     Padding(
            //                       padding: const EdgeInsets.only(right: paddingSize / 2),
            //                       child: MyText(
            //                         // width: MediaQuery.of(context).size.width - (paddingSize*2),
            //                         text: provider.accountM.address!.replaceRange(8, provider.accountM.address!.length - 8, "........"),
            //                         fontWeight: FontWeight.bold,
            //                         hexaColor: isDarkMode
            //                           ? AppColors.whiteColorHexa
            //                           : AppColors.textColor,
            //                         fontSize: 17,
            //                       ),
            //                     ),
                            
            //                     InkWell(
            //                       onTap: () async {
            //                         await Clipboard.setData(
            //                           ClipboardData(text: provider.accountM.address ??''),
            //                         );
            //                         Fluttertoast.showToast(
            //                           msg: "Copied address",
            //                           toastLength: Toast.LENGTH_SHORT,
            //                           gravity: ToastGravity.CENTER,
            //                         );
            //                       }, 
            //                       child: Icon(Iconsax.copy, color: hexaCodeToColor(AppColors.primaryColor),)
            //                     )
            //                   ],
            //                 )
            //               ],
            //             );
            //           }
            //         ),

            //         SizedBox(height: 2.5.h),

            //         Form(
            //           child: MyInputField(
            //             hintText: 'Enter Name',
            //             controller: accountModel!.editNameController,
            //             onSubmit: () async {
            //               if (accountModel!.editNameController.text.isNotEmpty){
            //                 await changeName!();
            //               }
            //             }, 
            //             focusNode: accountModel!.newNode,
            //             suffixIcon: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Icon(Iconsax.edit, color: hexaCodeToColor(AppColors.primaryColor),),
            //             ),
            //           ),
            //         ),

            //         SizedBox(height: 2.5.h),

            //         // ListTileComponent(
            //         //   action: (){
            //         //     AccountC().showEditName(
            //         //       context,
            //         //       accountModel!.editNameKey,
            //         //       accountModel!.editNameController,
            //         //       accountModel!.newNode,
            //         //       onChangeName!,
            //         //       changeName
            //         //     );
            //         //   },
            //         //   text: 'Edit Wallet Name',
            //         // ),
                    
            //         // ListTileComponent(
            //         //   action: (){
            //         //     Navigator.push(
            //         //       context, 
            //         //       Transition(
            //         //         child: const BackUpKeyBody(),
            //         //         transitionEffect: TransitionEffect.RIGHT_TO_LEFT
            //         //       )
            //         //     );
            //         //   },
            //         //   text: 'Backup Key',
            //         // ),
                    
            //         // ListTileComponent(
            //         //   action: ()  async {
            //         //     await Navigator.push(
            //         //       context, 
            //         //       Transition(
            //         //         child: const ChangePin(),
            //         //         transitionEffect: TransitionEffect.RIGHT_TO_LEFT
            //         //       )
            //         //     );

            //         //   },
            //         //   text: 'Change Pin',
            //         // ),
                    
            //       ],
            //     ),
            //   ),
            // ),


            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: MyGradientButton(
            //     lsColor: const [AppColors.warningColor, AppColors.warningColor],
            //     begin: Alignment.bottomRight, 
            //     end: Alignment.topLeft, 
            //     action: (){
            //       deleteAccout!();
            //     },
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       crossAxisAlignment: CrossAxisAlignment.center,

            //       children: const [
            //         MyText(
            //           text: "Delete",
            //           fontWeight: FontWeight.bold,
            //           hexaColor: AppColors.whiteColorHexa,
            //         ),
            //       ],
            //     )
            //   ),
            // ),

          ],
        ),
      ),
    );
  }

  Future _settingWalletBottomSheet(BuildContext context) {
    return showBarModalBottomSheet(
      context: context,
      backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(paddingSize),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _editAccountNameDialog(context);
                }, 
                icon: const Icon(Iconsax.edit_2, color: Colors.black, size: 25,), 
                label: const MyText(
                  text: "Edit Wallet Name", 
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  hexaColor: AppColors.blackColor,
                ),
              ),
            ),
            
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                    Navigator.push(
                    context, 
                    Transition(
                      child: const BackUpKey(),
                      transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                    )
                  );

                }, 
                icon: Icon(Iconsax.eye, color: hexaCodeToColor(AppColors.primaryColor), size: 25,), 
                label: const MyText(
                  text: "Export Wallet",
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  hexaColor: AppColors.primaryColor,
                ),
              ),
            ),
          ],  
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

  Future<String?> _editWalletNameDialog(BuildContext context) => showDialog<String?>(
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