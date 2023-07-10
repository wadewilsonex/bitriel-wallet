import 'package:bitriel_wallet/domain/usecases/acc_manage_uc/import_wallet/import_wallet_impl.dart';
import 'package:bitriel_wallet/index.dart';

class ImportWallet extends StatelessWidget {

  final String? pin;

  final bool? isVerify;

  const ImportWallet({super.key, this.pin, this.isVerify = false});

  @override
  Widget build(BuildContext context) {
    
    final importWalletImpl = ImportWalletImpl();
    importWalletImpl.setContext = context;
    // importWalletImpl.isSeedValid.value = isSeed!;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // const SeedContents(
            //   title: 'Restore with seed', 
            //   subTitle: 'Please add your 12 words seed below to restore your wallet.'
            // ),
      
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: MySeedField(
                controller: importWalletImpl.seedController,
                pLeft: 0, pRight: 0,
                pTop: 20,
                pBottom: 16.0,
                hintText: "Add your 12 keywords",
                textInputFormatter: [
                  LengthLimitingTextInputFormatter(
                    TextField.noMaxLength,
                  )
                ],
                // controller: importAccModel!.key,
                // focusNode: importAccModel!.keyNode,
                maxLine: 7,
                validateField: FormValidator.seedValidator,
                onChanged: (String value){
                  importWalletImpl.changeState(value);
                },
                onSubmit: (String value) async {
                  importWalletImpl.addAndImport(pin!);
                },
              ),
            ),
      
            Expanded(child: Container()),
            ValueListenableBuilder(
              valueListenable: importWalletImpl.isSeedValid,
              builder: (context, value, wg) {
                return MyGradientButton(
                  textButton: "Next",
                  action: value ? () async {
                    await importWalletImpl.addAndImport(pin!);
                  } : null,
                );
              }
            ),
          ],
        ),
      )
    );
  }

  Widget _textHeader() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyTextConstant(
          text: "Restore with seed",
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.start,
          fontSize: 25,
          color2: Colors.black,
        ),
        SizedBox(
          height: 10,
        ),
        MyTextConstant(
          text: "Please add your 12 words seed below to restore your wallet.",
          textAlign: TextAlign.start,
          fontSize: 19,
          color2: Colors.grey
        )
      ],
    );
  }
}