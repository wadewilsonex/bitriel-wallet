import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/seeds_c.dart';

class ImportAccBody extends StatelessWidget {
  final bool? enable;
  final String? reImport;
  final ImportAccModel? importAccModel;
  final Function? onChanged;
  final Function? onSubmit;
  final Function? clearInput;
  final Function? submit;

  const ImportAccBody({
    Key? key, 
    this.importAccModel,
    this.onChanged,
    this.onSubmit,
    this.clearInput,
    this.enable,
    this.reImport,
    this.submit,
  }) : super(key: key);

  final EdgeInsetsGeometry padding = const EdgeInsets.only(left: paddingSize, right: paddingSize);

  @override
  Widget build(BuildContext context) {

    return BodyScaffold(
      height: MediaQuery.of(context).size.height,
      bottom: paddingSize, left: paddingSize, right: paddingSize,
      child: Form(
        key: importAccModel!.formKey,
        child: Column(
          children: [

            const Align(
              alignment: Alignment.centerLeft,
              child: SeedContents(
                title: 'Restore with seed', 
                subTitle: 'Please add your 12 words seed below to restore your wallet.'
              ),
            ),

            MySeedField(
              pLeft: 0, pRight: 0,
              pTop: 20,
              pBottom: 16.0,
              hintText: "Add your 12 keywords",
              textInputFormatter: [
                LengthLimitingTextInputFormatter(
                  TextField.noMaxLength,
                )
              ],
              controller: importAccModel!.mnemonicCon,
              focusNode: importAccModel!.mnemonicNode,
              maxLine: 7,
              onChanged: onChanged,
              //inputAction: TextInputAction.done,
              onSubmit: onSubmit,
            ),

            Expanded(child: Container()),
            MyGradientButton(
              textButton: "Continue",
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              action: onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
