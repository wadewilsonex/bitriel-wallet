import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/components/seeds_c.dart';

class ImportAccBody extends StatelessWidget {
  final bool? enable;
  final String? reImport;
  final ImportAccModel? importAccModel;
  final Function? onChanged;
  final Function? onSubmit;
  final Function? clearInput;
  final Function? submit;

  ImportAccBody({
    this.importAccModel,
    this.onChanged,
    this.onSubmit,
    this.clearInput,
    this.enable,
    this.reImport,
    this.submit,
  });

  final EdgeInsetsGeometry padding = EdgeInsets.only(left: paddingSize, right: paddingSize);

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;

    return BodyScaffold(
      height: MediaQuery.of(context).size.height,
      bottom: paddingSize, left: paddingSize, right: paddingSize,
      child: Form(
        key: importAccModel!.formKey,
        child: Column(
          children: [

            SeedContents(
              title: 'Restore with seed', 
              subTitle: 'Please add your 12 words seed below to restore your wallet.'
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
