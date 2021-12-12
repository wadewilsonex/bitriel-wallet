//
// Generated file. Do not edit.
//

// ignore_for_file: directives_ordering
// ignore_for_file: lines_longer_than_80_chars

import 'package:biometric_storage/biometric_storage_web.dart';
import 'package:connectivity_for_web/connectivity_for_web.dart';
import 'package:contact_picker_web/contact_picker_web.dart';
import 'package:flutter_secure_storage_web/flutter_secure_storage_web.dart';
import 'package:geolocator_web/geolocator_web.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';
import 'package:vibration_web/vibration_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// ignore: public_member_api_docs
void registerPlugins(Registrar registrar) {
  BiometricStoragePluginWeb.registerWith(registrar);
  ConnectivityPlugin.registerWith(registrar);
  FlutterContactPickerPlugin.registerWith(registrar);
  FlutterSecureStorageWeb.registerWith(registrar);
  GeolocatorPlugin.registerWith(registrar);
  SharedPreferencesPlugin.registerWith(registrar);
  VibrationWebPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
