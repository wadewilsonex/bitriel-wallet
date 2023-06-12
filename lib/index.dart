// Core Flutter
export 'package:flutter/material.dart';
export 'dart:io';

// Pub & Packages
export 'package:bitriel_wallet/app.dart';
export 'package:flutter_dotenv/flutter_dotenv.dart';
export 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
export 'package:permission_handler/permission_handler.dart';
// ignore: depend_on_referenced_packages
export 'package:http/http.dart';
export 'package:provider/provider.dart';
export 'package:iconsax/iconsax.dart';
export 'package:go_router/go_router.dart';


/*---------- Data Layer ----------*/

/// SDK
// ignore: depend_on_referenced_packages
export 'package:polkawallet_sdk/polkawallet_sdk.dart';
// ignore: depend_on_referenced_packages
export 'package:polkawallet_sdk/storage/keyring.dart';
// ignore: depend_on_referenced_packages
export 'package:polkawallet_sdk/api/types/networkParams.dart';

/*---------- Domain Layer ----------*/

// Repository
export 'package:bitriel_wallet/domain/repository/asset_repo/asset_repo.dart';
export 'package:bitriel_wallet/domain/repository/asset_repo/asset_repo_impl.dart';
// Usecases
export 'package:bitriel_wallet/domain/usecases/asset_uc_impl.dart';
export 'package:bitriel_wallet/domain/usecases/asset_uc.dart';

/*---------- Standalone Layer ----------*/
export 'package:bitriel_wallet/standalone/utils/routes/router.dart';
export 'package:bitriel_wallet/standalone/utils/app_utils/app_utils.dart';
export 'package:bitriel_wallet/standalone/components/text_c.dart';

/*---------- Presentation Layer ----------*/
export 'package:bitriel_wallet/presentation/ui_welcome.dart';
export 'package:bitriel_wallet/presentation/widget/text_widget.dart';
// Provider
export 'package:bitriel_wallet/presentation/provider/asset_pro.dart';



