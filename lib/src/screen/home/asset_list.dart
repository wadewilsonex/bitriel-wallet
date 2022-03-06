// import 'package:bitcoin_flutter/bitcoin_flutter.dart';
// import 'package:bip39/bip39.dart' as bip39;
import 'package:provider/provider.dart';

import '../../../index.dart';

class AssetList extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  final passphraseController = TextEditingController();
  final pinController = TextEditingController();
  final focus = FocusNode();
  final pinFocus = FocusNode();

  Future<bool> validateMnemonic(String mnemonic, {@required BuildContext? context}) async {
    dynamic res = await Provider.of<ApiProvider>(context!, listen: false).validateMnemonic(mnemonic);
    return res;
  }

  String? validate(String value) {
    return null;
  }

  Future<bool> checkPassword(String pin, {@required BuildContext? context}) async {

    final res = await Provider.of<ApiProvider>(context!, listen: false);
    bool checkPass = await res.apiKeyring.checkPassword(res.getKeyring.current, pin);
    return checkPass;
  }

  Future<void> onSubmit(BuildContext context) async {

    if (_formKey.currentState!.validate()) {
      dialogLoading(context);
      final isValidSeed = await validateMnemonic(passphraseController.text, context: context);
      final isValidPw = await checkPassword(pinController.text, context: context);

      if (isValidSeed == false) {
        Navigator.pop(context);
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              title: const Align(
                child: Text('Opps'),
              ),
              content: const Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Text('Invalid Seed phrase'),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      }

      // await dialog(
      if (isValidPw == false) {
        Navigator.pop(context);
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: const Align(
                child: Text('Opps'),
              ),
              content: const Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Text('PIN verification failed'),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      }

      if (isValidSeed && isValidPw) {
        // final seed = bip39.mnemonicToSeed(passphraseController.text);
        // final hdWallet = HDWallet.fromSeed(seed);
        // final keyPair = ECPair.fromWIF(hdWallet.wif);
        // final bech32Address = new P2WPKH(data: new PaymentData(pubkey: keyPair.publicKey), network: bitcoin).data.address;

        // await StorageServices.storeData(bech32Address, 'bech32');
        // final res = await ApiProvider().encryptPrivateKey(hdWallet.wif, pinController.text);

        // if (res != null) {
        //   await StorageServices().writeSecure('btcwif', res);
        // }

        // await Provider.of<ApiProvider>(context, listen: false).getBtcBalance(hdWallet.address, context: context);
        Provider.of<ApiProvider>(context, listen: false).isBtcAvailable('contain', context: context);

        // Provider.of<ApiProvider>(context, listen: false).setBtcAddr(bech32Address);
        Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('BTC');

        Navigator.pop(context);
        Navigator.pop(context);

        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: const Align(
                child: Text('Success'),
              ),
              content: const Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Text('You have created bitcoin wallet.'),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer<ContractProvider>(
          builder: (context, value, child) {
            return Column(
              children: [
                for (int index = 0; index < value.sortListContract.length; index++)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        RouteAnimation(
                          enterPage: AssetInfo(
                            index: index,
                            scModel: value.sortListContract[index]
                          ),
                        ),
                      );
                    },
                    child: AssetItem(
                      scModel: value.sortListContract[index]
                    )
                  )
              ]
            );
          },
        ),

      ],
    );
  }
}
