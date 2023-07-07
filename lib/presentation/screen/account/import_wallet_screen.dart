import 'package:bitriel_wallet/index.dart';

class ImportWallet extends StatelessWidget {

  final String? pin;

  final bool? isSeed;

  const ImportWallet({super.key, this.pin, this.isSeed = false});

  @override
  Widget build(BuildContext context) {
    
    final accManage = AccountManagementImpl();
    accManage.setContext = context;
    accManage.isSeedValid.value = isSeed!;

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
                controller: accManage.seedController,
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
                  accManage.changeState(value);
                },
                onSubmit: (String value) async {
                  accManage.importAccount(pin!);
                },
              ),
            ),
      
            Expanded(child: Container()),
            ValueListenableBuilder(
              valueListenable: accManage.isSeedValid,
              builder: (context, value, wg) {
                return MyGradientButton(
                  textButton: "Continue",
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  action: value ? () async {
                    await accManage.importAccount(pin!);
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