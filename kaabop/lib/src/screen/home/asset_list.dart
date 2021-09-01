import 'package:bitcoin_flutter/bitcoin_flutter.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:provider/provider.dart';

import '../../../index.dart';

class AssetList extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final passphraseController = TextEditingController();
  final pinController = TextEditingController();
  final focus = FocusNode();
  final pinFocus = FocusNode();

  Future<bool> validateMnemonic(String mnemonic) async {
    final res = await ApiProvider.sdk.api.keyring.validateMnemonic(mnemonic);
    return res;
  }

  String validate(String value) {
    return null;
  }

  Future<bool> checkPassword(String pin) async {
    final res = await ApiProvider.sdk.api.keyring
        .checkPassword(ApiProvider.keyring.current, pin);
    return res;
  }

  Future<void> onSubmit(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      dialogLoading(context);
      final isValidSeed = await validateMnemonic(passphraseController.text);
      final isValidPw = await checkPassword(pinController.text);

      if (isValidSeed == false) {
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
        final seed = bip39.mnemonicToSeed(passphraseController.text);
        final hdWallet = HDWallet.fromSeed(seed);
        final keyPair = ECPair.fromWIF(hdWallet.wif);
        final bech32Address = new P2WPKH(
                data: new PaymentData(pubkey: keyPair.publicKey),
                network: bitcoin)
            .data
            .address;

        await StorageServices.setData(bech32Address, 'bech32');
        final res = await ApiProvider.keyring.store
            .encryptPrivateKey(hdWallet.wif, pinController.text);

        if (res != null) {
          await StorageServices().writeSecure('btcwif', res);
        }

        Provider.of<ApiProvider>(context, listen: false)
            .getBtcBalance(hdWallet.address);
        Provider.of<ApiProvider>(context, listen: false)
            .isBtcAvailable('contain');

        Provider.of<ApiProvider>(context, listen: false)
            .setBtcAddr(bech32Address);
        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol('BTC');
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
            return Column(children: [
              for (int index = 0;
                  index < value.sortListContract.length;
                  index++)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      RouteAnimation(
                        enterPage: AssetInfo(
                          id: value.sortListContract[index].id,
                          assetLogo: value.sortListContract[index].logo,
                          balance: value.sortListContract[index].balance ??
                              AppString.loadingPattern,
                          tokenSymbol:
                              value.sortListContract[index].symbol ?? '',
                          org: value.sortListContract[index].org,
                          marketPrice:
                              value.sortListContract[index].marketPrice,
                          priceChange24h:
                              value.sortListContract[index].change24h,
                        ),
                      ),
                    );
                  },
                  child: AssetItem(
                    value.sortListContract[index].logo,
                    value.sortListContract[index].symbol ?? '',
                    value.sortListContract[index].org,
                    value.sortListContract[index].balance ??
                        AppString.loadingPattern,
                    Colors.transparent,
                    marketPrice: value.sortListContract[index].marketPrice,
                    priceChange24h:
                        value.sortListContract[index].change24h ?? '',
                    lineChartData: value.sortListContract[index].lineChartData,
                    lineChartModel:
                        value.sortListContract[index].lineChartModel,
                  ),
                )
            ]);
          },
        ),

        // ERC or Token After Added
        Consumer<ContractProvider>(builder: (context, value, child) {
          return value.token.isNotEmpty
              ? Column(
                  children: [
                    for (int index = 0; index < value.token.length; index++)
                      Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        background: DismissibleBackground(),
                        onDismissed: (direct) {
                          if (value.token[index].org == 'ERC-20') {
                            value.removeEtherToken(
                                value.token[index].symbol, context);
                          } else {
                            value.removeToken(
                                value.token[index].symbol, context);
                          }

                          //setPortfolio();
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              RouteAnimation(
                                enterPage: AssetInfo(
                                  assetLogo: 'assets/circle.png',
                                  balance: value.token[index].balance ??
                                      AppString.loadingPattern,
                                  tokenSymbol: value.token[index].symbol ?? '',
                                  org: value.token[index].org,
                                ),
                              ),
                            );
                          },
                          child: AssetItem(
                            'assets/circle.png',
                            value.token[index].symbol ?? '',
                            value.token[index].org ?? '',
                            value.token[index].balance ??
                                AppString.loadingPattern,
                            Colors.transparent,
                          ),
                        ),
                      )
                  ],
                )
              : Container();
        }),
      ],
    );
  }
}
