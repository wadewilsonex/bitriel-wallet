import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/presentation/widget/appbar_widget.dart';

class CreateWallet extends StatelessWidget {

  final String? pin;

  const CreateWallet({super.key, this.pin});

  @override
  Widget build(BuildContext context) {

    final CreateWalletImpl createWalletImpl = CreateWalletImpl();

    createWalletImpl.setBuildContext = context;

    // createWalletImpl.showWarning();

    if (createWalletImpl.seed.value.isEmpty) createWalletImpl.generateSeed();

    return Scaffold(
      backgroundColor: hexaCodeToColor(AppColors.background),
      appBar: appBar(context, title: "Create Mnemonic"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              
              _textHeader(),

              const SizedBox(height: 20),

              _seedDisplay(context, createWalletImpl),

              const SizedBox(height: 20),

              _optionButton(context, createWalletImpl),

              Expanded(child: Container()),
              MyGradientButton(
                textButton: "Next",
                action: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VerifySeedScreen(pin: pin, createWalletImpl: createWalletImpl,))
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyTextConstant(
          text: "Write down or copy these words in the order and save them somewhere safe.\n\nAfter writing and securing your 12 words, click continue to proceed.",
          textAlign: TextAlign.start,
          fontSize: 19,
          color2: hexaCodeToColor(AppColors.text)
        )
      ],
    );
  }

  Widget _optionButton(BuildContext context, CreateWalletImpl createWalletImpl) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: 0,
          child: InkWell(
            onTap: (){
              createWalletImpl.generateSeed();
            },
            child: const Row(
              children: [
                Icon(Iconsax.refresh),
          
                SizedBox(width: 5),
          
                MyTextConstant(
                  text: "New Mnemonic",
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.start,
                  color2: Colors.black,
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(width: 20),

        Flexible(
          flex: 0,
          child: InkWell(
            onTap: (){
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                  'Copied to clipboard',
                  textAlign: TextAlign.center,
                ),
                duration: Duration(seconds: 1),
              ));
              Clipboard.setData(
                ClipboardData(text: createWalletImpl.seed.value),
              );
            },
            child: const Row(
              children: [
                Icon(Iconsax.copy),
          
                SizedBox(width: 5),
          
                MyTextConstant(
                  text: "Copy",
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.start,
                  color2: Colors.black,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _seedDisplay(BuildContext context, CreateWalletImpl createWalletImpl) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: hexaCodeToColor("#E8E8E8"),
      ),
      child: Column(
        children: [

          ValueListenableBuilder(
            valueListenable: createWalletImpl.seed,
            builder: (context, value, wg) {

              if (value.isEmpty){
                return const CircularProgressIndicator();
              }

              // return Text(value);

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: SeedsCompoent.getColumn(
                      context, value, 0,
                      moreSize: 10
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: SeedsCompoent.getColumn(
                        context, value, 1,
                        moreSize: 10),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: SeedsCompoent.getColumn(
                        context, value, 2,
                        moreSize: 10),
                  ),
                ],
              );
            }
          ),
        ],
      ),
    );
  }

}