import 'package:bitriel_wallet/index.dart';

class CreateWallet extends StatelessWidget {

  final String? pin;

  const CreateWallet({super.key, this.pin});

  @override
  Widget build(BuildContext context) {

    final CreateWalletImpl createWalletImpl = CreateWalletImpl();

    createWalletImpl.setBuildContext = context;

    if (createWalletImpl.seed.value.isEmpty) createWalletImpl.generateSeed();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              
              _textHeader(),

              const SizedBox(height: 20),

              _seedDisplay(context, createWalletImpl),

              const SizedBox(height: 20),

              _optionButton(createWalletImpl),

              Expanded(child: Container()),
              MyGradientButton(
                textButton: "Continue",
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
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
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: "Seed",
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.start,
          fontSize: 25,
          color: Colors.black,
        ),
        SizedBox(
          height: 10,
        ),
        MyText(
          text: "Write down or copy these words in the order and save them somewhere safe.\n\nAfter writing and securing your 12 words, click continue to proceed.",
          textAlign: TextAlign.start,
          fontSize: 19,
          color: Colors.grey
        )
      ],
    );
  }

  Widget _optionButton(CreateWalletImpl createWalletImpl) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: 0,
          child: Row(
            children: [
              const Icon(Iconsax.repeat),

              const SizedBox(width: 5),

              InkWell(
                onTap: (){
                  createWalletImpl.generateSeed();
                },
                child: const MyText(
                  text: "Change Seed",
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.start,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(width: 20),

        const Flexible(
          flex: 0,
          child: Row(
            children: [
              Icon(Iconsax.copy),

              SizedBox(width: 5),

              MyText(
                text: "Copy",
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
                color: Colors.black,
              ),
            ],
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