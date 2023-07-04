import 'package:bitriel_wallet/domain/validator/form_validate.dart';
import 'package:bitriel_wallet/index.dart';

class ImportWallet extends StatelessWidget {

  const ImportWallet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            const SeedContents(
              title: 'Restore with seed', 
              subTitle: 'Please add your 12 words seed below to restore your wallet.'
            ),
      
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: MySeedField(
                controller: Provider.of<ImportWalletProvider>(context, listen: false).seedController,
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
                  Provider.of<ImportWalletProvider>(context, listen: false).changeState(value);
                },
                onSubmit: (String value) async {
                  await Provider.of<SDKProvier>(context, listen: false).importSeed(value, Provider.of<ImportWalletProvider>(context, listen: false).password!);
                },
              ),
            ),
      
            Expanded(child: Container()),
            Consumer<ImportWalletProvider>(
              builder: (context, pro, wg) {
                return MyGradientButton(
                  textButton: "Continue",
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  action: pro.isSeedValid ? () async {
                    await Provider.of<SDKProvier>(context, listen: false).importSeed(
                      pro.seedController.text, 
                      pro.password!
                    );
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
        MyText(
          text: "Restore with seed",
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.start,
          fontSize: 25,
          color: Colors.black,
        ),
        SizedBox(
          height: 10,
        ),
        MyText(
          text: "Please add your 12 words seed below to restore your wallet.",
          textAlign: TextAlign.start,
          fontSize: 19,
          color: Colors.grey
        )
      ],
    );
  }
}