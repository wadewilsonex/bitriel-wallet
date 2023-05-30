import 'package:bitriel_wallet/features/import_wallet/presentation/pages/import_wallet_body.dart';
import 'package:flutter/material.dart';

class ImportWallet extends StatefulWidget {
  const ImportWallet({super.key});

  @override
  State<ImportWallet> createState() => _ImportWalletState();
}

class _ImportWalletState extends State<ImportWallet> {
  @override
  Widget build(BuildContext context) {
    return const ImportWalletBody();
  }
}