import 'package:wallet_apps/index.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallet_apps/src/components/acc_c.dart';
import 'package:wallet_apps/src/models/account.m.dart';
import 'package:wallet_apps/src/screen/home/menu/account/account_c.dart';
import 'package:wallet_apps/src/screen/home/menu/backup/body_backup_key.dart';

class AccountBody extends StatelessWidget{

  final AccountM? accountModel;
  final Function? onChangedBackup;
  final Function? onChangedChangePin;
  final Function? onSubmitChangePin;
  final Function? onSubmit;
  final Function? submitChangePin;
  final Function? submitBackUpKey;
  final Function? deleteAccout;

  AccountBody({this.accountModel, this.onChangedBackup, this.onSubmit, this.onChangedChangePin, this.onSubmitChangePin, this.submitChangePin, this.submitBackUpKey, this.deleteAccout});

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
                  borderRadius: BorderRadius.circular(5),
                  color: isDarkTheme
                    ? hexaCodeToColor(AppColors.darkCard)
                    : hexaCodeToColor(AppColors.whiteHexaColor),
                  boxShadow: [shadow(context)]
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 25,
                        bottom: 25,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: isDarkTheme
                          ? hexaCodeToColor(AppColors.darkCard)
                          : hexaCodeToColor(AppColors.whiteHexaColor),
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
                                    ),
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      borderRadius:BorderRadius.circular(5),
                                    ),
                                    child: SvgPicture.string(
                                      value.accountM.addressIcon!,
                                    ),
                                  );
                                },
                              ),
                              
                              MyText(
                                text: provider.accountM.name,
                                color: isDarkTheme
                                  ? AppColors.whiteColorHexa
                                  : AppColors.textColor,
                                fontSize: 20,
                                bottom: 5,
                              ),
                              MyText(
                                text: provider.accountM.address!,
                                color: isDarkTheme
                                  ? AppColors.whiteColorHexa
                                  : AppColors.textColor,
                                fontSize: 16,
                                width: MediaQuery.of(context).size.width/1.5,
                              )
                            ],
                          );
                        }
                      ),
                    ),
                    
                    ListTileComponent(
                      action: (){
                        print("Backup");
                        // AccountC().showBackup(
                        //   context,
                        //   accountModel!.backupKey,
                        //   accountModel!.pinController,
                        //   accountModel!.pinNode,
                        //   onChangedBackup!,
                        //   onSubmit!,
                        //   submitBackUpKey!,
                        // );
                        Navigator.push(context, MaterialPageRoute(builder: (context) => BackUpKeyBody()));
                      },
                      text: 'Backup Key',
                    ),
                    
                    const SizedBox(height: 20),
                    
                    ListTileComponent(
                      action: (){
                        AccountC().showChangePin(
                          context,
                          accountModel!.changePinKey,
                          accountModel!.oldPinController,
                          accountModel!.newPinController,
                          accountModel!.oldNode,
                          accountModel!.newNode,
                          onChangedChangePin!,
                          onSubmitChangePin!,
                          submitChangePin!,
                        );
                      },
                      text: 'Change Pin',
                    ),

                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        // await contract.unsubscribeNetwork();
                        await deleteAccout!();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(left: 16, right: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: 70,
                        child: MyText(
                          text: 'Delete Account',
                          color: "#FF0000",
                          fontWeight: FontWeight.bold,
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