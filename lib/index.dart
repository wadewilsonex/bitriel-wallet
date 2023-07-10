// Core Flutter
export 'package:flutter/material.dart';
export 'dart:io';
export 'package:flutter/services.dart';

// Pub & Packages
export 'package:bitriel_wallet/app.dart';
export 'package:flutter_dotenv/flutter_dotenv.dart';
export 'package:path_provider/path_provider.dart';
export 'package:local_auth/local_auth.dart';
// ignore: depend_on_referenced_packages
export 'package:permission_handler/permission_handler.dart';
// ignore: depend_on_referenced_packages
export 'package:http/http.dart';
export 'package:provider/provider.dart';
export 'package:iconsax/iconsax.dart';
export 'package:lottie/lottie.dart';
export 'package:flutter_secure_storage/flutter_secure_storage.dart';
export 'package:vibration/vibration.dart';

// ignore: depend_on_referenced_packages
export 'package:polkawallet_sdk/api/apiKeyring.dart';

/*---------- Data Layer ----------*/

/// SDK
// ignore: depend_on_referenced_packages
export 'package:polkawallet_sdk/polkawallet_sdk.dart';
// ignore: depend_on_referenced_packages
export 'package:polkawallet_sdk/storage/keyring.dart';
// ignore: depend_on_referenced_packages
export 'package:polkawallet_sdk/api/types/networkParams.dart';
export 'package:bitriel_wallet/data/sdk/bitriel_sdk.dart';
// Repository
export 'package:bitriel_wallet/data/repository/asset_repo/asset_repo.dart';
export 'package:bitriel_wallet/data/repository/asset_repo/asset_repo_impl.dart';
export 'package:bitriel_wallet/data/repository/sdk_repo/sdk_repo_impl.dart';

/*---------- Domain Layer ----------*/
export 'package:bitriel_wallet/domain/validator/form_validate.dart';
// Model
export 'package:bitriel_wallet/domain/model/pin_m.dart';
// Usecases
export 'package:bitriel_wallet/domain/usecases/asset_uc/asset_uc_impl.dart';
export 'package:bitriel_wallet/domain/usecases/pin_uc/pin_uc_impl.dart';
export 'package:bitriel_wallet/domain/usecases/asset_uc/asset_uc.dart';
export 'package:bitriel_wallet/domain/usecases/sdk_uc/sdk_uc.dart';
export 'package:bitriel_wallet/domain/usecases/sdk_uc/sdk_uc_impl.dart';
export 'package:bitriel_wallet/domain/usecases/pin_uc/pin_uc.dart';
export 'package:bitriel_wallet/domain/usecases/secure_storage_uc/secure_storage_uc.dart';
export 'package:bitriel_wallet/domain/usecases/secure_storage_uc/secure_storage_uc_impl.dart';
export 'package:bitriel_wallet/domain/usecases/acc_manage_uc/acc_manage_uc.dart';
export 'package:bitriel_wallet/domain/usecases/acc_manage_uc/acc_manage_impl.dart';
export 'package:bitriel_wallet/domain/usecases/acc_manage_uc/create_wallet/create_wallet_uc.dart';
export 'package:bitriel_wallet/domain/usecases/acc_manage_uc/create_wallet/create_wallet_impl.dart';

/*---------- Presentation Layer ----------*/


// Screen
export 'package:bitriel_wallet/presentation/screen/welcome_screen.dart';
export 'package:bitriel_wallet/presentation/screen/account/create_seed_screen.dart';
export 'package:bitriel_wallet/presentation/screen/account/import_wallet_screen.dart';
export 'package:bitriel_wallet/presentation/screen/account/verify_seed_screen.dart';
export 'package:bitriel_wallet/presentation/screen/pin_screen.dart';
export 'package:bitriel_wallet/presentation/screen/home_screen.dart';
// Widget
export 'package:bitriel_wallet/presentation/widget/text_widget.dart';
export 'package:bitriel_wallet/presentation/widget/seed_widget.dart';
export 'package:bitriel_wallet/presentation/widget/textformfield_wg.dart';
export 'package:bitriel_wallet/presentation/components/button_widget.dart';
export 'package:bitriel_wallet/presentation/widget/pin_widget.dart';
export 'package:bitriel_wallet/presentation/widget/dialog_widget.dart';
export 'package:bitriel_wallet/presentation/components/seed_widget.dart';
export 'package:bitriel_wallet/presentation/widget/btn_widget.dart';
export 'package:bitriel_wallet/presentation/widget/dashboard_menu_items.dart';
// Provider
export 'package:bitriel_wallet/presentation/provider/asset_pro.dart';
export 'package:bitriel_wallet/presentation/provider/sdk_pro.dart';

/*---------- Standalone Layer ----------*/
export 'package:bitriel_wallet/standalone/utils/routes/router.dart';
export 'package:bitriel_wallet/standalone/utils/app_utils/app_utils.dart';
export 'package:bitriel_wallet/presentation/components/text_c.dart';
export 'package:bitriel_wallet/standalone/utils/themes/colors.dart';
export 'package:bitriel_wallet/standalone/utils/app_utils/global.dart';
export 'package:bitriel_wallet/standalone/core/db_key_con.dart';