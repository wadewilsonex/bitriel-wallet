import 'package:bitriel_wallet/presentation/auth/import_wallet/ui_import.dart';
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