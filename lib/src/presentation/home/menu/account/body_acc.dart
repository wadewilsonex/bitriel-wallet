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
      appBar: secondaryAppBar(
        context: context,
        title: const MyText(
          text: "Account",
          fontSize: 2.5,
          fontWeight: FontWeight.w600
        ), 
      ),
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: accountModel!.loading
        ? const Center( child: CircularProgressIndicator())
        : Column(
          children: [

            Container(
              padding: EdgeInsets.all(2.4.vmax),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.2.vmax),
                  color: isDarkMode
                    ? Colors.white.withOpacity(0.06)
                    : hexaCodeToColor(AppColors.whiteHexaColor),
                  boxShadow: [shadow(context)]
                ),
                child: Column(
                  children: [
                    
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1.2.vmax),
                      ),
                      child: Consumer<ApiProvider>(
                        builder: (context, provider, widget){
                          return Column(
                            children: [

                              Consumer<ApiProvider>(
                                builder: (context, value, child) {
                                  return Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(
                                      bottom: 2.4.vmax,
                                      top: 2.4.vmax,
                                    ),
                                    width: 10.vmax,
                                    height: 10.vmax,
                                    decoration: BoxDecoration(
                                      borderRadius:BorderRadius.circular(0.71.vmax),
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
                                fontSize: 2.9,
                                fontWeight: FontWeight.w600,
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
                                child: Padding(
                                  padding: EdgeInsets.all(paddingSize),
                                  child: MyText(
                                    text: provider.accountM.address ?? '',
                                    hexaColor: isDarkMode
                                      ? AppColors.whiteColorHexa
                                      : AppColors.textColor,
                                    fontSize: 2.4,
                                  ),
                                ),
                              )
                            ],
                          );
                        }
                      ),
                    ),

                    SizedBox(height: 2.5.vmax),

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
                    
                  ],
                ),
              ),
            ),


            Padding(
              padding: EdgeInsets.all(2.4.vmax),
              child: MyGradientButton(
                lsColor: const [AppColors.warningColor, AppColors.warningColor],
                begin: Alignment.bottomRight, 
                end: Alignment.topLeft, 
                action: (){
                  deleteAccout!();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: const [
                    MyText(
                      text: "Delete Account",
                      fontWeight: FontWeight.bold,
                      hexaColor: AppColors.whiteColorHexa,
                    ),
                  ],
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}