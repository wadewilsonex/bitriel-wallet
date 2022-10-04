import 'package:random_avatar/random_avatar.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/acc_c.dart';
import 'package:wallet_apps/src/models/account.m.dart';
import 'package:wallet_apps/src/screen/home/menu/account/c_account.dart';
import 'package:wallet_apps/src/screen/home/menu/backup/body_backup_key.dart';
import 'package:wallet_apps/src/screen/home/menu/changePin/changepin.dart';

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
    this.deleteAccout
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
     
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkTheme ? hexaCodeToColor(AppColors.darkBgd) : hexaCodeToColor(AppColors.lightColorBg),
        iconTheme: IconThemeData(
          color: hexaCodeToColor(isDarkTheme ? AppColors.whiteColorHexa : AppColors.blackColor)
        ),
        title: MyText(
          color: isDarkTheme
            ? AppColors.whiteColorHexa
            : AppColors.textColor,
          text: "Account",
          fontSize: 17,
          fontWeight: FontWeight.w600
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Iconsax.arrow_left_2,
            color: isDarkTheme ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: accountModel!.loading
        ? const Center( child: CircularProgressIndicator())
        : Column(
          children: [
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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
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
                        Navigator.push(
                          context, 
                          Transition(
                            child: const BackUpKeyBody(),
                            transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                          )
                        );
                      },
                      text: 'Backup Key',
                    ),
                    
                    ListTileComponent(
                      action: ()  async {
                        await Navigator.push(
                          context, 
                          Transition(
                            child: const ChangePin(),
                            transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                          )
                        );

                      },
                      text: 'Change Pin',
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.all(paddingSize),
                    //   child: GestureDetector(
                    //     onTap: () async {
                    //       await deleteAccout!();
                    //     },
                    //     child: Container(
                    //       alignment: Alignment.center,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(8),
                    //         color: Colors.red.withOpacity(0.3)
                    //       ),
                    //       height: 7.h,
                    //       child: const MyText(
                    //         text: 'Delete Account',
                    //         color: "#FF0000",
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ),
                    // ),
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