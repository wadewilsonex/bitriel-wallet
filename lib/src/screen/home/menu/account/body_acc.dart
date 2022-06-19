import 'package:random_avatar/random_avatar.dart';
import 'package:wallet_apps/index.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallet_apps/src/components/acc_c.dart';
import 'package:wallet_apps/src/components/appbar_c.dart';
import 'package:wallet_apps/src/models/account.m.dart';
import 'package:wallet_apps/src/screen/home/menu/account/c_account.dart';
import 'package:wallet_apps/src/screen/home/menu/backup/body_backup_key.dart';
import 'package:wallet_apps/src/screen/home/menu/changePin/changePin.dart';

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
  final Function? deleteAccout;

  AccountBody({
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
    this.deleteAccout
  });

  Widget build(BuildContext context){
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: accountModel!.loading
        ? const Center( child: CircularProgressIndicator())
        : Column(
          children: [

            MyAppBar(
              title: "Account",
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            Container(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isDarkTheme
                    ? Colors.white.withOpacity(0.06)
                    : hexaCodeToColor(AppColors.whiteHexaColor),
                  boxShadow: [shadow(context)]
                ),
                child: Column(
                  children: [
                    
                    Container(
                      width: double.infinity,
                      // padding: const EdgeInsets.only(
                      //   left: 20,
                      //   right: 20,
                      //   top: 25,
                      //   bottom: 25,
                      // ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        // color: isDarkTheme
                        //   ? Colors.white.withOpacity(0.06)
                        //   : hexaCodeToColor(AppColors.whiteHexaColor),
                      ),
                      child: Consumer<ApiProvider>(
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
                                    // SvgPicture.string(
                                    //   value.accountM.addressIcon ?? '',
                                    // ),
                                  );
                                },
                              ),
                              
                              MyText(
                                text: provider.accountM.name ?? '',
                                color: isDarkTheme
                                  ? AppColors.whiteColorHexa
                                  : AppColors.textColor,
                                fontSize: 20,
                              ),

                              Padding(
                                padding: const EdgeInsets.all(paddingSize),
                                child: MyText(
                                  text: provider.accountM.address ?? '',
                                  color: isDarkTheme
                                    ? AppColors.whiteColorHexa
                                    : AppColors.textColor,
                                  fontSize: 16,
                                  // width: MediaQuery.of(context).size.width/1.5,
                                ),
                              )
                            ],
                          );
                        }
                      ),
                    ),

                    SizedBox(height: 2.5.h),

                    ListTileComponent(
                      action: (){
                        // underContstuctionAnimationDailog(context: context);
                        AccountC().showEditName(
                          context,
                          accountModel!.editNameKey,
                          accountModel!.editNameController,
                          accountModel!.newNode,
                          onChangeName!,
                          changeName
                        );
                      },
                      text: 'Edit Wallet Name',
                    ),
                    
                    ListTileComponent(
                      action: (){
                        // underContstuctionAnimationDailog(context: context);
                        // AccountC().showBackup(
                        //   context,
                        //   accountModel!.backupKey,
                        //   accountModel!.pinController,
                        //   accountModel!.pinNode,
                        //   onChangedBackup!,
                        //   onSubmit!,
                        //   submitBackUpKey!,
                        // );
                        Navigator.push(
                          context, 
                          Transition(
                            child: BackUpKeyBody(),
                            transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                          )
                        );
                      },
                      text: 'Backup Key',
                    ),
                    
                    // const SizedBox(height: 20),
                    
                    ListTileComponent(
                      action: ()  async {
                        // underContstuctionAnimationDailog(context: context);
                        // Passcode(label: PassCodeLabel.formChangePin);
                        // AccountC().showChangePin(
                        //   context,
                        //   accountModel!.changePinKey,
                        //   accountModel!.oldPinController,
                        //   accountModel!.newPinController,
                        //   accountModel!.oldNode,
                        //   accountModel!.newNode,
                        //   onChangedChangePin!,
                        //   onSubmitChangePin!,
                        //   submitChangePin!,
                        // );

                        final res = await Navigator.push(
                          context, 
                          Transition(
                            child: ChangePin(),
                            transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                          )
                        );

                        // await Provider.of<ApiProvider>(context, listen: false).
                      },
                      text: 'Change Pin',
                    ),

                    // const SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.all(paddingSize),
                      child: GestureDetector(
                        onTap: () async {
                          // await contract.unsubscribeNetwork();
                          await deleteAccout!();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          // margin: const EdgeInsets.only(left: 16, right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.red.withOpacity(0.3)
                          ),
                          height: 7.h,
                          child: MyText(
                            text: 'Delete Account',
                            color: "#FF0000",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}