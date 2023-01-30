import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/acc_c.dart';
import 'package:wallet_apps/src/models/account.m.dart';
import 'package:wallet_apps/src/presentation/home/menu/account/c_account.dart';
import 'package:wallet_apps/src/presentation/home/menu/backup/body_backup_key.dart';
import 'package:wallet_apps/src/presentation/home/menu/changePin/changepin.dart';

class AccountBody extends StatelessWidget{

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
      appBar: secondaryAppBar(
        context: context,
        title: const MyText(
          text: "Account",
          fontSize: 2.5,
          fontWeight: FontWeight.w600
        ), 
      ),
      body: BodyScaffold(
        child: accountModel!.loading
        ? const Center( child: CircularProgressIndicator())
        : Column(
          children: [
            SizedBox(height: 1.h,),

            Container(
              padding: EdgeInsets.all(2.4.sp),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isDarkMode
                    ? Colors.white.withOpacity(0.06)
                    : hexaCodeToColor(AppColors.whiteHexaColor),
                  boxShadow: [shadow(context)]
                ),
                child: Column(
                  children: [
                    
                    SizedBox(height: 1.h,),

                    Consumer<ApiProvider>(
                      builder: (context, provider, widget){
                        return Column(
                          children: [

                            Consumer<ApiProvider>(
                              builder: (context, value, child) {
                                return Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(
                                    bottom: 16,
                                    top: 16,
                                  ),
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius:BorderRadius.circular(5),
                                  ),
                                  child: randomAvatar(value.accountM.addressIcon ?? '')
                                );
                              },
                            ),
                            
                            MyText(
                              text: provider.accountM.name ?? '',
                              hexaColor: isDarkMode
                                ? AppColors.whiteColorHexa
                                : AppColors.textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),

                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                            
                                Padding(
                                  padding: EdgeInsets.only(right: paddingSize / 2),
                                  child: MyText(
                                    // width: MediaQuery.of(context).size.width - (paddingSize*2),
                                    text: provider.accountM.address!.replaceRange(8, provider.accountM.address!.length - 8, "........"),
                                    fontWeight: FontWeight.bold,
                                    hexaColor: isDarkMode
                                      ? AppColors.whiteColorHexa
                                      : AppColors.textColor,
                                    fontSize: 17,
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
                                  child: Icon(Iconsax.copy, color: hexaCodeToColor(AppColors.primaryColor),)
                                )
                              ],
                            )
                          ],
                        );
                      }
                    ),

                    SizedBox(height: 2.5.h),

                    Form(
                      child: MyInputField(
                        hintText: 'Enter Name',
                        controller: accountModel!.editNameController,
                        onSubmit: () async {
                          if (accountModel!.editNameController.text.isNotEmpty){
                            await changeName!();
                          }
                        }, 
                        focusNode: accountModel!.newNode,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Iconsax.edit, color: hexaCodeToColor(AppColors.primaryColor),),
                        ),
                      ),
                    ),

                    SizedBox(height: 2.5.sp),

                    // ListTileComponent(
                    //   action: (){
                    //     AccountC().showEditName(
                    //       context,
                    //       accountModel!.editNameKey,
                    //       accountModel!.editNameController,
                    //       accountModel!.newNode,
                    //       onChangeName!,
                    //       changeName
                    //     );
                    //   },
                    //   text: 'Edit Wallet Name',
                    // ),
                    
                    // ListTileComponent(
                    //   action: (){
                    //     Navigator.push(
                    //       context, 
                    //       Transition(
                    //         child: const BackUpKeyBody(),
                    //         transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                    //       )
                    //     );
                    //   },
                    //   text: 'Backup Key',
                    // ),
                    
                    // ListTileComponent(
                    //   action: ()  async {
                    //     await Navigator.push(
                    //       context, 
                    //       Transition(
                    //         child: const ChangePin(),
                    //         transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                    //       )
                    //     );

                    //   },
                    //   text: 'Change Pin',
                    // ),
                    
                  ],
                ),
              ),
            ),


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
}