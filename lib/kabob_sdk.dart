library polkawallet_sdk;

import 'dart:async';
import 'package:polkawallet_sdk/api/api.dart';
import 'package:polkawallet_sdk/service/index.dart';
import 'package:polkawallet_sdk/service/webViewRunner.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';

/// SDK launchs a hidden webView to run polkadot.js/api for interacting
/// with the substrate-based block-chain network.
class WalletSDK {
  
  KabobApi api;

  SubstrateService _service;

  /// webView instance, this is the only instance of FlutterWebViewPlugin
  /// in App, we need to get it and reuse in other sdk.
  WebViewRunner get webView => _service.webView;

  /// param [jsCode] is customized js code of parachain,
  /// the api works without [jsCode] param in Kusama/Polkadot.
  Future<void> init(
    Keyring keyring, {
    WebViewRunner webView,
    String jsCode,
  }) async {

    try {

      final c = Completer();

      _service = SubstrateService();

      if (_service.keyring == null) print("Hello my null");
      else print("Hello my not null");

      await _service.init(
        keyring,
        webViewParam: webView,
        jsCode: jsCode,
        onInitiated: () async {
          print("Hello onInitiated");
          // inject keyPairs after webView launched
          await _service.keyring.injectKeyPairsToWebView(keyring).then((value) {
            print("After injectKeyPairsToWebView $value");
          });

          // and initiate pubKeyIconsMap
          await api.keyring.updatePubKeyIconsMap(keyring);
          print("After updatePubKeyIconsMap");

          if (!c.isCompleted) {
            c.complete();
          }
        },
      );

      api = KabobApi(_service);
      print("After kabobapi");
      api.init();
      print("After api.init");
      return c.future;
    } catch (e) {
      print("Error WalletSDK $e");
    }
  }
}
