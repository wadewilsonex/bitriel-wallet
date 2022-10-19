import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/contact_book_m.dart';

class EditContactBody extends StatelessWidget {
  final ContactBookModel? model;
  final String Function(String)? validateAddress;
  final void Function()? submitContact;
  final String Function(String)? onChanged;
  final Function? onSubmit;

  const EditContactBody({
    Key? key, 
    this.model,
    this.validateAddress,
    this.submitContact,
    this.onChanged,
    this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     
    return Column(
      children: [
        MyAppBar(
          title: "Edit Contact",
          color: isDarkMode
              ? hexaCodeToColor(AppColors.darkCard)
              : hexaCodeToColor(AppColors.whiteHexaColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Container(
          margin: const EdgeInsets.only(top: 16),
          child: Form(
            key: model!.formKey,
            child: Column(
              children: [
                MyInputField(
                  labelText: "Contact number",
                  textInputFormatter: [
                    LengthLimitingTextInputFormatter(TextField.noMaxLength)
                  ],
                  inputType: TextInputType.phone,
                  controller: model?.contactNumber,
                  focusNode: model?.contactNumberNode,
                  enableInput: false,
                  onChanged: onChanged,
                  pBottom: 16,
                  onSubmit: onSubmit
                ),
                MyInputField(
                  labelText: "User name",
                  textInputFormatter: [
                    LengthLimitingTextInputFormatter(TextField.noMaxLength)
                  ],
                  controller: model?.userName,
                  focusNode: model?.userNameNode,
                  onChanged: onChanged,
                  pBottom: 16,
                  onSubmit: onSubmit
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyInputField(
                        labelText: "Address",
                        textInputFormatter: [
                          LengthLimitingTextInputFormatter(
                            TextField.noMaxLength,
                          )
                        ],
                        controller: model?.address,
                        focusNode: model?.addressNode,
                        validateField: validateAddress,
                        onChanged: onChanged,
                        pBottom: 16,
                        onSubmit: onSubmit,
                      ),
                    ),
                    IconButton(
                      padding: const EdgeInsets.only(left: 20, right: 36),
                      icon: SvgPicture.asset(
                        '${AppConfig.iconsPath}qr_code.svg',
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        try {
                          final response = await Navigator.push(
                              context, transitionRoute(const QrScanner()));

                          if (response != null) {
                            model?.address.text = response.toString();
                            onChanged!(response.toString());
                          }
                        } catch (e) {
                          if (ApiProvider().isDebug == true) {
                            if (kDebugMode) {
                              print("Error from QR scanner $e");
                            }
                          }
                        }
                      },
                    )
                  ],
                ),
                MyInputField(
                  labelText: "Memo",
                  textInputFormatter: [
                    LengthLimitingTextInputFormatter(TextField.noMaxLength)
                  ],
                  inputAction: TextInputAction.done,
                  controller: model?.memo,
                  focusNode: model?.memoNode,
                  onChanged: onChanged,
                  pBottom: 16,
                  onSubmit: onSubmit,
                )
              ],
            ),
          ),
        ),
        MyFlatButton(
            textButton: "Edit Contact",
            edgeMargin: const EdgeInsets.only(
              top: 40,
              left: 66,
              right: 66,
              bottom: 16,
            ),
            hasShadow: true,
            action: model!.enable ? submitContact : null)
      ],
    );
  }
}