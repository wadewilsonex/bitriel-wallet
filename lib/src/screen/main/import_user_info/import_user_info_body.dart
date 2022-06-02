import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/appbar_c.dart';

class ImportUserInfoBody extends StatelessWidget {
  final ModelUserInfo? modelUserInfo;
  final Function? onSubmit;
  final Function? popScreen;
  final Function? switchBio;
  final MenuModel? menuModel;
  final Function? changeGender;
  final Function? onChanged;
  final Function? validateFirstName;
  final Function? validatepassword;
  final Function? validateConfirmPassword;
  final Function? submitProfile;
  final Function? item;

  const ImportUserInfoBody({this.modelUserInfo,
    this.onSubmit,
    this.onChanged,
    this.changeGender,
    this.validateFirstName,
    this.validatepassword,
    this.validateConfirmPassword,
    this.submitProfile,
    this.popScreen,
    this.switchBio,
    this.menuModel,
    this.item
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;

    return Column(
      children: <Widget>[
        MyAppBar(
          title: "User Information",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Flexible(
            child: BodyScaffold(
                height: MediaQuery.of(context).size.height - 70,
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  // key: modelUserInfo!.formStateAddUserInfo,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      MyInputField(
                        pBottom: 16.0,
                        labelText: "Username",
                        textInputFormatter: [
                          LengthLimitingTextInputFormatter(
                            TextField.noMaxLength,
                          )
                        ],
                        controller: modelUserInfo!.userNameCon,
                        focusNode: modelUserInfo!.nodeFirstName,
                        validateField: validateFirstName,
                        onChanged: onChanged,
                        onSubmit: onSubmit,
                      ),
                      MyInputField(
                          labelText: "Pin",
                          pBottom: 16,
                          controller: modelUserInfo!.passwordCon,
                          focusNode: modelUserInfo!.passwordNode,
                          inputType: TextInputType.number,
                          validateField: validatepassword,
                          obcureText: true,
                          onChanged: onChanged,
                          textInputFormatter: [
                            LengthLimitingTextInputFormatter(4)
                          ],
                          onSubmit: onSubmit),
                      MyInputField(
                          labelText: "Confirm Pin",
                          pBottom: 16,
                          controller: modelUserInfo!.confirmPasswordCon,
                          focusNode: modelUserInfo!.confirmPasswordNode,
                          validateField: validateConfirmPassword,
                          inputType: TextInputType.number,
                          obcureText: true,
                          onChanged: onChanged,
                          textInputFormatter: [
                            LengthLimitingTextInputFormatter(4)
                          ],
                          onSubmit: onSubmit),
                      Container(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 50,
                              child: Switch(
                                value: menuModel!.switchBio,
                                onChanged: (value) {
                                  switchBio!(value);
                                },
                              ),
                            ),
                            MyText(
                              text: "Fingerprint",
                              color: isDarkTheme
                                  ? AppColors.whiteColorHexa
                                  : AppColors.textColor,
                            ),
                          ],
                        ),
                      ),
                      Flexible(child: Container()),
                      MyFlatButton(
                        textButton: "Submit",
                        edgeMargin: const EdgeInsets.only(top: 29, left: 66, right: 66, bottom: 81),
                        hasShadow: modelUserInfo!.enable,
                        action: submitProfile
                        // modelUserInfo!.enable == false
                        //     ? null
                        //     : submitProfile,
                      )
                    ],
                  ),
                )
              )
            ),
      ],
    );
  }
}
